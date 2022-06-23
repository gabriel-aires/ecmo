class Openrc < InitProvider

  getter name : String = "OpenRC"

  def initialize
    console_out = `rc-update -v`.chomp
    @units = console_out.split("\n").map do |line|
      line
        .split("|")
        .first
        .strip
    end
  end
    
  def check_service(unit) : Tuple(Bool, Bool)
    running = `rc-service #{unit} status`.includes? "started"
    enabled = `rc-update`.chomp.split("\n").map { |l| l.split("|").first.strip }.includes? unit
    {running, enabled}
  end
  
end
