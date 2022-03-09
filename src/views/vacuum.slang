blockquote
  p
    = "Vacuuming is an important database maintenance task. "
    = "You can read the official SQLite Documentation on the subject "
    a href="https://www.sqlite.org/lang_vacuum.html" here

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

p This operation is irreversible. Do you want to proceed?

a.btn.orange href=Jobs.index Cancel
br
a.btn.solid.orange hx-put=Jobs.vacuum_db hx-target="body" Start!
