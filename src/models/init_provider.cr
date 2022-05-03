abstract class InitProvider

	@units : Array(String)

	abstract def name : String
	abstract def check_service(unit : String) : Tuple(Bool, Bool)

	def services : Array(Service)
    all_services = Array(Service).new

    @units.each do |u|
      running, enabled = check_service u
      seconds = Time.local.to_unix
      all_services << Service.new(name: u, seconds: seconds, running: running, enabled: enabled)
    end

    all_services
	end

end