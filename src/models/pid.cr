class Pid < Granite::Base
  connection embedded
  table process

  column id : Int64, primary: true
  column seconds : Int64
  column pid : Int64
  column name : String
  column cmd : String
  column memory : String
  column threads : String
  column state : String
  column parent : String
end