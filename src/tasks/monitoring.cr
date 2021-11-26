Schedule.job :monitoring, :every, 5.second do
  mem = Hardware::Memory.new
  puts "* Memory"
  puts ""
  puts "** total   (MB) : #{mem.total / 1024}"
  puts "** used    (MB) : #{mem.used / 1024}"
  puts "** free    (MB) : #{mem.available / 1024}"
  puts ""

  cpu = Hardware::CPU.new
  puts "* CPU"
  puts ""
  puts "** usage    (%) : #{cpu.usage!.to_i}"
  puts ""

  puts "* Processes"
  puts ""
  Hardware::PID.each do |pid|
    next unless pid.name.size > 0
    puts "** pid (number) : #{pid.number}"
    puts "** pid   (name) : #{pid.name}"
    puts "** pid    (cmd) : #{pid.command}"
    puts "** pid  (cpu %) : #{pid.stat.cpu_usage!}"
    puts "** pid    (mem) : #{pid.status.vmrss}"
    puts "** pid(threads) : #{pid.status.threads}"
    puts "** pid  (state) : #{pid.status.state}"
    puts "** pid (parent) : #{pid.status.ppid}"
    puts ""
  end

  puts "* Disk Usage"
  puts ""
  Psutil.disk_partitions.each do |partition|
    du = Psutil.disk_usage partition.mountpoint
    puts "** mountpoint   : #{du.path}"
    puts "** fs_type      : #{partition.fstype}"
    puts "** device       : #{partition.device}"
    puts "** size    (Mb) : #{du.total / 1024 ** 2}"
    puts "** used    (Mb) : #{du.used / 1024 ** 2}"
    puts "** free    (Mb) : #{du.free / 1024 ** 2}"
    puts "** usage    (%) : #{du.used_percent}"
    puts ""
  end

  l_avg = Psutil.load_avg
  puts "* Load Averages"
  puts ""
  puts "** 1 minute     : #{l_avg.load1}"
  puts "** 5 minutes    : #{l_avg.load5}"
  puts "** 15 minutes   : #{l_avg.load15}"
  puts ""

  net = Psutil.net_io_counters.select { |counter| counter.name == "all" }.first
  puts "* Net I/O"
  puts ""
  puts "** received (Mb): #{net.bytes_recv / 1024 ** 2}"
  puts "** sent     (Mb): #{net.bytes_sent / 1024 ** 2}"
  puts "** packets  (In): #{net.packets_recv}"
  puts "** packets (Out): #{net.packets_sent}"
end
