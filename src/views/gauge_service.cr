[:div, {class: "gauge-service"},

  [:h4, {class: "gra-subheading"}, "Services"],

  [:p, {class: "gra-p-small"}, enabled_services.map do |svc|
    [:button, {class: "gra-btn gra-btn-#{svc.running ? :green : :red} gra-btn-small"}, svc.name]
  end ]]
