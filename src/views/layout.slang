doctype html
html lang="en" data-theme="light"

  head
    title Dashboard
    meta charset="UTF-8"
    link rel="shortcut icon" href=Assets.show(id:"favicon.ico")
    link rel="stylesheet" href=Assets.show(id:"pico.min.css")
    css:
      pre {
        margin:         0.2rem;
        padding:        1rem;
        border-radius:  0.5rem;
      }
      
      
  body
    main.container

      header
        nav
          ul
            li
              strong
                a href=Index.index OS-Probe
          ul
            li
              a role="button" onclick="change_theme();" Dark/Light

      br

      == content
              
      br

      footer
        h6 
          | Built with S2 and 
          a href="https://spider-gazelle.net" Spider-Gazelle
        h6 
          | Check the 
          a href="https://github.com/gabriel-aires/os-probe" Github Repo

  javascript:
    function change_theme() {
      const html = document.documentElement;
      if (html.dataset.theme === 'light') {
        html.dataset.theme = 'dark';
      } else {
        html.dataset.theme = 'light';
      }
    }
