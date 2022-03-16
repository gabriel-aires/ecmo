doctype html
html lang="en"

  head
    title Ecmo
    meta charset="UTF-8"
    link rel="icon" href=Assets.show(id:"activity.svg")
    link rel="stylesheet" href=Assets.show(id:"gralig.min.css")
    link rel="stylesheet" href=Assets.show(id:"ecmo.css")
    script src=Assets.show(id:"dygraph.min.js")
    script src=Assets.show(id:"htmx.min.js")

  body

    header.gra-navbar.dark
      .gra-container.gra-bold-text
        .gra-navbar-logo
          a.gra-navbar-logo-link.gra-pd-left-l href=Home.index
            == Storage.read "assets/activity.svg"
            span= " " + App::NAME

        .gra-navbar-content
          nav
            ul.gra-nav
              li.gra-nav-item
                a.gra-nav-link href="#"
                  .user-text #{current_user.not_nil!.name}/#{current_user.not_nil!.type}
                  .user-icon
                    == Storage.read "assets/user.svg"

              li.gra-nav-item
                a.gra-nav-link hx-delete=Sessions.destroy(id:"close") hx-target="body"
                  .logoff-text Logout
                  .logoff-icon
                    == Storage.read "assets/power.svg"

              li.gra-nav-item
                a.gra-nav-link onclick="toggleTheme();"
                  .sun
                    == Storage.read "assets/sun.svg"
                  .moon
                    == Storage.read "assets/moon.svg"

    .gra-container

      .row
        .col.gra-center-text

          - if notice?
            span.gra-alert class=tone role="alert"
              = notice

      .row
        .col.col-80.col-span-10.gra-center-text
          h1.gra-heading= @title
          h2.gra-subheading= @description

      .row
        .col.col-80.col-span-10
          == content

      .row

    footer.gra-footer
      nav
        ul.gra-nav.gra-nav-fill
          li.gra-nav-item
            a.gra-nav-link href="https://spider-gazelle.net" Built with S2 and Spider-Gazelle
          li.gra-nav-item
            a.gra-nav-link href="https://github.com/gabriel-aires/ecmo" Check the Github Repo

    javascript:
      var notice = document.querySelector("span.gra-alert");
      if (notice) {
        notice.addEventListener("click", function() {
          notice.style.display = "none";
        });
      }

      var pref = (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches);
      toggleTheme();

      function toggleTheme() {
        var sun = document.querySelector(".sun");
        var moon = document.querySelector(".moon");
        document.body.className = pref ? "dark" : "";
        sun.style.display = pref ? "none" : "block";
        moon.style.display = pref ? "block" : "none";
        pref = !pref
      }
