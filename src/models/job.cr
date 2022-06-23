class Job < Granite::Base
  connection embedded
  table job
  has_many :run

  column id : Int64, primary: true
  column path : String
  column name : String
  column cron : String
  column rev : Int64
  column log : Level, column_type: "TEXT", converter: Granite::Converters::Enum(Level, String)
end
