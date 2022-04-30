class Pid < Granite::Base
  connection embedded
  table process
  belongs_to :command

  column id : Int64, primary: true
  column seconds : Int64
  column pid : Int64
  column memory : Float64
  column threads : String
  column state : String
  column parent : String
end
