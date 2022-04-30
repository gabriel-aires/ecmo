Schedule.job :command_monitor, :cron, "0,20,40 * * * * *" do
  # wait for system cron jobs
  sleep 0.1
  seconds = Time.local.to_unix
  cmds = Array(Command).new

  Hardware::PID.each do |proc|
    begin
      all_cmds << Command.new(name: proc.name, line: proc.command)
    rescue
      next
    end
  end

  cmds.reject! { |cmd| Command.find_by line: cmd.line }
  Command.import cmds
end
