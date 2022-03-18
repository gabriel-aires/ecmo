class Metrics < Application

  def index
    @links = {
      "Uptime"  => ["yellow", "assets/watch.svg"  ],
      "Load"    => ["red", "assets/cpu.svg"       ],
      "Memory"  => ["green", "assets/server.svg"  ],
      "Network" => ["blue", "assets/wifi.svg"     ],
      "Disk"    => ["gray", "assets/database.svg" ]
    }

    respond_with { html template("metrics.slang") }
  end

  def show

    timeseries = case params["id"]
    when "uptime"
      b = Boot.all
      t = b.map &.seconds
      { uptime: t , time: t }
    when "load"
      l = Load.all
      t = l.map &.seconds
      { load_1m: l.map(&.load1), load_5m: l.map(&.load5), load_15m: l.map(&.load15), time: t }
    when "memory"
      m = Memory.all
      t = m.map &.seconds
      { total_memory: m.map(&.total_mb), used_memory: m.map(&.used_mb), free_memory: m.map(&.free_mb), time: t }
    when "network"
      n = Net.all
      t = n.map &.seconds
      { download: n.map(&.received_mb), upload: n.map(&.sent_mb), time: t }
    when "disk"
      usage = Hash(String, Array(Int64) | Array(Float64)).new
      Partition.all.each do |p|
        d = p.disk.all
        usage["#{p.mountpoint}_time" ] = d.map &.seconds
        usage["#{p.mountpoint}_total"] = d.map &.size_mb
        usage["#{p.mountpoint}_used" ] = d.map &.used_mb
        usage["#{p.mountpoint}_free" ] = d.map &.free_mb
        usage["#{p.mountpoint}_usage"] = d.map &.usage
      end
      usage
    end

    render json: timeseries
  end

end
