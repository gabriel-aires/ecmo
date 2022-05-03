class Init

	@provider : InitProvider

	def initialize
		procfile = File.new "/proc/1/status"
		init_type = procfile.gets.not_nil!.split(":").last.strip
		init_provider = case init_type
                		when "init" 		then	Openrc
                    #when "runit"		then	Runit
                    when "systemd"	then	Systemd
                    else raise "Unsupported init provider: #{init_type}"
                		end
		@provider = init_provider.new 
	end
	
	def provider
  	@provider.name
	end
	
	def services
  	@provider.services
	end

end


