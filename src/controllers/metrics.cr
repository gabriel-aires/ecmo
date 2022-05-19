require "csv"

class Metrics < Application

  @title = "Metrics Visualization"
  @description = "System Resources Timeseries"
  @data = [] of Hash(String, Int64|Float64|String|Nil)
  @headers = ["Time*"]

  def index
    @links = {
      "Uptime"  => ["yellow", "assets/watch.svg"  ],
      "Load"    => ["red", "assets/cpu.svg"       ],
      "Memory"  => ["green", "assets/server.svg"  ],
      "Network" => ["blue", "assets/wifi.svg"     ],
      "Disk"    => ["gray", "assets/database.svg" ]
    }

    render template: "metrics.cr"
  end

  def show
    resource = params["id"]
    @title = resource.capitalize
    @description = "Timeseries Visualization"
    render template: "timeseries.cr"
  end

  get "/csv", :csv do
    process(params["id"])
    _, csv = serialize @data, @headers, params["type"]
    render text: csv
  end

  get "/json", :json do
    process(params["id"])
    timeseries, _ = serialize @data, @headers, params["type"]
    render json: timeseries
  end

  private def process(resource)
    metric = {} of String => Int64|Float64|String|Nil

    case resource
    when "uptime"
      @headers << "Uptime*"
      series = Boot.order(seconds: :asc).select.map &.to_h.reject("id")
      series.each { |hash| @data << metric.merge hash }
    when "load"
      @headers << "Load1*" << "Load5" << "Load15"
      series = Load.order(seconds: :asc).select.map &.to_h.reject("id")
      series.each { |hash| @data << metric.merge hash }
    when "memory"
      @headers << "RamSize" << "RamUsed*" << "RamFree" << "SwapSize" << "SwapUsed*" << "SwapFree"
      series = Memory.order(seconds: :asc).select.map &.to_h.reject("id")
      series.each { |hash| @data << metric.merge hash }
    when "network"
      @headers << "Download*" << "Upload*" << "PacketsIn" << "PacketsOut"
      series = Net.order(seconds: :asc).select.map &.to_h.reject("id")
      series.each { |hash| @data << metric.merge hash }
    when "disk"
      usage = [] of Hash(String, Int64|Float64)
      times = [] of Int64
      mounts = [] of String
      dk = Disk.all("JOIN partition p on p.id = disk.partition_id")

      Partition.all.each do |p|
        mounts << p.mountpoint
        d = dk.select { |disk| disk.partition.mountpoint == p.mountpoint }
        d.each do |u|
          times << u.seconds
          usage << {
            "#{p.mountpoint}:seconds" => u.seconds,
            "#{p.mountpoint}:size_mb" => u.size_mb,
            "#{p.mountpoint}:used_mb" => u.used_mb,
            "#{p.mountpoint}:free_mb" => u.free_mb,
            "#{p.mountpoint}:usage"   => u.usage
          }
        end
      end

      mounts.each { |m| @headers << "#{m}:Size" << "#{m}:Used*" << "#{m}:Free" << "#{m}:Usage" }

      series = times.sort.uniq.map do |t|
        record = {} of String => Int64|Float64|String|Nil
        record["seconds"] = t

        mounts.each do |m|
          begin
            metrics = usage.select { |u| u["#{m}:seconds"] == t }.first.reject("#{m}:seconds")
            record.merge! metrics
          rescue
            record.merge!({ "#{m}:size_mb" => nil, "#{m}:used_mb" => nil, "#{m}:free_mb" => nil, "#{m}:usage" => nil })
          end
        end

        record
      end

      series.each { |hash| @data << metric.merge hash }
    end

  end

  private def serialize(data, headers, type = "detailed")
    detailed = type == "detailed"
    headers_simple = [] of String
    headers_indexes = [] of Int32
    headers.each_with_index do |header, i|
      if header.ends_with? '*'
        headers_indexes << i
        headers_simple << header
      end
    end

    csv = IO::Memory.new
    csv.puts(detailed ? headers.join(",").delete('*') : headers_simple.join(",").delete('*') )
    timeseries = Array(Hash(String,Int64|Float64|String|Nil)).new

    CSV.build(csv) do |txt|
      data.each do |item|
        timepoint = item # don't mutate the collection directly
        timepoint.update("seconds") { |s| Time::Format::ISO_8601_DATE_TIME.format(Time.unix(s.not_nil!.to_i64)) }
        if detailed
          timeseries << timepoint
          txt.row timepoint.values
        else
          timepoint_simple = {} of String => Int64|Float64|String|Nil
          timepoint.to_a.each_with_index { |v, i| timepoint_simple[v.first] = v.last if headers_indexes.includes? i }
          timeseries << timepoint_simple
          txt.row timepoint_simple.values
        end
      end
    end

    {timeseries, csv}
  end

end
