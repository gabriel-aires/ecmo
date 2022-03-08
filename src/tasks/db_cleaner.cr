Schedule.job :db_cleaner, :cron, "40 * * * * *" do
  time = Time.local - App::DB_RETENTION.days
  seconds = time.to_unix

  {% for model in [Disk, Load, Memory, Net, Pid] %}
    {{model}}.where(:seconds, :lt, seconds).each do |row|
      row.destroy
    end
  {% end %}

end
