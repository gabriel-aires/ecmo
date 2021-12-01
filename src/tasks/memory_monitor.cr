Schedule.job :memory_monitor, :cron, "1 * * * * *" do
  seconds = Time.local.to_unix

  mem = Hardware::Memory.new
  Memory.create! seconds: seconds,
    total_mb: mem.total / 1024,
    used_mb: mem.used / 1024,
    free_mb: mem.available / 1024
end
