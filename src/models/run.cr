class Run < Granite::Base
  connection embedded
  table run
  belongs_to :job

  column id : Int64, primary: true
  column seconds : Int64
  column duration : Int64
  column output : String?
  column error : String?
  column success : Bool
end
