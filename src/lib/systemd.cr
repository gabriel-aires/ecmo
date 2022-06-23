class Systemd < InitProvider

  getter name : String = "systemd"

  def initialize
    console_out = `systemctl list-units -t service --all --no-pager -q`.chomp
    @units = console_out.split("\n").map do |line|
      line
        .gsub(/^../, "")
        .gsub(/\.service.*$/, "")
    end
  end
    
  def check_service(unit) : Tuple(Bool, Bool)
    running = `systemctl is-active #{unit} 2> /dev/null`.chomp == "active"
    enabled = `systemctl is-enabled #{unit} 2> /dev/null`.chomp == "enabled"
    {running, enabled}
  end
  
end
