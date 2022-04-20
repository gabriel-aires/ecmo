[
  [:h3, "System Information for #{host[:name]}"],

  [:details,
    [:summary, {class: "gra-btn gra-btn-full-width gra-btn-#{tone}"}, "Machine Info"],
    [:div, {class: "gra-table-wrapper"},
      [:table, {class: "gra-table"}, 
        [:tr,
          [:th, "OS"],
          [:td, host[:os]]],
        [:tr,
          [:th, "Architecture"],
          [:td, host[:arch]]],
        [:tr,
          [:th, "Uptime"],
          [:td, host[:uptime]]],
        [:tr,
          [:th, "Boot Time"],
          [:td, Time.new(seconds: boot[:seconds], nanoseconds: 0, location: Time.local.location).to_s]]]]],

  [:br],

  [:details,
    [:summary, {class: "gra-btn gra-btn-full-width gra-btn-#{tone}"}, "Hardware Resources"],
    [:div, {class: "gra-table-wrapper"},
      [:table, {class: "gra-table"},
        [:tr,
          [:th, "Total Memory (Mb)"],
          [:td, memory[:total_mb].to_s]],
        [:tr,
          [:th, "Used Memory (Mb)"],
          [:td, memory[:used_mb].to_s]],
        [:tr,
          [:th, "Free Memory (Mb)"],
          [:td, memory[:free_mb].to_s]],
        [:tr,
          [:th, "Load (1m)"],
          [:td, load[:load1].to_s]],
        [:tr,
          [:th, "Load (5m)"],
          [:td, load[:load5].to_s]],
        [:tr,
          [:th, "Load (15m)"],
          [:td, load[:load15].to_s]]]]],

  [:br],

  [:details,
    [:summary, {class: "gra-btn gra-btn-full-width gra-btn-full-#{tone}"}, "Net I/O"],
    [:div, {class: "gra-table-wrapper"},
      [:table, {class: "gra-table"},
        [:tr,
          [:th, "Upload (Mb)"],
          [:td, net[:sent_mb].to_s]],
        [:tr,
          [:th, "Download (Mb)"],
          [:td, net[:received_mb].to_s]],
        [:tr,
          [:th, "Packets Received"],
          [:td, net[:packets_in].to_s]],
        [:tr,
          [:th, "Packets Sent"],
          [:td, net[:packets_out].to_s]]]]],

  [:h3, "Disk Details"],

  disks.sort_by {|d| d[:usage].to_f}.reverse.map do |disk|

    accent = case disk[:usage].to_f
      when .<= 25.0 then "blue"
      when .<= 50.0 then "green"
      when .<= 75.0 then "yellow"
      else "red"
    end
    
    offset = 100.0 - disk[:usage].to_f

    [:details, {class: "gra-dropdown gra-#{accent}-color gra-mg-all-s gra-inline-block"},
      [:summary, {class: "gra-dropdown-wrapper"},
      	[:h5, {class: "gra-block gra-thin-text gra-center-text gra-pd-all-s"}, disk[:mount]],
      	[:span, {class: "gra-block gra-progress-bar"},
          [:span, {class: "gra-progress-bar-value #{accent}", style: "transform: translateX(-#{offset}%);"}]]],

      [:ul, {class: "gra-dropdown-list gra-block-list"},
        [:li, {class: "gra-dropdown-list-item gra-list-item"},
          [:span, {class: "gra-bold-text"}, "Filesystem type: "],
          [:span, disk[:fstype]]],
        [:li, {class: "gra-dropdown-list-item gra-list-item"},
          [:span, {class: "gra-bold-text"}, "Device: "],
          [:span, disk[:device]]],
        [:li, {class: "gra-dropdown-list-item gra-list-item"},
          [:span, {class: "gra-bold-text"}, "Size (Mb): "],
          [:span, disk[:size_mb].to_s]],
        [:li, {class: "gra-dropdown-list-item gra-list-item"},
          [:span, {class: "gra-bold-text"}, "Used (Mb): "],
          [:span, disk[:used_mb].to_s]],
        [:li, {class: "gra-dropdown-list-item gra-list-item"},
          [:span, {class: "gra-bold-text"}, "Free (Mb): "],
          [:span, disk[:free_mb].to_s]],
        [:li, {class: "gra-dropdown-list-item gra-list-item"},
          [:span, {class: "gra-bold-text"}, "Usage (%): "],
          [:span, disk[:usage].to_s]]]]

  end ,

  [:h3, "Process Details"],

  pids.map do |pid|

    [:div,

      [:details,
        [:summary, {class: "btn solid #{tone}"}, "#{pid[:pid]} - #{pid[:name]}"],

        [:table, {role: "grid"},
          [:tr,
            [:th, "Command"],
            [:td, pid[:cmd]]],
          [:tr,
            [:th, "Memory"],
            [:td, pid[:memory]]],
          [:tr,
            [:th, "Threads"],
            [:td, pid[:threads]]],
          [:tr,
            [:th, "State"],
            [:td, pid[:state]]],
          [:tr,
            [:th, "Parent"],
            [:td, pid[:parent]]]],

      [:br]]]

  end ]
