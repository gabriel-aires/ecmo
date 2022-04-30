class Command < Granite::Base
  connection embedded
  table command
  has_many pids : Pid

  column id : Int64, primary: true
  column name : String
  column line : String
end