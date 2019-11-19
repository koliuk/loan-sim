/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/pagy.js.erb");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/pagy.js.erb":
/*!******************************************!*\
  !*** ./app/javascript/packs/pagy.js.erb ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(global) {// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript
function Pagy() {}

Pagy.version = '3.7.0';

Pagy.init = function (arg) {
  var target = arg instanceof Event || arg === undefined ? document : arg,
      jsonTags = target.getElementsByClassName('pagy-json');

  if (target === document) {
    // reset resize-listeners on page load (#163)
    for (var id in Pagy.navResizeListeners) {
      window.removeEventListener('resize', Pagy.navResizeListeners[id], true);
    }

    Pagy.navResizeListeners = {};
  }

  for (var i = 0, len = jsonTags.length; i < len; i++) {
    var args = JSON.parse(jsonTags[i].innerHTML);
    Pagy[args.shift()].apply(null, args);
  }
};

Pagy.nav = function (id, tags, sequels, param) {
  var pagyEl = document.getElementById(id),
      lastWidth = undefined,
      timeoutId = 0,
      pageREg = new RegExp(/__pagy_page__/g),
      widths = [],
      rendering = function rendering() {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(pagyEl.render, 150);
  }; // suppress rapid firing rendering


  for (var width in sequels) {
    widths.push(parseInt(width));
  } // fine with sequels structure


  widths.sort(function (a, b) {
    return b - a;
  });

  pagyEl.render = function () {
    if (this.parentElement.clientWidth === 0) {
      rendering();
    }

    var width, i, len;

    for (i = 0, len = widths.length; i < len; i++) {
      if (this.parentElement.clientWidth > widths[i]) {
        width = widths[i];
        break;
      }
    }

    if (width !== lastWidth) {
      var html = tags.before,
          series = sequels[width];

      for (i = 0, len = series.length; i < len; i++) {
        var item = series[i];

        if (typeof param === 'string' && item === 1) {
          html += Pagy.trim(tags.link.replace(pageREg, item), param);
        } else if (typeof item === 'number') {
          html += tags.link.replace(pageREg, item);
        } else if (item === 'gap') {
          html += tags.gap;
        } else if (typeof item === 'string') {
          html += tags.active.replace(pageREg, item);
        }
      }

      html += tags.after;
      this.innerHTML = '';
      this.insertAdjacentHTML('afterbegin', html);
      lastWidth = width;
    }
  }.bind(pagyEl);

  if (widths.length > 1) {
    // refresh the window resize listener (avoiding rendering multiple times)
    window.removeEventListener('resize', Pagy.navResizeListeners[id], true); // needed for AJAX init

    window.addEventListener('resize', rendering, true);
    Pagy.navResizeListeners[id] = rendering;
  }

  pagyEl.render();
};

Pagy.combo_nav = function (id, page, link, param) {
  var pagyEl = document.getElementById(id),
      input = pagyEl.getElementsByTagName('input')[0],
      go = function go() {
    if (page !== input.value) {
      var html = link.replace(/__pagy_page__/, input.value);

      if (typeof param === 'string' && input.value === '1') {
        html = Pagy.trim(html, param);
      }

      pagyEl.insertAdjacentHTML('afterbegin', html);
      pagyEl.getElementsByTagName('a')[0].click();
    }
  };

  Pagy.addInputEventListeners(input, go);
};

Pagy.items_selector = function (id, from, link, param) {
  var pagyEl = document.getElementById(id),
      input = pagyEl.getElementsByTagName('input')[0],
      current = input.value,
      go = function go() {
    var items = input.value;

    if (current !== items) {
      var page = Math.max(Math.ceil(from / items), 1),
          html = link.replace(/__pagy_page__/, page).replace(/__pagy_items__/, items);

      if (typeof param === 'string' && page === 1) {
        html = Pagy.trim(html, param);
      }

      pagyEl.insertAdjacentHTML('afterbegin', html);
      pagyEl.getElementsByTagName('a')[0].click();
    }
  };

  Pagy.addInputEventListeners(input, go);
};

Pagy.addInputEventListeners = function (input, handler) {
  // select the content on click: easier for typing a number
  input.addEventListener('click', function () {
    this.select();
  }); // go when the input looses focus

  input.addEventListener('focusout', handler); // … and when pressing enter inside the input

  input.addEventListener('keyup', function (e) {
    if (e.which === 13) handler();
  }.bind(this));
};

Pagy.trim = function (html, param) {
  var re = new RegExp('[?&]' + param + '=1\b(?!&)|\b' + param + '=1&');
  return html.replace(re, '');
};

window.addEventListener("load", Pagy.init);
global.Pagy = Pagy;
/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../node_modules/webpack/buildin/global.js */ "./node_modules/webpack/buildin/global.js")))

/***/ }),

/***/ "./node_modules/webpack/buildin/global.js":
/*!***********************************!*\
  !*** (webpack)/buildin/global.js ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports) {

var g;

// This works in non-strict mode
g = (function() {
	return this;
})();

try {
	// This works if eval is allowed (see CSP)
	g = g || new Function("return this")();
} catch (e) {
	// This works if the window reference is available
	if (typeof window === "object") g = window;
}

// g can still be undefined, but nothing to do about it...
// We return undefined, instead of nothing here, so it's
// easier to handle this case. if(!global) { ...}

module.exports = g;


/***/ })

/******/ });
//# sourceMappingURL=pagy-8d6ac7d402bc102138c9.js.map