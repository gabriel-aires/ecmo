class Gauges < Application

  layout ""

  skip_action :require_write
  before_action :require_read

  rescue_from DB::ConnectionRefused, :db_error
  rescue_from NilAssertionError, :null_error

  def db_error(e)
    render :internal_server_error, text: "500 Internal Server Error: Unable to open database"
  end

  def null_error(e)
    render :internal_server_error, text: "500 Internal Server Error: Resource not found"
  end

  def show_bar(percent : Float, size : String = "", color : String = "")
    <<-GAUGE
    <span class="gra-progress-bar #{size}">
      <span class="gra-progress-bar-value #{color}"
        style="transform: translateX(#{(percent - 100.0).round}%);">
      </span>
    </span>
    GAUGE
  end

  def show_arc(percent : Float, size : String = "", color : String = "")
    <<-GAUGE
    <div class="gra-progress-circle #{size} #{color}">
      <svg width="80" height="80" viewBox="0 0 80 80">
        <circle
          class="gra-progress-circle-back"
          cx="40" cy="40" r="35" fill="none">
        </circle>
        <circle
          class="gra-progress-circle-value"
          cx="40" cy="40" r="33" fill="none"
          style="stroke-dashoffset: #{(percent * 2.08 - 208.0).round}px">
        </circle>
      </svg>
    </div>
    GAUGE
  end

  def last
    {
      boot:   Sequence.find_by(name: "boot"),
      load:   Sequence.find_by(name: "load"),
      memory: Sequence.find_by(name: "memory"),
      net:    Sequence.find_by(name: "net"),
      disk:   Sequence.find_by(name: "disk"),
      pid:    Sequence.find_by(name: "process")
    }    
  end

  get "/host", :host do
    host = Host.first.not_nil!
    boot = Boot.find(last[:boot].not_nil!.seq).not_nil!    
    respond_with do
      html template("gauge_host.cr")
    end
  end

  get "/memory", :memory do
    memory = Memory.find(last[:memory].not_nil!.seq).not_nil!
    respond_with do
      html template("gauge_memory.cr")
    end
  end

  get "/load", :load do
    load = Load.find(last[:load].not_nil!.seq).not_nil!
    respond_with do
      html template("gauge_load.cr")
    end
  end

  get "/net", :net do
    net = Net.find(last[:net].not_nil!.seq).not_nil!
    respond_with do
      html template("gauge_net.cr")
    end
  end

	get "/disk/:group", :disk do
  	even = Array(Disk).new
    odd = Array(Disk).new
  	latest_disk = Disk.find(last[:disk].not_nil!.seq).not_nil!
  
  	Disk.all("JOIN partition p on p.id = disk.partition_id WHERE seconds = ?", [latest_disk.seconds])
      .reject { |d| d.size_mb == 0.0 }
  		.each_with_index { |d,i| (i % 2 == 0) ? (even << d) : (odd << d) }

		disks = (params["group"] == "even") ? even : odd
		disk = disks.shuffle.pop
	
    accent = case disk.usage
      when .<= 25.0 then "blue"
      when .<= 50.0 then "green"
      when .<= 75.0 then "yellow"
      else "red"
    end
  
		respond_with do
  		html template("gauge_disk.cr")
		end
  
	end
	
	get "/top", :top do
		latest_pid = Pid.find(last[:pid].not_nil!.seq).not_nil!
		pids = Pid
            .where(seconds: latest_pid.seconds)
            .order(memory: :asc)
            .select
            .pop(4)
            .reverse
					
		respond_with do
			html template("gauge_pid.cr")
		end
	end

  get "/service", :service do
    services_up = Array(Service).new
    services_dn = Array(Service).new
    last_svc = ""

    Service.order(name: :asc, seconds: :desc).select.each do |svc|
      if svc.enabled && svc.name != last_svc
        svc.running ? (services_up << svc) : (services_dn << svc)
      end
      last_svc = svc.name
    end

    services_up.sort_by! { |svc| svc.name.downcase }
    services_dn.sort_by! { |svc| svc.name.downcase }

    respond_with do
      html template("gauge_service.cr")
    end
  end

end
