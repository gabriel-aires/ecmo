[:div, {class: "gauge-service"},

  [:h4, {class: "gra-subheading"}, "Services Down"],

  [:p, {class: "gra-p-small"}, services_dn.map do |svc|
    [:button, {class: "gra-btn gra-btn-red gra-btn-small"}, svc.name]
  end ],

  [:h4, {class: "gra-subheading"}, "Services Up"],
  
  [:p, {class: "gra-p-small"}, services_up.map do |svc|
    [:button, {class: "gra-btn gra-btn-green gra-btn-small"}, svc.name]
  end ]]