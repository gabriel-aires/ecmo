Schedule.job :disk_monitor, :cron, "13 * * * * *" do
  seconds = Time.local.to_unix
  volumes = Psutil.disk_partitions

  mounts = Array(Mount).new
  volumes.each do |vol|
    du = Psutil.disk_usage vol.mountpoint
    part = Partition.find_by mountpoint: vol.mountpoint
    disk = Disk.new seconds: seconds,
      size_mb: du.total / 1024 ** 2,
      used_mb: du.used / 1024 ** 2,
      free_mb: du.free / 1024 ** 2,
      usage: du.used_percent

    mounts << Mount.new disk_id: disk.id, partition_id: part.id if part
  end

  Mount.import mounts
end
