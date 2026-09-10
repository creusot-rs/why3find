(function () {

  function toggle(elt) {
    var elts, j;
    while (elt && !elt.classList.contains("section")) {
      elt = elt.parentElement;
    }
    if (!elt) return;
    elts = elt.querySelectorAll(".section-text, .section-toggle");
    for (j = 0; j < elts.length; j++)
      elts[j].classList.toggle("active");
  }

  function toggleActiveElement() {
    var e, toggled = false;
    const h = window.location.hash;
    const root = e = document.getElementById(h.substring(1));
    const es = [];
    while (e) {
      if (e.classList.contains("section-text")) es.push(e);
      e = e.parentElement;
    }
    while (e = es.pop())
      if (!e.classList.contains("active")) {
        toggle(e);
        toggled = true;
      }
    if (toggled) root.scrollIntoView();
  }

  function onKeyPressed(evt) {
    var elts, e, i;
    if (evt.code === "Escape") {
      window.location = "";
      elts = document.querySelectorAll(".section");
      for (i = 0; i < elts.length; i++) {
        e = elts[i];
        if (e.querySelectorAll(".section-toggle.active").length)
          toggle(e);
      }
    }
  }

  var nodes, i;

  nodes = document.getElementsByClassName("section-toggle");
  for (i = 0; i < nodes.length; i++) {
    nodes[i].addEventListener("click", function () {
      toggle(this);
    });
  }

  toggleActiveElement();
  window.addEventListener('onload', toggleActiveElement);
  window.addEventListener('hashchange', toggleActiveElement);
  window.addEventListener('keypress', onKeyPressed);
})();
