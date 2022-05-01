[:div, {class: "dashboard"},

  [:div, {class: "row"},

    [:div, {class: "col col-25", "hx-get": Gauges.host,   "hx-trigger": "load delay:0.4s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.load,   "hx-trigger": "load delay:1.4s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.memory, "hx-trigger": "load delay:2.4s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.net,    "hx-trigger": "load delay:3.4s, every 10s"}, show_loading]],

  [:div, {class: "row"},

    [:div, {class: "col col-25", "hx-get": Gauges.disk(group: "even"),  "hx-trigger": "load delay:4.4s, every 10s"}, show_loading],
    [:div, {class: "col col-25", "hx-get": Gauges.disk(group: "odd"),   "hx-trigger": "load delay:5.4s, every 10s"}, show_loading]]]
