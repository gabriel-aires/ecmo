Schedule.job :disk_monitor, :cron, "5 * * * * *" do
  seconds = Time.local.to_unix
  volumes = Psutil.disk_partitions(true)
  disks = Array(Disk).new
  last = Sequence.find_by(name: "disk")
  acc = App::ACCURACY_DISK

  volumes.each do |vol|
    next unless part = Partition.find_by mountpoint: vol.mountpoint
    persist = false
    du = Psutil.disk_usage vol.mountpoint

    if last.nil?
      persist = true
    else
      record = Disk.find last.not_nil!.seq
      dk = Disk
            .all(
              "JOIN partition p on p.id = disk.partition_id \
              WHERE seconds = ? \
              ORDER BY p.mountpoint ASC",
              [record.not_nil!.seconds]
            ).select { |d| d.partition == part }
      change_size = ((du.total / 1024 ** 2) - dk.size_mb).abs
      change_used = ((du.free / 1024 ** 2) - dk.used_mb).abs
      persist = (change_size > acc) || (change_used > acc)
    end

    disks << Disk.new(
      seconds: seconds,
      size_mb: du.total / 1024 ** 2,
      used_mb: du.used / 1024 ** 2,
      free_mb: du.free / 1024 ** 2,
      usage: du.used_percent,
      partition_id: part.id
    ) if persist
  end

  Disk.import disks
end
