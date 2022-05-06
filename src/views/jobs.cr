[
	[:h4, {class: "gra-subheading"}, "Scheduled Jobs"],
	
  on_schedule.map do |job|
    
    [:div,
      [:details,
        [:summary, {class: "gra-btn gra-btn-blue gra-btn-full-width"}, job.name],
        [:div, {class: "gra-table-wrapper"},
          [:table, {class: "gra-table"},
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
              	[:a, {href: Jobs.show(id: job.id)}, [:btn,
                  {class: last_run(job.id)[:success] ? "gra-btn gra-btn-blue" : "gra-btn gra-btn-red"},
                  "View Log"
                ]]]]]]],

      [:br]]

	end ,

  [:h4, {class: "gra-subheading"}, "On-Demand Jobs"],
  
  on_demand.map do |job|

		[:div,
      [:details,
        [:summary, {class: "gra-btn gra-btn-green gra-btn-full-width"}, job.name],
        [:div, {class: "gra-table-wrapper"},
          [:table, {class: "gra-table"},
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
                [:a, {href: Jobs.show(id: job.id)}, [:btn,
            			{class: last_run(job.id)[:success] ? "gra-btn gra-btn-green" : "gra-btn gra-btn-red"},
                  "View Log"
            		]]],
            [:tr,
              [:th, "Run job"],
              [:td,
                [:a,
                	{ class:				"gra-btn",
                		"hx-put":			Jobs.replace(id: job.id),
                		"hx-target":	"body" },
                	"Start!" ]]]]]],

      [:br]]

	end ,

  [:h4, {class: "gra-subheading"}, "Ecmo Maintenance" ],

  [:a, {class: "gra-btn gra-btn-yellow gra-btn-full-width", href: Jobs.bkp_info}, "Backup Data"]]
