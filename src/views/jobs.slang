h4 Scheduled Jobs
- on_schedule.each do |job|
  details
    summary= job.name
    table role="grid"
      tr
        th Schedule
        td= job.cron       
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

h4 On-Demand Jobs
- on_demand.each do |job|
  details
    summary= job.name
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
        th Run job
        td
          a href=Jobs.show(id:job.id) role="button" Start!