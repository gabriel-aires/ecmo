doctype html
html lang="en"

  head
    title Ecmo
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
            img src=Assets.show(id:"icon-vital-orange.svg")

    .contents
      .row.hero.bg-orange.light-text
        .section.narrow.center
          h1 Ecmo
          hr.small.opacity-4
          h2 Easy Configuration Management Orchestration

      .row
        .section
          == content

    .row.footer
      .section
        h6
          | Built with S2 and
          a href="https://spider-gazelle.net" Spider-Gazelle
        h6
          | Check the
          a href="https://github.com/gabriel-aires/os-probe" Github Repo
