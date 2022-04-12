[
  [:h4, "Database details"],
  [:table,
    [:thead,
      [:tr,
        [:th, "Size"],
        [:th, "File"]]],
    [:tbody,
      du_output.split("\n").map do |line|
        [:tr,
          line.split("\t").map do |field|
            [:td, field]
	  end
        ]
      end
    ]
  ],

  [:p, "Perform backup?"],

  [:form, {method: "post", action: Jobs.bkp_db},
    [:p,
      [:a, {class: "btn #{tone}", href: Jobs.index}, "Cancel"]],
    [:p,
      [:input, {class: "btn solid #{tone}", type: "submit", value: "Start"}]]]]
