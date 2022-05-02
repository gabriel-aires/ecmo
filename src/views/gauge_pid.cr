[:div, {class: "gauge-top"},
  [:h4, {class: "gra-subheading"}, "Processes"],
  [:div, {class: "gra-table-wrapper"},
    [:table, {class: "gra-table"},
    	[:tr,	[:th, "#"], [:th, "Name"], [:th, "Cmd"], [:th, "Mem (Mb)"]],
    
    	pids.map do |p|
        	
        [:tr,
        	[:td, p.pid.to_s],
        	[:td, p.command.name],
        	[:td, (p.command.line.size < 36) ? p.command.line : p.command.line[0,32] + " ..."],
        	[:td, p.memory.round.to_s ]] 
        	
    	end ]]]
