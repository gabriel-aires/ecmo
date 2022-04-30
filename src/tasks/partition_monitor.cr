Schedule.job :partition_monitor, :cron, "17,37,57 * * * * *" do
  volumes = Psutil.disk_partitions(true)
  parts = Array(Partition).new

  volumes.each do |vol|
    if part = Partition.find_by mountpoint: vol.mountpoint
      updated = (part.fs_type != vol.fstype) || (part.device != vol.device)
      part.update fs_type: vol.fstype, device: vol.device if updated
    else
      persist = true
      persist = false if vol.mountpoint.starts_with?(/(\/sys\/|\/run\/|\/dev\/|\/proc\/)/)
      persist = false if vol.fstype.in?(["devtmpfs", "proc", "nsfs", "sysfs", "tmpfs", "squashfs"])
      
      parts << Partition.new(
        mountpoint: vol.mountpoint,
        fs_type: vol.fstype,
        device: vol.device
      ) if persist
    end
  end

  Partition.import parts
end
