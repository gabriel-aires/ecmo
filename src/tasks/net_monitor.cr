Schedule.job :net_monitor, :cron, "15 * * * * *" do
  seconds = Time.local.to_unix
  net = Psutil.net_io_counters.select { |counter| counter.name == "all" }.first

  Net.create seconds: seconds,
    received_mb: net.bytes_recv / 1024 ** 2,
    sent_mb: net.bytes_sent / 1024 ** 2,
    received_packets: net.packets_recv.to_i64,
    sent_packets: net.packets_sent.to_i64
end
