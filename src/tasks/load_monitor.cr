Schedule.job :load_monitor, :cron, "10 * * * * *" do
  seconds = Time.local.to_unix
  l_avg = Psutil.load_avg
  last = Sequence.find_by(name: "load")
  persist = false

  if last.nil?
    persist = true
  else
    ld = Load.find last.not_nil!.seq
    change1 = (l_avg.load1 - ld.not_nil!.load1).abs
    change5 = (l_avg.load5 - ld.not_nil!.load5).abs
    change15 = (l_avg.load15 - ld.not_nil!.load15).abs
    acc = App::ACCURACY_LOAD
    persist = (change1 > acc) || (change5 > acc) || (change15 > acc)
  end

  Load.create!(
    seconds: seconds,
    load1: l_avg.load1,
    load5: l_avg.load5,
    load15: l_avg.load15
  ) if persist

end
