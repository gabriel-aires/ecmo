class Jobs < Application

  def index
    on_schedule = [] of Job
    on_demand = [] of Job

    Job.all.each do |job|
      if job.cron == "on-demand"
        on_demand << job
      else
        on_schedule << job
      end
    end

    respond_with do
      html template("jobs.slang")
      json({
        jobs: {
          on_schedule: on_schedule.map { |job| job.to_json },
          on_demand:   on_demand.map { |job| job.to_json },
        },
      })
    end
  end

  def show
    job = Job.find(params["id"]).not_nil!

    if job.cron == "on-demand"
      mitamae = App::ROOT + "/bin/mitamae"
      run_at = Time.local.to_unix
      start = Time.local.to_unix_ms
      success = true
      io = {:error => "", :output => ""}

      begin
        Process.run mitamae, args: ["local", "-l", job.log.to_s, job.path] do |process|
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
        output: io[:output],
        error: io[:error],
        success: success,
        job_id: job.id

      log = last_run job.id
    else
      log = last_run job.id
    end

    respond_with do
      html template("job_report.slang")
      json({job: job.to_json, log: log})
    end
  end

  private def last_run(job_id)
    last = {:output => "", :error => nil, :duration => 0_i64, :success => false}

    Run.where(job_id: job_id).order(seconds: :desc).each do |run|
      last[:output] = run.output
      last[:error] = run.error
      last[:duration] = run.duration
      last[:success] = run.success
      break
    end

    last
  end

end
