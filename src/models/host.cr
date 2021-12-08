class Host < Granite::Base
  connection embedded
  table host

  column id : Int64, primary: true
  column name : String
  column os : String
  column uptime : Int64
  column arch : String
end
