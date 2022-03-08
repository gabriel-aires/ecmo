Schedule.job :memory_monitor, :cron, "12 * * * * *" do
  seconds = Time.local.to_unix
  mem = Hardware::Memory.new
  last = Sequence.find_by(name: "memory")
  acc = App::ACCURACY_MEM
  persist = false

  if last.nil?
    persist = true
  else
    mm = Memory.find last.not_nil!.seq
    change_size = ((mem.total / 1024) - mm.total_mb).abs
    change_used = ((mem.used / 1024) - mm.used_mb).abs
    persist = (change_size > acc) || (change_used > acc)
  end

  Memory.create!(
    seconds: seconds,
    total_mb: mem.total / 1024,
    used_mb: mem.used / 1024,
    free_mb: mem.available / 1024
  ) if persist
end
