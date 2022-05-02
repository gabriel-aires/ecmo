class Systemd < InitProvider
    
    def initialize
        console_out = `systemctl list-unit-files "*.service" --all --no-pager -q`.chomp
        lines = console_out.split("\n")
        @units = lines.map { |l| l.gsub /\.service.*$/, "" }
    end
    
    def name
        "systemd"
    end
    
    def check_service(unit)
        state = `systemctl is-active #{unit}`.chomp
        desired = `systemctl is-enabled #{unit}`.chomp
        [state, desired]
    end
    
    def services
        all_services = Array(Service).new
        @units.each do |u|
            state, desired = check_service u
            all_services << Service.new(name: u, state: state, desired: desired)
        end
        all_services
    end
    
end
