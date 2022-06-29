Schedule.job :job_discovery, :in, 5.seconds do
  script_dir = App::ROOT + "/jobs"
  scripts = Dir.glob script_dir + "/*.rb"
  scripts.each do |script|
    job = Job.from_file script
    job.save
  end
end
