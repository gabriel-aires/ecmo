Schedule.job :load_monitor, :cron, "10 * * * * *" do
  seconds = Time.local.to_unix
  l_avg = Psutil.load_avg

  Load.create! seconds: seconds,
    load1: l_avg.load1,
    load5: l_avg.load5,
    load15: l_avg.load15
end
