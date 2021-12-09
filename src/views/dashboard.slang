doctype html
html lang="en" data-theme="light"

  head
    title Welcome
    link rel="shortcut icon" href="/favicon.ico"
    link rel="stylesheet" href="/pico.min.css"

  body
    main.container

      h3 onclick="change_theme();" OS Probe

      details
        summary System Information for #{host[:name]}
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

      details
        summary Hardware Resources
        table role="grid"
          tr
            th CPU (%)
            td= cpu[:usage]
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

      details
        summary Net I/O
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
      - disks.each do |disk|
        details
          summary Mountpoint #{disk[:mount]}
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
        details
          summary #{pid[:pid]} - #{pid[:name]}
          table role="grid"
            tr
              th Command
              td= pid[:cmd]
            tr
              th Cpu Usage
              td= pid[:cpu]
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
              
      footer
        h6 
          | Built with S2 and 
          a href="https://spider-gazelle.net" Spider-Gazelle
        h6 
          | Check the 
          a href="https://github.com/gabriel-aires/os-probe" Github Repo

  javascript:
    function change_theme() {
      const html = document.documentElement;
      if (html.dataset.theme === 'light') {
        html.dataset.theme = 'dark';
      } else {
        html.dataset.theme = 'light';
      }
    }
