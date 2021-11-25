Schedule.job :monitoring, :every, 1.second do
  memory = Hardware::Memory.new
  p memory.used
  p memory.percent.to_i

  cpu = Hardware::CPU.new
  pid_stat = Hardware::PID.new.stat
  app_stat = Hardware::PID.new("firefox").stat

  p cpu.usage!.to_i          # => 17
  p pid_stat.cpu_usage!      # => 1.5
  p app_stat.cpu_usage!.to_i # => 4

  pp Psutil.cpu_times
  pp Psutil.virtual_memory
  pp Psutil.disk_partitions
  pp Psutil.disk_usage
  pp Psutil.disk_io_counters
  pp Psutil.host_info
  pp Psutil.load_avg
  pp Psutil.net_io_counters
end
