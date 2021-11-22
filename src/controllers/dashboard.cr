require "kilt/slang"

class Dashboard < Application
  def index
    hostname = `hostname 2> /dev/null`
    disk_info = `df -h 2> /dev/null`
    process_info = `top -b -n 1 2> /dev/null`
    service_info = `systemctl status --all --no-page 2> /dev/null`

    Log.warn { "logs can be collated using the request ID" }

    # You can use signals to change log levels at runtime
    # USR1 is debugging, USR2 is info
    # `kill -s USR1 %APP_PID`
    Log.debug { "use signals to change log levels at runtime" }

    respond_with do
      html template("welcome.slang")
      json({hostname: hostname, disk_info: disk_info, process_info: process_info, service_info: service_info})
    end
  end
end
