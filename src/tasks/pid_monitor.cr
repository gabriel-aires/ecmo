Schedule.job :pid_monitor, :cron, "20 */6 * * * *" do
  seconds = Time.local.to_unix
  pids = Array(Pid).new

  Hardware::PID.each do |pid|
    next unless pid.name.size > 0
    pids << Pid.new seconds: seconds,
      pid: pid.number,
      name: pid.name,
      cmd: pid.command,
      memory: pid.status.vmrss,
      threads: pid.status.threads,
      state: pid.status.state,
      parent: pid.status.ppid
  end

  Pid.import pids
end
