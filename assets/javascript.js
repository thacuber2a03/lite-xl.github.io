window.addEventListener('DOMContentLoaded', function() {
  function click(selector, callback) { document.querySelectorAll(selector).forEach(function(e) { e.addEventListener('click', function(ev) { callback(ev, e); }); }) }
  function hideMenus(except) { document.querySelectorAll('menu.active').forEach(function(e) { if (e != except) e.classList.remove('active'); }) }
  click('menu', function(ev, e) { hideMenus(e); ev.stopPropagation(); e.classList.toggle('active'); });
  click('expander', function() { document.querySelector('links').classList.toggle('active'); });
  click('body', hideMenus);
});
