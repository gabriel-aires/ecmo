.row

  - @links.not_nil!.each_key do |name|
    - color, icon = @links.not_nil![name]
    - btn_class = color == "gray" ? "square gra-btn" : "square gra-btn gra-btn-" + color

    .col.col-20
      a class=btn_class href=Metrics.show(id:name.downcase)
        .gra-block
          == Storage.read icon
      br
      .gra-center-text
        h5.gra-subheading= name
