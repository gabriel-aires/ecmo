Schedule.job :partition_monitor, :cron, "10 * * * * *" do
  seconds = Time.local.to_unix
  volumes = Psutil.disk_partitions

  parts = Array(Partition).new
  volumes.each do |vol|
    parts << Partition.new mountpoint: vol.mountpoint,
      fs_type: vol.fstype,
      device: vol.device
  end

  Partition.import parts, ignore_on_duplicate: true
end
