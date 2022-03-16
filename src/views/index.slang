.row

  .col.col-20.col-span-10

    a.gra-btn.gra-btn-yellow.square href="#"
      .gra-block
        == Storage.read "assets/info.svg"

    br
    .gra-center-text
      h5.gra-subheading Info

  .col.col-20

    a.gra-btn.gra-btn-red.square href="#"
      .gra-block
        == Storage.read "assets/trending-up.svg"

    br
    .gra-center-text
      h5.gra-subheading Metrics

  .col.col-20

    a.gra-btn.gra-btn-green.square href="#"
      .gra-block
        == Storage.read "assets/zap.svg"

    br
    .gra-center-text
      h5.gra-subheading Jobs

  .col.col-20

    a.gra-btn.gra-btn-blue.square href="#"
      .gra-block
        == Storage.read "assets/tool.svg"

    br
    .gra-center-text
      h5.gra-subheading Config
