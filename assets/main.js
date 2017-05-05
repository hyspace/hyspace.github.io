let html = document.documentElement;
html.classList.remove("nojs");
html.classList.add("domready");
let doms = document.querySelectorAll('[data-toggle-menu]');
for (let dom of doms) {
    dom.addEventListener('click', function() {
        document.body.classList.toggle('menu-open');
    });
}
window.addEventListener('unload', function() {
    document.body.classList.remove('menu-open');
});