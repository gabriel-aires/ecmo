[
  [:h4, {class: "gra-subheading"}, "Database details"],
  [:div, {class: "gra-table-wrapper"},
    [:table, {class: "gra-table"},
      [:thead,
        [:tr,
          [:th, "Size"],
          [:th, "File"]]],
      [:tbody,
        du_output.split("\n").map do |line|
          [:tr,
            line.split("\t").map do |field|
              [:td, field]
            end ]
        end ]]],

  [:br],
  [:h5, {class: "gra-subheading"}, "Perform backup?"],

  [:form, {method: "post", action: Jobs.bkp_db},
    [:div, {class: "gra-form-actions"},
      [:a, {class: "gra-btn gra-btn-red gra-btn-outline", href: Jobs.index}, "Cancel"],
      [:input, {class: "gra-btn", type: "submit", value: "Start"}]]]]
