doctype html
html lang="en"

  head
    title Login
    meta charset="UTF-8"
    link rel="shortcut icon" href=Assets.show(id:"favicon.ico")
    link rel="stylesheet" href=Assets.show(id:"vital.min.css")
    css:
      pre {
        margin:         0.2rem;
        padding:        1rem;
        border-radius:  0.5rem;
      }

  body
    .row.header-center
      .section
        h5 Ecmo: Easy Configuration Management Orchestration

    .contents.hero.bg-green
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
          a href="https://github.com/gabriel-aires/os-probe" Check the Github Repo
