class Dashboard < Application
  rescue_from DB::ConnectionRefused, :db_error
  rescue_from NilAssertionError, :null_error

  def db_error(e)
    render :internal_server_error, text: "500 Internal Server Error: Unable to open database"
  end

  def null_error(e)
    # Redirect to realtime dashboard if metrics are not in database yet
    redirect_to Dashboard.realtime
  end

  def index
    last = {
      boot:   Sequence.find_by(name: "boot"),
      cpu:    Sequence.find_by(name: "cpu"),
      load:   Sequence.find_by(name: "load"),
      memory: Sequence.find_by(name: "memory"),
      net:    Sequence.find_by(name: "net"),
      disk:   Sequence.find_by(name: "disk"),
      pid:    Sequence.find_by(name: "process"),
    }

    info = Host.first.not_nil!
    host = {
      :name   => info.name,
      :os     => info.os,
      :uptime => info.uptime,
      :arch   => info.arch,
    }

    bt = Boot.find last[:boot].not_nil!.seq
    boot = {:seconds => bt.not_nil!.seconds}

    mem = Memory.find last[:memory].not_nil!.seq
    memory = {
      :total_mb => mem.not_nil!.total_mb,
      :used_mb  => mem.not_nil!.used_mb,
      :free_mb  => mem.not_nil!.free_mb,
    }

    processor = CPU.find last[:cpu].not_nil!.seq
    cpu = {:usage => processor.not_nil!.usage}

    l_avg = Load.find last[:load].not_nil!.seq
    load = {
      :load1  => l_avg.not_nil!.load1,
      :load5  => l_avg.not_nil!.load5,
      :load15 => l_avg.not_nil!.load15,
    }

    netio = Net.find last[:net].not_nil!.seq
    net = {
      :received_mb => netio.not_nil!.received_mb,
      :sent_mb     => netio.not_nil!.sent_mb,
      :packets_in  => netio.not_nil!.received_packets,
      :packets_out => netio.not_nil!.sent_packets,
    }

    disks = Array(Hash(Symbol, Float64 | String)).new
    latest_disk = Disk.find last[:disk].not_nil!.seq
    storage = Disk.all("JOIN partition p on p.id = disk.partition_id \
                      WHERE seconds = ? \
                      ORDER BY p.mountpoint ASC", [latest_disk.not_nil!.seconds])

    storage.each do |disk|
      disks << {
        :mount   => disk.partition.not_nil!.mountpoint,
        :fstype  => disk.partition.not_nil!.fs_type,
        :device  => disk.partition.not_nil!.device,
        :size_mb => disk.size_mb,
        :used_mb => disk.used_mb,
        :free_mb => disk.free_mb,
        :usage   => disk.usage,
      }
    end

    pids = Array(Hash(Symbol, Float64 | Int64 | String)).new
    latest_pid = Pid.find last[:pid].not_nil!.seq
    processes = Pid.all("WHERE seconds = ? ORDER BY name ASC", [latest_pid.not_nil!.seconds])

    processes.each do |pid|
      pids << {
        :pid     => pid.pid,
        :name    => pid.name,
        :cmd     => pid.cmd,
        :cpu     => pid.cpu,
        :memory  => pid.memory,
        :threads => pid.threads,
        :state   => pid.state,
        :parent  => pid.parent,
      }
    end

    respond_with do
      html template("dashboard.slang")
      json({host: host, boot: boot, memory: memory, cpu: cpu, pids: pids, disks: disks, load: load, net: net})
    end
  end

  get "/realtime", :realtime do
    info = Psutil.host_info
    host = {
      :name   => info.hostname,
      :os     => info.os,
      :uptime => info.uptime,
      :arch   => info.arch,
    }

    boot = {:seconds => Time.local.to_unix - host[:uptime].to_i64}

    mem = Hardware::Memory.new
    memory = {
      :total_mb => mem.total / 1024,
      :used_mb  => mem.used / 1024,
      :free_mb  => mem.available / 1024,
    }

    cpu = {:usage => Hardware::CPU.new.usage!.to_i}

    l_avg = Psutil.load_avg
    load = {
      :load1  => l_avg.load1,
      :load5  => l_avg.load5,
      :load15 => l_avg.load15,
    }

    netio = Psutil.net_io_counters.select { |counter| counter.name == "all" }.first
    net = {
      :received_mb => netio.bytes_recv / 1024 ** 2,
      :sent_mb     => netio.bytes_sent / 1024 ** 2,
      :packets_in  => netio.packets_recv,
      :packets_out => netio.packets_sent,
    }

    pids = Array(Hash(Symbol, Float64 | Int64 | String)).new
    Hardware::PID.each do |pid|
      next unless pid.name.size > 0
      pids << {
        :pid     => pid.number,
        :name    => pid.name,
        :cmd     => pid.command,
        :cpu     => pid.stat.cpu_usage!,
        :memory  => pid.status.vmrss,
        :threads => pid.status.threads,
        :state   => pid.status.state,
        :parent  => pid.status.ppid,
      }
    end

    disks = Array(Hash(Symbol, Float64 | String)).new
    Psutil.disk_partitions(true).each do |partition|
      du = Psutil.disk_usage partition.mountpoint
      disks << {
        :mount   => du.path,
        :fstype  => partition.fstype,
        :device  => partition.device,
        :size_mb => du.total / 1024 ** 2,
        :used_mb => du.used / 1024 ** 2,
        :free_mb => du.free / 1024 ** 2,
        :usage   => du.used_percent,
      }
    end

    respond_with do
      html template("dashboard.slang")
      json({host: host, boot: boot, memory: memory, cpu: cpu, pids: pids, disks: disks, load: load, net: net})
    end
  end
end
