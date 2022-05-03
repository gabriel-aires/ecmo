class Service < Granite::Base
  connection embedded
  table service

  column id : Int64, primary: true
  column seconds : Int64
  column running : Bool
  column enabled : Bool
  column name : String
end