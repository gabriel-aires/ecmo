Schedule.job :pid_monitor, :cron, "0,20,40 * * * * *" do
  # wait for cmd_monitor
  sleep 0.3
  seconds = Time.local.to_unix
  metadata = Sequence.find_by(name: "process")
  last_pid = Pid.find metadata.not_nil!.seq
  last_time = last_pid.not_nil!.seconds
  pids = Array(Pid).new
  acc = App::ACCURACY_RSS

  Hardware::PID.each do |proc|
    begin
      next unless proc.name.size > 0
      cmd = Command.find_by(line: proc.command).not_nil!
      
      pid = Pid.new(
        seconds: seconds,
        pid: proc.number,
        memory: proc.status.vmrss.split(" ").first.to_f / 1024.0,
        threads: proc.status.threads,
        state: proc.status.state,
        parent: proc.status.ppid,
        command_id: cmd.id
      )
      
      if last = Pid.find_by(cmd_id: cmd.id, seconds: last_time)
        persist = ((last.memory - pid.memory).abs > acc) || (last.state != pid.state) || (last.threads != pid.threads)
     	else
       	persist = true
      end
      
      pids << pid if persist
      
    rescue
      next
    end
  end

  Pid.import pids
end
