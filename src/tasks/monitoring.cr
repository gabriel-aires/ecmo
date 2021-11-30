Schedule.job :monitoring, :every, 5.second do
  
  seconds = Time.local.to_unix

  mem = Hardware::Memory.new
  Memory.create! seconds: seconds,
    total_mb: mem.total / 1024,
    used_mb: mem.used / 1024,
    free_mb: mem.available / 1024

  cpu = Hardware::CPU.new
  CPU.create! seconds: seconds, usage: cpu.usage!.to_i

  Hardware::PID.each do |pid|
    next unless pid.name.size > 0
    SystemProcess.create! seconds: seconds,
      pid: pid.number,
      name: pid.name,
      cmd: pid.command,
      cpu: pid.stat.cpu_usage!,
      memory: pid.status.vmrss,
      threads: pid.status.threads,
      state: pid.status.state,
      parent: pid.status.ppid
  end

  Psutil.disk_partitions.each do |partition|
    du = Psutil.disk_usage partition.mountpoint
    disk = Disk.create! seconds: seconds,
      size_mb: du.total / 1024 ** 2,
      used_mb: du.used / 1024 ** 2,
      free_mb: du.free / 1024 ** 2,
      usage: du.used_percent

    part = Partition.find_by mountpoint: partition.mountpoint
    part = Partition.create! mountpoint: partition.mountpoint,
      fs_type: partition.fstype,
      device: partition.device unless part

    Mount.create! disk_id: disk.id, partition_id: part.id     
  end

  l_avg = Psutil.load_avg
  Load.create! seconds: seconds,
    load1: l_avg.load1,
    load5: l_avg.load5,
    load15: l_avg.load15

  net = Psutil.net_io_counters.select { |counter| counter.name == "all" }.first
  Net.create! seconds: seconds,
    received_mb: net.bytes_recv / 1024 ** 2,
    sent_mb: net.bytes_sent / 1024 ** 2,
    received_packets: net.packets_recv,
    sent_packets: net.packets_sent

end
