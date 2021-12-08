class Boot < Granite::Base
  connection embedded
  table boot

  column id : Int64, primary: true
  column seconds : Int64
end
