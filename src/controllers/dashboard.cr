class Dashboard < Application
  def index
    info = Psutil.host_info
    host = {
      :name => info.hostname,
      :os => info.os,
      :uptime => info.uptime,
      :arch => info.arch
    }
    
    mem = Hardware::Memory.new
    memory = {
      :total_mb => mem.total / 1024
      :used_mb => mem.used / 1024
      :free_mb => mem.available / 1024
    }
    
    cpu = Hardware::CPU.new.usage!.to_i
    
    pids = Array({
      :number => Int64,
      :name => String,
      :command => String,
      :cpu_usage => Float,
      :memory => String,
      :threads => String,
      :state => String,
      :parent => String
    }).new
    
    Hardware::PID.each do |pid|
      next unless pid.name.size > 0
      pids << {
        :number => pid.number,
        :name => pid.name,
        :command => pid.command,
        :cpu_usage => pid.stat.cpu_usage!,
        :memory => pid.status.vmrss,
        :threads => pid.status.threads,
        :state => pid.status.state,
        :parent => pid.status.ppid
      }
    end

    disks = Array({
      :mount => String,
      :fstype => String,
      :device => String,
      :size_mb => Float,
      :used_mb => Float,
      :free_mb => Float,
      :usage => Float
    }).new
    
    Psutil.disk_partitions.each do |partition|
      du = Psutil.disk_usage partition.mountpoint
      disks << {
        :mount => du.path,
        :fstype => partition.fstype,
        :device => partition.device,
        :size_mb => du.total / 1024 ** 2,
        :used_mb => du.used / 1024 ** 2,
        :free_mb => du.free / 1024 ** 2,
        :usage => du.used_percent
      }
    end

    l_avg = Psutil.load_avg
    load = {
      1 => l_avg.load1,
      5 => l_avg.load5,
      15 => l_avg.load15
    }

    netio = Psutil.net_io_counters.select { |counter| counter.name == "all" }.first
    net = {
      :received_mb => netio.bytes_recv / 1024 ** 2,
      :sent_mb => netio.bytes_sent / 1024 ** 2,
      :packets_in => netio.packets_recv,
      :packets_out => netio.packets_sent
    }   

    Log.warn { "logs can be collated using the request ID" }

    # You can use signals to change log levels at runtime
    # USR1 is debugging, USR2 is info
    # `kill -s USR1 %APP_PID`
    Log.debug { "use signals to change log levels at runtime" }

    respond_with do
      html template("welcome.slang")
      json({host: host, memory: memory, cpu: cpu, pids: pids, disks: disks, load: load, net: net})
    end
  end
end
