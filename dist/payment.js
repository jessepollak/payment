var payment =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {var Payment, QJ, cardFromNumber, cardFromType, cards, defaultFormat, formatBackCardNumber, formatBackExpiry, formatCardNumber, formatExpiry, formatForwardExpiry, formatForwardSlash, formatMonthExpiry, hasTextSelected, luhnCheck, reFormatCardNumber, restrictCVC, restrictCardNumber, restrictCombinedExpiry, restrictExpiry, restrictMonthExpiry, restrictNumeric, restrictYearExpiry, setCardType,
	  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

	QJ = __webpack_require__(1);

	defaultFormat = /(\d{1,4})/g;

	cards = [
	  {
	    type: 'amex',
	    pattern: /^3[47]/,
	    format: /(\d{1,4})(\d{1,6})?(\d{1,5})?/,
	    length: [15],
	    cvcLength: [4],
	    luhn: true
	  }, {
	    type: 'dankort',
	    pattern: /^5019/,
	    format: defaultFormat,
	    length: [16],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'dinersclub',
	    pattern: /^(36|38|30[0-5])/,
	    format: /(\d{1,4})(\d{1,6})?(\d{1,4})?/,
	    length: [14],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'discover',
	    pattern: /^(6011|65|64[4-9]|622)/,
	    format: defaultFormat,
	    length: [16],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'jcb',
	    pattern: /^35/,
	    format: defaultFormat,
	    length: [16],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'laser',
	    pattern: /^(6706|6771|6709)/,
	    format: defaultFormat,
	    length: [16, 17, 18, 19],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'maestro',
	    pattern: /^(5018|5020|5038|6304|6703|6708|6759|676[1-3])/,
	    format: defaultFormat,
	    length: [12, 13, 14, 15, 16, 17, 18, 19],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'mastercard',
	    pattern: /^(5[1-5]|677189)|^(222[1-9]|2[3-6]\d{2}|27[0-1]\d|2720)/,
	    format: defaultFormat,
	    length: [16],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'unionpay',
	    pattern: /^62/,
	    format: defaultFormat,
	    length: [16, 17, 18, 19],
	    cvcLength: [3],
	    luhn: false
	  }, {
	    type: 'visaelectron',
	    pattern: /^4(026|17500|405|508|844|91[37])/,
	    format: defaultFormat,
	    length: [16],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'elo',
	    pattern: /^(4011|438935|45(1416|76|7393)|50(4175|6699|67|90[4-7])|63(6297|6368))/,
	    format: defaultFormat,
	    length: [16],
	    cvcLength: [3],
	    luhn: true
	  }, {
	    type: 'visa',
	    pattern: /^4/,
	    format: defaultFormat,
	    length: [13, 16, 19],
	    cvcLength: [3],
	    luhn: true
	  }
	];

	cardFromNumber = function(num) {
	  var card, j, len;
	  num = (num + '').replace(/\D/g, '');
	  for (j = 0, len = cards.length; j < len; j++) {
	    card = cards[j];
	    if (card.pattern.test(num)) {
	      return card;
	    }
	  }
	};

	cardFromType = function(type) {
	  var card, j, len;
	  for (j = 0, len = cards.length; j < len; j++) {
	    card = cards[j];
	    if (card.type === type) {
	      return card;
	    }
	  }
	};

	luhnCheck = function(num) {
	  var digit, digits, j, len, odd, sum;
	  odd = true;
	  sum = 0;
	  digits = (num + '').split('').reverse();
	  for (j = 0, len = digits.length; j < len; j++) {
	    digit = digits[j];
	    digit = parseInt(digit, 10);
	    if ((odd = !odd)) {
	      digit *= 2;
	    }
	    if (digit > 9) {
	      digit -= 9;
	    }
	    sum += digit;
	  }
	  return sum % 10 === 0;
	};

	hasTextSelected = function(target) {
	  var e, error, ref;
	  try {
	    if ((target.selectionStart != null) && target.selectionStart !== target.selectionEnd) {
	      return true;
	    }
	    if ((typeof document !== "undefined" && document !== null ? (ref = document.selection) != null ? ref.createRange : void 0 : void 0) != null) {
	      if (document.selection.createRange().text) {
	        return true;
	      }
	    }
	  } catch (error) {
	    e = error;
	  }
	  return false;
	};

	reFormatCardNumber = function(e) {
	  return setTimeout((function(_this) {
	    return function() {
	      var target, value;
	      target = e.target;
	      value = QJ.val(target);
	      value = Payment.fns.formatCardNumber(value);
	      QJ.val(target, value);
	      return QJ.trigger(target, 'change');
	    };
	  })(this));
	};

	formatCardNumber = function(maxLength) {
	  return function(e) {
	    var card, digit, i, j, len, length, re, target, upperLength, upperLengths, value;
	    digit = String.fromCharCode(e.which);
	    if (!/^\d+$/.test(digit)) {
	      return;
	    }
	    target = e.target;
	    value = QJ.val(target);
	    card = cardFromNumber(value + digit);
	    length = (value.replace(/\D/g, '') + digit).length;
	    upperLengths = [16];
	    if (card) {
	      upperLengths = card.length;
	    }
	    if (maxLength) {
	      upperLengths = [Math.min(maxLength, upperLengths.slice(0).pop())];
	    }
	    for (i = j = 0, len = upperLengths.length; j < len; i = ++j) {
	      upperLength = upperLengths[i];
	      if (length >= upperLength && upperLengths[i + 1]) {
	        continue;
	      }
	      if (length >= upperLength) {
	        return;
	      }
	    }
	    if (hasTextSelected(target)) {
	      return;
	    }
	    if (card && card.type === 'amex') {
	      re = /^(\d{4}|\d{4}\s\d{6})$/;
	    } else {
	      re = /(?:^|\s)(\d{4})$/;
	    }
	    if (re.test(value)) {
	      e.preventDefault();
	      QJ.val(target, value + ' ' + digit);
	      return QJ.trigger(target, 'change');
	    }
	  };
	};

	formatBackCardNumber = function(e) {
	  var target, value;
	  target = e.target;
	  value = QJ.val(target);
	  if (e.meta) {
	    return;
	  }
	  if (e.which !== 8) {
	    return;
	  }
	  if (hasTextSelected(target)) {
	    return;
	  }
	  if (/\d\s$/.test(value)) {
	    e.preventDefault();
	    QJ.val(target, value.replace(/\d\s$/, ''));
	    return QJ.trigger(target, 'change');
	  } else if (/\s\d?$/.test(value)) {
	    e.preventDefault();
	    QJ.val(target, value.replace(/\s\d?$/, ''));
	    return QJ.trigger(target, 'change');
	  }
	};

	formatExpiry = function(e) {
	  var digit, target, val;
	  digit = String.fromCharCode(e.which);
	  if (!/^\d+$/.test(digit)) {
	    return;
	  }
	  target = e.target;
	  val = QJ.val(target) + digit;
	  if (/^\d$/.test(val) && (val !== '0' && val !== '1')) {
	    e.preventDefault();
	    QJ.val(target, "0" + val + " / ");
	    return QJ.trigger(target, 'change');
	  } else if (/^\d\d$/.test(val)) {
	    e.preventDefault();
	    QJ.val(target, val + " / ");
	    return QJ.trigger(target, 'change');
	  }
	};

	formatMonthExpiry = function(e) {
	  var digit, target, val;
	  digit = String.fromCharCode(e.which);
	  if (!/^\d+$/.test(digit)) {
	    return;
	  }
	  target = e.target;
	  val = QJ.val(target) + digit;
	  if (/^\d$/.test(val) && (val !== '0' && val !== '1')) {
	    e.preventDefault();
	    QJ.val(target, "0" + val);
	    return QJ.trigger(target, 'change');
	  } else if (/^\d\d$/.test(val)) {
	    e.preventDefault();
	    QJ.val(target, "" + val);
	    return QJ.trigger(target, 'change');
	  }
	};

	formatForwardExpiry = function(e) {
	  var digit, target, val;
	  digit = String.fromCharCode(e.which);
	  if (!/^\d+$/.test(digit)) {
	    return;
	  }
	  target = e.target;
	  val = QJ.val(target);
	  if (/^\d\d$/.test(val)) {
	    QJ.val(target, val + " / ");
	    return QJ.trigger(target, 'change');
	  }
	};

	formatForwardSlash = function(e) {
	  var slash, target, val;
	  slash = String.fromCharCode(e.which);
	  if (slash !== '/') {
	    return;
	  }
	  target = e.target;
	  val = QJ.val(target);
	  if (/^\d$/.test(val) && val !== '0') {
	    QJ.val(target, "0" + val + " / ");
	    return QJ.trigger(target, 'change');
	  }
	};

	formatBackExpiry = function(e) {
	  var target, value;
	  if (e.metaKey) {
	    return;
	  }
	  target = e.target;
	  value = QJ.val(target);
	  if (e.which !== 8) {
	    return;
	  }
	  if (hasTextSelected(target)) {
	    return;
	  }
	  if (/\d(\s|\/)+$/.test(value)) {
	    e.preventDefault();
	    QJ.val(target, value.replace(/\d(\s|\/)*$/, ''));
	    return QJ.trigger(target, 'change');
	  } else if (/\s\/\s?\d?$/.test(value)) {
	    e.preventDefault();
	    QJ.val(target, value.replace(/\s\/\s?\d?$/, ''));
	    return QJ.trigger(target, 'change');
	  }
	};

	restrictNumeric = function(e) {
	  var input;
	  if (e.metaKey || e.ctrlKey) {
	    return true;
	  }
	  if (e.which === 32) {
	    return e.preventDefault();
	  }
	  if (e.which === 0) {
	    return true;
	  }
	  if (e.which < 33) {
	    return true;
	  }
	  input = String.fromCharCode(e.which);
	  if (!/[\d\s]/.test(input)) {
	    return e.preventDefault();
	  }
	};

	restrictCardNumber = function(maxLength) {
	  return function(e) {
	    var card, digit, length, target, value;
	    target = e.target;
	    digit = String.fromCharCode(e.which);
	    if (!/^\d+$/.test(digit)) {
	      return;
	    }
	    if (hasTextSelected(target)) {
	      return;
	    }
	    value = (QJ.val(target) + digit).replace(/\D/g, '');
	    card = cardFromNumber(value);
	    length = 16;
	    if (card) {
	      length = card.length[card.length.length - 1];
	    }
	    if (maxLength) {
	      length = Math.min(length, maxLength);
	    }
	    if (!(value.length <= length)) {
	      return e.preventDefault();
	    }
	  };
	};

	restrictExpiry = function(e, length) {
	  var digit, target, value;
	  target = e.target;
	  digit = String.fromCharCode(e.which);
	  if (!/^\d+$/.test(digit)) {
	    return;
	  }
	  if (hasTextSelected(target)) {
	    return;
	  }
	  value = QJ.val(target) + digit;
	  value = value.replace(/\D/g, '');
	  if (value.length > length) {
	    return e.preventDefault();
	  }
	};

	restrictCombinedExpiry = function(e) {
	  return restrictExpiry(e, 6);
	};

	restrictMonthExpiry = function(e) {
	  return restrictExpiry(e, 2);
	};

	restrictYearExpiry = function(e) {
	  return restrictExpiry(e, 4);
	};

	restrictCVC = function(e) {
	  var digit, target, val;
	  target = e.target;
	  digit = String.fromCharCode(e.which);
	  if (!/^\d+$/.test(digit)) {
	    return;
	  }
	  if (hasTextSelected(target)) {
	    return;
	  }
	  val = QJ.val(target) + digit;
	  if (!(val.length <= 4)) {
	    return e.preventDefault();
	  }
	};

	setCardType = function(e) {
	  var allTypes, card, cardType, target, val;
	  target = e.target;
	  val = QJ.val(target);
	  cardType = Payment.fns.cardType(val) || 'unknown';
	  if (!QJ.hasClass(target, cardType)) {
	    allTypes = (function() {
	      var j, len, results;
	      results = [];
	      for (j = 0, len = cards.length; j < len; j++) {
	        card = cards[j];
	        results.push(card.type);
	      }
	      return results;
	    })();
	    QJ.removeClass(target, 'unknown');
	    QJ.removeClass(target, allTypes.join(' '));
	    QJ.addClass(target, cardType);
	    QJ.toggleClass(target, 'identified', cardType !== 'unknown');
	    return QJ.trigger(target, 'payment.cardType', cardType);
	  }
	};

	Payment = (function() {
	  function Payment() {}

	  Payment.fns = {
	    cardExpiryVal: function(value) {
	      var month, prefix, ref, year;
	      value = value.replace(/\s/g, '');
	      ref = value.split('/', 2), month = ref[0], year = ref[1];
	      if ((year != null ? year.length : void 0) === 2 && /^\d+$/.test(year)) {
	        prefix = (new Date).getFullYear();
	        prefix = prefix.toString().slice(0, 2);
	        year = prefix + year;
	      }
	      month = parseInt(month, 10);
	      year = parseInt(year, 10);
	      return {
	        month: month,
	        year: year
	      };
	    },
	    validateCardNumber: function(num) {
	      var card, ref;
	      num = (num + '').replace(/\s+|-/g, '');
	      if (!/^\d+$/.test(num)) {
	        return false;
	      }
	      card = cardFromNumber(num);
	      if (!card) {
	        return false;
	      }
	      return (ref = num.length, indexOf.call(card.length, ref) >= 0) && (card.luhn === false || luhnCheck(num));
	    },
	    validateCardExpiry: function(month, year) {
	      var currentTime, expiry, prefix, ref, ref1;
	      if (typeof month === 'object' && 'month' in month) {
	        ref = month, month = ref.month, year = ref.year;
	      } else if (typeof month === 'string' && indexOf.call(month, '/') >= 0) {
	        ref1 = Payment.fns.cardExpiryVal(month), month = ref1.month, year = ref1.year;
	      }
	      if (!(month && year)) {
	        return false;
	      }
	      month = QJ.trim(month);
	      year = QJ.trim(year);
	      if (!/^\d+$/.test(month)) {
	        return false;
	      }
	      if (!/^\d+$/.test(year)) {
	        return false;
	      }
	      month = parseInt(month, 10);
	      if (!(month && month <= 12)) {
	        return false;
	      }
	      if (year.length === 2) {
	        prefix = (new Date).getFullYear();
	        prefix = prefix.toString().slice(0, 2);
	        year = prefix + year;
	      }
	      expiry = new Date(year, month);
	      currentTime = new Date;
	      expiry.setMonth(expiry.getMonth() - 1);
	      expiry.setMonth(expiry.getMonth() + 1, 1);
	      return expiry > currentTime;
	    },
	    validateCardCVC: function(cvc, type) {
	      var ref, ref1;
	      cvc = QJ.trim(cvc);
	      if (!/^\d+$/.test(cvc)) {
	        return false;
	      }
	      if (type && cardFromType(type)) {
	        return ref = cvc.length, indexOf.call((ref1 = cardFromType(type)) != null ? ref1.cvcLength : void 0, ref) >= 0;
	      } else {
	        return cvc.length >= 3 && cvc.length <= 4;
	      }
	    },
	    cardType: function(num) {
	      var ref;
	      if (!num) {
	        return null;
	      }
	      return ((ref = cardFromNumber(num)) != null ? ref.type : void 0) || null;
	    },
	    formatCardNumber: function(num) {
	      var card, groups, ref, upperLength;
	      card = cardFromNumber(num);
	      if (!card) {
	        return num;
	      }
	      upperLength = card.length[card.length.length - 1];
	      num = num.replace(/\D/g, '');
	      num = num.slice(0, upperLength);
	      if (card.format.global) {
	        return (ref = num.match(card.format)) != null ? ref.join(' ') : void 0;
	      } else {
	        groups = card.format.exec(num);
	        if (groups == null) {
	          return;
	        }
	        groups.shift();
	        groups = groups.filter(function(n) {
	          return n;
	        });
	        return groups.join(' ');
	      }
	    }
	  };

	  Payment.restrictNumeric = function(el) {
	    return QJ.on(el, 'keypress', restrictNumeric);
	  };

	  Payment.cardExpiryVal = function(el) {
	    return Payment.fns.cardExpiryVal(QJ.val(el));
	  };

	  Payment.formatCardCVC = function(el) {
	    Payment.restrictNumeric(el);
	    QJ.on(el, 'keypress', restrictCVC);
	    return el;
	  };

	  Payment.formatCardExpiry = function(el) {
	    var month, year;
	    Payment.restrictNumeric(el);
	    if (el.length && el.length === 2) {
	      month = el[0], year = el[1];
	      this.formatCardExpiryMultiple(month, year);
	    } else {
	      QJ.on(el, 'keypress', restrictCombinedExpiry);
	      QJ.on(el, 'keypress', formatExpiry);
	      QJ.on(el, 'keypress', formatForwardSlash);
	      QJ.on(el, 'keypress', formatForwardExpiry);
	      QJ.on(el, 'keydown', formatBackExpiry);
	    }
	    return el;
	  };

	  Payment.formatCardExpiryMultiple = function(month, year) {
	    QJ.on(month, 'keypress', restrictMonthExpiry);
	    QJ.on(month, 'keypress', formatMonthExpiry);
	    return QJ.on(year, 'keypress', restrictYearExpiry);
	  };

	  Payment.formatCardNumber = function(el, maxLength) {
	    Payment.restrictNumeric(el);
	    QJ.on(el, 'keypress', restrictCardNumber(maxLength));
	    QJ.on(el, 'keypress', formatCardNumber(maxLength));
	    QJ.on(el, 'keydown', formatBackCardNumber);
	    QJ.on(el, 'keyup blur', setCardType);
	    QJ.on(el, 'paste', reFormatCardNumber);
	    return el;
	  };

	  Payment.getCardArray = function() {
	    return cards;
	  };

	  Payment.setCardArray = function(cardArray) {
	    cards = cardArray;
	    return true;
	  };

	  Payment.addToCardArray = function(cardObject) {
	    return cards.push(cardObject);
	  };

	  Payment.removeFromCardArray = function(type) {
	    var key, value;
	    for (key in cards) {
	      value = cards[key];
	      if (value.type === type) {
	        cards.splice(key, 1);
	      }
	    }
	    return true;
	  };

	  return Payment;

	})();

	module.exports = Payment;

	global.Payment = Payment;

	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ }),
