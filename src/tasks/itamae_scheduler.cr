Schedule.job :itamae_scheduler, :in, 10.seconds do
  mitamae = App::ROOT + "/bin/mitamae"
  jobs_path = App::ROOT + "/jobs/"

  Job.all.each do |job|
    job_id = job
      .path
      .sub(jobs_path, "")
      .sub("/", "_")
      .sub(".rb", "")

    begin
      Schedule.job job_id, :cron, job.cron do
        run_at = Time.local.to_unix
        start = Time.local.to_unix_ms
        success = true
        io = {:error => "", :output => ""}

        begin
          Process.run mitamae, args: ["local", job.path] do |process|
            io[:output] = process.output.gets_to_end
            io[:error] = process.error.gets_to_end
          end

          success = false if io[:error].size > 0
        rescue ex : Exception
          io[:error] = ex.message.not_nil!
          success = false
        end

        finish = Time.local.to_unix_ms
        duration = finish - start

        Run.create seconds: run_at,
          duration: duration,
          output: job.log ? io[:output] : nil,
          error: io[:error],
          success: success,
          job_id: job.id
      end

      puts "Found job '#{job.name}' r#{job.rev} at #{job.path}. Trigger: cron #{job.cron}. Log: #{job.log}"
    rescue
      puts "Found job '#{job.name}' r#{job.rev} at #{job.path}. Trigger: on-demand. Log: #{job.log}"
    end
  end
end
