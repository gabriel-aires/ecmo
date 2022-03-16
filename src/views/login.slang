doctype html
html lang="en"

  head
    title Login
    meta charset="UTF-8"
    link rel="icon" href=Assets.show(id:"activity.svg")
    link rel="stylesheet" href=Assets.show(id:"gralig.min.css")
    link rel="stylesheet" href=Assets.show(id:"ecmo.css")
    script src=Assets.show(id:"dygraph.min.js")
    script src=Assets.show(id:"htmx.min.js")

  body

    header.login.gra-navbar class="gra-#{tone}-bg"
      .gra-container.gra-bold-text
        .gra-navbar-logo
          a.gra-navbar-logo-link href=Home.index
            == Storage.read "assets/activity.svg"
            span= " " + App::NAME

        .gra-navbar-content
          nav
            ul.gra-nav
              li.gra-nav-item
                a.gra-nav-link Built with S2 and Spider-Gazelle

              li.gra-nav-item
                a.gra-nav-link Check the Github Repo

    .gra-container

      .row
        .col.gra-center-text

          - if notice?
            span.gra-alert class=tone role="alert"
              = notice

      .row
        .col.col-span-33.col-33

          form method="POST" action=Sessions.create
            fieldset
              legend
                h5.gra-heading Sign In:
              .gra-form-group
                label for="username" Username
                input#username type="text" name="username" required="true" placeholder="username..."
              .gra-form-group
                label for="password" Password
                input#password type="password" name="password" required="true" placeholder="password..."
              .gra-form-actions
                input.gra-btn class="gra-btn-#{tone}" type="submit" name="submit" value="Go"

      .row

      footer.gra-footer= App::DESC

    javascript:
      notice = document.querySelector("span.gra-alert");
      if (notice) {
        notice.addEventListener("click", function() {
          notice.style.display = "none";
        });
      }
