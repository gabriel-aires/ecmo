doctype html
html lang="en"

  head
    title= App::NAME
    meta charset="UTF-8"
    link rel="shortcut icon" href=Assets.show(id:"favicon.ico")
    link rel="stylesheet" href=Assets.show(id:"vital.min.css")
    script src=Assets.show(id:"htmx.min.js")
    css:
      code {
        width:          100%;
      }
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
            img src=Assets.show(id:"icon-vital-#{tone}.svg")
          label#menu-toggle-label for="menu-toggle"
          input#menu-toggle type="checkbox"
          .icon-menu
          ul.menu
            li
              a href="#" Logged in as #{current_user.not_nil!.name}/#{current_user.not_nil!.type}
            li
              a hx-delete=Sessions.destroy(id:"close") hx-target="body" Logout

    - if notice?
      .row.notice
        .section
          .notice-message
            .notice-text= notice
            .notice-dismiss
              img src=Assets.show(id:"icon-close-outline.svg") alt="close icon"

    .contents
      .row.light-text class="bg-#{tone}"
        .section.narrow.center
          h1= @title
          hr.small.opacity-4
          h2= @description

      .row
        .section.full-width-forms
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
      if (closeButton) {
        closeButton.addEventListener("click", function() {
          notice.style.display = "none";
        });
      }
