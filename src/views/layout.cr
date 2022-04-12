[
  %|<!doctype html>|,
  [:html {lang: "en"},

    [:head,
      [:title, "Ecmo"],
      [:meta, {charset: "UTF-8"}],
      [:link, {rel: "icon", href: Assets.show(id: "activity.svg")}],
      [:link, {rel: "stylesheet", href: Assets.show(id: "gralig.min.css")}],
      [:link, {rel: "stylesheet", href: Assets.show(id: "ecmo.css")}],
      [:script, {src: Assets.show(id: "dygraph.min.js")}],
      [:script, {src: Assets.show(id: "htmx.min.js")}],
      [:style, 
        <<-CSS
        pre {
          color: black;
          background: rgb(245, 242, 240) none repeat scroll 0% 0%;
          text-shadow: white 0px 1px;
          font-family: Consolas, Monaco, "Andale Mono", "Ubuntu Mono", monospace;
          text-align: left;
          white-space: pre;
          word-spacing: normal;
          word-break: normal;
          overflow-wrap: normal;
          line-height: 1.5;
          tab-size: 4;
          hyphens: none;
          padding: 1em;
          margin: 0.5em;
          overflow: auto;
        }
        .dark pre {
          background : black;
          color: rgb(245, 242, 240);
          text-shadow: black 0px 1px;
        }
        CSS
        ]]
        
    [:body,

      [:header, {class: "gra-navbar dark"},
        [:div, {class: "gra-container gra-bold-text"},
          [:div, {class: "gra-navbar-logo"},
            [:a, {class: "gra-navbar-logo-link gra-pd-left-l", href: Home.index},
              Storage.read("assets/activity.svg"),
              [:span, " " + App::NAME]]],

          [:div, {class: "gra-navbar-content"},
            [:nav,
              [:ul, {class: "gra-nav"},
                [:li, {class: "gra-nav-item"},
                  [:a, {class: "gra-nav-link", href: "#"},
                    [:div, {class: "user-text"},
                      "#{current_user.not_nil!.name}/#{current_user.not_nil!.type}",
                      [:div, {class: "user-icon"}, Storage.read("assets/user.svg")]]]],

                [:li, {class: "gra-nav-item"},
                  [:a, {class: "gra-nav-link", "hx-delete": Sessions.destroy(id: "close"), "hx-target": "body"},
                    [:div, {class: "logoff-text"}, "Logout"],
                    [:div, {class: "logoff-icon"}, Storage.read("assets/power.svg")]]],

                [:li, {class: "gra-nav-item"},
                  [:a, {class: "gra-nav-link", onclick: "toggleTheme();"},
                    [:div, {class: "sun"}, Storage.read("assets/sun.svg")],
                    [:div, {class: "moon"}, Storage.read("assets/moon.svg")]]]]]]]],
                  
      [:div, {class: "gra-container"},

        [:div, {class: "row"},
          [:div, {class: "col gra-center-text"}, [:span, {class: "gra-alert #{tone}", role: "alert"}, notice] if notice?]],

        [:div, {class: "row"},
          [:div, {class: "col col-80 col-span-10 gra-center-text"},
            [:h1, {class: "gra-heading"}, @title],
            [:h2, {class: "gra-subheading"}, @description]]],

        [:div, {class: "row"},
          [:div, {class: "col col-80 col-span-10"}, content]],
      
        [:div, {class: "row"}]],

      [:footer, {class: "gra-footer"},
        [:nav,
          [:ul, {class: "gra-nav gra-nav-fill"},
            [:li, {class: "gra-nav-item"},
              [:a, {class: "gra-nav-link", href: "https://spider-gazelle.net"}, "Built with S2 and Spider-Gazelle"]],
            [:li, {class: "gra-nav-item"},
              [:a, {class: "gra-nav-link", href: "https://github.com/gabriel-aires/ecmo"}, "Check the Github Repo"]]]]],

      [:script,
        <<-JAVASCRIPT
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
        JAVASCRIPT
        ]]]]
