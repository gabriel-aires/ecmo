[:div, {class: "gauge-load"},
  [:h4, {class: "gra-subheading"}, "System Load"],
  [:div, {class: "gra-table-wrapper"},
    [:table, {class: "gra-table"},
      [:tr,
        [:th, "1m #{load.load1}"],
        [:td, [show_bar(load.load1 * 100.0 / (load.load1 + load.load5 + load.load15), "large", "red")]]],
      [:tr,
        [:th, "5m #{load.load5}"],
        [:td, [show_bar(load.load5 * 100.0 / (load.load1 + load.load5 + load.load15), "large", "yellow")]]],
      [:tr,
        [:th, "15m #{load.load15}"],
        [:td, [show_bar(load.load15 * 100.0 / (load.load1 + load.load5 + load.load15), "large", "yellow")]]]]]]