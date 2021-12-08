Schedule.job :pid_monitor, :cron, "20 * * * * *" do
  seconds = Time.local.to_unix
  pids = Array(SystemProcess).new

  Hardware::PID.each do |pid|
    next unless pid.name.size > 0
    pids << SystemProcess.new seconds: seconds,
      pid: pid.number,
      name: pid.name,
      cmd: pid.command,
      cpu: pid.stat.cpu_usage!,
      memory: pid.status.vmrss,
      threads: pid.status.threads,
      state: pid.status.state,
      parent: pid.status.ppid
  end

  SystemProcess.import pids
end
