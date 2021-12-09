Schedule.job :job_discovery, :in, 5.seconds do
  jobs = Array(Job).new
  script_dir = App::ROOT + "/jobs"
  scripts = Dir.glob script_dir + "/*.rb"

  scripts.each do |script|
    i = 0
    name = nil
    cron = "on-demand"
    log = true
    rev = 1

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
        log = header.sub("# log:", "").strip == "true" ? true : false
      when .starts_with? "# revision:"
        begin
          rev = header.sub("# revision:", "").strip.to_i64
        rescue
          rev = 1
        end
      end

      i += 1
      break if i > 4
    end

    if job = Job.find_by name: name
      updated = (job.path != script) || (job.cron != cron) || (job.log != log) || (job.rev != rev)
      job.update path: script, cron: cron, log: log, rev: rev if updated
    else
      jobs << Job.new name: name, path: script, cron: cron, log: log, rev: rev
    end
  end

  Job.import jobs
end
