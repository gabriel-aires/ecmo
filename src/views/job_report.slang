h4= job.name + " v" + job.rev.to_s

figure
  table
    tr
      th Status
      - if log[:success]
        td
          a href=Jobs.show(id:job.id)
            ins Job successful
      - else
        td
          a href=Jobs.show(id:job.id)
            del Job failed
    tr
      th Duration (ms)
      td= log[:duration]
    tr
      td colspan="2"
        code
          pre= log[:output]
    - if !log[:success]
      tr
        th Errors
        td
          pre= log[:error]
