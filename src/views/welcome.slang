doctype html
html lang="en"

  head
    title Welcome
    link rel="shortcut icon" href="/favicon.ico"
    link rel="stylesheet" href="/pico.min.css"

  body.dark
    main.container

      header
        details
          summary
            h1 System Information for #{host[:name]}
          ul
            li
              OS
              = host[:os]
            li
              Architecture
              = host[:arch]
            li
              Uptime
              = host[:uptime]

      details
        summary
          h3 Hardware Resources
        ul
          li
            CPU (%)
            = cpu
          li
            Total Memory (Mb)
            = memory[:total_mb]
          li
            Used Memory (Mb)
            = memory[:used_mb]
          li
            Free Memory (Mb)
            = memory[:free_mb]
          li
            Memory (%)
            = memory[:usage]
          li
            Load (1m)
            = load[1]
          li
            Load (5m)
            = load[5]
          li
            Load (15m)
            = load[15]

      details
        summary
          h3 Net I/O
        ul
          li
            Upload (Mb)
            = net[:sent_mb]
          li
            Download (Mb)
            = net[:received_mb]
          li
            Packets Received
            = net[:packets_in]
          li
            Packets Sent
            = net[:packets_out]

      h3 Disk Details
      - disks.each do |disk|
        details
          summary
            h5 Mountpoint #{disk[:mount]}
          table role=grid
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
          summary
            h5 #{pid[:number} - #{pid[:name]}
          table role=grid
            tr
              th Command
              td= pid[:command]
            tr
              th Cpu Usage
              td= pid[:cpu_usage]
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
