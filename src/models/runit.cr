class Runit < InitProvider

  getter name = "Runit"

  def initialize
    @units = Dir.children("/etc/sv").select { |i| File.directory? i }
  end
    
  def check_service(unit)
    running = `sv status #{unit}`.split(":").first == "run"
    enabled = Dir.children("/var/service").includes? unit
    {running, enabled}
  end
  
end
