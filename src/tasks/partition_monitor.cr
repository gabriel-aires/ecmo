Schedule.job :partition_monitor, :cron, "17 * * * * *" do
  volumes = Psutil.disk_partitions
  parts = Array(Partition).new

  volumes.each do |vol|
    if part = Partition.find_by mountpoint: vol.mountpoint
      updated = (part.fs_type != vol.fstype) || (part.device != vol.device)
      part.update fs_type: vol.fstype, device: vol.device if updated
    else
      parts << Partition.new mountpoint: vol.mountpoint,
        fs_type: vol.fstype,
        device: vol.device
    end
  end

  Partition.import parts
end
