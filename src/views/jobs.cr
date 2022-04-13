[
	[:h4, "Scheduled Jobs"],
	
  on_schedule.map do |job|
    
    [:div,
      [:details,
        [:summary, {class: "btn solid #{tone}"}, job.name],
        [:table,
          [:tr,
            [:th, "Schedule"],
            [:td, job.cron]],
          [:tr,
            [:th, "Path"],
            [:td, job.path]],
          [:tr,
            [:th, "Definition"],
            [:td,
              [:pre, File.read(job.path)]]],
          [:tr,
            [:th, "Version"],
            [:td, job.rev]],
          [:tr,
            [:th, "Log level"],
            [:td, job.log]],
          [:tr,
            [:th, "Last Run"],
            [:td,
            	[:a, {href: Jobs.show(id: job.id)},
            		last_run(job.id)[:success] ? [:ins, "View Log"] : [:del, "View Log"]
            	]]]]],

      [:br]]

	end ,

  [:h4, "On-Demand Jobs"],
  
  on_demand.map do |job|

		[:div,
      [:details,
        [:summary, {class: "btn solid #{tone}"}, job.name],
        [:table, {role: "grid"},
          [:tr,
            [:th, "Path"],
            [:td, job.path]],
          [:tr,
            [:th, "Definition"],
            [:td,
              [:pre, File.read(job.path)]]],
          [:tr,
            [:th, "Version"],
            [:td, job.rev]],
          [:tr,
            [:th, "Log level"],
            [:td, job.log]],
          [:tr,
            [:th, "Last Run"],
            [:td,
              [:a, {href: Jobs.show(id: job.id)},
          			last_run(job.id)[:success] ? [:ins, "View Log"] : [:del, "View Log"]
          		]]],
          [:tr,
            [:th, "Run job"],
            [:td,
              [:a,
              	{ class:				"btn solid black",
              		"hx-put":			Jobs.replace(id: job.id),
              		"hx-target":	"body" },
              	"Start!" ]]]]],

      [:br]]

	end ,

  [:h4, "Ecmo Maintenance" ],

  [:a, {class: "btn solid #{tone}", href: Jobs.bkp_info}, "Backup Data"]]
