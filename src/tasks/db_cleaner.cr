Schedule.job :db_cleaner, :cron, "40 * * * * *" do
  time = Time.local - App::DEFAULT_DB_RETENTION.days
  seconds = time.to_unix

  {% for model in [CPU, Disk, Load, Memory, Net, Pid] %}
    {{model}}.where(:seconds, :lt, seconds).each do |row|
      row.destroy
    end
  {% end %}

  conn = Granite::Connections["embedded"]
  conn.open { |db| db.exec "VACUUM;" } if conn
end
