Schedule.job :pid_monitor, :cron, "0,20,40 * * * * *" do
  # wait for cmd_monitor
  sleep 0.6
  seconds = Time.local.to_unix
  metadata = Sequence.find_by(name: "command")
  last_cmd = Command.find metadata.not_nil!.seq
  last_time = last_cmd.not_nil!.seconds
  pids = Array(Pid).new

  # TODO: finish conditional Pid write to db

  Hardware::PID.each do |pid|
    next unless pid.name.size > 0
    begin
      pids << Pid.new(
        seconds: seconds,
        pid: pid.number,
        name: pid.name,
        cmd: pid.command,
        memory: pid.status.vmrss,
        threads: pid.status.threads,
        state: pid.status.state,
        parent: pid.status.ppid
      )
    rescue
      next
    end
  end

  Pid.import pids
end
