class Dashboard < Application
  def index
    host = Host.first.not_nil!

    last = {
      boot:   Sequence.find_by(name: "boot"),
      cpu:    Sequence.find_by(name: "cpu"),
      load:   Sequence.find_by(name: "load"),
      memory: Sequence.find_by(name: "memory"),
      net:    Sequence.find_by(name: "net"),
      disk:   Sequence.find_by(name: "disk"),
      pid:    Sequence.find_by(name: "process"),
    }

    boot = Boot.find last[:boot].not_nil!.seq
    cpu = CPU.find last[:cpu].not_nil!.seq
    load = Load.find last[:load].not_nil!.seq
    memory = Memory.find last[:memory].not_nil!.seq
    net = Net.find last[:net].not_nil!.seq
    latest_disk = Disk.find last[:disk].not_nil!.seq
    latest_pid = SystemProcess.find last[:pid].not_nil!.seq

    disks = Disk.all("JOIN mount m ON m.disk_id = disk.id \
                      JOIN partition p on p.id = m.partition_id \
                      WHERE seconds = ? \
                      ORDER BY p.mountpoint ASC", [latest_disk.not_nil!.seconds])

    pids = SystemProcess.all("WHERE seconds = ? ORDER BY name ASC", [latest_pid.not_nil!.seconds])

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
    Psutil.disk_partitions.each do |partition|
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

    respond_with do
      html template("dashboard.slang")
      json({host: host, boot: boot, memory: memory, cpu: cpu, pids: pids, disks: disks, load: load, net: net})
    end
  end
end
