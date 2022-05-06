[:div, {class: "dashboard"},

  [:div, {class: "row"},

    [:div, {class: "col col-25", "hx-get": Gauges.host,   "hx-trigger": "load delay:0.2s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.load,   "hx-trigger": "load delay:0.4s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.memory, "hx-trigger": "load delay:0.6s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.net,    "hx-trigger": "load delay:0.8s, every 10s"}, show_loading]],

  [:div, {class: "row"},

    [:div, {class: "col col-50", "hx-get": Gauges.top, "hx-trigger": "load delay:1.0s, every 10s"}, show_loading],

    [:div,
      { class: "col col-25",
        "hx-get": Gauges.disk(group: "even"),
        "hx-trigger": "load delay:1.2s, every 10s" },
      show_loading ],

    [:div,
      { class: "col col-25",
        "hx-get": Gauges.disk(group: "odd"),
        "hx-trigger": "load delay:1.4s, every 10s" }]],

  [:div, {class: "row"},
    
    [:div, 
      { class: "col",
        "hx-get": Gauges.service, 
        "hx-trigger": "load delay: 1.6s, every 10s" },
      show_loading ]]]