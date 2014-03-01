/*globals Node:true, NodeList:true*/
$ = (function (document, window, $) {
  // Node covers all elements, but also the document objects
  var node = Node.prototype,
      nodeList = NodeList.prototype,
      forEach = 'forEach',
      trigger = 'trigger',
      each = [][forEach],
      // note: createElement requires a string in Firefox
      dummy = document.createElement('i');

  nodeList[forEach] = each;

  // we have to explicitly add a window.on as it's not included
  // in the Node object.
  window.on = node.on = function (event, fn) {
    this.addEventListener(event, fn, false);

    // allow for chaining
    return this;
  };

  nodeList.on = function (event, fn) {
    this[forEach](function (el) {
      el.on(event, fn);
    });
    return this;
  };

  // we save a few bytes (but none really in compression)
  // by using [trigger] - really it's for consistency in the
  // source code.
  window[trigger] = node[trigger] = function (type, data) {
    // construct an HTML event. This could have
    // been a real custom event
    var event = document.createEvent('HTMLEvents');
    event.initEvent(type, true, true);
    event.data = data || {};
    event.eventName = type;
    event.target = this;
    this.dispatchEvent(event);
    return this;
  };

  nodeList[trigger] = function (event) {
    this[forEach](function (el) {
      el[trigger](event);
    });
    return this;
  };

  $ = function (s) {
    // querySelectorAll requires a string with a length
    // otherwise it throws an exception
    var r = document.querySelectorAll(s || '☺'),
        length = r.length;
    // if we have a single element, just return that.
    // if there's no matched elements, return a nodeList to chain from
    // else return the NodeList collection from qSA
    return length == 1 ? r[0] : r;
  };

  // $.on and $.trigger allow for pub/sub type global
  // custom events.
  $.on = node.on.bind(dummy);
  $[trigger] = node[trigger].bind(dummy);

  return $;
})(document, this);
var container, el, element, index, list, newElement, _i, _len;

newElement = function(tagName, className, innderHTML) {
  var el;
  if (tagName == null) {
    tagName = "div";
  }
  el = document.createElement(tagName);
  if (innderHTML != null) {
    el.innderHTML = innderHTML;
  }
  if (className != null) {
    el.className = className;
  }
  return el;
};

list = $(".article-content > p,\n.article-content > h1,\n.article-content > h2,\n.article-content > h3,\n.article-content > h4,\n.article-content > h5,\n.article-content > h6,\n.article-content > ul,\n.article-content > ol,\n.article-content > blockquote,\n.article-content > dl").slice();

container = $('#inline-comments');

for (index = _i = 0, _len = list.length; _i < _len; index = ++_i) {
  element = list[index];
  el = newElement('a', 'comments-count', index);
  el.style.top = "" + element.offsetTop + "px";
  container.appendChild(el);
}

$('[data-toggle-menu]').on('click', function() {
  return document.body.classList.toggle('menu-open');
});
