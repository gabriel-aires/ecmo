Schedule.job :itamae_scheduler, :in, 10.seconds do
  jobs_path = App::ROOT + "/jobs/"

  Job.all.each do |job|
    next unless File.exists?(job.path)
    job_id = job.path.sub(jobs_path, "").sub("/", "_").sub(".rb", "")

    begin
      Schedule.job job_id, :cron, job.cron do
        JobRunner.new job
      end
    rescue
      Schedule.call_msg job_id, "on", "demand"
    end

  end
end
