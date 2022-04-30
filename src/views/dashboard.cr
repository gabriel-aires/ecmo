[:div, {class: "dashboard"},

  [:div, {class: "row"},

    [:div, {class: "col col-25"},
      [:h4, {class: "gra-subheading"}, "Machine Info"],
      [:div, {class: "gra-table-wrapper"},
        [:table, {class: "gra-table"}, 
          [:tr,
            [:th, "Hostname"],
            [:td, host[:name]]],
          [:tr,
            [:th, "OS"],
            [:td, "#{host[:os]} #{host[:arch]}"]],
          [:tr,
            [:th, "Uptime"],
            [:td, host[:uptime]]],
          [:tr,
            [:th, "Boot Time"],
            [:td, Time.new(seconds: boot[:seconds], nanoseconds: 0, location: Time.local.location).to_s]]]]],

    [:div, {class: "col col-25"},
      [:h4, {class: "gra-subheading"}, "System Load"],
      [:div, {class: "gra-table-wrapper"},
        [:table, {class: "gra-table"},
          [:tr,
            [:th, "1m #{load[:load1]}"],
            [:td, [show_bar(load[:load1] * 100.0 / (load[:load1] + load[:load5] + load[:load15]), "large", "red")]]],
          [:tr,
            [:th, "5m #{load[:load5]}"],
            [:td, [show_bar(load[:load5] * 100.0 / (load[:load1] + load[:load5] + load[:load15]), "large", "yellow")]]],
          [:tr,
            [:th, "15m #{load[:load15]}"],
            [:td, [show_bar(load[:load15] * 100.0 / (load[:load1] + load[:load5] + load[:load15]), "large", "yellow")]]]]]],

    [:div, {class: "col col-25"},
      [:h4, {class: "gra-subheading"}, "Memory Usage"],
      [:div, {class: "gra-table-wrapper"},
        [:table, {class: "gra-table"},
          [:tr,
            [:th, "Total #{memory[:total_mb].round}Mb"],
            [:td, "Used #{memory[:used_mb].round}Mb"]]]],
      [show_arc(memory[:used_mb] * 100.0 / memory[:total_mb], "large", "green")]],

    [:div, {class: "col col-25"},
      [:h4, {class: "gra-subheading"}, "Net I/O"],
      [:div, {class: "gra-table-wrapper"},
        [:table, {class: "gra-table"},
          [:tr,
            [:th, "Upload #{net[:sent_mb].round}Mb"],
            [:td, [show_bar(net[:sent_mb] * 100.0 / (net[:sent_mb] + net[:received_mb]), "large", "blue")]]],
          [:tr,
            [:th, "Download #{net[:received_mb].round}Mb"],
            [:td, [show_bar(net[:received_mb] * 100.0 / (net[:sent_mb] + net[:received_mb]), "large", "blue")]]]]]]],

  [:div, {class: "row"},

    disks
    .reject { |d| d[:size_mb] == 0.0 }
    .sort_by { |d| d[:usage].to_f }
    .reverse
    .map do |disk|

      accent = case disk[:usage].to_f
        when .<= 25.0 then "blue"
        when .<= 50.0 then "green"
        when .<= 75.0 then "yellow"
        else "red"
      end
      
      [:div, {class: "col col-25"},
      	[:div, {class: "gra-card"},
      		[:div, {class: "gra-card-content"},
      			[:h5, {class: "gra-card-title"}, "Disk #{disk[:mount]}"],
      			[:div, {class: "gra-card-body"},
              [:p,
                [:span, {class: "gra-bold-text"}, "Filesystem type: "],
                [:span, disk[:fstype]]],
              [:p,
                [:span, {class: "gra-bold-text"}, "Device: "],
                [:span, disk[:device]]],
              [:p,
                [:span, {class: "gra-bold-text"}, "Size (Mb): "],
                [:span, disk[:size_mb].to_s]],
              [:p,
                [:span, {class: "gra-bold-text"}, "Used (Mb): "],
                [:span, disk[:used_mb].to_s]],
              [show_bar(disk[:usage].to_f.round, "large", accent)]]]]]

    end ]]