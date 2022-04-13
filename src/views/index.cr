[:div, {class: "row"},

  [:div, {class: "col col-20 col-span-10"},

    [:a, {class: "gra-btn gra-btn-yellow square", href: Dashboard.index},
      [:div, {class: "gra-block"}, Storage.read "assets/info.svg"]],

    [:br],
    [:div, {class: "gra-center-text"},
      [:h5, {class: "gra-subheading"}, "Info"]]],

  [:div, {class: "col col-20"},

    [:a, {class: "gra-btn gra-btn-red square", href: Metrics.index},
      [:div, {class: "gra-block"}, Storage.read "assets/trending-up.svg"]],

    [:br],
    [:div, {class: "gra-center-text"},
      [:h5, {class: "gra-subheading"}, "Metrics"]]],

  [:div, {class: "col col-20"},

    [:a, {class: "gra-btn gra-btn-green square", href: Jobs.index},
      [:div, {class: "gra-block"}, Storage.read "assets/zap.svg"]],

    [:br],
    [:div, {class: "gra-center-text"},
      [:h5, {class: "gra-subheading"}, "Jobs"]]],

  [:div, {class: "col col-20"},

    [:a, {class: "gra-btn gra-btn-blue square", href: "#"},
      [:div, {class: "gra-block"}, Storage.read "assets/tool.svg"]],

    [:br],
    [:div, {class: "gra-center-text"},
      [:h5, {class: "gra-subheading"}, "Config"]]]]
