[
  [%|<!doctype html>|],
  [:html, {lang: "en"},

    [:head,
      [:title,  "Login"],
      [:meta,   {charset: "UTF-8"}],
      [:link,   {rel: "icon", href: Assets.show(id: "activity.svg")}],
      [:link,   {rel: "stylesheet", href: Assets.show(id: "gralig.min.css")}],
      [:link,   {rel: "stylesheet", href: Assets.show(id: "ecmo.css")}],
      [:script, {src: Assets.show(id: "dygraph.min.js")}],
      [:script, {src: Assets.show(id: "htmx.min.js")}]],

    [:body,

      [:header, {class: "login gra-navbar gra-green-bg"},
        [:div, {class: "gra-container gra-bold-text"},
          [:div, {class: "gra-navbar-logo"},
            [:a, {class: "gra-navbar-logo-link", href: Home.index},
              Storage.read("assets/activity.svg"),
              [:span, " " + App::NAME]]],

          [:div, {class: "gra-navbar-content"},
            [:nav,
              [:ul, {class: "gra-nav"},
                [:li, {class: "gra-nav-item"},
                  [:a, {class: "gra-nav-link"}, "Built with S2 and Spider-Gazelle"]],
                [:li, {class: "gra-nav-item"},
                  [:a, {class: "gra-nav-link"}, "Check the Github Repo"]]]]]]],

      [:div, {class: "gra-container"},

        [:div, {class: "row"},
          [:div, {class: "col gra-center-text"},
          if notice?
            [:span, {class: "gra-alert yellow", role: "alert"}, notice]
          end ]],

        [:div, {class: "row"},
          [:div, {class: "col col-span-33 col-33"},

            [:form, {method: "POST", action: Sessions.create},
              [:fieldset,
                [:legend,
                  [:h5, {class: "gra-heading"}, "Sign In:"]],
                [:div, {class: "gra-form-group"},
                  [:label, {for: "username"}, "Username"],
                  [:input, {id: "username", type: "text", name: "username", required: "true", placeholder: "username..."}]],
                [:div, {class: "gra-form-group"},
                  [:label, {for: "password"}, "Password"],
                  [:input, {id: "password", type: "password", name: "password", required: "true", placeholder: "password..."}]],
                [:div, {class: "gra-form-actions"},
                  [:input, {class: "gra-btn gra-btn-green", type: "submit", name: "submit", value: "Go"}]]]]]],

        [:div, {class: "row"}],

        [:footer, {class: "gra-footer"}, App::DESC]],

      [:script,
      	<<-JAVASCRIPT
        notice = document.querySelector("span.gra-alert");
        if (notice) {
          notice.addEventListener("click", function() {
            notice.style.display = "none";
          });
        }
        JAVASCRIPT
      ]]]]
