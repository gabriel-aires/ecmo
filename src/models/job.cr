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

  def self.from_file(file_path : String)
    i = 0
    name = nil
    cron = "on-demand"
    log = Level::Info
    rev = 1_i64

    File.each_line(file_path) do |header|

      case header
      when .starts_with? "# name:"
        name = header.sub("# name:", "").strip
      when .starts_with? "# schedule:"
        cron = header.sub("# schedule:", "").strip
        begin
          CronParser.new cron
        rescue
          cron = "on-demand"
        end
      when .starts_with? "# log:"
        level = header.sub("# log:", "").strip
        begin
          log = Level.parse(level)
        rescue
          log = Level::Info
        end
      when .starts_with? "# revision:"
        begin
          rev = header.sub("# revision:", "").strip.to_i64
        rescue
          rev = 1_i64
        end
      end

      i += 1
      break if i > 4

    end

    job = find_or_initialize_by name: name
    job.path = file_path
    job.cron = cron
    job.log = log
    job.rev = rev
    job
  end

end
