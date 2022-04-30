Schedule.job :host_monitor, :cron, "8,28,48 * * * * *" do
  seconds = Time.local.to_unix
  info = Psutil.host_info

  if host = Host.first
    old_uptime = host.uptime
    new_uptime = info.uptime
    new_boot = new_uptime < old_uptime

    host.update name: info.hostname,
      os: info.os,
      uptime: info.uptime.to_i64,
      arch: info.arch

    Boot.create seconds: seconds - info.uptime if new_boot
  else
    Host.create name: info.hostname,
      os: info.os,
      uptime: info.uptime.to_i64,
      arch: info.arch

    Boot.create seconds: seconds - info.uptime
  end
end
