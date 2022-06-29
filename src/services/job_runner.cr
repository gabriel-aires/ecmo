class JobRunner

  MITAMAE   = App::ROOT + "/bin/mitamae"
  @success  = true
  @io       = {:error => "", :output => ""}

  def initialize(@job : Job)
    @run_at = Time.local.to_unix
    @start  = Time.local.to_unix_ms
    run
    @finish = Time.local.to_unix_ms
    @duration = @finish - @start
    save
  end

  private def run
    Process.run MITAMAE, args: ["local", "-l", @job.log.to_s, @job.path] do |process|
      @io[:output] = process.output.gets_to_end
      @io[:error] = process.error.gets_to_end
    end

    @success = false if @io[:error].size > 0
  rescue ex : Exception
    @io[:error] = ex.message.not_nil!
    @success = false
  end

  private def save
    Run.create seconds: @run_at,
      duration: @duration,
      output: @io[:output],
      error: @io[:error],
      success: @success,
      job_id: @job.id
  end

end
