[
  [:h4, job.name + " v" + job.rev.to_s],

  [:figure,
    [:table,
      [:tr,
        [:th, "Status"], 
        [:td,
          [:a, {href: Jobs.show(id: job.id),
            log[:success] ? [:ins, "Job successful"] : [:del, "Job failed"]
          ]]],
      [:tr
        [:th, "Duration (ms)"],
        [:td, log[:duration]]],
      [:tr
        [:td, {colspan: "2"},
          [:pre, log[:output]]]],
      [:tr,
        [:th, "Errors"],
        [:td,
          [:pre, log[:error]]]] unless log[:success] ]]]
