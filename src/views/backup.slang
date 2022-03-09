h4 Database details

table
  thead
    tr
      th Size
      th File
  tbody
    - du_output.split("\n").each do |line|
      tr
        - line.split("\t").each do |field|
          td= field

p Perform backup?

form method="post" action=Jobs.bkp_db
  p
    a.btn class=tone href=Jobs.index Cancel
  p
    input.btn.solid type="submit" class=tone value="Start"
