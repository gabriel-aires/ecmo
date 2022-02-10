details
  summary.btn.solid class="#{tone}" System Information for #{host[:name]}
  table role="grid"
    tr
      th OS
      td= host[:os]
    tr
      th Architecture
      td= host[:arch]
    tr
      th Uptime
      td= host[:uptime]
    tr
      th Boot Time
        td= Time.new seconds: boot[:seconds], nanoseconds: 0, location: Time.local.location

br
details
  summary.btn.solid class="#{tone}" Hardware Resources
  table role="grid"
    tr
      th Total Memory (Mb)
      td= memory[:total_mb]
    tr
      th Used Memory (Mb)
      td= memory[:used_mb]
    tr
      th Free Memory (Mb)
      td= memory[:free_mb]
    tr
      th Load (1m)
      td= load[:load1]
    tr
      th Load (5m)
      td= load[:load5]
    tr
      th Load (15m)
      td= load[:load15]

br
details
  summary.btn.solid class="#{tone}" Net I/O
  table role="grid"
    tr
      th Upload (Mb)
      td= net[:sent_mb]
    tr
      th Download (Mb)
      td= net[:received_mb]
    tr
      th Packets Received
      td= net[:packets_in]
    tr
      th Packets Sent
      td= net[:packets_out]

h3 Disk Details
- disks.sort_by {|d| d[:usage].to_f}.reverse.each do |disk|
  br
  details
    summary.btn.solid class="#{tone}"
      .grid style="width:95%; display: inline-block; vertical-align:bottom;"
        div.col-1-4.align-left Mountpoint #{disk[:mount]}
        div.col-3-4.align-right
          - progress_style="width:85%;margin-top:0.4rem;vertical-align:top;"
          progress value=disk[:usage] max="100" style=progress_style

    table role="grid"
      tr
        th Filesystem type
        td= disk[:fstype]
      tr
        th Device
        td= disk[:device]
      tr
        th Size (Mb)
        td= disk[:size_mb]
      tr
        th Used (Mb)
        td= disk[:used_mb]
      tr
        th Free (Mb)
        td= disk[:free_mb]
      tr
        th Usage (%)
        td= disk[:usage]

h3 Process Details
- pids.each do |pid|
  br
  details
    summary.btn.solid class="#{tone}" #{pid[:pid]} - #{pid[:name]}
    table role="grid"
      tr
        th Command
        td= pid[:cmd]
      tr
        th Memory
        td= pid[:memory]
      tr
        th Threads
        td= pid[:threads]
      tr
        th State
        td= pid[:state]
      tr
        th Parent
        td= pid[:parent]
