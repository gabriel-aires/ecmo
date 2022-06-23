class Runit < InitProvider

  getter name : String = "Runit"

  def initialize
    @units = Dir.children("/etc/sv").select { |i| File.directory? "/etc/sv/#{i}" }
  end
    
  def check_service(unit) : Tuple(Bool, Bool)
    running = `sv status #{unit}`.split(":").first == "run"
    enabled = Dir.children("/var/service").includes? unit
    {running, enabled}
  end
  
end
