Schedule.job :memory_monitor, :cron, "12,32,52 * * * * *" do
  seconds = Time.local.to_unix
  mem = Hardware::Memory.new
  last = Sequence.find_by(name: "memory")
  acc = App::ACCURACY_MEM
  persist = false

  if last.nil?
    persist = true
  else
    mm = Memory.find last.not_nil!.seq
    change_mem = ((mem.available / 1024) - mm.not_nil!.ram_free_mb).abs
    change_swp = ((mem.meminfo["SwapFree"] / 1024) - mm.not_nil!.swp_free_mb).abs
    persist = (change_mem > acc) || (change_swp > acc)
  end

  Memory.create!(
    seconds: seconds,
    ram_size_mb: mem.total / 1024,
    ram_used_mb: mem.used / 1024,
    ram_free_mb: mem.available / 1024,
    swp_size_mb: mem.meminfo["SwapTotal"] / 1024,
    swp_used_mb: (mem.meminfo["SwapTotal"] - mem.meminfo["SwapFree"]) / 1024,
    swp_free_mb: mem.meminfo["SwapFree"] / 1024
  ) if persist
end
