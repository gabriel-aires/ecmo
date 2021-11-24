Schedule.job :monitoring, :every, 1.second do
  puts Time.local
  puts `free -h`
  puts "------------------------------"
end
