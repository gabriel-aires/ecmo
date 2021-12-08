Schedule.job :cpu_monitor, :cron, "3 * * * * *" do
  seconds = Time.local.to_unix
  cpu = Hardware::CPU.new
  CPU.create seconds: seconds, usage: cpu.usage!.to_f
end
