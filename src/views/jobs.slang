h4 Scheduled Jobs
- on_schedule.each do |job|
  details
    summary.btn.solid class="#{tone}"
      = job.name
    table
      tr
        th Schedule
        td= job.cron
      tr
        th Path
        td= job.path
      tr
        th Definition
        td
          code
            pre= File.read(job.path)
      tr
        th Version
        td= job.rev
      tr
        th Log level
        td= job.log.to_s
      tr
        th Last Run
        - if last_run(job.id)[:success]
          td
            a href=Jobs.show(id:job.id)
              ins View Log
        - else
          td
            a href=Jobs.show(id:job.id)
              del View Log

  br

h4 On-Demand Jobs
- on_demand.each do |job|

  details
    summary.btn.solid class="#{tone}"
      = job.name
    table role="grid"
      tr
        th Path
        td= job.path
      tr
        th Definition
        td
          pre= File.read(job.path)
      tr
        th Version
        td= job.rev
      tr
        th Log level
        td= job.log.to_s
      tr
        th Last Run
        - if last_run(job.id)[:success]
          td
            a href=Jobs.show(id:job.id)
              ins View Log
        - else
          td
            a href=Jobs.show(id:job.id)
              del View Log
      tr
        th Run job
        td
          a.btn.solid.black hx-put=Jobs.replace(id:job.id) hx-target="body" Start!

  br

h4 Ecmo Maintenance

a.btn.solid class="#{tone}" href=Jobs.vacuum_warn Defrag & Shrink Data
