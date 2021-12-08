class Sequence < Granite::Base
  connection embedded
  table sqlite_sequence

  column name : String
  column seq : Int64
end
