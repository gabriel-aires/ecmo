[:div, {class: "dashboard"},

  [:div, {class: "row"},

    [:div, {class: "col col-25", "hx-get": Gauges.host,   "hx-trigger": "every 20s"}],
    [:div, {class: "col col-25", "hx-get": Gauges.load,   "hx-trigger": "every 20s delay:1s"}],
    [:div, {class: "col col-25", "hx-get": Gauges.memory, "hx-trigger": "every 20s delay:2s"}],
    [:div, {class: "col col-25", "hx-get": Gauges.net,    "hx-trigger": "every 20s delay:3s"}]]]