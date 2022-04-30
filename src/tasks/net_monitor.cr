Schedule.job :net_monitor, :cron, "15,35,55 * * * * *" do
  seconds = Time.local.to_unix
  net = Psutil.net_io_counters.select { |counter| counter.name == "all" }.first
  last = Sequence.find_by(name: "net")
  acc = App::ACCURACY_NET
  persist = false

  if last.nil?
    persist = true
  else
    nt = Net.find last.not_nil!.seq
    change_up = ((net.bytes_recv / 1024 ** 2) - nt.not_nil!.received_mb).abs
    change_dn = ((net.bytes_sent / 1024 ** 2) - nt.not_nil!.sent_mb).abs
    persist = (change_up > acc) || (change_dn > acc)
  end

  Net.create(
    seconds: seconds,
    received_mb: net.bytes_recv / 1024 ** 2,
    sent_mb: net.bytes_sent / 1024 ** 2,
    received_packets: net.packets_recv.to_i64,
    sent_packets: net.packets_sent.to_i64
  ) if persist
end
