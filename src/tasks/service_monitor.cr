Schedule.job :service_monitor, :cron, "19,39,59 * * * * *" do

  init = Init.new
  services = Array(Service).new
  current_services = init.services
  last = Sequence.find_by(name: "service")

  current_services.each do |svc|
    
    if last.nil?
      persist = true
    else
      last_svc = Service
                      .where(name: svc.name)
                      .order(seconds: :desc)
                      .limit(1)
                      .select
                      .first
                      .not_nil!

      persist = (svc.running != last_svc.running) || (svc.enabled != last_svc.enabled)
    end

    services << svc if persist

  end

  Service.import services
end
