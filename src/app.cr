require "baked_file_system"
require "option_parser"
require "sqlite3"
require "hardware"
require "psutil"
require "./constants"
require "./lib/*"

# App defaults
port = App::DEFAULT_PORT
host = App::DEFAULT_HOST
process_count = App::DEFAULT_PROCESS_COUNT
app = App::NAME
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
      job_samples = ["host_inventory.rb", "host_report.rb", "probe_restart.rb", "probe_shutdown.rb"]

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
      unit_file = Storage.get "setup/service/os-probe.sh"
      service_unit = "/etc/init.d/os-probe"
      service_conf = "/etc/conf.d/os-probe"
    when "systemd"
      unit_file = Storage.get "setup/service/os-probe.service"
      service_unit = "/etc/systemd/system/os-probe.service"
      service_conf = install_path + "/os-probe.conf"
    else
      puts "Unknown init type. Options are: OpenRC|systemd"
      exit 1
    end

    conf_file = Storage.get "setup/service/os-probe.conf"

    begin
      File.write service_unit, unit_file.gets_to_end
      File.write service_conf, conf_file.gets_to_end
      File.chmod service_unit, 0o664
      File.chmod service_conf, 0o664
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
puts "Launching #{App::NAME} v#{App::VERSION}"

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
  Log.builder.bind "#{App::NAME}.*", level, App::LOG_BACKEND
  signal.ignore
end

# Turn on DEBUG level logging `kill -s USR1 %PID`
# Default production log levels (INFO and above) `kill -s USR2 %PID`
Signal::USR1.trap &logging
Signal::USR2.trap &logging

# Start the server
server.run do
  puts "Listening on #{server.print_addresses}"
end

# Shutdown message
puts "#{App::NAME} stopped.\n"
