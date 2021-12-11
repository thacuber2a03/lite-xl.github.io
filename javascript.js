window.addEventListener('DOMContentLoaded', function() {
  function hideMenus(except) { document.querySelectorAll('menu.active').forEach(function(e) { if (e != except) e.classList.remove('active'); }) }
  function setActive(id, pushState) {
    hideMenus();
    document.querySelectorAll('pages page.active').forEach(function(p) { p.classList.remove('active'); });
    (document.querySelector("#page-" + (id || "index")) || document.querySelector('#page-404')).classList.add('active');
    document.querySelector('content').className = id || "index";
    document.title = "Lite XL" + (id && id != "index" ? " - " + document.querySelector('page.active h1').textContent : "");
    if (pushState) 
      history.pushState({ id: id }, document.title, window.location.pathname + (id && id != "index" ? "?/" + id.replace(/\-/,"/") : ""));
  }
  document.querySelectorAll('menu').forEach(function(e) { e.addEventListener('click', function(ev) { hideMenus(e); ev.stopPropagation(); e.classList.toggle('active'); }) })
  document.querySelector('expander').addEventListener('click', function(e) { document.querySelector('links').classList.toggle('active'); })
  document.querySelector('body').addEventListener('click', hideMenus);
  window.addEventListener('popstate', function(e) { setActive(e.state.id, false); });
  document.querySelectorAll('a[href^="http"], a[href^="//"], a[href^="img"]').forEach(function(a) { a.setAttribute('target', "_blank"); });
  document.querySelectorAll('a[href^="/"]').forEach(function(a) { a.addEventListener('click', function(ev) {
    ev.stopPropagation(); ev.preventDefault();
    setActive(a.getAttribute('href').toLowerCase().replace(/\/$/, "").replace(/^\/\w{2}/, "").replace(/\//g, "-").replace(/^-/, ""), true);
  })});
  setActive(window.location.search.replace(/^\?\/?/, "").replace(/\/$/, "").replace(/\//g, "-") || "index", true);
});
