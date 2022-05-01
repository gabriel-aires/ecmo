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
    render(html: show_loading)
  end

  def show_loading
    <<-ANIMATION
      <div class="gra-loading-dots" style="margin:auto; padding: 5rem;">
        <span class="gra-loading-dot gra-green-bg dot-1"></span>
        <span class="gra-loading-dot gra-yellow-bg dot-2"></span>
        <span class="gra-loading-dot gra-red-bg dot-3"></span>
      </div>    
    ANIMATION
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

end
