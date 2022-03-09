class Jobs < Application

  @title = "Jobs"
  @description = "System Configuration"

  before_action :set_theme

  def set_theme
    theme :day
    tone :info
  end

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
    job_report job
  end

  def replace
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

      job_report job
    end

  end

  get "/vacuum-warning", :vacuum_warn do
    @title = "SQLite VACUUM"
    @description = "Reduce database fragmentation and recover disk space"

    db_files = App::ROOT + "/db" + "/*"
    du_output = `du -sh #{db_files}`

    theme :night
    tone :warn

    respond_with do
      html template("vacuum.slang")
    end
  end

  post "/vacuum-db", :vaccum_db do
    conn = Granite::Connections["embedded"]
    conn.open { |db| db.exec "VACUUM;" } if conn
    notice "SQLite Vacuum finished."
    redirect_to Jobs.index
  end

  private def last_run(job_id)
    log = {:output => "", :error => nil, :duration => 0_i64, :success => false}

    Run.where(job_id: job_id).order(seconds: :desc).each do |run|
      log[:output] = run.output
      log[:error] = run.error
      log[:duration] = run.duration
      log[:success] = run.success
      break
    end

    log
  end

  private def job_report(job)
    log = last_run(job.id)
    log[:success] ? (tone :success) : (tone :error)
    respond_with do
      html template("job_report.slang")
      json({job: job.to_json, log: log})
    end
  end

end
