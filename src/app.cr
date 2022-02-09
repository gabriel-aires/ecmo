require "baked_file_system"
require "option_parser"
require "sqlite3"
require "hardware"
require "psutil"
require "./constants"
require "./lib/*"

# App defaults
app = App::NAME
version = App::VERSION
port = App::DEFAULT_PORT
host = App::DEFAULT_HOST
ssl_pkey = App::SSL_PKEY
ssl_cert = App::SSL_CERT
process_count = App::DEFAULT_PROCESS_COUNT
install_path = App::ROOT
db_path = App::ROOT + "/db"
binary_path = App::ROOT + "/bin"
job_path = App::ROOT + "/jobs"
lib_path = App::ROOT + "/jobs/lib"

# Command line options
OptionParser.parse(ARGV.dup) do |parser|
  parser.banner = "Usage: #{PROGRAM_NAME} [arguments]"

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit 0
  end

  parser.on("-v", "--version", "Display the application version") do
    puts "#{App::NAME} v#{App::VERSION}"
    exit 0
  end

  parser.on("-i", "--install", "Install database, binaries and job definitions") do
    if Dir.exists? App::ROOT
      puts "#{App::NAME} is already installed"
      exit 1

    else

      # create folder structure
      begin
        [install_path, db_path, binary_path, job_path, lib_path].each do |folder|
          Dir.mkdir folder
          puts "Created '#{folder}'."
        end
      rescue ex : File::AccessDeniedError
        puts "Must run as root."
        exit 1
      end

      # create db schema
      schema = Storage.get "setup/db/install.sql"
      sql = schema.gets_to_end
      statements = sql.split ";"

      DB.open "sqlite3://#{db_path}/data.db" do |db|
        statements.each { |stmt| db.exec stmt }
      end

      # install mitamae binary
      machine = Psutil.host_info
      file = Storage.get "setup/bin/#{machine.arch.downcase}/#{machine.os.downcase}/mitamae"
      mitamae = file.gets_to_end
      mitamae_path = binary_path + "/mitamae"
      File.write mitamae_path, mitamae
      File.chmod mitamae_path, 0o755

      # instal main binary
      program_path = binary_path + "/" + app.downcase
      File.copy Process.executable_path.not_nil!, program_path

      # install sample jobs / lib
      job_samples = ["host_inventory.rb", "host_report.rb", "app_restart.rb", "app_shutdown.rb"]

      job_samples.each do |job_sample|
        script = Storage.get "setup/jobs/" + job_sample
        script_path = job_path + "/" + job_sample
        File.write script_path, script.gets_to_end
        File.chmod script_path, 0o644
      end

      job_lib = "host.rb"
      script = Storage.get "setup/jobs/lib/" + job_lib
      script_path = lib_path + "/" + job_lib
      File.write script_path, script.gets_to_end
      File.chmod script_path, 0o644
    end

    exit 0
  end

  parser.on("-t", "--tls", "Generate temporary self-signed certificate (requires openssl)") do
    fqdn = `hostname -f 2> /dev/null || echo $HOSTNAME`.chomp
    subj = "/CN=#{fqdn}"
    `openssl req -x509 -newkey rsa:4096 -subj "#{subj}" -keyout "#{ssl_pkey}" -out "#{ssl_cert}" -sha256 -days 365 -nodes -batch`
    exit 0
  end

  parser.on("-r", "--routes", "List the application routes") do
    ActionController::Server.print_routes
    exit 0
  end

  parser.on("-g URL", "--get=URL", "Perform a basic health check by requesting the URL") do |url|
    begin
      response = HTTP::Client.get url
      exit 0 if (200..499).includes? response.status_code
      puts "health check failed, received response code #{response.status_code}"
      exit 1
    rescue error
      error.inspect_with_backtrace(STDOUT)
      exit 2
    end
  end

  parser.on("-b HOST", "--bind=HOST", "Specifies the server host") { |h| host = h }

  parser.on("-p PORT", "--port=PORT", "Specifies the server port") { |p| port = p.to_i }

  parser.on("-w COUNT", "--workers=COUNT", "Specifies the number of processes to handle requests") do |w|
    process_count = w.to_i
  end

  parser.on("-c INIT", "--config=INIT", "Configure init service: openrc|systemd") do |init|
    case init.downcase

    when "openrc"
      unit_mode = 0o755
      conf_mode = 0o644
      unit_file = Storage.get "setup/service/#{app.downcase}.sh"
      conf_file = Storage.get "setup/service/#{app.downcase}.conf"
      service_unit = "/etc/init.d/#{app.downcase}"
      service_conf = "/etc/conf.d/#{app.downcase}"

    when "systemd"
      unit_mode = 0o644
      conf_mode = 0o644
      unit_file = Storage.get "setup/service/#{app.downcase}.service"
      conf_file = Storage.get "setup/service/#{app.downcase}.conf"
      service_unit = "/etc/systemd/system/#{app.downcase}.service"
      service_conf = install_path + "/#{app.downcase}.conf"

    else
      puts "Unknown init type. Options are: OpenRC|systemd"
      exit 1
    end

    begin
      File.write service_unit, unit_file.gets_to_end
      File.write service_conf, conf_file.gets_to_end
      File.chmod service_unit, unit_mode
      File.chmod service_conf, conf_mode
    rescue ex : File::AccessDeniedError
      puts "Must run as root."
      exit 1
    end

    exit 0
  end

  parser.missing_option do |_|
    puts parser
    exit 1
  end

  parser.invalid_option do |_|
    puts parser
    exit 1
  end

end

# Load the routes
puts "Launching #{app} v#{version}"

# Requiring config here ensures that the option parser runs before
# attempting to connect to databases etc.
require "./config"
server = ActionController::Server.new(port, host)

# (process_count < 1) == `System.cpu_count` but this is not always accurate
# Clustering using processes, there is no forking once crystal threads drop
server.cluster(process_count, "-w", "--workers") if process_count != 1

terminate = Proc(Signal, Nil).new do |signal|
  puts " > terminating gracefully"
  spawn do
    server.close
    Schedule.finish
  end
  signal.ignore
end

# Detect ctr-c to shutdown gracefully
# Docker containers use the term signal
Signal::INT.trap &terminate
Signal::TERM.trap &terminate

# Allow signals to change the log level at run-time
logging = Proc(Signal, Nil).new do |signal|
  level = signal.usr1? ? Log::Severity::Debug : Log::Severity::Info
  puts " > Log level changed to #{level}"
  Log.builder.bind "#{app}.*", level, App::LOG_BACKEND
  signal.ignore
end

# Turn on DEBUG level logging `kill -s USR1 %PID`
# Default production log levels (INFO and above) `kill -s USR2 %PID`
Signal::USR1.trap &logging
Signal::USR2.trap &logging

# Start the https server
begin
  ctx = OpenSSL::SSL::Context::Server.new
  ctx.certificate_chain = ssl_cert
  ctx.private_key = ssl_pkey
  server.socket.bind_tls host, port, ctx
  puts "Listening on https://#{host}:#{port}"
  server.socket.listen
rescue error
  puts "Failed to start https server."
  exit 1
end

# Shutdown message
puts "#{app} stopped.\n"
