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
