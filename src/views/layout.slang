doctype html
html lang="en"

  head
    title= App::NAME
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
    .row.header
      .section
        nav
          a.logo href=Home.index
            img src=Assets.show(id:"icon-vital-#{ui_status}.svg")

    .contents
      - if notice?
        .row.notice
          .section
            .notice-message
              .notice-text= notice
              .notice-dismiss
                img src=Assets.show(id:"icon-vital-close-outline") alt="close icon"

      .row.hero.light-text class="bg-#{ui_status}"
        .section.narrow.center
          h1= App::NAME
          hr.small.opacity-4
          h2= App::NAME

      .row
        .section
          == content

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
