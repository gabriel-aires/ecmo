class Load < Granite::Base
  connection embedded
  table load

  column id : Int64, primary: true
  column seconds : Int64
  column load1 : Float64
  column load5 : Float64
  column load15 : Float64
end
