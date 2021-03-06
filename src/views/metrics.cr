[:div, {class: "row"},

  @links.not_nil!.map do |name, props|

    color, icon = props
    btn_class = color == "gray" ? "square gra-btn" : "square gra-btn gra-btn-" + color

    [:div, {class: "col col-20"},
      [:a, {class: btn_class, href: Metrics.show(id: name.downcase)},
        [:div, {class: "gra-block"}, Storage.read(icon)]],
      [:br],
      [:div, {class: "gra-center-text"},
        [:h5, {class: "gra-subheading"}, name]]]

  end ]
