Schedule.job :job_discovery, :in, 5.seconds do
  script_dir = App::ROOT + "/jobs"
  scripts = Dir.glob script_dir + "/*.rb"

  scripts.each do |script|
    i = 0
    name = nil
    cron = "on-demand"
    log = Level::Info
    rev = 1_i64

    File.each_line script do |header|
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

    if job = Job.find_by name: name
      updated = (job.path != script) || (job.cron != cron) || (job.log != log) || (job.rev != rev)

      job.path = script
      job.cron = cron
      job.log = log
      job.rev = rev

      job.save if updated
    else
      job = Job.new

      job.name = !!name ? name : script.sub(script_dir, "").sub(".rb", "").tr("/", "_")
      job.path = script
      job.cron = cron
      job.log = log
      job.rev = rev

      job.save
    end
  end
end
