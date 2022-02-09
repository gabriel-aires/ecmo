doctype html
html lang="en"

  head
    title Login
    meta charset="UTF-8"
    link rel="shortcut icon" href=Assets.show(id:"favicon.ico")
    link rel="stylesheet" href=Assets.show(id:"vital.min.css")

  body
    .row.header-center
      .section
        h5= "#{App::NAME}: #{App::DESC}"

    .contents.hero class="bg-#{ui_status}"
      - if notice?
        .row.notice
          .section
            .notice-message
              .notice-text= notice
              .notice-dismiss
                img src=Assets.show(id:"icon-vital-close-outline") alt="close icon"

      .row
        .section.center
          form.full-width-forms.padded method="POST" action=Sessions.create
            .col-1-4.space
            .col-1-4.logo
              img src=Assets.show(id:"icon-vital-white.svg")
            .col-1-4
              br
              input name="username" placeholder="Username" required="true" type="text"
              br
              input name="password" placeholder="Password" required="true" type="password"
              br
              input.btn.solid name="submit" type="submit" value="Login"
            .col-1-4.space

    .row.footer.center.full-width-forms
      .section.autogrid
        .col
          a href="https://spider-gazelle.net" Built with S2 and Spider-Gazelle
        .col
          a href="https://github.com/gabriel-aires/ecmo" Check the Github Repo

    javascript:
      notice = document.querySelector(".row.notice");
      closeButton = document.querySelector(".notice-dismiss");
      closeButton.addEventListener("click", function() {
        notice.style.display = "none";
      });
