[:div, {class: "gauge-disk"},
  [:h4, {class: "gra-subheading"}, "Storage"],
 	[:div, {class: "gra-card"},
 		[:div, {class: "gra-card-content"},
 			[:h5, {class: "gra-card-title gra-#{accent}-bg"}, "Mount #{disk.partition.not_nil!.mountpoint}"],
 			[:div, {class: "gra-card-body"},
         [:p,
           [:span, {class: "gra-bold-text"}, "Filesystem type: "],
           [:span, disk.partition.not_nil!.fs_type]],
         [:p,
           [:span, {class: "gra-bold-text"}, "Device: "],
           [:span, disk.partition.not_nil!.device]],
         [:p,
           [:span, {class: "gra-bold-text"}, "Size (Mb): "],
           [:span, disk.size_mb.round.to_s]],
         [:p,
           [:span, {class: "gra-bold-text"}, "Used (Mb): "],
           [:span, disk.used_mb.round.to_s]],
         [show_bar(disk.usage.round, "large", accent)]]]]]