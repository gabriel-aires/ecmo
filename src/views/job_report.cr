[
  [:h4, {class: "gra-subheading"}, job.name + " v" + job.rev.to_s],

  [:div, {class: "gra-table-wrapper"},
    [:table, {class: "gra-table"},
      [:tr,
        [:th, "Status"],
        [:td,
          [:a, {href: Jobs.show(id: job.id)},
            log[:success]
              ? [:btn, {class: "gra-btn gra-btn-clear gra-btn-green"}, "Job successful"]
              : [:btn, {class: "gra-btn gra-btn-clear gra-btn-red"}, "Job failed"]
          ]]],
      [:tr,
        [:th, "Duration (ms)"],
        [:td, log[:duration]]],
      [:tr,
        [:td, {colspan: "2"},
          [:pre, log[:output]]]],

      unless log[:success]
        [:tr,
          [:th, "Errors"],
          [:td,
            [:pre, log[:error]]]]
      end ]]]
