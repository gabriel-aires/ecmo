doctype html
html lang="en"

  head
    title Welcome
    link rel="shortcut icon" href="/favicon.ico"
    link rel="stylesheet" href="/pico.min.css"

  body.dark
    main.container

      header
        h1 System information for #{hostname}:

      h3 Disk Info
      figure
        pre
          = disk_info

      h3 Process Info
      figure
        pre
          = process_info

      h3 Service Info
      figure
        pre
          = service_info

      footer
        h6 
          | Built with S2 and 
          a href="https://spider-gazelle.net" Spider-Gazelle
        h6 
          | Check the 
          a href="https://github.com/gabriel-aires/os-probe" Github Repo