/* 1 */
/***/ (function(module, exports) {

	// Generated by CoffeeScript 1.10.0
	(function() {
	  var QJ, rreturn, rtrim;

	  QJ = function(selector) {
	    if (QJ.isDOMElement(selector)) {
	      return selector;
	    }
	    return document.querySelectorAll(selector);
	  };

	  QJ.isDOMElement = function(el) {
	    return el && (el.nodeName != null);
	  };

	  rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;

	  QJ.trim = function(text) {
	    if (text === null) {
	      return "";
	    } else {
	      return (text + "").replace(rtrim, "");
	    }
	  };

	  rreturn = /\r/g;

	  QJ.val = function(el, val) {
	    var ret;
	    if (arguments.length > 1) {
	      return el.value = val;
	    } else {
	      ret = el.value;
	      if (typeof ret === "string") {
	        return ret.replace(rreturn, "");
	      } else {
	        if (ret === null) {
	          return "";
	        } else {
	          return ret;
	        }
	      }
	    }
	  };

	  QJ.preventDefault = function(eventObject) {
	    if (typeof eventObject.preventDefault === "function") {
	      eventObject.preventDefault();
	      return;
	    }
	    eventObject.returnValue = false;
	    return false;
	  };

	  QJ.normalizeEvent = function(e) {
	    var original;
	    original = e;
	    e = {
	      which: original.which != null ? original.which : void 0,
	      target: original.target || original.srcElement,
	      preventDefault: function() {
	        return QJ.preventDefault(original);
	      },
	      originalEvent: original,
	      data: original.data || original.detail
	    };
	    if (e.which == null) {
	      e.which = original.charCode != null ? original.charCode : original.keyCode;
	    }
	    return e;
	  };

	  QJ.on = function(element, eventName, callback) {
	    var el, i, j, len, len1, multEventName, originalCallback, ref;
	    if (element.length) {
	      for (i = 0, len = element.length; i < len; i++) {
	        el = element[i];
	        QJ.on(el, eventName, callback);
	      }
	      return;
	    }
	    if (eventName.match(" ")) {
	      ref = eventName.split(" ");
	      for (j = 0, len1 = ref.length; j < len1; j++) {
	        multEventName = ref[j];
	        QJ.on(element, multEventName, callback);
	      }
	      return;
	    }
	    originalCallback = callback;
	    callback = function(e) {
	      e = QJ.normalizeEvent(e);
	      return originalCallback(e);
	    };
	    if (element.addEventListener) {
	      return element.addEventListener(eventName, callback, false);
	    }
	    if (element.attachEvent) {
	      eventName = "on" + eventName;
	      return element.attachEvent(eventName, callback);
	    }
	    element['on' + eventName] = callback;
	  };

	  QJ.addClass = function(el, className) {
	    var e;
	    if (el.length) {
	      return (function() {
	        var i, len, results;
	        results = [];
	        for (i = 0, len = el.length; i < len; i++) {
	          e = el[i];
	          results.push(QJ.addClass(e, className));
	        }
	        return results;
	      })();
	    }
	    if (el.classList) {
	      return el.classList.add(className);
	    } else {
	      return el.className += ' ' + className;
	    }
	  };

	  QJ.hasClass = function(el, className) {
	    var e, hasClass, i, len;
	    if (el.length) {
	      hasClass = true;
	      for (i = 0, len = el.length; i < len; i++) {
	        e = el[i];
	        hasClass = hasClass && QJ.hasClass(e, className);
	      }
	      return hasClass;
	    }
	    if (el.classList) {
	      return el.classList.contains(className);
	    } else {
	      return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
	    }
	  };

	  QJ.removeClass = function(el, className) {
	    var cls, e, i, len, ref, results;
	    if (el.length) {
	      return (function() {
	        var i, len, results;
	        results = [];
	        for (i = 0, len = el.length; i < len; i++) {
	          e = el[i];
	          results.push(QJ.removeClass(e, className));
	        }
	        return results;
	      })();
	    }
	    if (el.classList) {
	      ref = className.split(' ');
	      results = [];
	      for (i = 0, len = ref.length; i < len; i++) {
	        cls = ref[i];
	        results.push(el.classList.remove(cls));
	      }
	      return results;
	    } else {
	      return el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
	    }
	  };

	  QJ.toggleClass = function(el, className, bool) {
	    var e;
	    if (el.length) {
	      return (function() {
	        var i, len, results;
	        results = [];
	        for (i = 0, len = el.length; i < len; i++) {
	          e = el[i];
	          results.push(QJ.toggleClass(e, className, bool));
	        }
	        return results;
	      })();
	    }
	    if (bool) {
	      if (!QJ.hasClass(el, className)) {
	        return QJ.addClass(el, className);
	      }
	    } else {
	      return QJ.removeClass(el, className);
	    }
	  };

	  QJ.append = function(el, toAppend) {
	    var e;
	    if (el.length) {
	      return (function() {
	        var i, len, results;
	        results = [];
	        for (i = 0, len = el.length; i < len; i++) {
	          e = el[i];
	          results.push(QJ.append(e, toAppend));
	        }
	        return results;
	      })();
	    }
	    return el.insertAdjacentHTML('beforeend', toAppend);
	  };

	  QJ.find = function(el, selector) {
	    if (el instanceof NodeList || el instanceof Array) {
	      el = el[0];
	    }
	    return el.querySelectorAll(selector);
	  };

	  QJ.trigger = function(el, name, data) {
	    var e, error, ev;
	    try {
	      ev = new CustomEvent(name, {
	        detail: data
	      });
	    } catch (error) {
	      e = error;
	      ev = document.createEvent('CustomEvent');
	      if (ev.initCustomEvent) {
	        ev.initCustomEvent(name, true, true, data);
	      } else {
	        ev.initEvent(name, true, true, data);
	      }
	    }
	    return el.dispatchEvent(ev);
	  };

	  module.exports = QJ;

	}).call(this);


/***/ })
/******/ ]);