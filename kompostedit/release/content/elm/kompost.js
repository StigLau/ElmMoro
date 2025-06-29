(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



// SEND REQUEST

var _Http_toTask = F3(function(router, toTask, request)
{
	return _Scheduler_binding(function(callback)
	{
		function done(response) {
			callback(toTask(request.expect.a(response)));
		}

		var xhr = new XMLHttpRequest();
		xhr.addEventListener('error', function() { done($elm$http$Http$NetworkError_); });
		xhr.addEventListener('timeout', function() { done($elm$http$Http$Timeout_); });
		xhr.addEventListener('load', function() { done(_Http_toResponse(request.expect.b, xhr)); });
		$elm$core$Maybe$isJust(request.tracker) && _Http_track(router, xhr, request.tracker.a);

		try {
			xhr.open(request.method, request.url, true);
		} catch (e) {
			return done($elm$http$Http$BadUrl_(request.url));
		}

		_Http_configureRequest(xhr, request);

		request.body.a && xhr.setRequestHeader('Content-Type', request.body.a);
		xhr.send(request.body.b);

		return function() { xhr.c = true; xhr.abort(); };
	});
});


// CONFIGURE

function _Http_configureRequest(xhr, request)
{
	for (var headers = request.headers; headers.b; headers = headers.b) // WHILE_CONS
	{
		xhr.setRequestHeader(headers.a.a, headers.a.b);
	}
	xhr.timeout = request.timeout.a || 0;
	xhr.responseType = request.expect.d;
	xhr.withCredentials = request.allowCookiesFromOtherDomains;
}


// RESPONSES

function _Http_toResponse(toBody, xhr)
{
	return A2(
		200 <= xhr.status && xhr.status < 300 ? $elm$http$Http$GoodStatus_ : $elm$http$Http$BadStatus_,
		_Http_toMetadata(xhr),
		toBody(xhr.response)
	);
}


// METADATA

function _Http_toMetadata(xhr)
{
	return {
		url: xhr.responseURL,
		statusCode: xhr.status,
		statusText: xhr.statusText,
		headers: _Http_parseHeaders(xhr.getAllResponseHeaders())
	};
}


// HEADERS

function _Http_parseHeaders(rawHeaders)
{
	if (!rawHeaders)
	{
		return $elm$core$Dict$empty;
	}

	var headers = $elm$core$Dict$empty;
	var headerPairs = rawHeaders.split('\r\n');
	for (var i = headerPairs.length; i--; )
	{
		var headerPair = headerPairs[i];
		var index = headerPair.indexOf(': ');
		if (index > 0)
		{
			var key = headerPair.substring(0, index);
			var value = headerPair.substring(index + 2);

			headers = A3($elm$core$Dict$update, key, function(oldValue) {
				return $elm$core$Maybe$Just($elm$core$Maybe$isJust(oldValue)
					? value + ', ' + oldValue.a
					: value
				);
			}, headers);
		}
	}
	return headers;
}


// EXPECT

var _Http_expect = F3(function(type, toBody, toValue)
{
	return {
		$: 0,
		d: type,
		b: toBody,
		a: toValue
	};
});

var _Http_mapExpect = F2(function(func, expect)
{
	return {
		$: 0,
		d: expect.d,
		b: expect.b,
		a: function(x) { return func(expect.a(x)); }
	};
});

function _Http_toDataView(arrayBuffer)
{
	return new DataView(arrayBuffer);
}


// BODY and PARTS

var _Http_emptyBody = { $: 0 };
var _Http_pair = F2(function(a, b) { return { $: 0, a: a, b: b }; });

function _Http_toFormData(parts)
{
	for (var formData = new FormData(); parts.b; parts = parts.b) // WHILE_CONS
	{
		var part = parts.a;
		formData.append(part.a, part.b);
	}
	return formData;
}

var _Http_bytesToBlob = F2(function(mime, bytes)
{
	return new Blob([bytes], { type: mime });
});


// PROGRESS

function _Http_track(router, xhr, tracker)
{
	// TODO check out lengthComputable on loadstart event

	xhr.upload.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Sending({
			sent: event.loaded,
			size: event.total
		}))));
	});
	xhr.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Receiving({
			received: event.loaded,
			size: event.lengthComputable ? $elm$core$Maybe$Just(event.total) : $elm$core$Maybe$Nothing
		}))));
	});
}

function _Url_percentEncode(string)
{
	return encodeURIComponent(string);
}

function _Url_percentDecode(string)
{
	try
	{
		return $elm$core$Maybe$Just(decodeURIComponent(string));
	}
	catch (e)
	{
		return $elm$core$Maybe$Nothing;
	}
}


var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});
var $author$project$Models$Msg$ChangedUrl = function (a) {
	return {$: 'ChangedUrl', a: a};
};
var $author$project$Models$Msg$ClickedLink = function (a) {
	return {$: 'ClickedLink', a: a};
};
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var $elm$url$Url$Http = {$: 'Http'};
var $elm$url$Url$Https = {$: 'Https'};
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 'Nothing') {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Http,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Https,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0.a;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $elm$browser$Browser$application = _Browser_application;
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $author$project$Models$BaseModel$BeatPattern = F3(
	function (fromBeat, toBeat, masterBPM) {
		return {fromBeat: fromBeat, masterBPM: masterBPM, toBeat: toBeat};
	});
var $author$project$Models$BaseModel$DataRepresentation = F3(
	function (docs, warning, bookmark) {
		return {bookmark: bookmark, docs: docs, warning: warning};
	});
var $author$project$Models$BaseModel$Komposition = F9(
	function (id, name, revision, dvlType, bpm, segments, sources, config, beatpattern) {
		return {beatpattern: beatpattern, bpm: bpm, config: config, dvlType: dvlType, id: id, name: name, revision: revision, segments: segments, sources: sources};
	});
var $author$project$Navigation$Page$ListingsUI = {$: 'ListingsUI'};
var $author$project$Models$BaseModel$None = {$: 'None'};
var $author$project$Models$BaseModel$Row = F2(
	function (id, rev) {
		return {id: id, rev: rev};
	});
var $author$project$Models$BaseModel$Source = F9(
	function (id, url, startingOffset, checksum, format, extensionType, mediaType, width, height) {
		return {checksum: checksum, extensionType: extensionType, format: format, height: height, id: id, mediaType: mediaType, startingOffset: startingOffset, url: url, width: width};
	});
var $author$project$Models$BaseModel$VideoConfig = F4(
	function (width, height, framerate, extensionType) {
		return {extensionType: extensionType, framerate: framerate, height: height, width: width};
	});
var $author$project$Common$StaticVariables$audioTag = 'Audio';
var $author$project$Models$BaseModel$Segment = F5(
	function (id, sourceId, start, duration, end) {
		return {duration: duration, end: end, id: id, sourceId: sourceId, start: start};
	});
var $author$project$Main$defaultSegments = _List_fromArray(
	[
		A5($author$project$Models$BaseModel$Segment, 'Empty', 'http://jalla1', 0, 16, 16)
	]);
var $elm$core$Set$Set_elm_builtin = function (a) {
	return {$: 'Set_elm_builtin', a: a};
};
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Set$empty = $elm$core$Set$Set_elm_builtin($elm$core$Dict$empty);
var $author$project$Main$emptySegment = A5($author$project$Models$BaseModel$Segment, '', '', 0, 0, 0);
var $ContaSystemer$elm_menu$Menu$State = function (a) {
	return {$: 'State', a: a};
};
var $ContaSystemer$elm_menu$Menu$Internal$empty = {key: $elm$core$Maybe$Nothing, mouse: $elm$core$Maybe$Nothing};
var $ContaSystemer$elm_menu$Menu$empty = $ContaSystemer$elm_menu$Menu$State($ContaSystemer$elm_menu$Menu$Internal$empty);
var $author$project$Common$AutoComplete$Person = F4(
	function (name, year, city, state) {
		return {city: city, name: name, state: state, year: year};
	});
var $author$project$Common$AutoComplete$presidents = _List_fromArray(
	[
		A4($author$project$Common$AutoComplete$Person, 'George Washington', 1732, 'Westmoreland County', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'John Adams', 1735, 'Braintree', 'Massachusetts'),
		A4($author$project$Common$AutoComplete$Person, 'Thomas Jefferson', 1743, 'Shadwell', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'James Madison', 1751, 'Port Conway', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'James Monroe', 1758, 'Monroe Hall', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'Andrew Jackson', 1767, 'Waxhaws Region', 'South/North Carolina'),
		A4($author$project$Common$AutoComplete$Person, 'John Quincy Adams', 1767, 'Braintree', 'Massachusetts'),
		A4($author$project$Common$AutoComplete$Person, 'William Henry Harrison', 1773, 'Charles City County', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'Martin Van Buren', 1782, 'Kinderhook', 'New York'),
		A4($author$project$Common$AutoComplete$Person, 'Zachary Taylor', 1784, 'Barboursville', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'John Tyler', 1790, 'Charles City County', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'James Buchanan', 1791, 'Cove Gap', 'Pennsylvania'),
		A4($author$project$Common$AutoComplete$Person, 'James K. Polk', 1795, 'Pineville', 'North Carolina'),
		A4($author$project$Common$AutoComplete$Person, 'Millard Fillmore', 1800, 'Summerhill', 'New York'),
		A4($author$project$Common$AutoComplete$Person, 'Franklin Pierce', 1804, 'Hillsborough', 'New Hampshire'),
		A4($author$project$Common$AutoComplete$Person, 'Andrew Johnson', 1808, 'Raleigh', 'North Carolina'),
		A4($author$project$Common$AutoComplete$Person, 'Abraham Lincoln', 1809, 'Sinking spring', 'Kentucky'),
		A4($author$project$Common$AutoComplete$Person, 'Ulysses S. Grant', 1822, 'Point Pleasant', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Rutherford B. Hayes', 1822, 'Delaware', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Chester A. Arthur', 1829, 'Fairfield', 'Vermont'),
		A4($author$project$Common$AutoComplete$Person, 'James A. Garfield', 1831, 'Moreland Hills', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Benjamin Harrison', 1833, 'North Bend', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Grover Cleveland', 1837, 'Caldwell', 'New Jersey'),
		A4($author$project$Common$AutoComplete$Person, 'William McKinley', 1843, 'Niles', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Woodrow Wilson', 1856, 'Staunton', 'Virginia'),
		A4($author$project$Common$AutoComplete$Person, 'William Howard Taft', 1857, 'Cincinnati', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Theodore Roosevelt', 1858, 'New York City', 'New York'),
		A4($author$project$Common$AutoComplete$Person, 'Warren G. Harding', 1865, 'Blooming Grove', 'Ohio'),
		A4($author$project$Common$AutoComplete$Person, 'Calvin Coolidge', 1872, 'Plymouth', 'Vermont'),
		A4($author$project$Common$AutoComplete$Person, 'Herbert Hoover', 1874, 'West Branch', 'Iowa'),
		A4($author$project$Common$AutoComplete$Person, 'Franklin D. Roosevelt', 1882, 'Hyde Park', 'New York'),
		A4($author$project$Common$AutoComplete$Person, 'Harry S. Truman', 1884, 'Lamar', 'Missouri'),
		A4($author$project$Common$AutoComplete$Person, 'Dwight D. Eisenhower', 1890, 'Denison', 'Texas'),
		A4($author$project$Common$AutoComplete$Person, 'Lyndon B. Johnson', 1908, 'Stonewall', 'Texas'),
		A4($author$project$Common$AutoComplete$Person, 'Ronald Reagan', 1911, 'Tampico', 'Illinois'),
		A4($author$project$Common$AutoComplete$Person, 'Richard M. Nixon', 1913, 'Yorba Linda', 'California'),
		A4($author$project$Common$AutoComplete$Person, 'Gerald R. Ford', 1913, 'Omaha', 'Nebraska'),
		A4($author$project$Common$AutoComplete$Person, 'John F. Kennedy', 1917, 'Brookline', 'Massachusetts'),
		A4($author$project$Common$AutoComplete$Person, 'George H. W. Bush', 1924, 'Milton', 'Massachusetts'),
		A4($author$project$Common$AutoComplete$Person, 'Jimmy Carter', 1924, 'Plains', 'Georgia'),
		A4($author$project$Common$AutoComplete$Person, 'George W. Bush', 1946, 'New Haven', 'Connecticut'),
		A4($author$project$Common$AutoComplete$Person, 'Bill Clinton', 1946, 'Hope', 'Arkansas'),
		A4($author$project$Common$AutoComplete$Person, 'Barack Obama', 1961, 'Honolulu', 'Hawaii')
	]);
var $author$project$Common$AutoComplete$init = {autoState: $ContaSystemer$elm_menu$Menu$empty, howManyToShow: 5, people: $author$project$Common$AutoComplete$presidents, query: '', selectedPerson: $elm$core$Maybe$Nothing, showMenu: false};
var $author$project$Main$emptyModel = F3(
	function (navKey, theUrl, apiGatewayToken) {
		return {
			accessibleAutocomplete: $author$project$Common$AutoComplete$init,
			activePage: $author$project$Navigation$Page$ListingsUI,
			apiToken: apiGatewayToken,
			cacheUrl: '/fetch/',
			checkboxVisible: false,
			currentFocusAutoComplete: $author$project$Models$BaseModel$None,
			editableSegment: false,
			editingMediaFile: A9($author$project$Models$BaseModel$Source, '', '', $elm$core$Maybe$Nothing, '', '', '', $author$project$Common$StaticVariables$audioTag, $elm$core$Maybe$Nothing, $elm$core$Maybe$Nothing),
			integrationDestination: 'Sj3fFoojcnQ',
			integrationFormat: '136',
			key: navKey,
			kompoUrl: '/heap/',
			kompost: A9(
				$author$project$Models$BaseModel$Komposition,
				'',
				'Example',
				'',
				'Video',
				120,
				$author$project$Main$defaultSegments,
				_List_Nil,
				A4($author$project$Models$BaseModel$VideoConfig, 0, 0, 0, ''),
				$elm$core$Maybe$Just(
					A3($author$project$Models$BaseModel$BeatPattern, 0, 0, 0))),
			listings: A3(
				$author$project$Models$BaseModel$DataRepresentation,
				_List_fromArray(
					[
						A2($author$project$Models$BaseModel$Row, 'demokompo1', 'rev1'),
						A2($author$project$Models$BaseModel$Row, 'demokomp2', 'rev1')
					]),
				'',
				''),
			metaUrl: '/meta/',
			segment: $author$project$Main$emptySegment,
			statusMessage: _List_Nil,
			subSegmentList: $elm$core$Set$empty,
			url: theUrl
		};
	});
var $author$project$Models$Msg$ListingsUpdated = function (a) {
	return {$: 'ListingsUpdated', a: a};
};
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $elm$json$Json$Decode$decodeString = _Json_runOnString;
var $elm$http$Http$BadStatus_ = F2(
	function (a, b) {
		return {$: 'BadStatus_', a: a, b: b};
	});
var $elm$http$Http$BadUrl_ = function (a) {
	return {$: 'BadUrl_', a: a};
};
var $elm$http$Http$GoodStatus_ = F2(
	function (a, b) {
		return {$: 'GoodStatus_', a: a, b: b};
	});
var $elm$http$Http$NetworkError_ = {$: 'NetworkError_'};
var $elm$http$Http$Receiving = function (a) {
	return {$: 'Receiving', a: a};
};
var $elm$http$Http$Sending = function (a) {
	return {$: 'Sending', a: a};
};
var $elm$http$Http$Timeout_ = {$: 'Timeout_'};
var $elm$core$Maybe$isJust = function (maybe) {
	if (maybe.$ === 'Just') {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (_v0.$ === 'Just') {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm$http$Http$expectStringResponse = F2(
	function (toMsg, toResult) {
		return A3(
			_Http_expect,
			'',
			$elm$core$Basics$identity,
			A2($elm$core$Basics$composeR, toResult, toMsg));
	});
var $elm$core$Result$mapError = F2(
	function (f, result) {
		if (result.$ === 'Ok') {
			var v = result.a;
			return $elm$core$Result$Ok(v);
		} else {
			var e = result.a;
			return $elm$core$Result$Err(
				f(e));
		}
	});
var $elm$http$Http$BadBody = function (a) {
	return {$: 'BadBody', a: a};
};
var $elm$http$Http$BadStatus = function (a) {
	return {$: 'BadStatus', a: a};
};
var $elm$http$Http$BadUrl = function (a) {
	return {$: 'BadUrl', a: a};
};
var $elm$http$Http$NetworkError = {$: 'NetworkError'};
var $elm$http$Http$Timeout = {$: 'Timeout'};
var $elm$http$Http$resolve = F2(
	function (toResult, response) {
		switch (response.$) {
			case 'BadUrl_':
				var url = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadUrl(url));
			case 'Timeout_':
				return $elm$core$Result$Err($elm$http$Http$Timeout);
			case 'NetworkError_':
				return $elm$core$Result$Err($elm$http$Http$NetworkError);
			case 'BadStatus_':
				var metadata = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadStatus(metadata.statusCode));
			default:
				var body = response.b;
				return A2(
					$elm$core$Result$mapError,
					$elm$http$Http$BadBody,
					toResult(body));
		}
	});
var $elm$http$Http$expectJson = F2(
	function (toMsg, decoder) {
		return A2(
			$elm$http$Http$expectStringResponse,
			toMsg,
			$elm$http$Http$resolve(
				function (string) {
					return A2(
						$elm$core$Result$mapError,
						$elm$json$Json$Decode$errorToString,
						A2($elm$json$Json$Decode$decodeString, decoder, string));
				}));
	});
var $krisajenkins$remotedata$RemoteData$Failure = function (a) {
	return {$: 'Failure', a: a};
};
var $krisajenkins$remotedata$RemoteData$Success = function (a) {
	return {$: 'Success', a: a};
};
var $krisajenkins$remotedata$RemoteData$fromResult = function (result) {
	if (result.$ === 'Err') {
		var e = result.a;
		return $krisajenkins$remotedata$RemoteData$Failure(e);
	} else {
		var x = result.a;
		return $krisajenkins$remotedata$RemoteData$Success(x);
	}
};
var $elm$http$Http$Header = F2(
	function (a, b) {
		return {$: 'Header', a: a, b: b};
	});
var $elm$http$Http$header = $elm$http$Http$Header;
var $author$project$Models$KompostApi$kompoUrl = '/heap/';
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$map3 = _Json_map3;
var $elm$json$Json$Decode$string = _Json_decodeString;
var $author$project$Models$JsonCoding$rowDecoder = A3(
	$elm$json$Json$Decode$map2,
	$author$project$Models$BaseModel$Row,
	A2($elm$json$Json$Decode$field, '_id', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, '_rev', $elm$json$Json$Decode$string));
var $author$project$Models$JsonCoding$kompositionListDecoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$Models$BaseModel$DataRepresentation,
	A2(
		$elm$json$Json$Decode$field,
		'docs',
		$elm$json$Json$Decode$list($author$project$Models$JsonCoding$rowDecoder)),
	A2($elm$json$Json$Decode$field, 'bookmark', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'warning', $elm$json$Json$Decode$string));
var $elm$http$Http$Request = function (a) {
	return {$: 'Request', a: a};
};
var $elm$http$Http$State = F2(
	function (reqs, subs) {
		return {reqs: reqs, subs: subs};
	});
var $elm$http$Http$init = $elm$core$Task$succeed(
	A2($elm$http$Http$State, $elm$core$Dict$empty, _List_Nil));
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$http$Http$updateReqs = F3(
	function (router, cmds, reqs) {
		updateReqs:
		while (true) {
			if (!cmds.b) {
				return $elm$core$Task$succeed(reqs);
			} else {
				var cmd = cmds.a;
				var otherCmds = cmds.b;
				if (cmd.$ === 'Cancel') {
					var tracker = cmd.a;
					var _v2 = A2($elm$core$Dict$get, tracker, reqs);
					if (_v2.$ === 'Nothing') {
						var $temp$router = router,
							$temp$cmds = otherCmds,
							$temp$reqs = reqs;
						router = $temp$router;
						cmds = $temp$cmds;
						reqs = $temp$reqs;
						continue updateReqs;
					} else {
						var pid = _v2.a;
						return A2(
							$elm$core$Task$andThen,
							function (_v3) {
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A2($elm$core$Dict$remove, tracker, reqs));
							},
							$elm$core$Process$kill(pid));
					}
				} else {
					var req = cmd.a;
					return A2(
						$elm$core$Task$andThen,
						function (pid) {
							var _v4 = req.tracker;
							if (_v4.$ === 'Nothing') {
								return A3($elm$http$Http$updateReqs, router, otherCmds, reqs);
							} else {
								var tracker = _v4.a;
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A3($elm$core$Dict$insert, tracker, pid, reqs));
							}
						},
						$elm$core$Process$spawn(
							A3(
								_Http_toTask,
								router,
								$elm$core$Platform$sendToApp(router),
								req)));
				}
			}
		}
	});
var $elm$http$Http$onEffects = F4(
	function (router, cmds, subs, state) {
		return A2(
			$elm$core$Task$andThen,
			function (reqs) {
				return $elm$core$Task$succeed(
					A2($elm$http$Http$State, reqs, subs));
			},
			A3($elm$http$Http$updateReqs, router, cmds, state.reqs));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$http$Http$maybeSend = F4(
	function (router, desiredTracker, progress, _v0) {
		var actualTracker = _v0.a;
		var toMsg = _v0.b;
		return _Utils_eq(desiredTracker, actualTracker) ? $elm$core$Maybe$Just(
			A2(
				$elm$core$Platform$sendToApp,
				router,
				toMsg(progress))) : $elm$core$Maybe$Nothing;
	});
var $elm$http$Http$onSelfMsg = F3(
	function (router, _v0, state) {
		var tracker = _v0.a;
		var progress = _v0.b;
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$filterMap,
					A3($elm$http$Http$maybeSend, router, tracker, progress),
					state.subs)));
	});
var $elm$http$Http$Cancel = function (a) {
	return {$: 'Cancel', a: a};
};
var $elm$http$Http$cmdMap = F2(
	function (func, cmd) {
		if (cmd.$ === 'Cancel') {
			var tracker = cmd.a;
			return $elm$http$Http$Cancel(tracker);
		} else {
			var r = cmd.a;
			return $elm$http$Http$Request(
				{
					allowCookiesFromOtherDomains: r.allowCookiesFromOtherDomains,
					body: r.body,
					expect: A2(_Http_mapExpect, func, r.expect),
					headers: r.headers,
					method: r.method,
					timeout: r.timeout,
					tracker: r.tracker,
					url: r.url
				});
		}
	});
var $elm$http$Http$MySub = F2(
	function (a, b) {
		return {$: 'MySub', a: a, b: b};
	});
var $elm$http$Http$subMap = F2(
	function (func, _v0) {
		var tracker = _v0.a;
		var toMsg = _v0.b;
		return A2(
			$elm$http$Http$MySub,
			tracker,
			A2($elm$core$Basics$composeR, toMsg, func));
	});
_Platform_effectManagers['Http'] = _Platform_createManager($elm$http$Http$init, $elm$http$Http$onEffects, $elm$http$Http$onSelfMsg, $elm$http$Http$cmdMap, $elm$http$Http$subMap);
var $elm$http$Http$command = _Platform_leaf('Http');
var $elm$http$Http$subscription = _Platform_leaf('Http');
var $elm$http$Http$request = function (r) {
	return $elm$http$Http$command(
		$elm$http$Http$Request(
			{allowCookiesFromOtherDomains: false, body: r.body, expect: r.expect, headers: r.headers, method: r.method, timeout: r.timeout, tracker: r.tracker, url: r.url}));
};
var $author$project$Models$JsonCoding$searchEncoder = function (typeIdentifier) {
	return '{\"selector\": {\"_id\": {\"$gt\": \"0\"}, \"type\": \"' + (typeIdentifier + '\"}, \"fields\": [ \"_id\", \"_rev\" ], \"sort\": [ {\"_id\": \"asc\"} ] }');
};
var $elm$http$Http$stringBody = _Http_pair;
var $author$project$Models$KompostApi$fetchKompositionList = F2(
	function (typeIdentifier, token) {
		return $elm$http$Http$request(
			{
				body: A2(
					$elm$http$Http$stringBody,
					'application/json',
					$author$project$Models$JsonCoding$searchEncoder(typeIdentifier)),
				expect: A2(
					$elm$http$Http$expectJson,
					A2($elm$core$Basics$composeR, $krisajenkins$remotedata$RemoteData$fromResult, $author$project$Models$Msg$ListingsUpdated),
					$author$project$Models$JsonCoding$kompositionListDecoder),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', token)
					]),
				method: 'POST',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: $author$project$Models$KompostApi$kompoUrl + '_find'
			});
	});
var $author$project$Common$StaticVariables$kompositionTag = 'Komposition';
var $author$project$Main$init = F3(
	function (flag, url, navKey) {
		return _Utils_Tuple2(
			A3($author$project$Main$emptyModel, navKey, url, flag),
			$elm$core$Platform$Cmd$batch(
				_List_fromArray(
					[
						A2($author$project$Models$KompostApi$fetchKompositionList, $author$project$Common$StaticVariables$kompositionTag, flag)
					])));
	});
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $author$project$Main$subscriptions = function (model) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Navigation$Page$DvlSpecificsUI = {$: 'DvlSpecificsUI'};
var $author$project$Navigation$Page$KompositionJsonUI = {$: 'KompositionJsonUI'};
var $author$project$Navigation$Page$KompostUI = {$: 'KompostUI'};
var $author$project$Navigation$Page$SegmentUI = {$: 'SegmentUI'};
var $elm$core$Debug$log = _Debug_log;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $elm$browser$Browser$Navigation$replaceUrl = _Browser_replaceUrl;
var $author$project$Navigation$Page$NotFound = {$: 'NotFound'};
var $author$project$Navigation$AppRouting$routeToString = function (page) {
	var pieces = function () {
		switch (page.$) {
			case 'ListingsUI':
				return _List_fromArray(
					['listings']);
			case 'KompostUI':
				return _List_fromArray(
					['Main.elm', 'kompost']);
			case 'KompositionJsonUI':
				return _List_fromArray(
					['kompositionjson']);
			case 'SegmentUI':
				return _List_fromArray(
					['segment']);
			case 'DvlSpecificsUI':
				return _List_fromArray(
					['dvlspecifics']);
			case 'MediaFileUI':
				return _List_fromArray(
					['mediafile']);
			default:
				var _v1 = A2($elm$core$Debug$log, 'routeToString dead end', $author$project$Navigation$Page$NotFound);
				return _List_Nil;
		}
	}();
	return A2(
		$elm$core$Debug$log,
		'routeToString ',
		'#/' + A2($elm$core$String$join, '/', pieces));
};
var $author$project$Navigation$AppRouting$replaceUrl = F2(
	function (page, navKey) {
		var _v0 = A2($elm$core$Debug$log, 'Approuting.replaceUrl', page);
		return A2(
			$elm$browser$Browser$Navigation$replaceUrl,
			navKey,
			$author$project$Navigation$AppRouting$routeToString(page));
	});
var $author$project$Main$changeRouteTo = F2(
	function (maybePage, model) {
		if (maybePage.$ === 'Nothing') {
			var _v1 = $elm$core$Debug$log('changeRouteTo to Nothing');
			return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		} else {
			var anotherPage = maybePage.a;
			var _v2 = A2($elm$core$Debug$log, 'Routing towards', anotherPage);
			return _Utils_Tuple2(
				model,
				A2($author$project$Navigation$AppRouting$replaceUrl, anotherPage, model.key));
		}
	});
var $author$project$Models$Msg$CouchServerStatus = function (a) {
	return {$: 'CouchServerStatus', a: a};
};
var $author$project$Models$BaseModel$CouchStatusMessage = F3(
	function (id, ok, rev) {
		return {id: id, ok: ok, rev: rev};
	});
var $elm$json$Json$Decode$bool = _Json_decodeBool;
var $author$project$Models$JsonCoding$couchServerStatusDecoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$Models$BaseModel$CouchStatusMessage,
	A2($elm$json$Json$Decode$field, 'id', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'ok', $elm$json$Json$Decode$bool),
	A2($elm$json$Json$Decode$field, 'rev', $elm$json$Json$Decode$string));
var $elm$json$Json$Encode$float = _Json_wrap;
var $elm$json$Json$Encode$int = _Json_wrap;
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var $author$project$Models$JsonCoding$encodeBeatPattern = function (beatpattern) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'frombeat',
				$elm$json$Json$Encode$int(beatpattern.fromBeat)),
				_Utils_Tuple2(
				'tobeat',
				$elm$json$Json$Encode$int(beatpattern.toBeat)),
				_Utils_Tuple2(
				'masterbpm',
				$elm$json$Json$Encode$float(beatpattern.masterBPM))
			]));
};
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Models$JsonCoding$encodeConfig = function (config) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'width',
				$elm$json$Json$Encode$int(config.width)),
				_Utils_Tuple2(
				'height',
				$elm$json$Json$Encode$int(config.height)),
				_Utils_Tuple2(
				'framerate',
				$elm$json$Json$Encode$int(config.framerate)),
				_Utils_Tuple2(
				'extension',
				$elm$json$Json$Encode$string(config.extensionType))
			]));
};
var $author$project$Models$JsonCoding$encodeSegment = function (segment) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'id',
				$elm$json$Json$Encode$string(segment.id)),
				_Utils_Tuple2(
				'sourceid',
				$elm$json$Json$Encode$string(segment.sourceId)),
				_Utils_Tuple2(
				'start',
				$elm$json$Json$Encode$int(segment.start)),
				_Utils_Tuple2(
				'duration',
				$elm$json$Json$Encode$int(segment.duration)),
				_Utils_Tuple2(
				'end',
				$elm$json$Json$Encode$int(segment.end))
			]));
};
var $elm$json$Json$Encode$null = _Json_encodeNull;
var $author$project$Models$JsonCoding$encodeSource = function (source) {
	var start = function () {
		var _v0 = source.startingOffset;
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return $elm$json$Json$Encode$float(x);
		} else {
			return $elm$json$Json$Encode$null;
		}
	}();
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'id',
				$elm$json$Json$Encode$string(source.id)),
				_Utils_Tuple2(
				'url',
				$elm$json$Json$Encode$string(source.url)),
				_Utils_Tuple2('startingOffset', start),
				_Utils_Tuple2(
				'checksums',
				$elm$json$Json$Encode$string(source.checksum)),
				_Utils_Tuple2(
				'format',
				$elm$json$Json$Encode$string(source.format)),
				_Utils_Tuple2(
				'extension',
				$elm$json$Json$Encode$string(source.extensionType)),
				_Utils_Tuple2(
				'mediatype',
				$elm$json$Json$Encode$string(source.mediaType))
			]));
};
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $author$project$Models$JsonCoding$kompositionEncoder = function (kompo) {
	var sources = _List_fromArray(
		[
			_Utils_Tuple2(
			'sources',
			A2($elm$json$Json$Encode$list, $author$project$Models$JsonCoding$encodeSource, kompo.sources))
		]);
	var segments = _List_fromArray(
		[
			_Utils_Tuple2(
			'segments',
			A2($elm$json$Json$Encode$list, $author$project$Models$JsonCoding$encodeSegment, kompo.segments))
		]);
	var revision = function () {
		var _v2 = kompo.revision;
		if (_v2 === '') {
			return _List_Nil;
		} else {
			var theRevision = _v2;
			return _List_fromArray(
				[
					_Utils_Tuple2(
					'_rev',
					$elm$json$Json$Encode$string(theRevision))
				]);
		}
	}();
	var config = function () {
		var _v1 = kompo.dvlType;
		if (_v1 === 'Komposition') {
			return _List_fromArray(
				[
					_Utils_Tuple2(
					'config',
					$author$project$Models$JsonCoding$encodeConfig(kompo.config))
				]);
		} else {
			return _List_Nil;
		}
	}();
	var beatpattern = function () {
		var _v0 = kompo.beatpattern;
		if (_v0.$ === 'Just') {
			var bpm = _v0.a;
			return _List_fromArray(
				[
					_Utils_Tuple2(
					'beatpattern',
					$author$project$Models$JsonCoding$encodeBeatPattern(bpm))
				]);
		} else {
			return _List_Nil;
		}
	}();
	return A2(
		$elm$json$Json$Encode$encode,
		0,
		$elm$json$Json$Encode$object(
			_Utils_ap(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'_id',
						$elm$json$Json$Encode$string(kompo.id)),
						_Utils_Tuple2(
						'name',
						$elm$json$Json$Encode$string(kompo.name)),
						_Utils_Tuple2(
						'type',
						$elm$json$Json$Encode$string(kompo.dvlType)),
						_Utils_Tuple2(
						'bpm',
						$elm$json$Json$Encode$float(kompo.bpm))
					]),
				_Utils_ap(
					revision,
					_Utils_ap(
						config,
						_Utils_ap(
							beatpattern,
							_Utils_ap(segments, sources)))))));
};
var $author$project$Models$KompostApi$createVideo = F2(
	function (komposition, apiToken) {
		return $elm$http$Http$request(
			{
				body: A2(
					$elm$http$Http$stringBody,
					'application/json',
					$author$project$Models$JsonCoding$kompositionEncoder(komposition)),
				expect: A2(
					$elm$http$Http$expectJson,
					A2($elm$core$Basics$composeR, $krisajenkins$remotedata$RemoteData$fromResult, $author$project$Models$Msg$CouchServerStatus),
					$author$project$Models$JsonCoding$couchServerStatusDecoder),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', apiToken)
					]),
				method: 'POST',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: '/kvaern/createvideo?' + komposition.id
			});
	});
var $elm$http$Http$emptyBody = _Http_emptyBody;
var $author$project$Models$KompostApi$deleteKompo = F2(
	function (komposition, apiToken) {
		return $elm$http$Http$request(
			{
				body: $elm$http$Http$emptyBody,
				expect: A2(
					$elm$http$Http$expectJson,
					A2($elm$core$Basics$composeR, $krisajenkins$remotedata$RemoteData$fromResult, $author$project$Models$Msg$CouchServerStatus),
					$author$project$Models$JsonCoding$couchServerStatusDecoder),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', apiToken)
					]),
				method: 'DELETE',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: $author$project$Models$KompostApi$kompoUrl + (komposition.id + ('?rev=' + komposition.revision))
			});
	});
var $author$project$DvlSpecifics$DvlSpecificsModel$extractFromOutmessage = function (childMsg) {
	if ((childMsg.$ === 'Just') && (childMsg.a.$ === 'OutNavigateTo')) {
		var page = childMsg.a.a;
		return $elm$core$Maybe$Just(page);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Models$Msg$SourceUpdated = function (a) {
	return {$: 'SourceUpdated', a: a};
};
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$custom = $elm$json$Json$Decode$map2($elm$core$Basics$apR);
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3($elm$core$List$foldr, $elm$json$Json$Decode$field, decoder, fields);
	});
var $elm$json$Json$Decode$decodeValue = _Json_run;
var $elm$json$Json$Decode$null = _Json_decodeNull;
var $elm$json$Json$Decode$oneOf = _Json_oneOf;
var $elm$json$Json$Decode$value = _Json_decodeValue;
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optionalDecoder = F3(
	function (path, valDecoder, fallback) {
		var nullOr = function (decoder) {
			return $elm$json$Json$Decode$oneOf(
				_List_fromArray(
					[
						decoder,
						$elm$json$Json$Decode$null(fallback)
					]));
		};
		var handleResult = function (input) {
			var _v0 = A2(
				$elm$json$Json$Decode$decodeValue,
				A2($elm$json$Json$Decode$at, path, $elm$json$Json$Decode$value),
				input);
			if (_v0.$ === 'Ok') {
				var rawValue = _v0.a;
				var _v1 = A2(
					$elm$json$Json$Decode$decodeValue,
					nullOr(valDecoder),
					rawValue);
				if (_v1.$ === 'Ok') {
					var finalResult = _v1.a;
					return $elm$json$Json$Decode$succeed(finalResult);
				} else {
					return A2(
						$elm$json$Json$Decode$at,
						path,
						nullOr(valDecoder));
				}
			} else {
				return $elm$json$Json$Decode$succeed(fallback);
			}
		};
		return A2($elm$json$Json$Decode$andThen, handleResult, $elm$json$Json$Decode$value);
	});
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional = F4(
	function (key, valDecoder, fallback, decoder) {
		return A2(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$custom,
			A3(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optionalDecoder,
				_List_fromArray(
					[key]),
				valDecoder,
				fallback),
			decoder);
	});
var $author$project$Models$JsonCoding$beatpatternDecoder = A4(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
	'masterbpm',
	$elm$json$Json$Decode$float,
	0,
	A4(
		$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
		'tobeat',
		$elm$json$Json$Decode$int,
		0,
		A4(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
			'frombeat',
			$elm$json$Json$Decode$int,
			0,
			$elm$json$Json$Decode$succeed($author$project$Models$BaseModel$BeatPattern))));
var $author$project$Models$JsonCoding$configDecoder = A4(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
	'extension',
	$elm$json$Json$Decode$string,
	'',
	A4(
		$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
		'framerate',
		$elm$json$Json$Decode$int,
		0,
		A4(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
			'height',
			$elm$json$Json$Decode$int,
			0,
			A4(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
				'width',
				$elm$json$Json$Decode$int,
				0,
				$elm$json$Json$Decode$succeed($author$project$Models$BaseModel$VideoConfig)))));
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required = F3(
	function (key, valDecoder, decoder) {
		return A2(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$custom,
			A2($elm$json$Json$Decode$field, key, valDecoder),
			decoder);
	});
var $author$project$Models$JsonCoding$segmentDecoder = A4(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
	'end',
	$elm$json$Json$Decode$int,
	0,
	A4(
		$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
		'duration',
		$elm$json$Json$Decode$int,
		0,
		A3(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
			'start',
			$elm$json$Json$Decode$int,
			A4(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
				'sourceid',
				$elm$json$Json$Decode$string,
				'',
				A3(
					$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
					'id',
					$elm$json$Json$Decode$string,
					$elm$json$Json$Decode$succeed($author$project$Models$BaseModel$Segment))))));
var $elm$json$Json$Decode$maybe = function (decoder) {
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, decoder),
				$elm$json$Json$Decode$succeed($elm$core$Maybe$Nothing)
			]));
};
var $author$project$Models$JsonCoding$sourceDecoder = A4(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
	'height',
	$elm$json$Json$Decode$maybe($elm$json$Json$Decode$int),
	$elm$core$Maybe$Nothing,
	A4(
		$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
		'width',
		$elm$json$Json$Decode$maybe($elm$json$Json$Decode$int),
		$elm$core$Maybe$Nothing,
		A3(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
			'mediatype',
			$elm$json$Json$Decode$string,
			A3(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
				'extension',
				$elm$json$Json$Decode$string,
				A4(
					$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
					'format',
					$elm$json$Json$Decode$string,
					'',
					A3(
						$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
						'checksums',
						$elm$json$Json$Decode$string,
						A4(
							$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
							'startingOffset',
							$elm$json$Json$Decode$maybe($elm$json$Json$Decode$float),
							$elm$core$Maybe$Nothing,
							A3(
								$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
								'url',
								$elm$json$Json$Decode$string,
								A3(
									$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
									'id',
									$elm$json$Json$Decode$string,
									$elm$json$Json$Decode$succeed($author$project$Models$BaseModel$Source))))))))));
var $author$project$Models$JsonCoding$kompositionDecoder = A4(
	$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
	'beatpattern',
	A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, $author$project$Models$JsonCoding$beatpatternDecoder),
	$elm$core$Maybe$Nothing,
	A4(
		$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
		'config',
		$author$project$Models$JsonCoding$configDecoder,
		A4($author$project$Models$BaseModel$VideoConfig, 0, 0, 0, ''),
		A4(
			$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
			'sources',
			$elm$json$Json$Decode$list($author$project$Models$JsonCoding$sourceDecoder),
			_List_Nil,
			A4(
				$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
				'segments',
				$elm$json$Json$Decode$list($author$project$Models$JsonCoding$segmentDecoder),
				_List_Nil,
				A4(
					$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
					'bpm',
					$elm$json$Json$Decode$float,
					-1,
					A4(
						$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
						'type',
						$elm$json$Json$Decode$string,
						'',
						A4(
							$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
							'_rev',
							$elm$json$Json$Decode$string,
							'',
							A4(
								$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$optional,
								'name',
								$elm$json$Json$Decode$string,
								'',
								A3(
									$NoRedInk$elm_json_decode_pipeline$Json$Decode$Pipeline$required,
									'_id',
									$elm$json$Json$Decode$string,
									$elm$json$Json$Decode$succeed($author$project$Models$BaseModel$Komposition))))))))));
var $author$project$Models$KompostApi$fetchSource = F2(
	function (id, apiToken) {
		return $elm$http$Http$request(
			{
				body: $elm$http$Http$emptyBody,
				expect: A2(
					$elm$http$Http$expectJson,
					A2($elm$core$Basics$composeR, $krisajenkins$remotedata$RemoteData$fromResult, $author$project$Models$Msg$SourceUpdated),
					$author$project$Models$JsonCoding$kompositionDecoder),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', apiToken)
					]),
				method: 'GET',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: _Utils_ap($author$project$Models$KompostApi$kompoUrl, id)
			});
	});
var $elm$core$Set$insert = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return $elm$core$Set$Set_elm_builtin(
			A3($elm$core$Dict$insert, key, _Utils_Tuple0, dict));
	});
var $elm$core$Set$fromList = function (list) {
	return A3($elm$core$List$foldl, $elm$core$Set$insert, $elm$core$Set$empty, list);
};
var $elm$url$Url$Parser$State = F5(
	function (visited, unvisited, params, frag, value) {
		return {frag: frag, params: params, unvisited: unvisited, value: value, visited: visited};
	});
var $elm$url$Url$Parser$getFirstMatch = function (states) {
	getFirstMatch:
	while (true) {
		if (!states.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			var state = states.a;
			var rest = states.b;
			var _v1 = state.unvisited;
			if (!_v1.b) {
				return $elm$core$Maybe$Just(state.value);
			} else {
				if ((_v1.a === '') && (!_v1.b.b)) {
					return $elm$core$Maybe$Just(state.value);
				} else {
					var $temp$states = rest;
					states = $temp$states;
					continue getFirstMatch;
				}
			}
		}
	}
};
var $elm$url$Url$Parser$removeFinalEmpty = function (segments) {
	if (!segments.b) {
		return _List_Nil;
	} else {
		if ((segments.a === '') && (!segments.b.b)) {
			return _List_Nil;
		} else {
			var segment = segments.a;
			var rest = segments.b;
			return A2(
				$elm$core$List$cons,
				segment,
				$elm$url$Url$Parser$removeFinalEmpty(rest));
		}
	}
};
var $elm$url$Url$Parser$preparePath = function (path) {
	var _v0 = A2($elm$core$String$split, '/', path);
	if (_v0.b && (_v0.a === '')) {
		var segments = _v0.b;
		return $elm$url$Url$Parser$removeFinalEmpty(segments);
	} else {
		var segments = _v0;
		return $elm$url$Url$Parser$removeFinalEmpty(segments);
	}
};
var $elm$url$Url$Parser$addToParametersHelp = F2(
	function (value, maybeList) {
		if (maybeList.$ === 'Nothing') {
			return $elm$core$Maybe$Just(
				_List_fromArray(
					[value]));
		} else {
			var list = maybeList.a;
			return $elm$core$Maybe$Just(
				A2($elm$core$List$cons, value, list));
		}
	});
var $elm$url$Url$percentDecode = _Url_percentDecode;
var $elm$url$Url$Parser$addParam = F2(
	function (segment, dict) {
		var _v0 = A2($elm$core$String$split, '=', segment);
		if ((_v0.b && _v0.b.b) && (!_v0.b.b.b)) {
			var rawKey = _v0.a;
			var _v1 = _v0.b;
			var rawValue = _v1.a;
			var _v2 = $elm$url$Url$percentDecode(rawKey);
			if (_v2.$ === 'Nothing') {
				return dict;
			} else {
				var key = _v2.a;
				var _v3 = $elm$url$Url$percentDecode(rawValue);
				if (_v3.$ === 'Nothing') {
					return dict;
				} else {
					var value = _v3.a;
					return A3(
						$elm$core$Dict$update,
						key,
						$elm$url$Url$Parser$addToParametersHelp(value),
						dict);
				}
			}
		} else {
			return dict;
		}
	});
var $elm$url$Url$Parser$prepareQuery = function (maybeQuery) {
	if (maybeQuery.$ === 'Nothing') {
		return $elm$core$Dict$empty;
	} else {
		var qry = maybeQuery.a;
		return A3(
			$elm$core$List$foldr,
			$elm$url$Url$Parser$addParam,
			$elm$core$Dict$empty,
			A2($elm$core$String$split, '&', qry));
	}
};
var $elm$url$Url$Parser$parse = F2(
	function (_v0, url) {
		var parser = _v0.a;
		return $elm$url$Url$Parser$getFirstMatch(
			parser(
				A5(
					$elm$url$Url$Parser$State,
					_List_Nil,
					$elm$url$Url$Parser$preparePath(url.path),
					$elm$url$Url$Parser$prepareQuery(url.query),
					url.fragment,
					$elm$core$Basics$identity)));
	});
var $author$project$Navigation$Page$MediaFileUI = {$: 'MediaFileUI'};
var $elm$url$Url$Parser$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var $elm$url$Url$Parser$mapState = F2(
	function (func, _v0) {
		var visited = _v0.visited;
		var unvisited = _v0.unvisited;
		var params = _v0.params;
		var frag = _v0.frag;
		var value = _v0.value;
		return A5(
			$elm$url$Url$Parser$State,
			visited,
			unvisited,
			params,
			frag,
			func(value));
	});
var $elm$url$Url$Parser$map = F2(
	function (subValue, _v0) {
		var parseArg = _v0.a;
		return $elm$url$Url$Parser$Parser(
			function (_v1) {
				var visited = _v1.visited;
				var unvisited = _v1.unvisited;
				var params = _v1.params;
				var frag = _v1.frag;
				var value = _v1.value;
				return A2(
					$elm$core$List$map,
					$elm$url$Url$Parser$mapState(value),
					parseArg(
						A5($elm$url$Url$Parser$State, visited, unvisited, params, frag, subValue)));
			});
	});
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$url$Url$Parser$oneOf = function (parsers) {
	return $elm$url$Url$Parser$Parser(
		function (state) {
			return A2(
				$elm$core$List$concatMap,
				function (_v0) {
					var parser = _v0.a;
					return parser(state);
				},
				parsers);
		});
};
var $elm$url$Url$Parser$s = function (str) {
	return $elm$url$Url$Parser$Parser(
		function (_v0) {
			var visited = _v0.visited;
			var unvisited = _v0.unvisited;
			var params = _v0.params;
			var frag = _v0.frag;
			var value = _v0.value;
			if (!unvisited.b) {
				return _List_Nil;
			} else {
				var next = unvisited.a;
				var rest = unvisited.b;
				return _Utils_eq(next, str) ? _List_fromArray(
					[
						A5(
						$elm$url$Url$Parser$State,
						A2($elm$core$List$cons, next, visited),
						rest,
						params,
						frag,
						value)
					]) : _List_Nil;
			}
		});
};
var $elm$url$Url$Parser$top = $elm$url$Url$Parser$Parser(
	function (state) {
		return _List_fromArray(
			[state]);
	});
var $author$project$Navigation$AppRouting$parser = $elm$url$Url$Parser$oneOf(
	_List_fromArray(
		[
			A2($elm$url$Url$Parser$map, $author$project$Navigation$Page$ListingsUI, $elm$url$Url$Parser$top),
			A2(
			$elm$url$Url$Parser$map,
			$author$project$Navigation$Page$KompostUI,
			$elm$url$Url$Parser$s('kompost')),
			A2(
			$elm$url$Url$Parser$map,
			$author$project$Navigation$Page$KompositionJsonUI,
			$elm$url$Url$Parser$s('kompostjson')),
			A2(
			$elm$url$Url$Parser$map,
			$author$project$Navigation$Page$SegmentUI,
			$elm$url$Url$Parser$s('segment')),
			A2(
			$elm$url$Url$Parser$map,
			$author$project$Navigation$Page$DvlSpecificsUI,
			$elm$url$Url$Parser$s('dvlSpecifics')),
			A2(
			$elm$url$Url$Parser$map,
			$author$project$Navigation$Page$MediaFileUI,
			$elm$url$Url$Parser$s('media'))
		]));
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Navigation$AppRouting$fromUrl = function (url) {
	return A2(
		$elm$url$Url$Parser$parse,
		$author$project$Navigation$AppRouting$parser,
		_Utils_update(
			url,
			{
				fragment: $elm$core$Maybe$Nothing,
				path: A2($elm$core$Maybe$withDefault, '', url.fragment)
			}));
};
var $author$project$Models$Msg$KompositionUpdated = function (a) {
	return {$: 'KompositionUpdated', a: a};
};
var $author$project$Models$KompostApi$getFromURL = F2(
	function (integrationDestination, apiToken) {
		return $elm$http$Http$request(
			{
				body: $elm$http$Http$emptyBody,
				expect: A2(
					$elm$http$Http$expectJson,
					A2($elm$core$Basics$composeR, $krisajenkins$remotedata$RemoteData$fromResult, $author$project$Models$Msg$KompositionUpdated),
					$author$project$Models$JsonCoding$kompositionDecoder),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', apiToken)
					]),
				method: 'GET',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: _Utils_ap(integrationDestination.urlPart, integrationDestination.id)
			});
	});
var $elm$browser$Browser$Navigation$load = _Browser_load;
var $elm$browser$Browser$Navigation$pushUrl = _Browser_pushUrl;
var $krisajenkins$remotedata$RemoteData$Loading = {$: 'Loading'};
var $krisajenkins$remotedata$RemoteData$NotAsked = {$: 'NotAsked'};
var $krisajenkins$remotedata$RemoteData$map = F2(
	function (f, data) {
		switch (data.$) {
			case 'Success':
				var value = data.a;
				return $krisajenkins$remotedata$RemoteData$Success(
					f(value));
			case 'Loading':
				return $krisajenkins$remotedata$RemoteData$Loading;
			case 'NotAsked':
				return $krisajenkins$remotedata$RemoteData$NotAsked;
			default:
				var error = data.a;
				return $krisajenkins$remotedata$RemoteData$Failure(error);
		}
	});
var $krisajenkins$remotedata$RemoteData$withDefault = F2(
	function (_default, data) {
		if (data.$ === 'Success') {
			var x = data.a;
			return x;
		} else {
			return _default;
		}
	});
var $krisajenkins$remotedata$RemoteData$toMaybe = A2(
	$elm$core$Basics$composeR,
	$krisajenkins$remotedata$RemoteData$map($elm$core$Maybe$Just),
	$krisajenkins$remotedata$RemoteData$withDefault($elm$core$Maybe$Nothing));
var $elm$url$Url$addPort = F2(
	function (maybePort, starter) {
		if (maybePort.$ === 'Nothing') {
			return starter;
		} else {
			var port_ = maybePort.a;
			return starter + (':' + $elm$core$String$fromInt(port_));
		}
	});
var $elm$url$Url$addPrefixed = F3(
	function (prefix, maybeSegment, starter) {
		if (maybeSegment.$ === 'Nothing') {
			return starter;
		} else {
			var segment = maybeSegment.a;
			return _Utils_ap(
				starter,
				_Utils_ap(prefix, segment));
		}
	});
var $elm$url$Url$toString = function (url) {
	var http = function () {
		var _v0 = url.protocol;
		if (_v0.$ === 'Http') {
			return 'http://';
		} else {
			return 'https://';
		}
	}();
	return A3(
		$elm$url$Url$addPrefixed,
		'#',
		url.fragment,
		A3(
			$elm$url$Url$addPrefixed,
			'?',
			url.query,
			_Utils_ap(
				A2(
					$elm$url$Url$addPort,
					url.port_,
					_Utils_ap(http, url.host)),
				url.path)));
};
var $author$project$Models$BaseModel$OutNavigateTo = function (a) {
	return {$: 'OutNavigateTo', a: a};
};
var $author$project$DvlSpecifics$DvlSpecificsModel$extractBeatPattern = function (model) {
	var _v0 = model.kompost.beatpattern;
	if (_v0.$ === 'Just') {
		var bpm = _v0.a;
		return bpm;
	} else {
		return A3($author$project$Models$BaseModel$BeatPattern, 0, 0, 0);
	}
};
var $author$project$DvlSpecifics$DvlSpecificsModel$setBeatPattern = F2(
	function (funk, model) {
		var kompost = model.kompost;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{
					kompost: _Utils_update(
						kompost,
						{
							beatpattern: $elm$core$Maybe$Just(funk)
						})
				}),
			$elm$core$Maybe$Nothing);
	});
var $author$project$DvlSpecifics$DvlSpecificsModel$setConfig = F2(
	function (funk, model) {
		var kompost = model.kompost;
		return _Utils_update(
			model,
			{
				kompost: _Utils_update(
					kompost,
					{config: funk})
			});
	});
var $elm$core$String$toFloat = _String_toFloat;
var $author$project$DvlSpecifics$DvlSpecificsModel$standardFloat = function (value) {
	return A2(
		$elm$core$Maybe$withDefault,
		0,
		$elm$core$String$toFloat(value));
};
var $author$project$DvlSpecifics$DvlSpecificsModel$standardInt = function (value) {
	return A2(
		$elm$core$Maybe$withDefault,
		0,
		$elm$core$String$toInt(value));
};
var $author$project$DvlSpecifics$DvlSpecificsModel$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'SetKompositionName':
				var name = msg.a;
				var kompost = model.kompost;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							kompost: _Utils_update(
								kompost,
								{name: name})
						}),
					$elm$core$Maybe$Nothing);
			case 'SetDvlType':
				var dvlType = msg.a;
				var kompost = model.kompost;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							kompost: _Utils_update(
								kompost,
								{dvlType: dvlType})
						}),
					$elm$core$Maybe$Nothing);
			case 'SetWidth':
				var value = msg.a;
				var config = model.kompost.config;
				return _Utils_Tuple2(
					A2(
						$author$project$DvlSpecifics$DvlSpecificsModel$setConfig,
						_Utils_update(
							config,
							{
								width: $author$project$DvlSpecifics$DvlSpecificsModel$standardInt(value)
							}),
						model),
					$elm$core$Maybe$Nothing);
			case 'SetHeight':
				var value = msg.a;
				var config = model.kompost.config;
				return _Utils_Tuple2(
					A2(
						$author$project$DvlSpecifics$DvlSpecificsModel$setConfig,
						_Utils_update(
							config,
							{
								height: $author$project$DvlSpecifics$DvlSpecificsModel$standardInt(value)
							}),
						model),
					$elm$core$Maybe$Nothing);
			case 'SetFramerate':
				var value = msg.a;
				var config = model.kompost.config;
				return _Utils_Tuple2(
					A2(
						$author$project$DvlSpecifics$DvlSpecificsModel$setConfig,
						_Utils_update(
							config,
							{
								framerate: $author$project$DvlSpecifics$DvlSpecificsModel$standardInt(value)
							}),
						model),
					$elm$core$Maybe$Nothing);
			case 'SetExtensionType':
				var value = msg.a;
				var config = model.kompost.config;
				return _Utils_Tuple2(
					A2(
						$author$project$DvlSpecifics$DvlSpecificsModel$setConfig,
						_Utils_update(
							config,
							{extensionType: value}),
						model),
					$elm$core$Maybe$Nothing);
			case 'SetBpm':
				var value = msg.a;
				var kompost = model.kompost;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							kompost: _Utils_update(
								kompost,
								{
									bpm: $author$project$DvlSpecifics$DvlSpecificsModel$standardFloat(value)
								})
						}),
					$elm$core$Maybe$Nothing);
			case 'SetFromBpm':
				var value = msg.a;
				var beatpattern = $author$project$DvlSpecifics$DvlSpecificsModel$extractBeatPattern(model);
				return A2(
					$author$project$DvlSpecifics$DvlSpecificsModel$setBeatPattern,
					_Utils_update(
						beatpattern,
						{
							fromBeat: $author$project$DvlSpecifics$DvlSpecificsModel$standardInt(value)
						}),
					model);
			case 'SetToBpm':
				var value = msg.a;
				var beatpattern = $author$project$DvlSpecifics$DvlSpecificsModel$extractBeatPattern(model);
				return A2(
					$author$project$DvlSpecifics$DvlSpecificsModel$setBeatPattern,
					_Utils_update(
						beatpattern,
						{
							toBeat: $author$project$DvlSpecifics$DvlSpecificsModel$standardInt(value)
						}),
					model);
			case 'SetMasterBpm':
				var value = msg.a;
				var beatpattern = $author$project$DvlSpecifics$DvlSpecificsModel$extractBeatPattern(model);
				return A2(
					$author$project$DvlSpecifics$DvlSpecificsModel$setBeatPattern,
					_Utils_update(
						beatpattern,
						{
							masterBPM: $author$project$DvlSpecifics$DvlSpecificsModel$standardFloat(value)
						}),
					model);
			default:
				var page = msg.a;
				var _v1 = A2($elm$core$Debug$log, 'Navigating to', page);
				var _v2 = A2($elm$core$Debug$log, 'BPM is', model.kompost.bpm);
				return _Utils_Tuple2(
					model,
					$elm$core$Maybe$Just(
						$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI)));
		}
	});
var $author$project$Models$BaseModel$FetchSourceListMsg = function (a) {
	return {$: 'FetchSourceListMsg', a: a};
};
var $author$project$Segment$Model$addSegmentToKomposition = F2(
	function (segment, komposition) {
		return _Utils_update(
			komposition,
			{
				segments: A2($elm$core$List$cons, segment, komposition.segments)
			});
	});
var $author$project$Segment$Model$setCurrentSegment = F2(
	function (newSegment, model) {
		return _Utils_update(
			model,
			{segment: newSegment});
	});
var $author$project$Segment$Model$asCurrentSegmentIn = F2(
	function (b, a) {
		return A2($author$project$Segment$Model$setCurrentSegment, a, b);
	});
var $author$project$Segment$Model$setId = F2(
	function (newId, segment) {
		return _Utils_update(
			segment,
			{id: newId});
	});
var $author$project$Segment$Model$asIdIn = F2(
	function (b, a) {
		return A2($author$project$Segment$Model$setId, a, b);
	});
var $author$project$Segment$Model$setSourceId = F2(
	function (newSourceId, segment) {
		return _Utils_update(
			segment,
			{sourceId: newSourceId});
	});
var $author$project$Segment$Model$asSourceIdIn = F2(
	function (b, a) {
		return A2($author$project$Segment$Model$setSourceId, a, b);
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $author$project$Segment$Model$containsSegment = F2(
	function (id, komposition) {
		return A2(
			$elm$core$List$filter,
			function (seg) {
				return _Utils_eq(seg.id, id);
			},
			komposition.segments);
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $author$project$Segment$Model$deleteSegmentFromKomposition = F2(
	function (segment, komposition) {
		return _Utils_update(
			komposition,
			{
				segments: A2(
					$elm$core$List$filter,
					function (n) {
						return !_Utils_eq(n.id, segment.id);
					},
					komposition.segments)
			});
	});
var $author$project$Segment$Model$performSegmentOnModel = F3(
	function (segment, _function, model) {
		return _Utils_update(
			model,
			{
				kompost: A2(_function, segment, model.kompost)
			});
	});
var $author$project$Segment$Model$setDuration = F2(
	function (duration, segment) {
		var dur = A2(
			$elm$core$Debug$log,
			'duration',
			A2(
				$elm$core$Maybe$withDefault,
				0,
				$elm$core$String$toInt(duration)));
		return _Utils_update(
			segment,
			{duration: dur, end: segment.start + dur});
	});
var $author$project$Segment$Model$setEnd = F2(
	function (newEnd, segment) {
		var end = A2(
			$elm$core$Debug$log,
			'newEnd',
			A2(
				$elm$core$Maybe$withDefault,
				0,
				$elm$core$String$toInt(newEnd)));
		return _Utils_update(
			segment,
			{duration: end - segment.start, end: end});
	});
var $author$project$Segment$Model$setStart = F2(
	function (newStart, segment) {
		return _Utils_update(
			segment,
			{
				start: A2(
					$elm$core$Maybe$withDefault,
					0,
					$elm$core$String$toInt(newStart))
			});
	});
var $author$project$Segment$Model$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'SetSegmentId':
				var id = msg.a;
				var newModel = A2(
					$author$project$Segment$Model$asCurrentSegmentIn,
					model,
					A2($author$project$Segment$Model$asIdIn, model.segment, id));
				return _Utils_Tuple3(newModel, $elm$core$Platform$Cmd$none, $elm$core$Maybe$Nothing);
			case 'SetSourceId':
				var id = msg.a;
				var newModel = A2(
					$author$project$Segment$Model$asCurrentSegmentIn,
					model,
					A2($author$project$Segment$Model$asSourceIdIn, model.segment, id));
				return _Utils_Tuple3(
					newModel,
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Just(
						$author$project$Models$BaseModel$FetchSourceListMsg(id)));
			case 'SetSegmentStart':
				var start = msg.a;
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{
							segment: A2($author$project$Segment$Model$setStart, start, model.segment)
						}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetSegmentEnd':
				var end = msg.a;
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{
							segment: A2($author$project$Segment$Model$setEnd, end, model.segment)
						}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetSegmentDuration':
				var duration = msg.a;
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{
							segment: A2($author$project$Segment$Model$setDuration, duration, model.segment)
						}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'EditSegment':
				var id = msg.a;
				var segment = function () {
					var _v1 = A2($author$project$Segment$Model$containsSegment, id, model.kompost);
					if (_v1.b && (!_v1.b.b)) {
						var theSegment = _v1.a;
						return theSegment;
					} else {
						return model.segment;
					}
				}();
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{editableSegment: false, segment: segment}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Just(
						$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$SegmentUI)));
			case 'UpdateSegment':
				var _v2 = A2($author$project$Segment$Model$containsSegment, model.segment.id, model.kompost);
				if (!_v2.b) {
					var _v3 = $elm$core$Debug$log('Adding segment []: ');
					return _Utils_Tuple3(
						A3($author$project$Segment$Model$performSegmentOnModel, model.segment, $author$project$Segment$Model$addSegmentToKomposition, model),
						$elm$core$Platform$Cmd$none,
						$elm$core$Maybe$Just(
							$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI)));
				} else {
					if (!_v2.b.b) {
						var deleted = A3($author$project$Segment$Model$performSegmentOnModel, model.segment, $author$project$Segment$Model$deleteSegmentFromKomposition, model);
						var addedTo = A3($author$project$Segment$Model$performSegmentOnModel, model.segment, $author$project$Segment$Model$addSegmentToKomposition, deleted);
						return A2(
							$elm$core$Debug$log,
							'Updating segment [x]: ',
							_Utils_Tuple3(
								addedTo,
								$elm$core$Platform$Cmd$none,
								$elm$core$Maybe$Just(
									$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI))));
					} else {
						var head = _v2.a;
						var tail = _v2.b;
						return A2(
							$elm$core$Debug$log,
							'Seggie heads tails: ',
							_Utils_Tuple3(
								model,
								$elm$core$Platform$Cmd$none,
								$elm$core$Maybe$Just(
									$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI))));
					}
				}
			case 'DeleteSegment':
				return A2(
					$elm$core$Debug$log,
					'Deleting segment: ',
					_Utils_Tuple3(
						A3($author$project$Segment$Model$performSegmentOnModel, model.segment, $author$project$Segment$Model$deleteSegmentFromKomposition, model),
						$elm$core$Platform$Cmd$none,
						$elm$core$Maybe$Just(
							$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI))));
			case 'FetchAndLoadMediaFile':
				var id = msg.a;
				return _Utils_Tuple3(
					model,
					A2($author$project$Models$KompostApi$fetchSource, id, model.apiToken),
					$elm$core$Maybe$Nothing);
			default:
				var isVisible = msg.a;
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{checkboxVisible: isVisible}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
		}
	});
var $author$project$Models$BaseModel$IntegrationDestination = F2(
	function (id, urlPart) {
		return {id: id, urlPart: urlPart};
	});
var $author$project$Models$BaseModel$Simple = {$: 'Simple'};
var $author$project$Source$SourcesUI$addMediaFileToKomposition = F2(
	function (mediaFile, komposition) {
		return _Utils_update(
			komposition,
			{
				sources: _Utils_ap(
					_List_fromArray(
						[mediaFile]),
					komposition.sources)
			});
	});
var $author$project$Source$SourcesUI$containsMediaFile = F2(
	function (id, komposition) {
		return A2(
			$elm$core$List$filter,
			function (mediaFile) {
				return _Utils_eq(mediaFile.id, id);
			},
			komposition.sources);
	});
var $author$project$Source$SourcesUI$deleteMediaFileFromKomposition = F2(
	function (mediaFile, komposition) {
		return _Utils_update(
			komposition,
			{
				sources: A2(
					$elm$core$List$filter,
					function (n) {
						return !_Utils_eq(n.id, mediaFile.id);
					},
					komposition.sources)
			});
	});
var $author$project$Common$StaticVariables$evaluateMediaType = function (extensionType) {
	switch (extensionType) {
		case 'mp4':
			return 'video';
		case 'webm':
			return 'video';
		case 'mp3':
			return 'audio';
		case 'flac':
			return 'audio';
		case 'aac':
			return 'audio';
		case 'jpg':
			return 'image';
		case 'png':
			return 'image';
		case 'dvl.xml':
			return 'metadata';
		case 'kompo.xml':
			return 'metadata';
		case 'htmlImagelist':
			return 'metadata';
		default:
			return 'Unrecognized media type';
	}
};
var $author$project$Models$Msg$ETagResponse = function (a) {
	return {$: 'ETagResponse', a: a};
};
var $elm$core$Debug$toString = _Debug_toString;
var $author$project$Models$KompostApi$extractSingleHeader = F2(
	function (headerName, headers) {
		var availableHeaders = $elm$core$Debug$toString(headers);
		var _v0 = A2($elm$core$Debug$log, 'Printable', availableHeaders);
		var _v1 = A2($elm$core$Dict$get, headerName, headers);
		if (_v1.$ === 'Just') {
			var header = _v1.a;
			return header;
		} else {
			return A2($elm$core$Debug$log, 'Header not found: ' + headerName, 'available headers ' + availableHeaders);
		}
	});
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Array$repeat = F2(
	function (n, e) {
		return A2(
			$elm$core$Array$initialize,
			n,
			function (_v0) {
				return e;
			});
	});
var $truqu$elm_md5$MD5$emptyWords = A2($elm$core$Array$repeat, 16, 0);
var $truqu$elm_md5$MD5$addUnsigned = F2(
	function (x, y) {
		return 4294967295 & (x + y);
	});
var $elm$core$Bitwise$or = _Bitwise_or;
var $elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $truqu$elm_md5$MD5$rotateLeft = F2(
	function (bits, input) {
		return (input << bits) | (input >>> (32 - bits));
	});
var $truqu$elm_md5$MD5$cmn = F8(
	function (fun, a, b, c, d, x, s, ac) {
		return A2(
			$truqu$elm_md5$MD5$addUnsigned,
			b,
			A2(
				$truqu$elm_md5$MD5$rotateLeft,
				s,
				A2(
					$truqu$elm_md5$MD5$addUnsigned,
					a,
					A2(
						$truqu$elm_md5$MD5$addUnsigned,
						ac,
						A2(
							$truqu$elm_md5$MD5$addUnsigned,
							A3(fun, b, c, d),
							x)))));
	});
var $elm$core$Bitwise$xor = _Bitwise_xor;
var $truqu$elm_md5$MD5$f = F3(
	function (x, y, z) {
		return z ^ (x & (y ^ z));
	});
var $truqu$elm_md5$MD5$ff = F7(
	function (a, b, c, d, x, s, ac) {
		return A8($truqu$elm_md5$MD5$cmn, $truqu$elm_md5$MD5$f, a, b, c, d, x, s, ac);
	});
var $truqu$elm_md5$MD5$g = F3(
	function (x, y, z) {
		return y ^ (z & (x ^ y));
	});
var $truqu$elm_md5$MD5$gg = F7(
	function (a, b, c, d, x, s, ac) {
		return A8($truqu$elm_md5$MD5$cmn, $truqu$elm_md5$MD5$g, a, b, c, d, x, s, ac);
	});
var $truqu$elm_md5$MD5$h = F3(
	function (x, y, z) {
		return z ^ (x ^ y);
	});
var $truqu$elm_md5$MD5$hh = F7(
	function (a, b, c, d, x, s, ac) {
		return A8($truqu$elm_md5$MD5$cmn, $truqu$elm_md5$MD5$h, a, b, c, d, x, s, ac);
	});
var $elm$core$Bitwise$complement = _Bitwise_complement;
var $truqu$elm_md5$MD5$i = F3(
	function (x, y, z) {
		return y ^ (x | (~z));
	});
var $truqu$elm_md5$MD5$ii = F7(
	function (a, b, c, d, x, s, ac) {
		return A8($truqu$elm_md5$MD5$cmn, $truqu$elm_md5$MD5$i, a, b, c, d, x, s, ac);
	});
var $truqu$elm_md5$MD5$hex_ = F2(
	function (xs, acc) {
		var a = acc.a;
		var b = acc.b;
		var c = acc.c;
		var d = acc.d;
		if ((((((((((((((((xs.b && xs.b.b) && xs.b.b.b) && xs.b.b.b.b) && xs.b.b.b.b.b) && xs.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b.b.b.b.b.b) && xs.b.b.b.b.b.b.b.b.b.b.b.b.b.b.b.b) && (!xs.b.b.b.b.b.b.b.b.b.b.b.b.b.b.b.b.b)) {
			var x0 = xs.a;
			var _v1 = xs.b;
			var x1 = _v1.a;
			var _v2 = _v1.b;
			var x2 = _v2.a;
			var _v3 = _v2.b;
			var x3 = _v3.a;
			var _v4 = _v3.b;
			var x4 = _v4.a;
			var _v5 = _v4.b;
			var x5 = _v5.a;
			var _v6 = _v5.b;
			var x6 = _v6.a;
			var _v7 = _v6.b;
			var x7 = _v7.a;
			var _v8 = _v7.b;
			var x8 = _v8.a;
			var _v9 = _v8.b;
			var x9 = _v9.a;
			var _v10 = _v9.b;
			var x10 = _v10.a;
			var _v11 = _v10.b;
			var x11 = _v11.a;
			var _v12 = _v11.b;
			var x12 = _v12.a;
			var _v13 = _v12.b;
			var x13 = _v13.a;
			var _v14 = _v13.b;
			var x14 = _v14.a;
			var _v15 = _v14.b;
			var x15 = _v15.a;
			var s44 = 21;
			var s43 = 15;
			var s42 = 10;
			var s41 = 6;
			var s34 = 23;
			var s33 = 16;
			var s32 = 11;
			var s31 = 4;
			var s24 = 20;
			var s23 = 14;
			var s22 = 9;
			var s21 = 5;
			var s14 = 22;
			var s13 = 17;
			var s12 = 12;
			var s11 = 7;
			var d00 = d;
			var c00 = c;
			var b00 = b;
			var a00 = a;
			var a01 = A7($truqu$elm_md5$MD5$ff, a00, b00, c00, d00, x0, s11, 3614090360);
			var d01 = A7($truqu$elm_md5$MD5$ff, d00, a01, b00, c00, x1, s12, 3905402710);
			var c01 = A7($truqu$elm_md5$MD5$ff, c00, d01, a01, b00, x2, s13, 606105819);
			var b01 = A7($truqu$elm_md5$MD5$ff, b00, c01, d01, a01, x3, s14, 3250441966);
			var a02 = A7($truqu$elm_md5$MD5$ff, a01, b01, c01, d01, x4, s11, 4118548399);
			var d02 = A7($truqu$elm_md5$MD5$ff, d01, a02, b01, c01, x5, s12, 1200080426);
			var c02 = A7($truqu$elm_md5$MD5$ff, c01, d02, a02, b01, x6, s13, 2821735955);
			var b02 = A7($truqu$elm_md5$MD5$ff, b01, c02, d02, a02, x7, s14, 4249261313);
			var a03 = A7($truqu$elm_md5$MD5$ff, a02, b02, c02, d02, x8, s11, 1770035416);
			var d03 = A7($truqu$elm_md5$MD5$ff, d02, a03, b02, c02, x9, s12, 2336552879);
			var c03 = A7($truqu$elm_md5$MD5$ff, c02, d03, a03, b02, x10, s13, 4294925233);
			var b03 = A7($truqu$elm_md5$MD5$ff, b02, c03, d03, a03, x11, s14, 2304563134);
			var a04 = A7($truqu$elm_md5$MD5$ff, a03, b03, c03, d03, x12, s11, 1804603682);
			var d04 = A7($truqu$elm_md5$MD5$ff, d03, a04, b03, c03, x13, s12, 4254626195);
			var c04 = A7($truqu$elm_md5$MD5$ff, c03, d04, a04, b03, x14, s13, 2792965006);
			var b04 = A7($truqu$elm_md5$MD5$ff, b03, c04, d04, a04, x15, s14, 1236535329);
			var a05 = A7($truqu$elm_md5$MD5$gg, a04, b04, c04, d04, x1, s21, 4129170786);
			var d05 = A7($truqu$elm_md5$MD5$gg, d04, a05, b04, c04, x6, s22, 3225465664);
			var c05 = A7($truqu$elm_md5$MD5$gg, c04, d05, a05, b04, x11, s23, 643717713);
			var b05 = A7($truqu$elm_md5$MD5$gg, b04, c05, d05, a05, x0, s24, 3921069994);
			var a06 = A7($truqu$elm_md5$MD5$gg, a05, b05, c05, d05, x5, s21, 3593408605);
			var d06 = A7($truqu$elm_md5$MD5$gg, d05, a06, b05, c05, x10, s22, 38016083);
			var c06 = A7($truqu$elm_md5$MD5$gg, c05, d06, a06, b05, x15, s23, 3634488961);
			var b06 = A7($truqu$elm_md5$MD5$gg, b05, c06, d06, a06, x4, s24, 3889429448);
			var a07 = A7($truqu$elm_md5$MD5$gg, a06, b06, c06, d06, x9, s21, 568446438);
			var d07 = A7($truqu$elm_md5$MD5$gg, d06, a07, b06, c06, x14, s22, 3275163606);
			var c07 = A7($truqu$elm_md5$MD5$gg, c06, d07, a07, b06, x3, s23, 4107603335);
			var b07 = A7($truqu$elm_md5$MD5$gg, b06, c07, d07, a07, x8, s24, 1163531501);
			var a08 = A7($truqu$elm_md5$MD5$gg, a07, b07, c07, d07, x13, s21, 2850285829);
			var d08 = A7($truqu$elm_md5$MD5$gg, d07, a08, b07, c07, x2, s22, 4243563512);
			var c08 = A7($truqu$elm_md5$MD5$gg, c07, d08, a08, b07, x7, s23, 1735328473);
			var b08 = A7($truqu$elm_md5$MD5$gg, b07, c08, d08, a08, x12, s24, 2368359562);
			var a09 = A7($truqu$elm_md5$MD5$hh, a08, b08, c08, d08, x5, s31, 4294588738);
			var d09 = A7($truqu$elm_md5$MD5$hh, d08, a09, b08, c08, x8, s32, 2272392833);
			var c09 = A7($truqu$elm_md5$MD5$hh, c08, d09, a09, b08, x11, s33, 1839030562);
			var b09 = A7($truqu$elm_md5$MD5$hh, b08, c09, d09, a09, x14, s34, 4259657740);
			var a10 = A7($truqu$elm_md5$MD5$hh, a09, b09, c09, d09, x1, s31, 2763975236);
			var d10 = A7($truqu$elm_md5$MD5$hh, d09, a10, b09, c09, x4, s32, 1272893353);
			var c10 = A7($truqu$elm_md5$MD5$hh, c09, d10, a10, b09, x7, s33, 4139469664);
			var b10 = A7($truqu$elm_md5$MD5$hh, b09, c10, d10, a10, x10, s34, 3200236656);
			var a11 = A7($truqu$elm_md5$MD5$hh, a10, b10, c10, d10, x13, s31, 681279174);
			var d11 = A7($truqu$elm_md5$MD5$hh, d10, a11, b10, c10, x0, s32, 3936430074);
			var c11 = A7($truqu$elm_md5$MD5$hh, c10, d11, a11, b10, x3, s33, 3572445317);
			var b11 = A7($truqu$elm_md5$MD5$hh, b10, c11, d11, a11, x6, s34, 76029189);
			var a12 = A7($truqu$elm_md5$MD5$hh, a11, b11, c11, d11, x9, s31, 3654602809);
			var d12 = A7($truqu$elm_md5$MD5$hh, d11, a12, b11, c11, x12, s32, 3873151461);
			var c12 = A7($truqu$elm_md5$MD5$hh, c11, d12, a12, b11, x15, s33, 530742520);
			var b12 = A7($truqu$elm_md5$MD5$hh, b11, c12, d12, a12, x2, s34, 3299628645);
			var a13 = A7($truqu$elm_md5$MD5$ii, a12, b12, c12, d12, x0, s41, 4096336452);
			var d13 = A7($truqu$elm_md5$MD5$ii, d12, a13, b12, c12, x7, s42, 1126891415);
			var c13 = A7($truqu$elm_md5$MD5$ii, c12, d13, a13, b12, x14, s43, 2878612391);
			var b13 = A7($truqu$elm_md5$MD5$ii, b12, c13, d13, a13, x5, s44, 4237533241);
			var a14 = A7($truqu$elm_md5$MD5$ii, a13, b13, c13, d13, x12, s41, 1700485571);
			var d14 = A7($truqu$elm_md5$MD5$ii, d13, a14, b13, c13, x3, s42, 2399980690);
			var c14 = A7($truqu$elm_md5$MD5$ii, c13, d14, a14, b13, x10, s43, 4293915773);
			var b14 = A7($truqu$elm_md5$MD5$ii, b13, c14, d14, a14, x1, s44, 2240044497);
			var a15 = A7($truqu$elm_md5$MD5$ii, a14, b14, c14, d14, x8, s41, 1873313359);
			var d15 = A7($truqu$elm_md5$MD5$ii, d14, a15, b14, c14, x15, s42, 4264355552);
			var c15 = A7($truqu$elm_md5$MD5$ii, c14, d15, a15, b14, x6, s43, 2734768916);
			var b15 = A7($truqu$elm_md5$MD5$ii, b14, c15, d15, a15, x13, s44, 1309151649);
			var a16 = A7($truqu$elm_md5$MD5$ii, a15, b15, c15, d15, x4, s41, 4149444226);
			var d16 = A7($truqu$elm_md5$MD5$ii, d15, a16, b15, c15, x11, s42, 3174756917);
			var c16 = A7($truqu$elm_md5$MD5$ii, c15, d16, a16, b15, x2, s43, 718787259);
			var b16 = A7($truqu$elm_md5$MD5$ii, b15, c16, d16, a16, x9, s44, 3951481745);
			var b17 = A2($truqu$elm_md5$MD5$addUnsigned, b00, b16);
			var c17 = A2($truqu$elm_md5$MD5$addUnsigned, c00, c16);
			var d17 = A2($truqu$elm_md5$MD5$addUnsigned, d00, d16);
			var a17 = A2($truqu$elm_md5$MD5$addUnsigned, a00, a16);
			return {a: a17, b: b17, c: c17, d: d17};
		} else {
			return acc;
		}
	});
var $elm$core$Array$bitMask = 4294967295 >>> (32 - $elm$core$Array$shiftStep);
var $elm$core$Basics$ge = _Utils_ge;
var $elm$core$Elm$JsArray$unsafeGet = _JsArray_unsafeGet;
var $elm$core$Array$getHelp = F3(
	function (shift, index, tree) {
		getHelp:
		while (true) {
			var pos = $elm$core$Array$bitMask & (index >>> shift);
			var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_v0.$ === 'SubTree') {
				var subTree = _v0.a;
				var $temp$shift = shift - $elm$core$Array$shiftStep,
					$temp$index = index,
					$temp$tree = subTree;
				shift = $temp$shift;
				index = $temp$index;
				tree = $temp$tree;
				continue getHelp;
			} else {
				var values = _v0.a;
				return A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, values);
			}
		}
	});
var $elm$core$Array$tailIndex = function (len) {
	return (len >>> 5) << 5;
};
var $elm$core$Array$get = F2(
	function (index, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? $elm$core$Maybe$Nothing : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? $elm$core$Maybe$Just(
			A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, tail)) : $elm$core$Maybe$Just(
			A3($elm$core$Array$getHelp, startShift, index, tree)));
	});
var $truqu$elm_md5$MD5$iget = F2(
	function (index, array) {
		return A2(
			$elm$core$Maybe$withDefault,
			0,
			A2($elm$core$Array$get, index, array));
	});
var $elm$core$Elm$JsArray$unsafeSet = _JsArray_unsafeSet;
var $elm$core$Array$setHelp = F4(
	function (shift, index, value, tree) {
		var pos = $elm$core$Array$bitMask & (index >>> shift);
		var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
		if (_v0.$ === 'SubTree') {
			var subTree = _v0.a;
			var newSub = A4($elm$core$Array$setHelp, shift - $elm$core$Array$shiftStep, index, value, subTree);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$SubTree(newSub),
				tree);
		} else {
			var values = _v0.a;
			var newLeaf = A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, values);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$Leaf(newLeaf),
				tree);
		}
	});
var $elm$core$Array$set = F3(
	function (index, value, array) {
		var len = array.a;
		var startShift = array.b;
		var tree = array.c;
		var tail = array.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? array : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			tree,
			A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, tail)) : A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			A4($elm$core$Array$setHelp, startShift, index, value, tree),
			tail));
	});
var $truqu$elm_md5$MD5$consume = F2(
	function (_char, _v0) {
		var hashState = _v0.a;
		var _v1 = _v0.b;
		var byteCount = _v1.a;
		var words = _v1.b;
		var totalByteCount = _v0.c;
		var wordCount = (byteCount / 4) | 0;
		var oldWord = A2($truqu$elm_md5$MD5$iget, wordCount, words);
		var bytePosition = 8 * (byteCount % 4);
		var code = _char << bytePosition;
		var newWord = oldWord | code;
		var newWords = A3($elm$core$Array$set, wordCount, newWord, words);
		return (byteCount === 63) ? _Utils_Tuple3(
			A2(
				$truqu$elm_md5$MD5$hex_,
				$elm$core$Array$toList(newWords),
				hashState),
			_Utils_Tuple2(0, $truqu$elm_md5$MD5$emptyWords),
			totalByteCount + 1) : _Utils_Tuple3(
			hashState,
			_Utils_Tuple2(byteCount + 1, newWords),
			totalByteCount + 1);
	});
var $truqu$elm_md5$MD5$finishUp = function (_v0) {
	var hashState = _v0.a;
	var _v1 = _v0.b;
	var byteCount = _v1.a;
	var words = _v1.b;
	var totalByteCount = _v0.c;
	var wordCount = (byteCount / 4) | 0;
	var oldWord = A2($truqu$elm_md5$MD5$iget, wordCount, words);
	var bytePosition = 8 * (byteCount % 4);
	var code = 128 << bytePosition;
	var newWord = oldWord | code;
	var newWords = A3($elm$core$Array$set, wordCount, newWord, words);
	return (wordCount < 14) ? function (x) {
		return A2($truqu$elm_md5$MD5$hex_, x, hashState);
	}(
		$elm$core$Array$toList(
			A3(
				$elm$core$Array$set,
				15,
				totalByteCount >>> 29,
				A3($elm$core$Array$set, 14, totalByteCount << 3, newWords)))) : function (x) {
		return A2(
			$truqu$elm_md5$MD5$hex_,
			x,
			A2(
				$truqu$elm_md5$MD5$hex_,
				$elm$core$Array$toList(newWords),
				hashState));
	}(
		$elm$core$Array$toList(
			A3(
				$elm$core$Array$set,
				15,
				totalByteCount >>> 29,
				A3($elm$core$Array$set, 14, totalByteCount << 3, $truqu$elm_md5$MD5$emptyWords))));
};
var $elm$core$String$foldl = _String_foldl;
var $zwilias$elm_utf_tools$String$UTF8$utf32ToUtf8 = F3(
	function (add, _char, acc) {
		return (_char < 128) ? A2(add, _char, acc) : ((_char < 2048) ? A2(
			add,
			128 | (63 & _char),
			A2(add, 192 | (_char >>> 6), acc)) : ((_char < 65536) ? A2(
			add,
			128 | (63 & _char),
			A2(
				add,
				128 | (63 & (_char >>> 6)),
				A2(add, 224 | (_char >>> 12), acc))) : A2(
			add,
			128 | (63 & _char),
			A2(
				add,
				128 | (63 & (_char >>> 6)),
				A2(
					add,
					128 | (63 & (_char >>> 12)),
					A2(add, 240 | (_char >>> 18), acc))))));
	});
var $zwilias$elm_utf_tools$String$UTF8$foldl = F3(
	function (op, initialAcc, input) {
		return A3(
			$elm$core$String$foldl,
			F2(
				function (_char, acc) {
					return A3(
						$zwilias$elm_utf_tools$String$UTF8$utf32ToUtf8,
						op,
						$elm$core$Char$toCode(_char),
						acc);
				}),
			initialAcc,
			input);
	});
var $truqu$elm_md5$MD5$State = F4(
	function (a, b, c, d) {
		return {a: a, b: b, c: c, d: d};
	});
var $truqu$elm_md5$MD5$initialHashState = A4($truqu$elm_md5$MD5$State, 1732584193, 4023233417, 2562383102, 271733878);
var $truqu$elm_md5$MD5$hash = function (input) {
	return $truqu$elm_md5$MD5$finishUp(
		A3(
			$zwilias$elm_utf_tools$String$UTF8$foldl,
			$truqu$elm_md5$MD5$consume,
			_Utils_Tuple3(
				$truqu$elm_md5$MD5$initialHashState,
				_Utils_Tuple2(0, $truqu$elm_md5$MD5$emptyWords),
				0),
			input));
};
var $truqu$elm_md5$MD5$bytes = function (string) {
	var _v0 = $truqu$elm_md5$MD5$hash(string);
	var a = _v0.a;
	var b = _v0.b;
	var c = _v0.c;
	var d = _v0.d;
	return _List_fromArray(
		[a & 255, (a >>> 8) & 255, (a >>> 16) & 255, (a >>> 24) & 255, b & 255, (b >>> 8) & 255, (b >>> 16) & 255, (b >>> 24) & 255, c & 255, (c >>> 8) & 255, (c >>> 16) & 255, (c >>> 24) & 255, d & 255, (d >>> 8) & 255, (d >>> 16) & 255, (d >>> 24) & 255]);
};
var $elm$core$String$cons = _String_cons;
var $elm$core$String$fromChar = function (_char) {
	return A2($elm$core$String$cons, _char, '');
};
var $elm$core$Bitwise$shiftRightBy = _Bitwise_shiftRightBy;
var $elm$core$String$repeatHelp = F3(
	function (n, chunk, result) {
		return (n <= 0) ? result : A3(
			$elm$core$String$repeatHelp,
			n >> 1,
			_Utils_ap(chunk, chunk),
			(!(n & 1)) ? result : _Utils_ap(result, chunk));
	});
var $elm$core$String$repeat = F2(
	function (n, chunk) {
		return A3($elm$core$String$repeatHelp, n, chunk, '');
	});
var $elm$core$String$padLeft = F3(
	function (n, _char, string) {
		return _Utils_ap(
			A2(
				$elm$core$String$repeat,
				n - $elm$core$String$length(string),
				$elm$core$String$fromChar(_char)),
			string);
	});
var $truqu$elm_md5$MD5$toHex = function (_byte) {
	switch (_byte) {
		case 0:
			return '0';
		case 1:
			return '1';
		case 2:
			return '2';
		case 3:
			return '3';
		case 4:
			return '4';
		case 5:
			return '5';
		case 6:
			return '6';
		case 7:
			return '7';
		case 8:
			return '8';
		case 9:
			return '9';
		case 10:
			return 'a';
		case 11:
			return 'b';
		case 12:
			return 'c';
		case 13:
			return 'd';
		case 14:
			return 'e';
		case 15:
			return 'f';
		default:
			return _Utils_ap(
				$truqu$elm_md5$MD5$toHex((_byte / 16) | 0),
				$truqu$elm_md5$MD5$toHex(_byte % 16));
	}
};
var $truqu$elm_md5$MD5$hex = function (s) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (b, acc) {
				return _Utils_ap(
					acc,
					A3(
						$elm$core$String$padLeft,
						2,
						_Utils_chr('0'),
						$truqu$elm_md5$MD5$toHex(b)));
			}),
		'',
		$truqu$elm_md5$MD5$bytes(s));
};
var $author$project$Models$KompostApi$extractHeaderResponse = F3(
	function (headerName, toResult, response) {
		switch (response.$) {
			case 'BadUrl_':
				var url = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadUrl(url));
			case 'Timeout_':
				return $elm$core$Result$Err($elm$http$Http$Timeout);
			case 'NetworkError_':
				return $elm$core$Result$Err($elm$http$Http$NetworkError);
			case 'BadStatus_':
				var metadata = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadStatus(metadata.statusCode));
			default:
				var metadata = response.a;
				var body = response.b;
				var header = A2($author$project$Models$KompostApi$extractSingleHeader, headerName, metadata.headers);
				var bodyval = $elm$core$Debug$toString(body);
				var hex = $truqu$elm_md5$MD5$hex(bodyval);
				return A2(
					$elm$core$Result$mapError,
					$elm$http$Http$BadBody,
					toResult(header + (',' + hex)));
		}
	});
var $author$project$Models$KompostApi$fetchHeaderParam = F3(
	function (urlId, headerName, apiToken) {
		return $elm$http$Http$request(
			{
				body: $elm$http$Http$emptyBody,
				expect: A2(
					$elm$http$Http$expectStringResponse,
					$author$project$Models$Msg$ETagResponse,
					A2($author$project$Models$KompostApi$extractHeaderResponse, headerName, $elm$core$Result$Ok)),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', apiToken)
					]),
				method: 'GET',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: _Utils_ap($author$project$Models$KompostApi$kompoUrl, urlId)
			});
	});
var $author$project$Source$SourcesUI$performMediaFileOnModel = F3(
	function (mf, _function, model) {
		return _Utils_update(
			model,
			{
				kompost: A2(_function, mf, model.kompost)
			});
	});
var $author$project$Source$SourcesUI$setSource = F2(
	function (funk, model) {
		return _Utils_update(
			model,
			{editingMediaFile: funk});
	});
var $author$project$Source$SourcesUI$standardFloat = function (value) {
	return A2(
		$elm$core$Maybe$withDefault,
		0,
		$elm$core$String$toFloat(value));
};
var $author$project$Common$AutoComplete$NoOp = {$: 'NoOp'};
var $author$project$Common$AutoComplete$Reset = {$: 'Reset'};
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$core$String$toLower = _String_toLower;
var $author$project$Common$AutoComplete$acceptablePeople = F2(
	function (query, people) {
		var lowerQuery = $elm$core$String$toLower(query);
		return A2(
			$elm$core$List$filter,
			A2(
				$elm$core$Basics$composeL,
				A2(
					$elm$core$Basics$composeL,
					$elm$core$String$contains(lowerQuery),
					$elm$core$String$toLower),
				function ($) {
					return $.name;
				}),
			people);
	});
var $elm$core$Task$onError = _Scheduler_onError;
var $elm$core$Task$attempt = F2(
	function (resultToMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2(
					$elm$core$Task$onError,
					A2(
						$elm$core$Basics$composeL,
						A2($elm$core$Basics$composeL, $elm$core$Task$succeed, resultToMessage),
						$elm$core$Result$Err),
					A2(
						$elm$core$Task$andThen,
						A2(
							$elm$core$Basics$composeL,
							A2($elm$core$Basics$composeL, $elm$core$Task$succeed, resultToMessage),
							$elm$core$Result$Ok),
						task))));
	});
var $elm$browser$Browser$Dom$focus = _Browser_call('focus');
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Common$AutoComplete$getPersonAtId = F2(
	function (people, id) {
		return A2(
			$elm$core$Maybe$withDefault,
			A4($author$project$Common$AutoComplete$Person, '', 0, '', ''),
			$elm$core$List$head(
				A2(
					$elm$core$List$filter,
					function (person) {
						return _Utils_eq(person.name, id);
					},
					people)));
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$core$Basics$not = _Basics_not;
var $author$project$Common$AutoComplete$removeSelection = function (model) {
	return _Utils_update(
		model,
		{selectedPerson: $elm$core$Maybe$Nothing});
};
var $ContaSystemer$elm_menu$Menu$Internal$reset = F2(
	function (_v0, _v1) {
		var separateSelections = _v0.separateSelections;
		var mouse = _v1.mouse;
		return separateSelections ? {key: $elm$core$Maybe$Nothing, mouse: mouse} : $ContaSystemer$elm_menu$Menu$Internal$empty;
	});
var $ContaSystemer$elm_menu$Menu$reset = F2(
	function (_v0, _v1) {
		var config = _v0.a;
		var state = _v1.a;
		return $ContaSystemer$elm_menu$Menu$State(
			A2($ContaSystemer$elm_menu$Menu$Internal$reset, config, state));
	});
var $author$project$Common$AutoComplete$resetMenu = function (model) {
	return _Utils_update(
		model,
		{autoState: $ContaSystemer$elm_menu$Menu$empty, showMenu: false});
};
var $author$project$Common$AutoComplete$resetInput = function (model) {
	return $author$project$Common$AutoComplete$resetMenu(
		$author$project$Common$AutoComplete$removeSelection(
			_Utils_update(
				model,
				{query: ''})));
};
var $ContaSystemer$elm_menu$Menu$Internal$resetToFirst = F3(
	function (config, data, state) {
		var _v0 = config;
		var toId = _v0.toId;
		var separateSelections = _v0.separateSelections;
		var setFirstItem = F2(
			function (datum, newState) {
				return _Utils_update(
					newState,
					{
						key: $elm$core$Maybe$Just(
							toId(datum))
					});
			});
		var _v1 = $elm$core$List$head(data);
		if (_v1.$ === 'Nothing') {
			return $ContaSystemer$elm_menu$Menu$Internal$empty;
		} else {
			var datum = _v1.a;
			return separateSelections ? A2(
				setFirstItem,
				datum,
				A2($ContaSystemer$elm_menu$Menu$Internal$reset, config, state)) : A2(setFirstItem, datum, $ContaSystemer$elm_menu$Menu$Internal$empty);
		}
	});
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $ContaSystemer$elm_menu$Menu$Internal$resetToFirstItem = F4(
	function (config, data, howManyToShow, state) {
		return A3(
			$ContaSystemer$elm_menu$Menu$Internal$resetToFirst,
			config,
			A2($elm$core$List$take, howManyToShow, data),
			state);
	});
var $ContaSystemer$elm_menu$Menu$resetToFirstItem = F4(
	function (_v0, data, howManyToShow, _v1) {
		var config = _v0.a;
		var state = _v1.a;
		return $ContaSystemer$elm_menu$Menu$State(
			A4($ContaSystemer$elm_menu$Menu$Internal$resetToFirstItem, config, data, howManyToShow, state));
	});
var $ContaSystemer$elm_menu$Menu$Internal$resetToLastItem = F4(
	function (config, data, howManyToShow, state) {
		var reversedData = $elm$core$List$reverse(
			A2($elm$core$List$take, howManyToShow, data));
		return A3($ContaSystemer$elm_menu$Menu$Internal$resetToFirst, config, reversedData, state);
	});
var $ContaSystemer$elm_menu$Menu$resetToLastItem = F4(
	function (_v0, data, howManyToShow, _v1) {
		var config = _v0.a;
		var state = _v1.a;
		return $ContaSystemer$elm_menu$Menu$State(
			A4($ContaSystemer$elm_menu$Menu$Internal$resetToLastItem, config, data, howManyToShow, state));
	});
var $author$project$Common$AutoComplete$setQuery = F2(
	function (model, id) {
		return _Utils_update(
			model,
			{
				query: function ($) {
					return $.name;
				}(
					A2($author$project$Common$AutoComplete$getPersonAtId, model.people, id)),
				selectedPerson: $elm$core$Maybe$Just(
					A2($author$project$Common$AutoComplete$getPersonAtId, model.people, id))
			});
	});
var $ContaSystemer$elm_menu$Menu$Internal$WentTooHigh = {$: 'WentTooHigh'};
var $ContaSystemer$elm_menu$Menu$Internal$WentTooLow = {$: 'WentTooLow'};
var $ContaSystemer$elm_menu$Menu$Internal$getPrevious = F3(
	function (id, selectedId, resultId) {
		return _Utils_eq(selectedId, id) ? $elm$core$Maybe$Just(id) : (_Utils_eq(
			A2($elm$core$Maybe$withDefault, '', resultId),
			id) ? $elm$core$Maybe$Just(selectedId) : resultId);
	});
var $ContaSystemer$elm_menu$Menu$Internal$getNextItemId = F2(
	function (ids, selectedId) {
		return A2(
			$elm$core$Maybe$withDefault,
			selectedId,
			A3(
				$elm$core$List$foldl,
				$ContaSystemer$elm_menu$Menu$Internal$getPrevious(selectedId),
				$elm$core$Maybe$Nothing,
				ids));
	});
var $ContaSystemer$elm_menu$Menu$Internal$getPreviousItemId = F2(
	function (ids, selectedId) {
		return A2(
			$elm$core$Maybe$withDefault,
			selectedId,
			A3(
				$elm$core$List$foldr,
				$ContaSystemer$elm_menu$Menu$Internal$getPrevious(selectedId),
				$elm$core$Maybe$Nothing,
				ids));
	});
var $ContaSystemer$elm_menu$Menu$Internal$navigateWithKey = F3(
	function (code, ids, maybeId) {
		switch (code) {
			case 38:
				return A2(
					$elm$core$Maybe$map,
					$ContaSystemer$elm_menu$Menu$Internal$getPreviousItemId(ids),
					maybeId);
			case 40:
				return A2(
					$elm$core$Maybe$map,
					$ContaSystemer$elm_menu$Menu$Internal$getNextItemId(ids),
					maybeId);
			default:
				return maybeId;
		}
	});
var $ContaSystemer$elm_menu$Menu$Internal$resetMouseStateWithId = F3(
	function (separateSelections, id, state) {
		return separateSelections ? {
			key: state.key,
			mouse: $elm$core$Maybe$Just(id)
		} : {
			key: $elm$core$Maybe$Just(id),
			mouse: $elm$core$Maybe$Just(id)
		};
	});
var $ContaSystemer$elm_menu$Menu$Internal$update = F5(
	function (config, msg, howManyToShow, state, data) {
		update:
		while (true) {
			switch (msg.$) {
				case 'KeyDown':
					var keyCode = msg.a;
					var boundedList = A2(
						$elm$core$List$take,
						howManyToShow,
						A2($elm$core$List$map, config.toId, data));
					var newKey = A3($ContaSystemer$elm_menu$Menu$Internal$navigateWithKey, keyCode, boundedList, state.key);
					if (_Utils_eq(newKey, state.key) && (keyCode === 38)) {
						var $temp$config = config,
							$temp$msg = $ContaSystemer$elm_menu$Menu$Internal$WentTooHigh,
							$temp$howManyToShow = howManyToShow,
							$temp$state = state,
							$temp$data = data;
						config = $temp$config;
						msg = $temp$msg;
						howManyToShow = $temp$howManyToShow;
						state = $temp$state;
						data = $temp$data;
						continue update;
					} else {
						if (_Utils_eq(newKey, state.key) && (keyCode === 40)) {
							var $temp$config = config,
								$temp$msg = $ContaSystemer$elm_menu$Menu$Internal$WentTooLow,
								$temp$howManyToShow = howManyToShow,
								$temp$state = state,
								$temp$data = data;
							config = $temp$config;
							msg = $temp$msg;
							howManyToShow = $temp$howManyToShow;
							state = $temp$state;
							data = $temp$data;
							continue update;
						} else {
							if (config.separateSelections) {
								return _Utils_Tuple2(
									_Utils_update(
										state,
										{key: newKey}),
									A2(config.onKeyDown, keyCode, newKey));
							} else {
								return _Utils_Tuple2(
									{key: newKey, mouse: newKey},
									A2(config.onKeyDown, keyCode, newKey));
							}
						}
					}
				case 'WentTooLow':
					return _Utils_Tuple2(state, config.onTooLow);
				case 'WentTooHigh':
					return _Utils_Tuple2(state, config.onTooHigh);
				case 'MouseEnter':
					var id = msg.a;
					return _Utils_Tuple2(
						A3($ContaSystemer$elm_menu$Menu$Internal$resetMouseStateWithId, config.separateSelections, id, state),
						config.onMouseEnter(id));
				case 'MouseLeave':
					var id = msg.a;
					return _Utils_Tuple2(
						A3($ContaSystemer$elm_menu$Menu$Internal$resetMouseStateWithId, config.separateSelections, id, state),
						config.onMouseLeave(id));
				case 'MouseClick':
					var id = msg.a;
					return _Utils_Tuple2(
						A3($ContaSystemer$elm_menu$Menu$Internal$resetMouseStateWithId, config.separateSelections, id, state),
						config.onMouseClick(id));
				default:
					return _Utils_Tuple2(state, $elm$core$Maybe$Nothing);
			}
		}
	});
var $ContaSystemer$elm_menu$Menu$update = F5(
	function (_v0, _v1, howManyToShow, _v2, data) {
		var config = _v0.a;
		var msg = _v1.a;
		var state = _v2.a;
		var _v3 = A5($ContaSystemer$elm_menu$Menu$Internal$update, config, msg, howManyToShow, state, data);
		var newState = _v3.a;
		var maybeMsg = _v3.b;
		return _Utils_Tuple2(
			$ContaSystemer$elm_menu$Menu$State(newState),
			maybeMsg);
	});
var $author$project$Common$AutoComplete$PreviewPerson = function (a) {
	return {$: 'PreviewPerson', a: a};
};
var $author$project$Common$AutoComplete$SelectPersonKeyboard = function (a) {
	return {$: 'SelectPersonKeyboard', a: a};
};
var $author$project$Common$AutoComplete$SelectPersonMouse = function (a) {
	return {$: 'SelectPersonMouse', a: a};
};
var $author$project$Common$AutoComplete$Wrap = function (a) {
	return {$: 'Wrap', a: a};
};
var $ContaSystemer$elm_menu$Menu$UpdateConfig = function (a) {
	return {$: 'UpdateConfig', a: a};
};
var $ContaSystemer$elm_menu$Menu$Internal$updateConfig = function (_v0) {
	var toId = _v0.toId;
	var onKeyDown = _v0.onKeyDown;
	var onTooLow = _v0.onTooLow;
	var onTooHigh = _v0.onTooHigh;
	var onMouseEnter = _v0.onMouseEnter;
	var onMouseLeave = _v0.onMouseLeave;
	var onMouseClick = _v0.onMouseClick;
	var separateSelections = _v0.separateSelections;
	return {onKeyDown: onKeyDown, onMouseClick: onMouseClick, onMouseEnter: onMouseEnter, onMouseLeave: onMouseLeave, onTooHigh: onTooHigh, onTooLow: onTooLow, separateSelections: separateSelections, toId: toId};
};
var $ContaSystemer$elm_menu$Menu$updateConfig = function (config) {
	return $ContaSystemer$elm_menu$Menu$UpdateConfig(
		$ContaSystemer$elm_menu$Menu$Internal$updateConfig(config));
};
var $author$project$Common$AutoComplete$updateConfig = $ContaSystemer$elm_menu$Menu$updateConfig(
	{
		onKeyDown: F2(
			function (code, maybeId) {
				return ((code === 38) || (code === 40)) ? A2($elm$core$Maybe$map, $author$project$Common$AutoComplete$PreviewPerson, maybeId) : ((code === 13) ? A2($elm$core$Maybe$map, $author$project$Common$AutoComplete$SelectPersonKeyboard, maybeId) : $elm$core$Maybe$Just($author$project$Common$AutoComplete$Reset));
			}),
		onMouseClick: function (id) {
			return $elm$core$Maybe$Just(
				$author$project$Common$AutoComplete$SelectPersonMouse(id));
		},
		onMouseEnter: function (id) {
			return $elm$core$Maybe$Just(
				$author$project$Common$AutoComplete$PreviewPerson(id));
		},
		onMouseLeave: function (_v0) {
			return $elm$core$Maybe$Nothing;
		},
		onTooHigh: $elm$core$Maybe$Just(
			$author$project$Common$AutoComplete$Wrap(true)),
		onTooLow: $elm$core$Maybe$Just(
			$author$project$Common$AutoComplete$Wrap(false)),
		separateSelections: false,
		toId: function ($) {
			return $.name;
		}
	});
var $author$project$Common$AutoComplete$update = F2(
	function (msg, model) {
		update:
		while (true) {
			switch (msg.$) {
				case 'SetQuery':
					var newQuery = msg.a;
					var showMenu = !$elm$core$List$isEmpty(
						A2($author$project$Common$AutoComplete$acceptablePeople, newQuery, model.people));
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{query: newQuery, selectedPerson: $elm$core$Maybe$Nothing, showMenu: showMenu}),
						$elm$core$Platform$Cmd$none);
				case 'SetAutoState':
					var autoMsg = msg.a;
					var _v1 = A5(
						$ContaSystemer$elm_menu$Menu$update,
						$author$project$Common$AutoComplete$updateConfig,
						autoMsg,
						model.howManyToShow,
						model.autoState,
						A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people));
					var newState = _v1.a;
					var maybeMsg = _v1.b;
					var newModel = _Utils_update(
						model,
						{autoState: newState});
					return A2(
						$elm$core$Maybe$withDefault,
						_Utils_Tuple2(newModel, $elm$core$Platform$Cmd$none),
						A2(
							$elm$core$Maybe$map,
							function (updateMsg) {
								return A2($author$project$Common$AutoComplete$update, updateMsg, newModel);
							},
							maybeMsg));
				case 'HandleEscape':
					var validOptions = !$elm$core$List$isEmpty(
						A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people));
					var handleEscape = validOptions ? $author$project$Common$AutoComplete$resetMenu(
						$author$project$Common$AutoComplete$removeSelection(model)) : $author$project$Common$AutoComplete$resetInput(model);
					var escapedModel = function () {
						var _v2 = model.selectedPerson;
						if (_v2.$ === 'Just') {
							var person = _v2.a;
							return _Utils_eq(model.query, person.name) ? $author$project$Common$AutoComplete$resetInput(model) : handleEscape;
						} else {
							return handleEscape;
						}
					}();
					return _Utils_Tuple2(escapedModel, $elm$core$Platform$Cmd$none);
				case 'Wrap':
					var toTop = msg.a;
					var _v3 = model.selectedPerson;
					if (_v3.$ === 'Just') {
						var person = _v3.a;
						var $temp$msg = $author$project$Common$AutoComplete$Reset,
							$temp$model = model;
						msg = $temp$msg;
						model = $temp$model;
						continue update;
					} else {
						return toTop ? _Utils_Tuple2(
							_Utils_update(
								model,
								{
									autoState: A4(
										$ContaSystemer$elm_menu$Menu$resetToLastItem,
										$author$project$Common$AutoComplete$updateConfig,
										A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people),
										model.howManyToShow,
										model.autoState),
									selectedPerson: $elm$core$List$head(
										$elm$core$List$reverse(
											A2(
												$elm$core$List$take,
												model.howManyToShow,
												A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people))))
								}),
							$elm$core$Platform$Cmd$none) : _Utils_Tuple2(
							_Utils_update(
								model,
								{
									autoState: A4(
										$ContaSystemer$elm_menu$Menu$resetToFirstItem,
										$author$project$Common$AutoComplete$updateConfig,
										A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people),
										model.howManyToShow,
										model.autoState),
									selectedPerson: $elm$core$List$head(
										A2(
											$elm$core$List$take,
											model.howManyToShow,
											A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people)))
								}),
							$elm$core$Platform$Cmd$none);
					}
				case 'Reset':
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								autoState: A2($ContaSystemer$elm_menu$Menu$reset, $author$project$Common$AutoComplete$updateConfig, model.autoState),
								selectedPerson: $elm$core$Maybe$Nothing
							}),
						$elm$core$Platform$Cmd$none);
				case 'SelectPersonKeyboard':
					var id = msg.a;
					var newModel = $author$project$Common$AutoComplete$resetMenu(
						A2($author$project$Common$AutoComplete$setQuery, model, id));
					return _Utils_Tuple2(newModel, $elm$core$Platform$Cmd$none);
				case 'SelectPersonMouse':
					var id = msg.a;
					var newModel = $author$project$Common$AutoComplete$resetMenu(
						A2($author$project$Common$AutoComplete$setQuery, model, id));
					return _Utils_Tuple2(
						newModel,
						A2(
							$elm$core$Task$attempt,
							function (_v4) {
								return $author$project$Common$AutoComplete$NoOp;
							},
							$elm$browser$Browser$Dom$focus('president-input')));
				case 'PreviewPerson':
					var id = msg.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								selectedPerson: $elm$core$Maybe$Just(
									A2($author$project$Common$AutoComplete$getPersonAtId, model.people, id))
							}),
						$elm$core$Platform$Cmd$none);
				case 'OnFocus':
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				default:
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			}
		}
	});
var $author$project$Source$SourcesUI$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'SetSourceId':
				var id = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{id: id}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SourceSearchVisible':
				var isVisible = msg.a;
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{checkboxVisible: isVisible}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetUrl':
				var url = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{url: url}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetChecksum':
				var checksum = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{checksum: checksum}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetFormat':
				var format = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{format: format}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetOffset':
				var value = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{
								startingOffset: $elm$core$Maybe$Just(
									$author$project$Source$SourcesUI$standardFloat(value))
							}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetSourceExtensionType':
				var value = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{
								extensionType: value,
								mediaType: $author$project$Common$StaticVariables$evaluateMediaType(value)
							}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'SetSourceMediaType':
				var value = msg.a;
				var source = model.editingMediaFile;
				return _Utils_Tuple3(
					A2(
						$author$project$Source$SourcesUI$setSource,
						_Utils_update(
							source,
							{mediaType: value}),
						model),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Nothing);
			case 'EditMediaFile':
				var id = msg.a;
				var theMediaFile = function () {
					var _v1 = A2($author$project$Source$SourcesUI$containsMediaFile, id, model.kompost);
					if (_v1.b && (!_v1.b.b)) {
						var mediaFile = _v1.a;
						return A2($elm$core$Debug$log, 'We found preexisting media file', mediaFile);
					} else {
						return A9($author$project$Models$BaseModel$Source, '', '', $elm$core$Maybe$Nothing, '', '', '', '', $elm$core$Maybe$Nothing, $elm$core$Maybe$Nothing);
					}
				}();
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{editingMediaFile: theMediaFile}),
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Just(
						$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$MediaFileUI)));
			case 'FetchSourceList':
				var id = msg.a;
				return _Utils_Tuple3(
					model,
					A2($author$project$Models$KompostApi$fetchKompositionList, id, model.apiToken),
					$elm$core$Maybe$Nothing);
			case 'SaveSource':
				var _v2 = A2($author$project$Source$SourcesUI$containsMediaFile, model.editingMediaFile.id, model.kompost);
				if (!_v2.b) {
					return A2(
						$elm$core$Debug$log,
						'Adding MediaFile []: ',
						_Utils_Tuple3(
							A3($author$project$Source$SourcesUI$performMediaFileOnModel, model.editingMediaFile, $author$project$Source$SourcesUI$addMediaFileToKomposition, model),
							$elm$core$Platform$Cmd$none,
							$elm$core$Maybe$Just(
								$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI))));
				} else {
					if (!_v2.b.b) {
						var x = _v2.a;
						var deleted = A3($author$project$Source$SourcesUI$performMediaFileOnModel, model.editingMediaFile, $author$project$Source$SourcesUI$deleteMediaFileFromKomposition, model);
						var addedTo = A3($author$project$Source$SourcesUI$performMediaFileOnModel, model.editingMediaFile, $author$project$Source$SourcesUI$addMediaFileToKomposition, deleted);
						return A2(
							$elm$core$Debug$log,
							'Updating mediaFile [x]: ',
							_Utils_Tuple3(
								addedTo,
								$elm$core$Platform$Cmd$none,
								$elm$core$Maybe$Just(
									$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI))));
					} else {
						var head = _v2.a;
						var tail = _v2.b;
						return A2(
							$elm$core$Debug$log,
							'Seggie heads tails: ',
							_Utils_Tuple3(
								model,
								$elm$core$Platform$Cmd$none,
								$elm$core$Maybe$Just(
									$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI))));
					}
				}
			case 'DeleteSource':
				var id = msg.a;
				var modifiedModel = A3($author$project$Source$SourcesUI$performMediaFileOnModel, model.editingMediaFile, $author$project$Source$SourcesUI$deleteMediaFileFromKomposition, model);
				return _Utils_Tuple3(
					modifiedModel,
					$elm$core$Platform$Cmd$none,
					$elm$core$Maybe$Just(
						$author$project$Models$BaseModel$OutNavigateTo($author$project$Navigation$Page$KompostUI)));
			case 'OrderChecksumEvalutation':
				var id = msg.a;
				return _Utils_Tuple3(
					model,
					A3($author$project$Models$KompostApi$fetchHeaderParam, id, 'etag', model.apiToken),
					$elm$core$Maybe$Nothing);
			case 'JumpToSourceKomposition':
				var mediaId = msg.a;
				var _v3 = A2($elm$core$Debug$log, 'Navigating to Komposition', mediaId);
				return _Utils_Tuple3(
					_Utils_update(
						model,
						{activePage: $author$project$Navigation$Page$KompostUI}),
					A2(
						$author$project$Models$KompostApi$getFromURL,
						A2($author$project$Models$BaseModel$IntegrationDestination, mediaId, model.kompoUrl),
						model.apiToken),
					$elm$core$Maybe$Nothing);
			default:
				var autoMsg = msg.a;
				var mods = _Utils_update(
					model,
					{
						accessibleAutocomplete: A2($author$project$Common$AutoComplete$update, autoMsg, model.accessibleAutocomplete).a
					});
				if (autoMsg.$ === 'OnFocus') {
					return _Utils_Tuple3(
						_Utils_update(
							mods,
							{currentFocusAutoComplete: $author$project$Models$BaseModel$Simple}),
						$elm$core$Platform$Cmd$none,
						$elm$core$Maybe$Nothing);
				} else {
					return _Utils_Tuple3(mods, $elm$core$Platform$Cmd$none, $elm$core$Maybe$Nothing);
				}
		}
	});
var $author$project$Models$KompostApi$updateKompo = F2(
	function (komposition, apiToken) {
		return $elm$http$Http$request(
			{
				body: A2(
					$elm$http$Http$stringBody,
					'application/json',
					$author$project$Models$JsonCoding$kompositionEncoder(komposition)),
				expect: A2(
					$elm$http$Http$expectJson,
					A2($elm$core$Basics$composeR, $krisajenkins$remotedata$RemoteData$fromResult, $author$project$Models$Msg$CouchServerStatus),
					$author$project$Models$JsonCoding$couchServerStatusDecoder),
				headers: _List_fromArray(
					[
						A2($elm$http$Http$header, 'Authy', apiToken),
						A2($elm$http$Http$header, 'x-amz-version-id', komposition.revision)
					]),
				method: 'PUT',
				timeout: $elm$core$Maybe$Nothing,
				tracker: $elm$core$Maybe$Nothing,
				url: _Utils_ap($author$project$Models$KompostApi$kompoUrl, komposition.id)
			});
	});
var $author$project$Main$update = F2(
	function (msg, model) {
		var _v0 = A2($elm$core$Debug$log, 'Root.update', msg);
		switch (_v0.$) {
			case 'ListingsUpdated':
				switch (_v0.a.$) {
					case 'Success':
						var kompositionList = _v0.a.a;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{listings: kompositionList}),
							$elm$core$Platform$Cmd$none);
					case 'Failure':
						var err = _v0.a.a;
						var _v1 = A2($elm$core$Debug$log, 'Fetching komposition list failed marvellously', err);
						return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
					case 'NotAsked':
						var _v2 = _v0.a;
						return A2(
							$elm$core$Debug$log,
							'Initialising KompositionList',
							_Utils_Tuple2(model, $elm$core$Platform$Cmd$none));
					default:
						var _v3 = _v0.a;
						return A2(
							$elm$core$Debug$log,
							'Loading',
							_Utils_Tuple2(model, $elm$core$Platform$Cmd$none));
				}
			case 'NavigateTo':
				var page = _v0.a;
				var _v4 = A2($elm$core$Debug$log, 'NavigateTo', page);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{activePage: page}),
					A2($author$project$Navigation$AppRouting$replaceUrl, page, model.key));
			case 'FetchLocalIntegration':
				var integrationDestination = _v0.a;
				var empModel = A3($author$project$Main$emptyModel, model.key, model.url, model.apiToken);
				return _Utils_Tuple2(
					_Utils_update(
						empModel,
						{activePage: $author$project$Navigation$Page$KompostUI, listings: model.listings}),
					A2($author$project$Models$KompostApi$getFromURL, integrationDestination, model.apiToken));
			case 'NewKomposition':
				var empModel = A3($author$project$Main$emptyModel, model.key, model.url, model.apiToken);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{activePage: $author$project$Navigation$Page$DvlSpecificsUI, kompost: empModel.kompost}),
					A2($author$project$Navigation$AppRouting$replaceUrl, $author$project$Navigation$Page$DvlSpecificsUI, model.key));
			case 'ChangeKompositionType':
				var searchType = _v0.a;
				return _Utils_Tuple2(
					model,
					A2($author$project$Models$KompostApi$fetchKompositionList, searchType, model.apiToken));
			case 'ChangedIntegrationId':
				var integrationId = _v0.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{integrationDestination: integrationId}),
					$elm$core$Platform$Cmd$none);
			case 'ChangedIntegrationFormat':
				var formatId = _v0.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{integrationFormat: formatId}),
					$elm$core$Platform$Cmd$none);
			case 'KompositionUpdated':
				var webKomposition = _v0.a;
				return _Utils_Tuple2(
					function () {
						var _v5 = $krisajenkins$remotedata$RemoteData$toMaybe(webKomposition);
						if (_v5.$ === 'Just') {
							var kompost = _v5.a;
							return _Utils_update(
								model,
								{kompost: kompost});
						} else {
							return model;
						}
					}(),
					A2($author$project$Navigation$AppRouting$replaceUrl, $author$project$Navigation$Page$KompostUI, model.key));
			case 'SourceUpdated':
				var webKomposition = _v0.a;
				return _Utils_Tuple2(
					function () {
						var _v6 = $krisajenkins$remotedata$RemoteData$toMaybe(webKomposition);
						if (_v6.$ === 'Just') {
							var kompost = _v6.a;
							return _Utils_update(
								model,
								{
									subSegmentList: $elm$core$Set$fromList(
										A2(
											$elm$core$List$map,
											function (segment) {
												return segment.id;
											},
											kompost.segments))
								});
						} else {
							return model;
						}
					}(),
					A2($author$project$Navigation$AppRouting$replaceUrl, $author$project$Navigation$Page$KompostUI, model.key));
			case 'SegmentListUpdated':
				var webKomposition = _v0.a;
				var newModel = function () {
					var _v7 = $krisajenkins$remotedata$RemoteData$toMaybe(webKomposition);
					if (_v7.$ === 'Just') {
						var kompost = _v7.a;
						return _Utils_update(
							model,
							{kompost: kompost});
					} else {
						return model;
					}
				}();
				var segmentNames = A2(
					$elm$core$Debug$log,
					'SegmentListUpdated',
					A2(
						$elm$core$List$map,
						function (segment) {
							return segment.id;
						},
						newModel.kompost.segments));
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							subSegmentList: $elm$core$Set$fromList(segmentNames)
						}),
					$elm$core$Platform$Cmd$none);
			case 'StoreKomposition':
				var updateId = function () {
					var _v8 = model.kompost.id;
					if (_v8 === '') {
						return model.kompost.name + '.json';
					} else {
						return model.kompost.id;
					}
				}();
				var kompost = model.kompost;
				return _Utils_Tuple2(
					model,
					A2(
						$author$project$Models$KompostApi$updateKompo,
						_Utils_update(
							kompost,
							{id: updateId}),
						model.apiToken));
			case 'DeleteKomposition':
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{activePage: $author$project$Navigation$Page$ListingsUI}),
					A4($elm$core$Debug$log, 'Deleting komposition', $author$project$Models$KompostApi$deleteKompo, model.kompost, model.apiToken));
			case 'EditSpecifics':
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{activePage: $author$project$Navigation$Page$DvlSpecificsUI}),
					A2($author$project$Navigation$AppRouting$replaceUrl, $author$project$Navigation$Page$DvlSpecificsUI, model.key));
			case 'CreateSegment':
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{activePage: $author$project$Navigation$Page$SegmentUI, editableSegment: true, segment: $author$project$Main$emptySegment}),
					$elm$core$Platform$Cmd$none);
			case 'CouchServerStatus':
				var serverstatus = _v0.a;
				var _v9 = function () {
					var _v10 = $krisajenkins$remotedata$RemoteData$toMaybe(serverstatus);
					if (_v10.$ === 'Just') {
						var status = _v10.a;
						var kompost = model.kompost;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									kompost: _Utils_update(
										kompost,
										{revision: status.rev})
								}),
							$author$project$Navigation$Page$KompostUI);
					} else {
						return _Utils_Tuple2(model, $author$project$Navigation$Page$KompostUI);
					}
				}();
				var newModel = _v9.a;
				var page = _v9.b;
				return _Utils_Tuple2(
					newModel,
					A2($author$project$Navigation$AppRouting$replaceUrl, page, model.key));
			case 'SourceMsg':
				var theMsg = _v0.a;
				var _v11 = A2($author$project$Source$SourcesUI$update, theMsg, model);
				var newModel = _v11.a;
				var sourceMsg = _v11.b;
				var childMsg = _v11.c;
				var _v12 = $author$project$DvlSpecifics$DvlSpecificsModel$extractFromOutmessage(childMsg);
				if (_v12.$ === 'Just') {
					var page = _v12.a;
					return _Utils_Tuple2(
						_Utils_update(
							newModel,
							{activePage: page}),
						sourceMsg);
				} else {
					return _Utils_Tuple2(newModel, sourceMsg);
				}
			case 'DvlSpecificsMsg':
				var theMsg = _v0.a;
				var _v13 = A2($author$project$DvlSpecifics$DvlSpecificsModel$update, theMsg, model);
				var newModel = _v13.a;
				var childMsg = _v13.b;
				var _v14 = $author$project$DvlSpecifics$DvlSpecificsModel$extractFromOutmessage(childMsg);
				if (_v14.$ === 'Just') {
					var page = _v14.a;
					return _Utils_Tuple2(
						_Utils_update(
							newModel,
							{activePage: page}),
						$elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(newModel, $elm$core$Platform$Cmd$none);
				}
			case 'SegmentMsg':
				var theMsg = _v0.a;
				var _v15 = A2($author$project$Segment$Model$update, theMsg, model);
				if (_v15.c.$ === 'Just') {
					if (_v15.c.a.$ === 'OutNavigateTo') {
						var newModel = _v15.a;
						var page = _v15.c.a.a;
						return _Utils_Tuple2(
							_Utils_update(
								newModel,
								{activePage: page}),
							$elm$core$Platform$Cmd$none);
					} else {
						var newModel = _v15.a;
						var sourceId = _v15.c.a.a;
						return _Utils_Tuple2(
							newModel,
							A2($author$project$Models$KompostApi$fetchSource, sourceId, model.apiToken));
					}
				} else {
					var newModel = _v15.a;
					var command = _v15.b;
					var childMsg = _v15.c;
					var _v16 = A2($elm$core$Debug$log, 'Extracting outmessage failed', childMsg);
					return _Utils_Tuple2(newModel, command);
				}
			case 'CreateVideo':
				var _v17 = A2($elm$core$Debug$log, 'Creating video', model.kompost);
				return _Utils_Tuple2(
					model,
					A2($author$project$Models$KompostApi$createVideo, model.kompost, model.apiToken));
			case 'ShowKompositionJson':
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{activePage: $author$project$Navigation$Page$KompositionJsonUI}),
					A2($author$project$Navigation$AppRouting$replaceUrl, $author$project$Navigation$Page$KompositionJsonUI, model.key));
			case 'ETagResponse':
				if (_v0.a.$ === 'Ok') {
					var checksum = _v0.a.a;
					var source = model.editingMediaFile;
					var modifiedSource = _Utils_update(
						source,
						{checksum: checksum});
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{editingMediaFile: modifiedSource}),
						$elm$core$Platform$Cmd$none);
				} else {
					var err = _v0.a.a;
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			case 'ClickedLink':
				var urlRequest = _v0.a;
				if (urlRequest.$ === 'Internal') {
					var url = urlRequest.a;
					var _v19 = url.fragment;
					if (_v19.$ === 'Nothing') {
						return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
					} else {
						return A2(
							$elm$core$Debug$log,
							'BrowserInternal',
							_Utils_Tuple2(
								model,
								A2(
									$elm$browser$Browser$Navigation$pushUrl,
									model.key,
									$elm$url$Url$toString(url))));
					}
				} else {
					var href = urlRequest.a;
					return A2(
						$elm$core$Debug$log,
						'To BrowserExternal',
						_Utils_Tuple2(
							model,
							$elm$browser$Browser$Navigation$load(href)));
				}
			default:
				var url = _v0.a;
				var _v20 = A2($elm$core$Debug$log, 'ChangedUrl', url);
				return A2(
					$author$project$Main$changeRouteTo,
					$author$project$Navigation$AppRouting$fromUrl(url),
					model);
		}
	});
var $author$project$Models$Msg$DvlSpecificsMsg = function (a) {
	return {$: 'DvlSpecificsMsg', a: a};
};
var $author$project$Models$Msg$SegmentMsg = function (a) {
	return {$: 'SegmentMsg', a: a};
};
var $author$project$Models$Msg$SourceMsg = function (a) {
	return {$: 'SourceMsg', a: a};
};
var $elm$html$Html$div = _VirtualDom_node('div');
var $author$project$DvlSpecifics$Msg$InternalNavigateTo = function (a) {
	return {$: 'InternalNavigateTo', a: a};
};
var $author$project$DvlSpecifics$Msg$SetBpm = function (a) {
	return {$: 'SetBpm', a: a};
};
var $author$project$DvlSpecifics$Msg$SetDvlType = function (a) {
	return {$: 'SetDvlType', a: a};
};
var $author$project$DvlSpecifics$Msg$SetExtensionType = function (a) {
	return {$: 'SetExtensionType', a: a};
};
var $author$project$DvlSpecifics$Msg$SetFramerate = function (a) {
	return {$: 'SetFramerate', a: a};
};
var $author$project$DvlSpecifics$Msg$SetFromBpm = function (a) {
	return {$: 'SetFromBpm', a: a};
};
var $author$project$DvlSpecifics$Msg$SetHeight = function (a) {
	return {$: 'SetHeight', a: a};
};
var $author$project$DvlSpecifics$Msg$SetKompositionName = function (a) {
	return {$: 'SetKompositionName', a: a};
};
var $author$project$DvlSpecifics$Msg$SetMasterBpm = function (a) {
	return {$: 'SetMasterBpm', a: a};
};
var $author$project$DvlSpecifics$Msg$SetToBpm = function (a) {
	return {$: 'SetToBpm', a: a};
};
var $author$project$DvlSpecifics$Msg$SetWidth = function (a) {
	return {$: 'SetWidth', a: a};
};
var $elm$html$Html$button = _VirtualDom_node('button');
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$applyModifier = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'Size':
				var size = modifier.a;
				return _Utils_update(
					options,
					{
						size: $elm$core$Maybe$Just(size)
					});
			case 'Coloring':
				var coloring = modifier.a;
				return _Utils_update(
					options,
					{
						coloring: $elm$core$Maybe$Just(coloring)
					});
			case 'Block':
				return _Utils_update(
					options,
					{block: true});
			case 'Disabled':
				var val = modifier.a;
				return _Utils_update(
					options,
					{disabled: val});
			default:
				var attrs = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs)
					});
		}
	});
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $elm$html$Html$Attributes$classList = function (classes) {
	return $elm$html$Html$Attributes$class(
		A2(
			$elm$core$String$join,
			' ',
			A2(
				$elm$core$List$map,
				$elm$core$Tuple$first,
				A2($elm$core$List$filter, $elm$core$Tuple$second, classes))));
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$defaultOptions = {attributes: _List_Nil, block: false, coloring: $elm$core$Maybe$Nothing, disabled: false, size: $elm$core$Maybe$Nothing};
var $elm$json$Json$Encode$bool = _Json_wrap;
var $elm$html$Html$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$bool(bool));
	});
var $elm$html$Html$Attributes$disabled = $elm$html$Html$Attributes$boolProperty('disabled');
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$roleClass = function (role) {
	switch (role.$) {
		case 'Primary':
			return 'primary';
		case 'Secondary':
			return 'secondary';
		case 'Success':
			return 'success';
		case 'Info':
			return 'info';
		case 'Warning':
			return 'warning';
		case 'Danger':
			return 'danger';
		case 'Dark':
			return 'dark';
		case 'Light':
			return 'light';
		default:
			return 'link';
	}
};
var $rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption = function (size) {
	switch (size.$) {
		case 'XS':
			return $elm$core$Maybe$Nothing;
		case 'SM':
			return $elm$core$Maybe$Just('sm');
		case 'MD':
			return $elm$core$Maybe$Just('md');
		case 'LG':
			return $elm$core$Maybe$Just('lg');
		default:
			return $elm$core$Maybe$Just('xl');
	}
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$buttonAttributes = function (modifiers) {
	var options = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$Internal$Button$applyModifier, $rundis$elm_bootstrap$Bootstrap$Internal$Button$defaultOptions, modifiers);
	return _Utils_ap(
		_List_fromArray(
			[
				$elm$html$Html$Attributes$classList(
				_List_fromArray(
					[
						_Utils_Tuple2('btn', true),
						_Utils_Tuple2('btn-block', options.block),
						_Utils_Tuple2('disabled', options.disabled)
					])),
				$elm$html$Html$Attributes$disabled(options.disabled)
			]),
		_Utils_ap(
			function () {
				var _v0 = A2($elm$core$Maybe$andThen, $rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption, options.size);
				if (_v0.$ === 'Just') {
					var s = _v0.a;
					return _List_fromArray(
						[
							$elm$html$Html$Attributes$class('btn-' + s)
						]);
				} else {
					return _List_Nil;
				}
			}(),
			_Utils_ap(
				function () {
					var _v1 = options.coloring;
					if (_v1.$ === 'Just') {
						if (_v1.a.$ === 'Roled') {
							var role = _v1.a.a;
							return _List_fromArray(
								[
									$elm$html$Html$Attributes$class(
									'btn-' + $rundis$elm_bootstrap$Bootstrap$Internal$Button$roleClass(role))
								]);
						} else {
							var role = _v1.a.a;
							return _List_fromArray(
								[
									$elm$html$Html$Attributes$class(
									'btn-outline-' + $rundis$elm_bootstrap$Bootstrap$Internal$Button$roleClass(role))
								]);
						}
					} else {
						return _List_Nil;
					}
				}(),
				options.attributes)));
};
var $rundis$elm_bootstrap$Bootstrap$Button$button = F2(
	function (options, children) {
		return A2(
			$elm$html$Html$button,
			$rundis$elm_bootstrap$Bootstrap$Internal$Button$buttonAttributes(options),
			children);
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Disabled = function (a) {
	return {$: 'Disabled', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$disabled = function (disabled_) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Input$Disabled(disabled_);
};
var $author$project$Common$StaticVariables$extensionTypes = _List_fromArray(
	['mp3', 'mp4', 'aac', 'webm', 'flac', 'dvl.json', 'kompo.json', 'htmlImagelist', 'jpg', 'png']);
var $elm$html$Html$form = _VirtualDom_node('form');
var $rundis$elm_bootstrap$Bootstrap$Form$form = F2(
	function (attributes, children) {
		return A2($elm$html$Html$form, attributes, children);
	});
var $elm$core$String$fromFloat = _String_fromNumber;
var $elm$html$Html$h1 = _VirtualDom_node('h1');
var $elm$html$Html$h3 = _VirtualDom_node('h3');
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Id = function (a) {
	return {$: 'Id', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$id = function (id_) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Input$Id(id_);
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$Id = function (a) {
	return {$: 'Id', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$id = function (id_) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Select$Id(id_);
};
var $author$project$Common$StaticVariables$videoTag = 'Video';
var $author$project$Common$StaticVariables$komposionTypes = _List_fromArray(
	[$author$project$Common$StaticVariables$audioTag, $author$project$Common$StaticVariables$videoTag, $author$project$Common$StaticVariables$kompositionTag]);
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Number = {$: 'Number'};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Input = function (a) {
	return {$: 'Input', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Type = function (a) {
	return {$: 'Type', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$create = F2(
	function (tipe, options) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Input$Input(
			{
				options: A2(
					$elm$core$List$cons,
					$rundis$elm_bootstrap$Bootstrap$Form$Input$Type(tipe),
					options)
			});
	});
var $elm$html$Html$input = _VirtualDom_node('input');
var $rundis$elm_bootstrap$Bootstrap$Form$Input$applyModifier = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'Size':
				var size_ = modifier.a;
				return _Utils_update(
					options,
					{
						size: $elm$core$Maybe$Just(size_)
					});
			case 'Id':
				var id_ = modifier.a;
				return _Utils_update(
					options,
					{
						id: $elm$core$Maybe$Just(id_)
					});
			case 'Type':
				var tipe = modifier.a;
				return _Utils_update(
					options,
					{tipe: tipe});
			case 'Disabled':
				var val = modifier.a;
				return _Utils_update(
					options,
					{disabled: val});
			case 'Value':
				var value_ = modifier.a;
				return _Utils_update(
					options,
					{
						value: $elm$core$Maybe$Just(value_)
					});
			case 'Placeholder':
				var value_ = modifier.a;
				return _Utils_update(
					options,
					{
						placeholder: $elm$core$Maybe$Just(value_)
					});
			case 'OnInput':
				var onInput_ = modifier.a;
				return _Utils_update(
					options,
					{
						onInput: $elm$core$Maybe$Just(onInput_)
					});
			case 'Validation':
				var validation_ = modifier.a;
				return _Utils_update(
					options,
					{
						validation: $elm$core$Maybe$Just(validation_)
					});
			case 'Readonly':
				var val = modifier.a;
				return _Utils_update(
					options,
					{readonly: val});
			case 'PlainText':
				var val = modifier.a;
				return _Utils_update(
					options,
					{plainText: val});
			default:
				var attrs_ = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Text = {$: 'Text'};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$defaultOptions = {attributes: _List_Nil, disabled: false, id: $elm$core$Maybe$Nothing, onInput: $elm$core$Maybe$Nothing, placeholder: $elm$core$Maybe$Nothing, plainText: false, readonly: false, size: $elm$core$Maybe$Nothing, tipe: $rundis$elm_bootstrap$Bootstrap$Form$Input$Text, validation: $elm$core$Maybe$Nothing, value: $elm$core$Maybe$Nothing};
var $elm$html$Html$Attributes$id = $elm$html$Html$Attributes$stringProperty('id');
var $elm$html$Html$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var $elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 'MayStopPropagation', a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var $elm$html$Html$Events$targetValue = A2(
	$elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	$elm$json$Json$Decode$string);
var $elm$html$Html$Events$onInput = function (tagger) {
	return A2(
		$elm$html$Html$Events$stopPropagationOn,
		'input',
		A2(
			$elm$json$Json$Decode$map,
			$elm$html$Html$Events$alwaysStop,
			A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetValue)));
};
var $elm$html$Html$Attributes$placeholder = $elm$html$Html$Attributes$stringProperty('placeholder');
var $elm$html$Html$Attributes$readonly = $elm$html$Html$Attributes$boolProperty('readOnly');
var $rundis$elm_bootstrap$Bootstrap$Form$Input$sizeAttribute = function (size) {
	return A2(
		$elm$core$Maybe$map,
		function (s) {
			return $elm$html$Html$Attributes$class('form-control-' + s);
		},
		$rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(size));
};
var $elm$html$Html$Attributes$type_ = $elm$html$Html$Attributes$stringProperty('type');
var $rundis$elm_bootstrap$Bootstrap$Form$Input$typeAttribute = function (inputType) {
	return $elm$html$Html$Attributes$type_(
		function () {
			switch (inputType.$) {
				case 'Text':
					return 'text';
				case 'Password':
					return 'password';
				case 'DatetimeLocal':
					return 'datetime-local';
				case 'Date':
					return 'date';
				case 'Month':
					return 'month';
				case 'Time':
					return 'time';
				case 'Week':
					return 'week';
				case 'Number':
					return 'number';
				case 'Email':
					return 'email';
				case 'Url':
					return 'url';
				case 'Search':
					return 'search';
				case 'Tel':
					return 'tel';
				default:
					return 'color';
			}
		}());
};
var $rundis$elm_bootstrap$Bootstrap$Form$FormInternal$validationToString = function (validation) {
	if (validation.$ === 'Success') {
		return 'is-valid';
	} else {
		return 'is-invalid';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$validationAttribute = function (validation) {
	return $elm$html$Html$Attributes$class(
		$rundis$elm_bootstrap$Bootstrap$Form$FormInternal$validationToString(validation));
};
var $elm$html$Html$Attributes$value = $elm$html$Html$Attributes$stringProperty('value');
var $rundis$elm_bootstrap$Bootstrap$Form$Input$toAttributes = function (modifiers) {
	var options = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$Form$Input$applyModifier, $rundis$elm_bootstrap$Bootstrap$Form$Input$defaultOptions, modifiers);
	return _Utils_ap(
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				options.plainText ? 'form-control-plaintext' : 'form-control'),
				$elm$html$Html$Attributes$disabled(options.disabled),
				$elm$html$Html$Attributes$readonly(options.readonly || options.plainText),
				$rundis$elm_bootstrap$Bootstrap$Form$Input$typeAttribute(options.tipe)
			]),
		_Utils_ap(
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						A2($elm$core$Maybe$map, $elm$html$Html$Attributes$id, options.id),
						A2($elm$core$Maybe$andThen, $rundis$elm_bootstrap$Bootstrap$Form$Input$sizeAttribute, options.size),
						A2($elm$core$Maybe$map, $elm$html$Html$Attributes$value, options.value),
						A2($elm$core$Maybe$map, $elm$html$Html$Attributes$placeholder, options.placeholder),
						A2($elm$core$Maybe$map, $elm$html$Html$Events$onInput, options.onInput),
						A2($elm$core$Maybe$map, $rundis$elm_bootstrap$Bootstrap$Form$Input$validationAttribute, options.validation)
					])),
			options.attributes));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$view = function (_v0) {
	var options = _v0.a.options;
	return A2(
		$elm$html$Html$input,
		$rundis$elm_bootstrap$Bootstrap$Form$Input$toAttributes(options),
		_List_Nil);
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$input = F2(
	function (tipe, options) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Input$view(
			A2($rundis$elm_bootstrap$Bootstrap$Form$Input$create, tipe, options));
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Input$number = $rundis$elm_bootstrap$Bootstrap$Form$Input$input($rundis$elm_bootstrap$Bootstrap$Form$Input$Number);
var $rundis$elm_bootstrap$Bootstrap$Form$Select$OnChange = function (a) {
	return {$: 'OnChange', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$onChange = function (toMsg) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Select$OnChange(toMsg);
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Attrs = function (a) {
	return {$: 'Attrs', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Button$attrs = function (attrs_) {
	return $rundis$elm_bootstrap$Bootstrap$Internal$Button$Attrs(attrs_);
};
var $elm$virtual_dom$VirtualDom$MayPreventDefault = function (a) {
	return {$: 'MayPreventDefault', a: a};
};
var $elm$html$Html$Events$preventDefaultOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayPreventDefault(decoder));
	});
var $rundis$elm_bootstrap$Bootstrap$Button$onClick = function (message) {
	return $rundis$elm_bootstrap$Bootstrap$Button$attrs(
		_List_fromArray(
			[
				A2(
				$elm$html$Html$Events$preventDefaultOn,
				'click',
				$elm$json$Json$Decode$succeed(
					_Utils_Tuple2(message, true)))
			]));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$OnInput = function (a) {
	return {$: 'OnInput', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$onInput = function (toMsg) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Input$OnInput(toMsg);
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Coloring = function (a) {
	return {$: 'Coloring', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Primary = {$: 'Primary'};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Roled = function (a) {
	return {$: 'Roled', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Button$primary = $rundis$elm_bootstrap$Bootstrap$Internal$Button$Coloring(
	$rundis$elm_bootstrap$Bootstrap$Internal$Button$Roled($rundis$elm_bootstrap$Bootstrap$Internal$Button$Primary));
var $rundis$elm_bootstrap$Bootstrap$Form$Select$Select = function (a) {
	return {$: 'Select', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$create = F2(
	function (options, items) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Select$Select(
			{items: items, options: options});
	});
var $elm$html$Html$select = _VirtualDom_node('select');
var $rundis$elm_bootstrap$Bootstrap$Form$Select$applyModifier = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'Size':
				var size_ = modifier.a;
				return _Utils_update(
					options,
					{
						size: $elm$core$Maybe$Just(size_)
					});
			case 'Id':
				var id_ = modifier.a;
				return _Utils_update(
					options,
					{
						id: $elm$core$Maybe$Just(id_)
					});
			case 'Custom':
				return _Utils_update(
					options,
					{custom: true});
			case 'Disabled':
				var val = modifier.a;
				return _Utils_update(
					options,
					{disabled: val});
			case 'OnChange':
				var onChange_ = modifier.a;
				return _Utils_update(
					options,
					{
						onChange: $elm$core$Maybe$Just(onChange_)
					});
			case 'Validation':
				var validation_ = modifier.a;
				return _Utils_update(
					options,
					{
						validation: $elm$core$Maybe$Just(validation_)
					});
			default:
				var attrs_ = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs_)
					});
		}
	});
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Select$customEventOnChange = function (tagger) {
	return A2(
		$elm$html$Html$Events$on,
		'change',
		A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetValue));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$defaultOptions = {attributes: _List_Nil, custom: false, disabled: false, id: $elm$core$Maybe$Nothing, onChange: $elm$core$Maybe$Nothing, size: $elm$core$Maybe$Nothing, validation: $elm$core$Maybe$Nothing};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$sizeAttribute = F2(
	function (isCustom, size_) {
		var prefix = isCustom ? 'custom-select-' : 'form-control-';
		return A2(
			$elm$core$Maybe$map,
			function (s) {
				return $elm$html$Html$Attributes$class(
					_Utils_ap(prefix, s));
			},
			$rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(size_));
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Select$validationAttribute = function (validation_) {
	return $elm$html$Html$Attributes$class(
		$rundis$elm_bootstrap$Bootstrap$Form$FormInternal$validationToString(validation_));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$toAttributes = function (modifiers) {
	var options = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$Form$Select$applyModifier, $rundis$elm_bootstrap$Bootstrap$Form$Select$defaultOptions, modifiers);
	return _Utils_ap(
		_List_fromArray(
			[
				$elm$html$Html$Attributes$classList(
				_List_fromArray(
					[
						_Utils_Tuple2('form-control', !options.custom),
						_Utils_Tuple2('custom-select', options.custom)
					])),
				$elm$html$Html$Attributes$disabled(options.disabled)
			]),
		_Utils_ap(
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						A2($elm$core$Maybe$map, $elm$html$Html$Attributes$id, options.id),
						A2(
						$elm$core$Maybe$andThen,
						$rundis$elm_bootstrap$Bootstrap$Form$Select$sizeAttribute(options.custom),
						options.size),
						A2($elm$core$Maybe$map, $rundis$elm_bootstrap$Bootstrap$Form$Select$customEventOnChange, options.onChange),
						A2($elm$core$Maybe$map, $rundis$elm_bootstrap$Bootstrap$Form$Select$validationAttribute, options.validation)
					])),
			options.attributes));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$view = function (_v0) {
	var options = _v0.a.options;
	var items = _v0.a.items;
	return A2(
		$elm$html$Html$select,
		$rundis$elm_bootstrap$Bootstrap$Form$Select$toAttributes(options),
		A2(
			$elm$core$List$map,
			function (_v1) {
				var e = _v1.a;
				return e;
			},
			items));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Select$select = F2(
	function (options, items) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Select$view(
			A2($rundis$elm_bootstrap$Bootstrap$Form$Select$create, options, items));
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Select$Item = function (a) {
	return {$: 'Item', a: a};
};
var $elm$html$Html$option = _VirtualDom_node('option');
var $rundis$elm_bootstrap$Bootstrap$Form$Select$item = F2(
	function (attributes, children) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Select$Item(
			A2($elm$html$Html$option, attributes, children));
	});
var $elm$html$Html$Attributes$selected = $elm$html$Html$Attributes$boolProperty('selected');
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $author$project$Common$UIFunctions$selectItems = F2(
	function (chosen, itemList) {
		return A2(
			$elm$core$List$map,
			function (idz) {
				return A2(
					$rundis$elm_bootstrap$Bootstrap$Form$Select$item,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$value(idz),
							$elm$html$Html$Attributes$selected(
							_Utils_eq(chosen, idz))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(idz)
						]));
			},
			itemList);
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Input$text = $rundis$elm_bootstrap$Bootstrap$Form$Input$input($rundis$elm_bootstrap$Bootstrap$Form$Input$Text);
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Value = function (a) {
	return {$: 'Value', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$value = function (value_) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Input$Value(value_);
};
var $rundis$elm_bootstrap$Bootstrap$Form$Col = function (a) {
	return {$: 'Col', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$col = F2(
	function (options, children) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Col(
			{children: children, elemFn: $elm$html$Html$div, options: options});
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$ColAttrs = function (a) {
	return {$: 'ColAttrs', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Col$attrs = function (attrs_) {
	return $rundis$elm_bootstrap$Bootstrap$Grid$Internal$ColAttrs(attrs_);
};
var $elm$html$Html$label = _VirtualDom_node('label');
var $rundis$elm_bootstrap$Bootstrap$Form$colLabel = F2(
	function (options, children) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Col(
			{
				children: children,
				elemFn: $elm$html$Html$label,
				options: A2(
					$elm$core$List$cons,
					$rundis$elm_bootstrap$Bootstrap$Grid$Col$attrs(
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('col-form-label')
							])),
					options)
			});
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col = {$: 'Col'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Width = F2(
	function (screenSize, columnCount) {
		return {columnCount: columnCount, screenSize: screenSize};
	});
var $rundis$elm_bootstrap$Bootstrap$General$Internal$XS = {$: 'XS'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColAlign = F2(
	function (align_, options) {
		var _v0 = align_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						alignXs: $elm$core$Maybe$Just(align_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						alignSm: $elm$core$Maybe$Just(align_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						alignMd: $elm$core$Maybe$Just(align_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						alignLg: $elm$core$Maybe$Just(align_)
					});
			default:
				return _Utils_update(
					options,
					{
						alignXl: $elm$core$Maybe$Just(align_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColOffset = F2(
	function (offset_, options) {
		var _v0 = offset_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						offsetXs: $elm$core$Maybe$Just(offset_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						offsetSm: $elm$core$Maybe$Just(offset_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						offsetMd: $elm$core$Maybe$Just(offset_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						offsetLg: $elm$core$Maybe$Just(offset_)
					});
			default:
				return _Utils_update(
					options,
					{
						offsetXl: $elm$core$Maybe$Just(offset_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColOrder = F2(
	function (order_, options) {
		var _v0 = order_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						orderXs: $elm$core$Maybe$Just(order_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						orderSm: $elm$core$Maybe$Just(order_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						orderMd: $elm$core$Maybe$Just(order_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						orderLg: $elm$core$Maybe$Just(order_)
					});
			default:
				return _Utils_update(
					options,
					{
						orderXl: $elm$core$Maybe$Just(order_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColPull = F2(
	function (pull_, options) {
		var _v0 = pull_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						pullXs: $elm$core$Maybe$Just(pull_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						pullSm: $elm$core$Maybe$Just(pull_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						pullMd: $elm$core$Maybe$Just(pull_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						pullLg: $elm$core$Maybe$Just(pull_)
					});
			default:
				return _Utils_update(
					options,
					{
						pullXl: $elm$core$Maybe$Just(pull_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColPush = F2(
	function (push_, options) {
		var _v0 = push_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						pushXs: $elm$core$Maybe$Just(push_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						pushSm: $elm$core$Maybe$Just(push_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						pushMd: $elm$core$Maybe$Just(push_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						pushLg: $elm$core$Maybe$Just(push_)
					});
			default:
				return _Utils_update(
					options,
					{
						pushXl: $elm$core$Maybe$Just(push_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColWidth = F2(
	function (width_, options) {
		var _v0 = width_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						widthXs: $elm$core$Maybe$Just(width_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						widthSm: $elm$core$Maybe$Just(width_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						widthMd: $elm$core$Maybe$Just(width_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						widthLg: $elm$core$Maybe$Just(width_)
					});
			default:
				return _Utils_update(
					options,
					{
						widthXl: $elm$core$Maybe$Just(width_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColOption = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'ColAttrs':
				var attrs = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs)
					});
			case 'ColWidth':
				var width_ = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColWidth, width_, options);
			case 'ColOffset':
				var offset_ = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColOffset, offset_, options);
			case 'ColPull':
				var pull_ = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColPull, pull_, options);
			case 'ColPush':
				var push_ = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColPush, push_, options);
			case 'ColOrder':
				var order_ = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColOrder, order_, options);
			case 'ColAlign':
				var align = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColAlign, align, options);
			default:
				var align = modifier.a;
				return _Utils_update(
					options,
					{
						textAlign: $elm$core$Maybe$Just(align)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$columnCountOption = function (size) {
	switch (size.$) {
		case 'Col':
			return $elm$core$Maybe$Nothing;
		case 'Col1':
			return $elm$core$Maybe$Just('1');
		case 'Col2':
			return $elm$core$Maybe$Just('2');
		case 'Col3':
			return $elm$core$Maybe$Just('3');
		case 'Col4':
			return $elm$core$Maybe$Just('4');
		case 'Col5':
			return $elm$core$Maybe$Just('5');
		case 'Col6':
			return $elm$core$Maybe$Just('6');
		case 'Col7':
			return $elm$core$Maybe$Just('7');
		case 'Col8':
			return $elm$core$Maybe$Just('8');
		case 'Col9':
			return $elm$core$Maybe$Just('9');
		case 'Col10':
			return $elm$core$Maybe$Just('10');
		case 'Col11':
			return $elm$core$Maybe$Just('11');
		case 'Col12':
			return $elm$core$Maybe$Just('12');
		default:
			return $elm$core$Maybe$Just('auto');
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$colWidthClass = function (_v0) {
	var screenSize = _v0.screenSize;
	var columnCount = _v0.columnCount;
	return $elm$html$Html$Attributes$class(
		'col' + (A2(
			$elm$core$Maybe$withDefault,
			'',
			A2(
				$elm$core$Maybe$map,
				function (v) {
					return '-' + v;
				},
				$rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(screenSize))) + A2(
			$elm$core$Maybe$withDefault,
			'',
			A2(
				$elm$core$Maybe$map,
				function (v) {
					return '-' + v;
				},
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$columnCountOption(columnCount)))));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$colWidthsToAttributes = function (widths) {
	var width_ = function (w) {
		return A2($elm$core$Maybe$map, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$colWidthClass, w);
	};
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		A2($elm$core$List$map, width_, widths));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$defaultColOptions = {alignLg: $elm$core$Maybe$Nothing, alignMd: $elm$core$Maybe$Nothing, alignSm: $elm$core$Maybe$Nothing, alignXl: $elm$core$Maybe$Nothing, alignXs: $elm$core$Maybe$Nothing, attributes: _List_Nil, offsetLg: $elm$core$Maybe$Nothing, offsetMd: $elm$core$Maybe$Nothing, offsetSm: $elm$core$Maybe$Nothing, offsetXl: $elm$core$Maybe$Nothing, offsetXs: $elm$core$Maybe$Nothing, orderLg: $elm$core$Maybe$Nothing, orderMd: $elm$core$Maybe$Nothing, orderSm: $elm$core$Maybe$Nothing, orderXl: $elm$core$Maybe$Nothing, orderXs: $elm$core$Maybe$Nothing, pullLg: $elm$core$Maybe$Nothing, pullMd: $elm$core$Maybe$Nothing, pullSm: $elm$core$Maybe$Nothing, pullXl: $elm$core$Maybe$Nothing, pullXs: $elm$core$Maybe$Nothing, pushLg: $elm$core$Maybe$Nothing, pushMd: $elm$core$Maybe$Nothing, pushSm: $elm$core$Maybe$Nothing, pushXl: $elm$core$Maybe$Nothing, pushXs: $elm$core$Maybe$Nothing, textAlign: $elm$core$Maybe$Nothing, widthLg: $elm$core$Maybe$Nothing, widthMd: $elm$core$Maybe$Nothing, widthSm: $elm$core$Maybe$Nothing, widthXl: $elm$core$Maybe$Nothing, widthXs: $elm$core$Maybe$Nothing};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$offsetCountOption = function (size) {
	switch (size.$) {
		case 'Offset0':
			return '0';
		case 'Offset1':
			return '1';
		case 'Offset2':
			return '2';
		case 'Offset3':
			return '3';
		case 'Offset4':
			return '4';
		case 'Offset5':
			return '5';
		case 'Offset6':
			return '6';
		case 'Offset7':
			return '7';
		case 'Offset8':
			return '8';
		case 'Offset9':
			return '9';
		case 'Offset10':
			return '10';
		default:
			return '11';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$screenSizeToPartialString = function (screenSize) {
	var _v0 = $rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(screenSize);
	if (_v0.$ === 'Just') {
		var s = _v0.a;
		return '-' + (s + '-');
	} else {
		return '-';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$offsetClass = function (_v0) {
	var screenSize = _v0.screenSize;
	var offsetCount = _v0.offsetCount;
	return $elm$html$Html$Attributes$class(
		'offset' + ($rundis$elm_bootstrap$Bootstrap$Grid$Internal$screenSizeToPartialString(screenSize) + $rundis$elm_bootstrap$Bootstrap$Grid$Internal$offsetCountOption(offsetCount)));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$offsetsToAttributes = function (offsets) {
	var offset_ = function (m) {
		return A2($elm$core$Maybe$map, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$offsetClass, m);
	};
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		A2($elm$core$List$map, offset_, offsets));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$orderColOption = function (size) {
	switch (size.$) {
		case 'OrderFirst':
			return 'first';
		case 'Order1':
			return '1';
		case 'Order2':
			return '2';
		case 'Order3':
			return '3';
		case 'Order4':
			return '4';
		case 'Order5':
			return '5';
		case 'Order6':
			return '6';
		case 'Order7':
			return '7';
		case 'Order8':
			return '8';
		case 'Order9':
			return '9';
		case 'Order10':
			return '10';
		case 'Order11':
			return '11';
		case 'Order12':
			return '12';
		default:
			return 'last';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$orderToAttributes = function (orders) {
	var order_ = function (m) {
		if (m.$ === 'Just') {
			var screenSize = m.a.screenSize;
			var moveCount = m.a.moveCount;
			return $elm$core$Maybe$Just(
				$elm$html$Html$Attributes$class(
					'order' + ($rundis$elm_bootstrap$Bootstrap$Grid$Internal$screenSizeToPartialString(screenSize) + $rundis$elm_bootstrap$Bootstrap$Grid$Internal$orderColOption(moveCount))));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	};
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		A2($elm$core$List$map, order_, orders));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$moveCountOption = function (size) {
	switch (size.$) {
		case 'Move0':
			return '0';
		case 'Move1':
			return '1';
		case 'Move2':
			return '2';
		case 'Move3':
			return '3';
		case 'Move4':
			return '4';
		case 'Move5':
			return '5';
		case 'Move6':
			return '6';
		case 'Move7':
			return '7';
		case 'Move8':
			return '8';
		case 'Move9':
			return '9';
		case 'Move10':
			return '10';
		case 'Move11':
			return '11';
		default:
			return '12';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$pullsToAttributes = function (pulls) {
	var pull_ = function (m) {
		if (m.$ === 'Just') {
			var screenSize = m.a.screenSize;
			var moveCount = m.a.moveCount;
			return $elm$core$Maybe$Just(
				$elm$html$Html$Attributes$class(
					'pull' + ($rundis$elm_bootstrap$Bootstrap$Grid$Internal$screenSizeToPartialString(screenSize) + $rundis$elm_bootstrap$Bootstrap$Grid$Internal$moveCountOption(moveCount))));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	};
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		A2($elm$core$List$map, pull_, pulls));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$pushesToAttributes = function (pushes) {
	var push_ = function (m) {
		if (m.$ === 'Just') {
			var screenSize = m.a.screenSize;
			var moveCount = m.a.moveCount;
			return $elm$core$Maybe$Just(
				$elm$html$Html$Attributes$class(
					'push' + ($rundis$elm_bootstrap$Bootstrap$Grid$Internal$screenSizeToPartialString(screenSize) + $rundis$elm_bootstrap$Bootstrap$Grid$Internal$moveCountOption(moveCount))));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	};
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		A2($elm$core$List$map, push_, pushes));
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Text$textAlignDirOption = function (dir) {
	switch (dir.$) {
		case 'Center':
			return 'center';
		case 'Left':
			return 'left';
		default:
			return 'right';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Text$textAlignClass = function (_v0) {
	var dir = _v0.dir;
	var size = _v0.size;
	return $elm$html$Html$Attributes$class(
		'text' + (A2(
			$elm$core$Maybe$withDefault,
			'-',
			A2(
				$elm$core$Maybe$map,
				function (s) {
					return '-' + (s + '-');
				},
				$rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(size))) + $rundis$elm_bootstrap$Bootstrap$Internal$Text$textAlignDirOption(dir)));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$verticalAlignOption = function (align) {
	switch (align.$) {
		case 'Top':
			return 'start';
		case 'Middle':
			return 'center';
		default:
			return 'end';
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$vAlignClass = F2(
	function (prefix, _v0) {
		var align = _v0.align;
		var screenSize = _v0.screenSize;
		return $elm$html$Html$Attributes$class(
			_Utils_ap(
				prefix,
				_Utils_ap(
					A2(
						$elm$core$Maybe$withDefault,
						'',
						A2(
							$elm$core$Maybe$map,
							function (v) {
								return v + '-';
							},
							$rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(screenSize))),
					$rundis$elm_bootstrap$Bootstrap$Grid$Internal$verticalAlignOption(align))));
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$vAlignsToAttributes = F2(
	function (prefix, aligns) {
		var align = function (a) {
			return A2(
				$elm$core$Maybe$map,
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$vAlignClass(prefix),
				a);
		};
		return A2(
			$elm$core$List$filterMap,
			$elm$core$Basics$identity,
			A2($elm$core$List$map, align, aligns));
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$colAttributes = function (modifiers) {
	var options = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyColOption, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$defaultColOptions, modifiers);
	var shouldAddDefaultXs = !$elm$core$List$length(
		A2(
			$elm$core$List$filterMap,
			$elm$core$Basics$identity,
			_List_fromArray(
				[options.widthXs, options.widthSm, options.widthMd, options.widthLg, options.widthXl])));
	return _Utils_ap(
		$rundis$elm_bootstrap$Bootstrap$Grid$Internal$colWidthsToAttributes(
			_List_fromArray(
				[
					shouldAddDefaultXs ? $elm$core$Maybe$Just(
					A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$Width, $rundis$elm_bootstrap$Bootstrap$General$Internal$XS, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col)) : options.widthXs,
					options.widthSm,
					options.widthMd,
					options.widthLg,
					options.widthXl
				])),
		_Utils_ap(
			$rundis$elm_bootstrap$Bootstrap$Grid$Internal$offsetsToAttributes(
				_List_fromArray(
					[options.offsetXs, options.offsetSm, options.offsetMd, options.offsetLg, options.offsetXl])),
			_Utils_ap(
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$pullsToAttributes(
					_List_fromArray(
						[options.pullXs, options.pullSm, options.pullMd, options.pullLg, options.pullXl])),
				_Utils_ap(
					$rundis$elm_bootstrap$Bootstrap$Grid$Internal$pushesToAttributes(
						_List_fromArray(
							[options.pushXs, options.pushSm, options.pushMd, options.pushLg, options.pushXl])),
					_Utils_ap(
						$rundis$elm_bootstrap$Bootstrap$Grid$Internal$orderToAttributes(
							_List_fromArray(
								[options.orderXs, options.orderSm, options.orderMd, options.orderLg, options.orderXl])),
						_Utils_ap(
							A2(
								$rundis$elm_bootstrap$Bootstrap$Grid$Internal$vAlignsToAttributes,
								'align-self-',
								_List_fromArray(
									[options.alignXs, options.alignSm, options.alignMd, options.alignLg, options.alignXl])),
							_Utils_ap(
								function () {
									var _v0 = options.textAlign;
									if (_v0.$ === 'Just') {
										var a = _v0.a;
										return _List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Internal$Text$textAlignClass(a)
											]);
									} else {
										return _List_Nil;
									}
								}(),
								options.attributes)))))));
};
var $rundis$elm_bootstrap$Bootstrap$Form$renderCol = function (_v0) {
	var elemFn = _v0.a.elemFn;
	var options = _v0.a.options;
	var children = _v0.a.children;
	return A2(
		elemFn,
		$rundis$elm_bootstrap$Bootstrap$Grid$Internal$colAttributes(options),
		children);
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyRowHAlign = F2(
	function (align, options) {
		var _v0 = align.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						hAlignXs: $elm$core$Maybe$Just(align)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						hAlignSm: $elm$core$Maybe$Just(align)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						hAlignMd: $elm$core$Maybe$Just(align)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						hAlignLg: $elm$core$Maybe$Just(align)
					});
			default:
				return _Utils_update(
					options,
					{
						hAlignXl: $elm$core$Maybe$Just(align)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyRowVAlign = F2(
	function (align_, options) {
		var _v0 = align_.screenSize;
		switch (_v0.$) {
			case 'XS':
				return _Utils_update(
					options,
					{
						vAlignXs: $elm$core$Maybe$Just(align_)
					});
			case 'SM':
				return _Utils_update(
					options,
					{
						vAlignSm: $elm$core$Maybe$Just(align_)
					});
			case 'MD':
				return _Utils_update(
					options,
					{
						vAlignMd: $elm$core$Maybe$Just(align_)
					});
			case 'LG':
				return _Utils_update(
					options,
					{
						vAlignLg: $elm$core$Maybe$Just(align_)
					});
			default:
				return _Utils_update(
					options,
					{
						vAlignXl: $elm$core$Maybe$Just(align_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyRowOption = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'RowAttrs':
				var attrs = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs)
					});
			case 'RowVAlign':
				var align = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyRowVAlign, align, options);
			default:
				var align = modifier.a;
				return A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyRowHAlign, align, options);
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$defaultRowOptions = {attributes: _List_Nil, hAlignLg: $elm$core$Maybe$Nothing, hAlignMd: $elm$core$Maybe$Nothing, hAlignSm: $elm$core$Maybe$Nothing, hAlignXl: $elm$core$Maybe$Nothing, hAlignXs: $elm$core$Maybe$Nothing, vAlignLg: $elm$core$Maybe$Nothing, vAlignMd: $elm$core$Maybe$Nothing, vAlignSm: $elm$core$Maybe$Nothing, vAlignXl: $elm$core$Maybe$Nothing, vAlignXs: $elm$core$Maybe$Nothing};
var $rundis$elm_bootstrap$Bootstrap$General$Internal$horizontalAlignOption = function (align) {
	switch (align.$) {
		case 'Left':
			return 'start';
		case 'Center':
			return 'center';
		case 'Right':
			return 'end';
		case 'Around':
			return 'around';
		default:
			return 'between';
	}
};
var $rundis$elm_bootstrap$Bootstrap$General$Internal$hAlignClass = function (_v0) {
	var align = _v0.align;
	var screenSize = _v0.screenSize;
	return $elm$html$Html$Attributes$class(
		'justify-content-' + (A2(
			$elm$core$Maybe$withDefault,
			'',
			A2(
				$elm$core$Maybe$map,
				function (v) {
					return v + '-';
				},
				$rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption(screenSize))) + $rundis$elm_bootstrap$Bootstrap$General$Internal$horizontalAlignOption(align)));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$hAlignsToAttributes = function (aligns) {
	var align = function (a) {
		return A2($elm$core$Maybe$map, $rundis$elm_bootstrap$Bootstrap$General$Internal$hAlignClass, a);
	};
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		A2($elm$core$List$map, align, aligns));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$rowAttributes = function (modifiers) {
	var options = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$applyRowOption, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$defaultRowOptions, modifiers);
	return _Utils_ap(
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('row')
			]),
		_Utils_ap(
			A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$vAlignsToAttributes,
				'align-items-',
				_List_fromArray(
					[options.vAlignXs, options.vAlignSm, options.vAlignMd, options.vAlignLg, options.vAlignXl])),
			_Utils_ap(
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$hAlignsToAttributes(
					_List_fromArray(
						[options.hAlignXs, options.hAlignSm, options.hAlignMd, options.hAlignLg, options.hAlignXl])),
				options.attributes)));
};
var $rundis$elm_bootstrap$Bootstrap$Form$row = F2(
	function (options, cols) {
		return A2(
			$elm$html$Html$div,
			A2(
				$elm$core$List$cons,
				$elm$html$Html$Attributes$class('form-group'),
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$rowAttributes(options)),
			A2($elm$core$List$map, $rundis$elm_bootstrap$Bootstrap$Form$renderCol, cols));
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col4 = {$: 'Col4'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$ColWidth = function (a) {
	return {$: 'ColWidth', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$width = F2(
	function (size, count) {
		return $rundis$elm_bootstrap$Bootstrap$Grid$Internal$ColWidth(
			A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$Width, size, count));
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4 = A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$width, $rundis$elm_bootstrap$Bootstrap$General$Internal$XS, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col4);
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col8 = {$: 'Col8'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Col$xs8 = A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$width, $rundis$elm_bootstrap$Bootstrap$General$Internal$XS, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col8);
var $author$project$DvlSpecifics$DvlSpecificsUI$wrapping = F2(
	function (identifier, funk) {
		return A2(
			$rundis$elm_bootstrap$Bootstrap$Form$row,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$rundis$elm_bootstrap$Bootstrap$Form$colLabel,
					_List_fromArray(
						[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
					_List_fromArray(
						[
							$elm$html$Html$text(identifier)
						])),
					A2(
					$rundis$elm_bootstrap$Bootstrap$Form$col,
					_List_fromArray(
						[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs8]),
					_List_fromArray(
						[funk]))
				]));
	});
var $author$project$DvlSpecifics$DvlSpecificsUI$editSpecifics = function (kompo) {
	var specificsUI = A2(
		$rundis$elm_bootstrap$Bootstrap$Form$form,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('container')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Editing Specifics')
					])),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
				'Name',
				$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Input$id('Name'),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$value(kompo.name),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetKompositionName),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$disabled(false)
						]))),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
				'Id',
				$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Input$id('Id'),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$value(kompo.id),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$disabled(true)
						]))),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
				'Revision',
				$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Input$id('Revision'),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$value(kompo.revision),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$disabled(true)
						]))),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
				'BPM',
				$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Input$id('bpm'),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
							$elm$core$String$fromFloat(kompo.bpm)),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetBpm)
						]))),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
				'Type',
				A2(
					$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$DvlSpecifics$Msg$SetDvlType)
						]),
					A2($author$project$Common$UIFunctions$selectItems, kompo.dvlType, $author$project$Common$StaticVariables$komposionTypes)))
			]));
	var bpm = function () {
		var _v1 = kompo.beatpattern;
		if (_v1.$ === 'Just') {
			var theBpm = _v1.a;
			return theBpm;
		} else {
			return A3($author$project$Models$BaseModel$BeatPattern, 0, 0, 0);
		}
	}();
	var configUI = function () {
		var _v0 = kompo.dvlType;
		if (_v0 === 'Komposition') {
			return A2(
				$rundis$elm_bootstrap$Bootstrap$Form$form,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('container')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h3,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Video Config')
							])),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'Width',
						$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Input$id('width'),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
									$elm$core$String$fromInt(kompo.config.width)),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetWidth)
								]))),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'Height',
						$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Input$id('height'),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
									$elm$core$String$fromInt(kompo.config.height)),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetHeight)
								]))),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'Framerate',
						$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Input$id('framerate'),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
									$elm$core$String$fromInt(kompo.config.framerate)),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetFramerate)
								]))),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'Extension Type',
						A2(
							$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Select$id('segmentId'),
									$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$DvlSpecifics$Msg$SetExtensionType)
								]),
							A2($author$project$Common$UIFunctions$selectItems, kompo.config.extensionType, $author$project$Common$StaticVariables$extensionTypes))),
						A2(
						$elm$html$Html$h3,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Beat Pattern')
							])),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'From BPM',
						$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Input$id('frombpm'),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
									$elm$core$String$fromInt(bpm.fromBeat)),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetFromBpm)
								]))),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'To BPM',
						$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Input$id('tobpm'),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
									$elm$core$String$fromInt(bpm.toBeat)),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetToBpm)
								]))),
						A2(
						$author$project$DvlSpecifics$DvlSpecificsUI$wrapping,
						'Master BPM',
						$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Input$id('masterbpm'),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
									$elm$core$String$fromFloat(bpm.masterBPM)),
									$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$DvlSpecifics$Msg$SetMasterBpm)
								])))
					]));
		} else {
			return A2($rundis$elm_bootstrap$Bootstrap$Form$form, _List_Nil, _List_Nil);
		}
	}();
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				specificsUI,
				configUI,
				A2(
				$rundis$elm_bootstrap$Bootstrap$Button$button,
				_List_fromArray(
					[
						$rundis$elm_bootstrap$Bootstrap$Button$primary,
						$rundis$elm_bootstrap$Bootstrap$Button$onClick(
						$author$project$DvlSpecifics$Msg$InternalNavigateTo($author$project$Navigation$Page$KompostUI))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('<- Back')
					]))
			]));
};
var $author$project$Source$Msg$AutoComplete = function (a) {
	return {$: 'AutoComplete', a: a};
};
var $author$project$Source$Msg$DeleteSource = function (a) {
	return {$: 'DeleteSource', a: a};
};
var $author$project$Source$Msg$OrderChecksumEvalutation = function (a) {
	return {$: 'OrderChecksumEvalutation', a: a};
};
var $author$project$Source$Msg$SaveSource = {$: 'SaveSource'};
var $author$project$Source$Msg$SetChecksum = function (a) {
	return {$: 'SetChecksum', a: a};
};
var $author$project$Source$Msg$SetFormat = function (a) {
	return {$: 'SetFormat', a: a};
};
var $author$project$Source$Msg$SetOffset = function (a) {
	return {$: 'SetOffset', a: a};
};
var $author$project$Source$Msg$SetSourceExtensionType = function (a) {
	return {$: 'SetSourceExtensionType', a: a};
};
var $author$project$Source$Msg$SetUrl = function (a) {
	return {$: 'SetUrl', a: a};
};
var $author$project$Source$Msg$SourceSearchVisible = function (a) {
	return {$: 'SourceSearchVisible', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Checkbox = function (a) {
	return {$: 'Checkbox', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$create = F2(
	function (options, label_) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Checkbox(
			{label: label_, options: options});
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Label = function (a) {
	return {$: 'Label', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$label = F2(
	function (attributes, children) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Label(
			{attributes: attributes, children: children});
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$applyModifier = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'Id':
				var val = modifier.a;
				return _Utils_update(
					options,
					{
						id: $elm$core$Maybe$Just(val)
					});
			case 'Value':
				var val = modifier.a;
				return _Utils_update(
					options,
					{state: val});
			case 'Inline':
				return _Utils_update(
					options,
					{inline: true});
			case 'OnChecked':
				var toMsg = modifier.a;
				return _Utils_update(
					options,
					{
						onChecked: $elm$core$Maybe$Just(toMsg)
					});
			case 'Custom':
				return _Utils_update(
					options,
					{custom: true});
			case 'Disabled':
				var val = modifier.a;
				return _Utils_update(
					options,
					{disabled: val});
			case 'Validation':
				var validation = modifier.a;
				return _Utils_update(
					options,
					{
						validation: $elm$core$Maybe$Just(validation)
					});
			default:
				var attrs_ = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Off = {$: 'Off'};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$defaultOptions = {attributes: _List_Nil, custom: false, disabled: false, id: $elm$core$Maybe$Nothing, inline: false, onChecked: $elm$core$Maybe$Nothing, state: $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Off, validation: $elm$core$Maybe$Nothing};
var $elm$html$Html$Attributes$for = $elm$html$Html$Attributes$stringProperty('htmlFor');
var $elm$html$Html$Events$targetChecked = A2(
	$elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'checked']),
	$elm$json$Json$Decode$bool);
var $elm$html$Html$Events$onCheck = function (tagger) {
	return A2(
		$elm$html$Html$Events$on,
		'change',
		A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetChecked));
};
var $elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var $elm$html$Html$Attributes$attribute = $elm$virtual_dom$VirtualDom$attribute;
var $elm$html$Html$Attributes$checked = $elm$html$Html$Attributes$boolProperty('checked');
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$stateAttribute = function (state) {
	switch (state.$) {
		case 'On':
			return $elm$html$Html$Attributes$checked(true);
		case 'Off':
			return $elm$html$Html$Attributes$checked(false);
		default:
			return A2($elm$html$Html$Attributes$attribute, 'indeterminate', 'true');
	}
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$toAttributes = function (options) {
	return _Utils_ap(
		_List_fromArray(
			[
				$elm$html$Html$Attributes$classList(
				_List_fromArray(
					[
						_Utils_Tuple2('form-check-input', !options.custom),
						_Utils_Tuple2('custom-control-input', options.custom)
					])),
				$elm$html$Html$Attributes$type_('checkbox'),
				$elm$html$Html$Attributes$disabled(options.disabled),
				$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$stateAttribute(options.state)
			]),
		_Utils_ap(
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						A2($elm$core$Maybe$map, $elm$html$Html$Events$onCheck, options.onChecked),
						A2($elm$core$Maybe$map, $elm$html$Html$Attributes$id, options.id)
					])),
			_Utils_ap(
				function () {
					var _v0 = options.validation;
					if (_v0.$ === 'Just') {
						var v = _v0.a;
						return _List_fromArray(
							[
								$elm$html$Html$Attributes$class(
								$rundis$elm_bootstrap$Bootstrap$Form$FormInternal$validationToString(v))
							]);
					} else {
						return _List_Nil;
					}
				}(),
				options.attributes)));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$view = function (_v0) {
	var chk = _v0.a;
	var opts = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$applyModifier, $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$defaultOptions, chk.options);
	var _v1 = chk.label;
	var label_ = _v1.a;
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$classList(
				_List_fromArray(
					[
						_Utils_Tuple2('form-check', !opts.custom),
						_Utils_Tuple2('form-check-inline', (!opts.custom) && opts.inline),
						_Utils_Tuple2('custom-control', opts.custom),
						_Utils_Tuple2('custom-checkbox', opts.custom),
						_Utils_Tuple2('custom-control-inline', opts.inline && opts.custom)
					]))
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$input,
				$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$toAttributes(opts),
				_List_Nil),
				A2(
				$elm$html$Html$label,
				_Utils_ap(
					label_.attributes,
					_Utils_ap(
						_List_fromArray(
							[
								$elm$html$Html$Attributes$classList(
								_List_fromArray(
									[
										_Utils_Tuple2('form-check-label', !opts.custom),
										_Utils_Tuple2('custom-control-label', opts.custom)
									]))
							]),
						function () {
							var _v2 = opts.id;
							if (_v2.$ === 'Just') {
								var v = _v2.a;
								return _List_fromArray(
									[
										$elm$html$Html$Attributes$for(v)
									]);
							} else {
								return _List_Nil;
							}
						}())),
				label_.children)
			]));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$checkbox = F2(
	function (options, labelText) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$view(
			A2(
				$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$create,
				options,
				A2(
					$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$label,
					_List_Nil,
					_List_fromArray(
						[
							$elm$html$Html$text(labelText)
						]))));
	});
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$On = {$: 'On'};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Value = function (a) {
	return {$: 'Value', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$checked = function (isCheck) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Value(
		isCheck ? $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$On : $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$Off);
};
var $elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var $elm$html$Html$map = $elm$virtual_dom$VirtualDom$map;
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$OnChecked = function (a) {
	return {$: 'OnChecked', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$onCheck = function (toMsg) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Checkbox$OnChecked(toMsg);
};
var $rundis$elm_bootstrap$Bootstrap$General$Internal$SM = {$: 'SM'};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Size = function (a) {
	return {$: 'Size', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Button$small = $rundis$elm_bootstrap$Bootstrap$Internal$Button$Size($rundis$elm_bootstrap$Bootstrap$General$Internal$SM);
var $author$project$Source$Msg$FetchSourceList = function (a) {
	return {$: 'FetchSourceList', a: a};
};
var $author$project$Source$Msg$JumpToSourceKomposition = function (a) {
	return {$: 'JumpToSourceKomposition', a: a};
};
var $author$project$Source$Msg$SetSourceId = function (a) {
	return {$: 'SetSourceId', a: a};
};
var $author$project$Source$Msg$SetSourceMediaType = function (a) {
	return {$: 'SetSourceMediaType', a: a};
};
var $author$project$Source$SourcesUI$sourceIdSelection = F2(
	function (sourceId, sourceList) {
		return A2(
			$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
			_List_fromArray(
				[
					$rundis$elm_bootstrap$Bootstrap$Form$Select$id('sourceId'),
					$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$Source$Msg$SetSourceId)
				]),
			A2(
				$author$project$Common$UIFunctions$selectItems,
				sourceId,
				A2(
					$elm$core$List$map,
					function (segment) {
						return segment.id;
					},
					sourceList)));
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col2 = {$: 'Col2'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Col$xs2 = A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$width, $rundis$elm_bootstrap$Bootstrap$General$Internal$XS, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col2);
var $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col7 = {$: 'Col7'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Col$xs7 = A2($rundis$elm_bootstrap$Bootstrap$Grid$Internal$width, $rundis$elm_bootstrap$Bootstrap$General$Internal$XS, $rundis$elm_bootstrap$Bootstrap$Grid$Internal$Col7);
var $author$project$Source$SourcesUI$sourceSelector = function (model) {
	var mediaFile = model.editingMediaFile;
	return model.checkboxVisible ? _List_fromArray(
		[
			A2(
			$rundis$elm_bootstrap$Bootstrap$Form$col,
			_List_fromArray(
				[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs7]),
			_List_fromArray(
				[
					A2(
					$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Select$id('Media type'),
							$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$Source$Msg$SetSourceMediaType)
						]),
					A2($author$project$Common$UIFunctions$selectItems, mediaFile.mediaType, $author$project$Common$StaticVariables$komposionTypes)),
					A2($author$project$Source$SourcesUI$sourceIdSelection, model.segment.sourceId, model.listings.docs)
				])),
			A2(
			$rundis$elm_bootstrap$Bootstrap$Form$col,
			_List_fromArray(
				[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs2]),
			_List_fromArray(
				[
					A2(
					$rundis$elm_bootstrap$Bootstrap$Button$button,
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Button$primary,
							$rundis$elm_bootstrap$Bootstrap$Button$small,
							$rundis$elm_bootstrap$Bootstrap$Button$onClick(
							$author$project$Source$Msg$FetchSourceList(mediaFile.mediaType))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Fetch alternatives')
						]))
				]))
		]) : _List_fromArray(
		[
			A2(
			$rundis$elm_bootstrap$Bootstrap$Form$col,
			_List_fromArray(
				[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs7]),
			_List_fromArray(
				[
					$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Form$Input$id('id'),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$value(mediaFile.id),
							$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Source$Msg$SetSourceId)
						]))
				])),
			A2(
			$rundis$elm_bootstrap$Bootstrap$Form$col,
			_List_fromArray(
				[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs2]),
			_List_fromArray(
				[
					A2(
					$rundis$elm_bootstrap$Bootstrap$Button$button,
					_List_fromArray(
						[
							$rundis$elm_bootstrap$Bootstrap$Button$primary,
							$rundis$elm_bootstrap$Bootstrap$Button$small,
							$rundis$elm_bootstrap$Bootstrap$Button$onClick(
							$author$project$Source$Msg$JumpToSourceKomposition(mediaFile.id))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Navigate To')
						]))
				]))
		]);
};
var $author$project$Common$AutoComplete$HandleEscape = {$: 'HandleEscape'};
var $author$project$Common$AutoComplete$OnFocus = {$: 'OnFocus'};
var $author$project$Common$AutoComplete$SetQuery = function (a) {
	return {$: 'SetQuery', a: a};
};
var $elm$html$Html$Attributes$autocomplete = function (bool) {
	return A2(
		$elm$html$Html$Attributes$stringProperty,
		'autocomplete',
		bool ? 'on' : 'off');
};
var $author$project$Common$AutoComplete$boolToString = function (bool) {
	if (bool) {
		return 'true';
	} else {
		return 'false';
	}
};
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$html$Html$Events$keyCode = A2($elm$json$Json$Decode$field, 'keyCode', $elm$json$Json$Decode$int);
var $elm$html$Html$Events$onFocus = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'focus',
		$elm$json$Json$Decode$succeed(msg));
};
var $author$project$Common$AutoComplete$SetAutoState = function (a) {
	return {$: 'SetAutoState', a: a};
};
var $ContaSystemer$elm_menu$Menu$Msg = function (a) {
	return {$: 'Msg', a: a};
};
var $ContaSystemer$elm_menu$Menu$Internal$NoOp = {$: 'NoOp'};
var $elm$virtual_dom$VirtualDom$mapAttribute = _VirtualDom_mapAttribute;
var $elm$html$Html$Attributes$map = $elm$virtual_dom$VirtualDom$mapAttribute;
var $ContaSystemer$elm_menu$Menu$Internal$mapNeverToMsg = function (msg) {
	return A2(
		$elm$html$Html$Attributes$map,
		function (_v0) {
			return $ContaSystemer$elm_menu$Menu$Internal$NoOp;
		},
		msg);
};
var $elm$virtual_dom$VirtualDom$keyedNode = function (tag) {
	return _VirtualDom_keyedNode(
		_VirtualDom_noScript(tag));
};
var $elm$html$Html$Keyed$node = $elm$virtual_dom$VirtualDom$keyedNode;
var $elm$html$Html$Keyed$ul = $elm$html$Html$Keyed$node('ul');
var $ContaSystemer$elm_menu$Menu$Internal$MouseClick = function (a) {
	return {$: 'MouseClick', a: a};
};
var $ContaSystemer$elm_menu$Menu$Internal$MouseEnter = function (a) {
	return {$: 'MouseEnter', a: a};
};
var $ContaSystemer$elm_menu$Menu$Internal$MouseLeave = function (a) {
	return {$: 'MouseLeave', a: a};
};
var $elm$html$Html$li = _VirtualDom_node('li');
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$html$Html$Events$onMouseEnter = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'mouseenter',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$html$Html$Events$onMouseLeave = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'mouseleave',
		$elm$json$Json$Decode$succeed(msg));
};
var $ContaSystemer$elm_menu$Menu$Internal$viewItem = F3(
	function (_v0, _v1, data) {
		var toId = _v0.toId;
		var li = _v0.li;
		var key = _v1.key;
		var mouse = _v1.mouse;
		var id = toId(data);
		var isSelected = function (maybeId) {
			if (maybeId.$ === 'Just') {
				var someId = maybeId.a;
				return _Utils_eq(someId, id);
			} else {
				return false;
			}
		};
		var listItemData = A3(
			li,
			isSelected(key),
			isSelected(mouse),
			data);
		var customAttributes = A2($elm$core$List$map, $ContaSystemer$elm_menu$Menu$Internal$mapNeverToMsg, listItemData.attributes);
		var customLiAttr = A2(
			$elm$core$List$append,
			customAttributes,
			_List_fromArray(
				[
					$elm$html$Html$Events$onMouseEnter(
					$ContaSystemer$elm_menu$Menu$Internal$MouseEnter(id)),
					$elm$html$Html$Events$onMouseLeave(
					$ContaSystemer$elm_menu$Menu$Internal$MouseLeave(id)),
					$elm$html$Html$Events$onClick(
					$ContaSystemer$elm_menu$Menu$Internal$MouseClick(id))
				]));
		return A2(
			$elm$html$Html$li,
			customLiAttr,
			A2(
				$elm$core$List$map,
				$elm$html$Html$map(
					function (_v2) {
						return $ContaSystemer$elm_menu$Menu$Internal$NoOp;
					}),
				listItemData.children));
	});
var $ContaSystemer$elm_menu$Menu$Internal$view = F4(
	function (config, howManyToShow, state, data) {
		var getKeyedItems = function (datum) {
			return _Utils_Tuple2(
				config.toId(datum),
				A3($ContaSystemer$elm_menu$Menu$Internal$viewItem, config, state, datum));
		};
		var customUlAttr = A2($elm$core$List$map, $ContaSystemer$elm_menu$Menu$Internal$mapNeverToMsg, config.ul);
		return A2(
			$elm$html$Html$Keyed$ul,
			customUlAttr,
			A2(
				$elm$core$List$map,
				getKeyedItems,
				A2($elm$core$List$take, howManyToShow, data)));
	});
var $ContaSystemer$elm_menu$Menu$view = F4(
	function (_v0, howManyToShow, _v1, data) {
		var config = _v0.a;
		var state = _v1.a;
		return A2(
			$elm$html$Html$map,
			$ContaSystemer$elm_menu$Menu$Msg,
			A4($ContaSystemer$elm_menu$Menu$Internal$view, config, howManyToShow, state, data));
	});
var $ContaSystemer$elm_menu$Menu$ViewConfig = function (a) {
	return {$: 'ViewConfig', a: a};
};
var $ContaSystemer$elm_menu$Menu$Internal$viewConfig = function (_v0) {
	var toId = _v0.toId;
	var ul = _v0.ul;
	var li = _v0.li;
	return {li: li, toId: toId, ul: ul};
};
var $ContaSystemer$elm_menu$Menu$viewConfig = function (config) {
	return $ContaSystemer$elm_menu$Menu$ViewConfig(
		$ContaSystemer$elm_menu$Menu$Internal$viewConfig(config));
};
var $author$project$Common$AutoComplete$viewConfig = function () {
	var customizedLi = F3(
		function (keySelected, mouseSelected, person) {
			return {
				attributes: _List_fromArray(
					[
						$elm$html$Html$Attributes$classList(
						_List_fromArray(
							[
								_Utils_Tuple2('autocomplete-item', true),
								_Utils_Tuple2('key-selected', keySelected || mouseSelected)
							])),
						$elm$html$Html$Attributes$id(person.name)
					]),
				children: _List_fromArray(
					[
						$elm$html$Html$text(person.name)
					])
			};
		});
	return $ContaSystemer$elm_menu$Menu$viewConfig(
		{
			li: customizedLi,
			toId: function ($) {
				return $.name;
			},
			ul: _List_fromArray(
				[
					$elm$html$Html$Attributes$class('autocomplete-list')
				])
		});
}();
var $author$project$Common$AutoComplete$viewMenu = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('autocomplete-menu')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$map,
				$author$project$Common$AutoComplete$SetAutoState,
				A4(
					$ContaSystemer$elm_menu$Menu$view,
					$author$project$Common$AutoComplete$viewConfig,
					model.howManyToShow,
					model.autoState,
					A2($author$project$Common$AutoComplete$acceptablePeople, model.query, model.people)))
			]));
};
var $author$project$Common$AutoComplete$view = function (model) {
	var upDownEscDecoderHelper = function (code) {
		return ((code === 38) || (code === 40)) ? $elm$json$Json$Decode$succeed($author$project$Common$AutoComplete$NoOp) : ((code === 27) ? $elm$json$Json$Decode$succeed($author$project$Common$AutoComplete$HandleEscape) : $elm$json$Json$Decode$fail('not handling that key'));
	};
	var upDownEscDecoder = A2(
		$elm$json$Json$Decode$map,
		function (msg) {
			return _Utils_Tuple2(msg, true);
		},
		A2($elm$json$Json$Decode$andThen, upDownEscDecoderHelper, $elm$html$Html$Events$keyCode));
	var query = A2(
		$elm$core$Maybe$withDefault,
		model.query,
		A2(
			$elm$core$Maybe$map,
			function ($) {
				return $.name;
			},
			model.selectedPerson));
	var menu = model.showMenu ? _List_fromArray(
		[
			$author$project$Common$AutoComplete$viewMenu(model)
		]) : _List_Nil;
	var activeDescendant = function (attributes) {
		return A2(
			$elm$core$Maybe$withDefault,
			attributes,
			A2(
				$elm$core$Maybe$map,
				function (attribute) {
					return A2($elm$core$List$cons, attribute, attributes);
				},
				A2(
					$elm$core$Maybe$map,
					$elm$html$Html$Attributes$attribute('aria-activedescendant'),
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.name;
						},
						model.selectedPerson))));
	};
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		A2(
			$elm$core$List$append,
			_List_fromArray(
				[
					A2(
					$elm$html$Html$input,
					activeDescendant(
						_List_fromArray(
							[
								$elm$html$Html$Events$onInput($author$project$Common$AutoComplete$SetQuery),
								$elm$html$Html$Events$onFocus($author$project$Common$AutoComplete$OnFocus),
								A2($elm$html$Html$Events$preventDefaultOn, 'keydown', upDownEscDecoder),
								$elm$html$Html$Attributes$value(query),
								$elm$html$Html$Attributes$id('president-input'),
								$elm$html$Html$Attributes$class('autocomplete-input'),
								$elm$html$Html$Attributes$autocomplete(false),
								A2($elm$html$Html$Attributes$attribute, 'aria-owns', 'list-of-presidents'),
								A2(
								$elm$html$Html$Attributes$attribute,
								'aria-expanded',
								$author$project$Common$AutoComplete$boolToString(model.showMenu)),
								A2(
								$elm$html$Html$Attributes$attribute,
								'aria-haspopup',
								$author$project$Common$AutoComplete$boolToString(model.showMenu)),
								A2($elm$html$Html$Attributes$attribute, 'role', 'combobox'),
								A2($elm$html$Html$Attributes$attribute, 'aria-autocomplete', 'list')
							])),
					_List_Nil)
				]),
			menu));
};
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Warning = {$: 'Warning'};
var $rundis$elm_bootstrap$Bootstrap$Button$warning = $rundis$elm_bootstrap$Bootstrap$Internal$Button$Coloring(
	$rundis$elm_bootstrap$Bootstrap$Internal$Button$Roled($rundis$elm_bootstrap$Bootstrap$Internal$Button$Warning));
var $author$project$Source$SourcesUI$textField = F3(
	function (ref, inputvalue, func) {
		return $rundis$elm_bootstrap$Bootstrap$Form$Input$text(
			_List_fromArray(
				[
					$rundis$elm_bootstrap$Bootstrap$Form$Input$id(ref),
					$rundis$elm_bootstrap$Bootstrap$Form$Input$value(inputvalue),
					$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput(func)
				]));
	});
var $author$project$Source$SourcesUI$wrapping = F2(
	function (identifier, htmlPart) {
		return A2(
			$rundis$elm_bootstrap$Bootstrap$Form$row,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$rundis$elm_bootstrap$Bootstrap$Form$colLabel,
					_List_fromArray(
						[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
					_List_fromArray(
						[
							$elm$html$Html$text(identifier)
						])),
					A2(
					$rundis$elm_bootstrap$Bootstrap$Form$col,
					_List_fromArray(
						[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs8]),
					_List_fromArray(
						[htmlPart]))
				]));
	});
var $author$project$Source$SourcesUI$wrapTextField = F3(
	function (stringref, inputvalue, func) {
		return A2(
			$author$project$Source$SourcesUI$wrapping,
			stringref,
			A3($author$project$Source$SourcesUI$textField, stringref, inputvalue, func));
	});
var $author$project$Source$SourcesUI$editSpecifics = function (model) {
	var mediaFile = model.editingMediaFile;
	var offset = function () {
		var _v0 = mediaFile.startingOffset;
		if (_v0.$ === 'Just') {
			var a = _v0.a;
			return $elm$core$String$fromFloat(a);
		} else {
			return '';
		}
	}();
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$checkbox,
						_List_fromArray(
							[
								$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$onCheck($author$project$Source$Msg$SourceSearchVisible),
								$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$checked(model.checkboxVisible)
							]),
						'Editing Source')
					])),
				A2(
				$rundis$elm_bootstrap$Bootstrap$Form$form,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('container')
					]),
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$row,
						_List_Nil,
						$author$project$Source$SourcesUI$sourceSelector(model)),
						A3($author$project$Source$SourcesUI$wrapTextField, 'Url', mediaFile.url, $author$project$Source$Msg$SetUrl),
						A3($author$project$Source$SourcesUI$wrapTextField, 'Starting Offset', offset, $author$project$Source$Msg$SetOffset),
						A3($author$project$Source$SourcesUI$wrapTextField, 'Checksums', mediaFile.checksum, $author$project$Source$Msg$SetChecksum),
						A3($author$project$Source$SourcesUI$wrapTextField, 'Format', mediaFile.format, $author$project$Source$Msg$SetFormat),
						A2(
						$author$project$Source$SourcesUI$wrapping,
						'Extension Type',
						A2(
							$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Form$Select$id('segmentId'),
									$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$Source$Msg$SetSourceExtensionType)
								]),
							A2($author$project$Common$UIFunctions$selectItems, mediaFile.extensionType, $author$project$Common$StaticVariables$extensionTypes))),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$row,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabel,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
								_List_Nil),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$primary,
												$rundis$elm_bootstrap$Bootstrap$Button$small,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Source$Msg$SaveSource)
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Back')
											]))
									])),
								A2($rundis$elm_bootstrap$Bootstrap$Form$col, _List_Nil, _List_Nil),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$warning,
												$rundis$elm_bootstrap$Bootstrap$Button$small,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick(
												$author$project$Source$Msg$DeleteSource(mediaFile.id))
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Remove')
											]))
									])),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$small,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick(
												$author$project$Source$Msg$OrderChecksumEvalutation(mediaFile.id))
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Evaluate Checksum')
											]))
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class('example-autocomplete')
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$map,
								$author$project$Source$Msg$AutoComplete,
								$author$project$Common$AutoComplete$view(model.accessibleAutocomplete))
							]))
					]))
			]));
};
var $author$project$Models$Msg$CreateSegment = {$: 'CreateSegment'};
var $author$project$Models$Msg$CreateVideo = {$: 'CreateVideo'};
var $author$project$Models$Msg$DeleteKomposition = {$: 'DeleteKomposition'};
var $author$project$Models$Msg$NavigateTo = function (a) {
	return {$: 'NavigateTo', a: a};
};
var $author$project$Models$Msg$ShowKompositionJson = {$: 'ShowKompositionJson'};
var $author$project$Models$Msg$StoreKomposition = {$: 'StoreKomposition'};
var $rundis$elm_bootstrap$Bootstrap$Grid$Column = function (a) {
	return {$: 'Column', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Grid$col = F2(
	function (options, children) {
		return $rundis$elm_bootstrap$Bootstrap$Grid$Column(
			{children: children, options: options});
	});
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Danger = {$: 'Danger'};
var $rundis$elm_bootstrap$Bootstrap$Button$danger = $rundis$elm_bootstrap$Bootstrap$Internal$Button$Coloring(
	$rundis$elm_bootstrap$Bootstrap$Internal$Button$Roled($rundis$elm_bootstrap$Bootstrap$Internal$Button$Danger));
var $author$project$Source$Msg$EditMediaFile = function (a) {
	return {$: 'EditMediaFile', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Grid$renderCol = function (column) {
	switch (column.$) {
		case 'Column':
			var options = column.a.options;
			var children = column.a.children;
			return A2(
				$elm$html$Html$div,
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$colAttributes(options),
				children);
		case 'ColBreak':
			var e = column.a;
			return e;
		default:
			var options = column.a.options;
			var children = column.a.children;
			return A3(
				$elm$html$Html$Keyed$node,
				'div',
				$rundis$elm_bootstrap$Bootstrap$Grid$Internal$colAttributes(options),
				children);
	}
};
var $rundis$elm_bootstrap$Bootstrap$Grid$row = F2(
	function (options, cols) {
		return A2(
			$elm$html$Html$div,
			$rundis$elm_bootstrap$Bootstrap$Grid$Internal$rowAttributes(options),
			A2($elm$core$List$map, $rundis$elm_bootstrap$Bootstrap$Grid$renderCol, cols));
	});
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Secondary = {$: 'Secondary'};
var $rundis$elm_bootstrap$Bootstrap$Button$secondary = $rundis$elm_bootstrap$Bootstrap$Internal$Button$Coloring(
	$rundis$elm_bootstrap$Bootstrap$Internal$Button$Roled($rundis$elm_bootstrap$Bootstrap$Internal$Button$Secondary));
var $author$project$Source$View$showSingleSource = function (source) {
	return A2(
		$rundis$elm_bootstrap$Bootstrap$Grid$row,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$col,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$map,
						$author$project$Models$Msg$SourceMsg,
						A2(
							$rundis$elm_bootstrap$Bootstrap$Button$button,
							_List_fromArray(
								[
									$rundis$elm_bootstrap$Bootstrap$Button$secondary,
									$rundis$elm_bootstrap$Bootstrap$Button$small,
									$rundis$elm_bootstrap$Bootstrap$Button$onClick(
									$author$project$Source$Msg$EditMediaFile(source.id))
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(source.id)
								])))
					]))
			]));
};
var $author$project$Source$View$showSourceList = function (source) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		A2($elm$core$List$map, $author$project$Source$View$showSingleSource, source));
};
var $author$project$Source$View$editSources = function (sources) {
	return $author$project$Source$View$showSourceList(sources);
};
var $elm$svg$Svg$Attributes$dy = _VirtualDom_attribute('dy');
var $elm$svg$Svg$Attributes$fontSize = _VirtualDom_attribute('font-size');
var $elm$svg$Svg$Attributes$pointerEvents = _VirtualDom_attribute('pointer-events');
var $author$project$Segment$SegmentRendering$startPart = function (startInt) {
	return $elm$core$String$fromInt(10 % startInt);
};
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $elm$svg$Svg$text = $elm$virtual_dom$VirtualDom$text;
var $elm$svg$Svg$trustedNode = _VirtualDom_nodeNS('http://www.w3.org/2000/svg');
var $elm$svg$Svg$text_ = $elm$svg$Svg$trustedNode('text');
var $elm$svg$Svg$tspan = $elm$svg$Svg$trustedNode('tspan');
var $elm$svg$Svg$Attributes$x = _VirtualDom_attribute('x');
var $elm$svg$Svg$Attributes$y = _VirtualDom_attribute('y');
var $author$project$Segment$SegmentRendering$drawLegendText = F3(
	function (text, startInt, widthInt) {
		var wi = $author$project$Segment$SegmentRendering$startPart(startInt + 110);
		return A2(
			$elm$svg$Svg$text_,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$pointerEvents('none'),
					$elm$svg$Svg$Attributes$x(
					$elm$core$String$fromInt(widthInt)),
					$elm$svg$Svg$Attributes$y(
					$elm$core$String$fromInt(startInt)),
					$elm$svg$Svg$Attributes$fontSize('4'),
					A2($elm$html$Html$Attributes$style, '-webkit-user-select', 'none')
				]),
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$tspan,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$x(wi),
							$elm$svg$Svg$Attributes$dy('1.2em')
						]),
					_List_fromArray(
						[
							$elm$svg$Svg$text(text)
						]))
				]));
	});
var $elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var $elm$svg$Svg$Attributes$fill = _VirtualDom_attribute('fill');
var $elm$svg$Svg$Attributes$height = _VirtualDom_attribute('height');
var $elm$svg$Svg$rect = $elm$svg$Svg$trustedNode('rect');
var $elm$svg$Svg$Attributes$width = _VirtualDom_attribute('width');
var $author$project$Segment$SegmentRendering$drawRect = F3(
	function (text, startInt, widthInt) {
		var widthZ = $elm$core$String$fromInt(
			$elm$core$Basics$abs(widthInt));
		var start = $elm$core$String$fromInt(startInt);
		var color = (widthInt > 0) ? '#023963' : ((widthInt < 0) ? '#0B79CE' : '#AAAAAA');
		return A2(
			$elm$svg$Svg$rect,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x(
					$author$project$Segment$SegmentRendering$startPart(startInt)),
					$elm$svg$Svg$Attributes$y(start),
					$elm$svg$Svg$Attributes$width('10'),
					$elm$svg$Svg$Attributes$height(widthZ),
					$elm$svg$Svg$Attributes$fill(color)
				]),
			_List_Nil);
	});
var $author$project$Segment$SegmentRendering$drawSegmentGaps = F2(
	function (svgDrawer, segmentList) {
		return A2(
			$elm$core$List$map,
			function (segment) {
				return A3(
					svgDrawer,
					$elm$core$String$fromInt(segment.start) + (' ' + segment.id),
					segment.start,
					(segment.end - segment.start) - 1);
			},
			segmentList);
	});
var $elm$svg$Svg$svg = $elm$svg$Svg$trustedNode('svg');
var $elm$svg$Svg$Attributes$viewBox = _VirtualDom_attribute('viewBox');
var $author$project$Segment$SegmentRendering$gapVisualizer = function (kompost) {
	return A2(
		$elm$svg$Svg$svg,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$viewBox('0 0 200 800'),
				$elm$svg$Svg$Attributes$width('800 px')
			]),
		_Utils_ap(
			A2($author$project$Segment$SegmentRendering$drawSegmentGaps, $author$project$Segment$SegmentRendering$drawRect, kompost.segments),
			A2($author$project$Segment$SegmentRendering$drawSegmentGaps, $author$project$Segment$SegmentRendering$drawLegendText, kompost.segments)));
};
var $elm$html$Html$h4 = _VirtualDom_node('h4');
var $author$project$Segment$Msg$EditSegment = function (a) {
	return {$: 'EditSegment', a: a};
};
var $author$project$Segment$SegmentUI$showSingleSegment = function (segment) {
	return A2(
		$rundis$elm_bootstrap$Bootstrap$Grid$row,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$col,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Button$button,
						_List_fromArray(
							[
								$rundis$elm_bootstrap$Bootstrap$Button$secondary,
								$rundis$elm_bootstrap$Bootstrap$Button$small,
								$rundis$elm_bootstrap$Bootstrap$Button$onClick(
								$author$project$Segment$Msg$EditSegment(segment.id))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(segment.id)
							]))
					])),
				A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$col,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text(
						$elm$core$String$fromInt(segment.start))
					])),
				A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$col,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text(
						$elm$core$String$fromInt(segment.duration))
					]))
			]));
};
var $elm$core$List$sortBy = _List_sortBy;
var $author$project$Segment$SegmentUI$showSegmentList = function (segs) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		A2(
			$elm$core$List$cons,
			A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$row,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Segment')
							])),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Start')
							])),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Duration')
							]))
					])),
			A2(
				$elm$core$List$map,
				$author$project$Segment$SegmentUI$showSingleSegment,
				A2(
					$elm$core$List$sortBy,
					function ($) {
						return $.start;
					},
					segs))));
};
var $author$project$Models$Msg$EditSpecifics = {$: 'EditSpecifics'};
var $author$project$DvlSpecifics$DvlSpecificsUI$addRow = F2(
	function (title, htmlIsh) {
		return A2(
			$rundis$elm_bootstrap$Bootstrap$Grid$row,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$rundis$elm_bootstrap$Bootstrap$Grid$col,
					_List_Nil,
					_List_fromArray(
						[
							$elm$html$Html$text(title)
						])),
					A2(
					$rundis$elm_bootstrap$Bootstrap$Grid$col,
					_List_Nil,
					_List_fromArray(
						[htmlIsh]))
				]));
	});
var $rundis$elm_bootstrap$Bootstrap$Grid$container = F2(
	function (attributes, children) {
		return A2(
			$elm$html$Html$div,
			_Utils_ap(
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('container')
					]),
				attributes),
			children);
	});
var $author$project$DvlSpecifics$DvlSpecificsUI$showSpecifics = function (model) {
	return A2(
		$rundis$elm_bootstrap$Bootstrap$Grid$container,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$addRow,
				'Name',
				$elm$html$Html$text(model.kompost.name)),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$addRow,
				'Revision',
				$elm$html$Html$text(model.kompost.revision)),
				A2(
				$author$project$DvlSpecifics$DvlSpecificsUI$addRow,
				'BPM',
				$elm$html$Html$text(
					$elm$core$String$fromFloat(model.kompost.bpm))),
				A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$row,
				_List_Nil,
				_List_fromArray(
					[
						A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil),
						A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$secondary,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$EditSpecifics)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Edit Specifics')
									]))
							]))
					]))
			]));
};
var $rundis$elm_bootstrap$Bootstrap$Grid$simpleRow = function (cols) {
	return A2($rundis$elm_bootstrap$Bootstrap$Grid$row, _List_Nil, cols);
};
var $author$project$Source$View$sourceNewButton = A2(
	$rundis$elm_bootstrap$Bootstrap$Grid$row,
	_List_Nil,
	_List_fromArray(
		[
			A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil),
			A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil),
			A2(
			$rundis$elm_bootstrap$Bootstrap$Grid$col,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$html$Html$map,
					$author$project$Models$Msg$SourceMsg,
					A2(
						$rundis$elm_bootstrap$Bootstrap$Button$button,
						_List_fromArray(
							[
								$rundis$elm_bootstrap$Bootstrap$Button$primary,
								$rundis$elm_bootstrap$Bootstrap$Button$small,
								$rundis$elm_bootstrap$Bootstrap$Button$onClick(
								$author$project$Source$Msg$EditMediaFile(''))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('New Source')
							])))
				]))
		]));
var $rundis$elm_bootstrap$Bootstrap$Internal$Button$Success = {$: 'Success'};
var $rundis$elm_bootstrap$Bootstrap$Button$success = $rundis$elm_bootstrap$Bootstrap$Internal$Button$Coloring(
	$rundis$elm_bootstrap$Bootstrap$Internal$Button$Roled($rundis$elm_bootstrap$Bootstrap$Internal$Button$Success));
var $author$project$UI$KompostUI$kompost = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$rundis$elm_bootstrap$Bootstrap$Grid$row,
				_List_Nil,
				_List_fromArray(
					[
						A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$secondary,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick(
										$author$project$Models$Msg$NavigateTo($author$project$Navigation$Page$ListingsUI))
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('List Komposti')
									]))
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h4,
						_List_fromArray(
							[
								A2($elm$html$Html$Attributes$style, 'flex', '1')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(model.kompost.dvlType)
							]))
					])),
				$author$project$DvlSpecifics$DvlSpecificsUI$showSpecifics(model),
				A2(
				$elm$html$Html$h4,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Original Sources:')
					])),
				$author$project$Source$View$editSources(model.kompost.sources),
				$author$project$Source$View$sourceNewButton,
				$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
				_List_fromArray(
					[
						A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil)
					])),
				A2(
				$elm$html$Html$h4,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Segments:')
					])),
				A2(
				$elm$html$Html$map,
				$author$project$Models$Msg$SegmentMsg,
				$author$project$Segment$SegmentUI$showSegmentList(model.kompost.segments)),
				$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$primary,
										$rundis$elm_bootstrap$Bootstrap$Button$small,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$CreateSegment)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('New Segment')
									]))
							]))
					])),
				$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
				_List_fromArray(
					[
						A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil)
					])),
				$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
				_List_fromArray(
					[
						A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$success,
										$rundis$elm_bootstrap$Bootstrap$Button$small,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$StoreKomposition)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Store Komposition')
									]))
							])),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$danger,
										$rundis$elm_bootstrap$Bootstrap$Button$small,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$DeleteKomposition)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Delete Komposition')
									]))
							]))
					])),
				$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$primary,
										$rundis$elm_bootstrap$Bootstrap$Button$small,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$CreateVideo)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Create Video')
									]))
							]))
					])),
				$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Grid$col,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Button$button,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Button$primary,
										$rundis$elm_bootstrap$Bootstrap$Button$small,
										$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$ShowKompositionJson)
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Show JSON')
									]))
							]))
					])),
				A2(
				$elm$html$Html$h4,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Segments view:')
					])),
				$author$project$Segment$SegmentRendering$gapVisualizer(model.kompost)
			]));
};
var $author$project$Models$Msg$ChangeKompositionType = function (a) {
	return {$: 'ChangeKompositionType', a: a};
};
var $author$project$Models$Msg$ChangedIntegrationFormat = function (a) {
	return {$: 'ChangedIntegrationFormat', a: a};
};
var $author$project$Models$Msg$ChangedIntegrationId = function (a) {
	return {$: 'ChangedIntegrationId', a: a};
};
var $author$project$Models$Msg$FetchLocalIntegration = function (a) {
	return {$: 'FetchLocalIntegration', a: a};
};
var $author$project$Models$Msg$NewKomposition = {$: 'NewKomposition'};
var $elm$html$Html$a = _VirtualDom_node('a');
var $author$project$UI$KompostListingsUI$chooseDvlButton = F2(
	function (model, row) {
		return A2(
			$rundis$elm_bootstrap$Bootstrap$Button$button,
			_List_fromArray(
				[
					$rundis$elm_bootstrap$Bootstrap$Button$attrs(
					_List_fromArray(
						[
							A2($elm$html$Html$Attributes$style, 'margin-top', 'auto')
						])),
					$rundis$elm_bootstrap$Bootstrap$Button$secondary,
					$rundis$elm_bootstrap$Bootstrap$Button$onClick(
					$author$project$Models$Msg$FetchLocalIntegration(
						A2($author$project$Models$BaseModel$IntegrationDestination, row.id, model.kompoUrl)))
				]),
			_List_fromArray(
				[
					$elm$html$Html$text(row.id)
				]));
	});
var $elm$html$Html$Attributes$href = function (url) {
	return A2(
		$elm$html$Html$Attributes$stringProperty,
		'href',
		_VirtualDom_noJavaScriptUri(url));
};
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$RadioButtonItem = function (a) {
	return {$: 'RadioButtonItem', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Button$radioButton = F3(
	function (checked, options, children) {
		var hideRadio = A2($elm$html$Html$Attributes$attribute, 'data-toggle', 'button');
		return A2(
			$elm$html$Html$label,
			A2(
				$elm$core$List$cons,
				$elm$html$Html$Attributes$classList(
					_List_fromArray(
						[
							_Utils_Tuple2('active', checked)
						])),
				A2(
					$elm$core$List$cons,
					hideRadio,
					$rundis$elm_bootstrap$Bootstrap$Internal$Button$buttonAttributes(options))),
			A2(
				$elm$core$List$cons,
				A2(
					$elm$html$Html$input,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$type_('radio'),
							$elm$html$Html$Attributes$checked(checked),
							$elm$html$Html$Attributes$autocomplete(false)
						]),
					_List_Nil),
				children));
	});
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButton = F3(
	function (checked, options, children) {
		return $rundis$elm_bootstrap$Bootstrap$ButtonGroup$RadioButtonItem(
			A3($rundis$elm_bootstrap$Bootstrap$Button$radioButton, checked, options, children));
	});
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$GroupItem = function (a) {
	return {$: 'GroupItem', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$applyModifier = F2(
	function (modifier, options) {
		switch (modifier.$) {
			case 'Size':
				var size = modifier.a;
				return _Utils_update(
					options,
					{
						size: $elm$core$Maybe$Just(size)
					});
			case 'Vertical':
				return _Utils_update(
					options,
					{vertical: true});
			default:
				var attrs_ = modifier.a;
				return _Utils_update(
					options,
					{
						attributes: _Utils_ap(options.attributes, attrs_)
					});
		}
	});
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$defaultOptions = {attributes: _List_Nil, size: $elm$core$Maybe$Nothing, vertical: false};
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$groupAttributes = F2(
	function (toggle, modifiers) {
		var options = A3($elm$core$List$foldl, $rundis$elm_bootstrap$Bootstrap$ButtonGroup$applyModifier, $rundis$elm_bootstrap$Bootstrap$ButtonGroup$defaultOptions, modifiers);
		return _Utils_ap(
			_List_fromArray(
				[
					A2($elm$html$Html$Attributes$attribute, 'role', 'group'),
					$elm$html$Html$Attributes$classList(
					_List_fromArray(
						[
							_Utils_Tuple2('btn-group', true),
							_Utils_Tuple2('btn-group-toggle', toggle),
							_Utils_Tuple2('btn-group-vertical', options.vertical)
						])),
					A2($elm$html$Html$Attributes$attribute, 'data-toggle', 'buttons')
				]),
			_Utils_ap(
				function () {
					var _v0 = A2($elm$core$Maybe$andThen, $rundis$elm_bootstrap$Bootstrap$General$Internal$screenSizeOption, options.size);
					if (_v0.$ === 'Just') {
						var s = _v0.a;
						return _List_fromArray(
							[
								$elm$html$Html$Attributes$class('btn-group-' + s)
							]);
					} else {
						return _List_Nil;
					}
				}(),
				options.attributes));
	});
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButtonGroupItem = F2(
	function (options, items) {
		return $rundis$elm_bootstrap$Bootstrap$ButtonGroup$GroupItem(
			A2(
				$elm$html$Html$div,
				A2($rundis$elm_bootstrap$Bootstrap$ButtonGroup$groupAttributes, true, options),
				A2(
					$elm$core$List$map,
					function (_v0) {
						var elem = _v0.a;
						return elem;
					},
					items)));
	});
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$renderGroup = function (_v0) {
	var elem = _v0.a;
	return elem;
};
var $rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButtonGroup = F2(
	function (options, items) {
		return $rundis$elm_bootstrap$Bootstrap$ButtonGroup$renderGroup(
			A2($rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButtonGroupItem, options, items));
	});
var $elm$html$Html$table = _VirtualDom_node('table');
var $elm$html$Html$tbody = _VirtualDom_node('tbody');
var $elm$html$Html$thead = _VirtualDom_node('thead');
var $elm$html$Html$tr = _VirtualDom_node('tr');
var $author$project$UI$KompostListingsUI$listings = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('listings')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Kompositions')
					])),
				A2(
				$elm$html$Html$table,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('table table-striped')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$thead,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$elm$html$Html$tr,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButtonGroup,
										_List_Nil,
										_List_fromArray(
											[
												A3(
												$rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButton,
												true,
												_List_fromArray(
													[
														$rundis$elm_bootstrap$Bootstrap$Button$secondary,
														$rundis$elm_bootstrap$Bootstrap$Button$onClick(
														$author$project$Models$Msg$ChangeKompositionType('Komposition'))
													]),
												_List_fromArray(
													[
														$elm$html$Html$text('Komposition')
													])),
												A3(
												$rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButton,
												false,
												_List_fromArray(
													[
														$rundis$elm_bootstrap$Bootstrap$Button$warning,
														$rundis$elm_bootstrap$Bootstrap$Button$onClick(
														$author$project$Models$Msg$ChangeKompositionType('Video'))
													]),
												_List_fromArray(
													[
														$elm$html$Html$text('Video')
													])),
												A3(
												$rundis$elm_bootstrap$Bootstrap$ButtonGroup$radioButton,
												false,
												_List_fromArray(
													[
														$rundis$elm_bootstrap$Bootstrap$Button$success,
														$rundis$elm_bootstrap$Bootstrap$Button$onClick(
														$author$project$Models$Msg$ChangeKompositionType('Audio'))
													]),
												_List_fromArray(
													[
														$elm$html$Html$text('Audio')
													]))
											])),
										A2(
										$elm$html$Html$tbody,
										_List_Nil,
										A2(
											$elm$core$List$map,
											$author$project$UI$KompostListingsUI$chooseDvlButton(model),
											model.listings.docs)),
										$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
										_List_fromArray(
											[
												A2(
												$rundis$elm_bootstrap$Bootstrap$Grid$col,
												_List_Nil,
												_List_fromArray(
													[
														A2(
														$rundis$elm_bootstrap$Bootstrap$Button$button,
														_List_fromArray(
															[
																$rundis$elm_bootstrap$Bootstrap$Button$primary,
																$rundis$elm_bootstrap$Bootstrap$Button$small,
																$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Models$Msg$NewKomposition)
															]),
														_List_fromArray(
															[
																$elm$html$Html$text('New Komposition')
															]))
													]))
											])),
										$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Input$id('id'),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$value(model.integrationDestination),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Models$Msg$ChangedIntegrationId)
											])),
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$primary,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick(
												$author$project$Models$Msg$FetchLocalIntegration(
													A2($author$project$Models$BaseModel$IntegrationDestination, model.integrationDestination, model.metaUrl)))
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Fetch YT metadata')
											])),
										$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Input$id('format'),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$value(model.integrationFormat),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Models$Msg$ChangedIntegrationFormat)
											])),
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$primary,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick(
												$author$project$Models$Msg$FetchLocalIntegration(
													A2($author$project$Models$BaseModel$IntegrationDestination, model.integrationDestination + ('/' + model.integrationFormat), model.cacheUrl)))
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Cache Media')
											])),
										A2(
										$elm$html$Html$li,
										_List_Nil,
										_List_fromArray(
											[
												A2(
												$elm$html$Html$a,
												_List_fromArray(
													[
														$elm$html$Html$Attributes$href('fileupload.html?authy=' + model.apiToken)
													]),
												_List_fromArray(
													[
														$elm$html$Html$text('Upload file')
													]))
											]))
									])),
								$rundis$elm_bootstrap$Bootstrap$Grid$simpleRow(
								_List_fromArray(
									[
										A2($rundis$elm_bootstrap$Bootstrap$Grid$col, _List_Nil, _List_Nil)
									]))
							]))
					]))
			]));
};
var $elm$virtual_dom$VirtualDom$node = function (tag) {
	return _VirtualDom_node(
		_VirtualDom_noScript(tag));
};
var $elm$html$Html$node = $elm$virtual_dom$VirtualDom$node;
var $elm$html$Html$Attributes$rel = _VirtualDom_attribute('rel');
var $rundis$elm_bootstrap$Bootstrap$CDN$fontAwesome = A3(
	$elm$html$Html$node,
	'link',
	_List_fromArray(
		[
			$elm$html$Html$Attributes$rel('stylesheet'),
			$elm$html$Html$Attributes$href('https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css')
		]),
	_List_Nil);
var $rundis$elm_bootstrap$Bootstrap$CDN$stylesheet = A3(
	$elm$html$Html$node,
	'link',
	_List_fromArray(
		[
			$elm$html$Html$Attributes$rel('stylesheet'),
			$elm$html$Html$Attributes$href('https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css')
		]),
	_List_Nil);
var $author$project$Main$pageWrapper = function (forwaredPage) {
	return A2(
		$rundis$elm_bootstrap$Bootstrap$Grid$container,
		_List_Nil,
		_List_fromArray(
			[$rundis$elm_bootstrap$Bootstrap$CDN$stylesheet, $rundis$elm_bootstrap$Bootstrap$CDN$fontAwesome, forwaredPage]));
};
var $author$project$Segment$Msg$DeleteSegment = {$: 'DeleteSegment'};
var $author$project$Segment$Msg$SegmentSearchVisible = function (a) {
	return {$: 'SegmentSearchVisible', a: a};
};
var $author$project$Segment$Msg$SetSegmentDuration = function (a) {
	return {$: 'SetSegmentDuration', a: a};
};
var $author$project$Segment$Msg$SetSegmentEnd = function (a) {
	return {$: 'SetSegmentEnd', a: a};
};
var $author$project$Segment$Msg$SetSegmentId = function (a) {
	return {$: 'SetSegmentId', a: a};
};
var $author$project$Segment$Msg$SetSegmentStart = function (a) {
	return {$: 'SetSegmentStart', a: a};
};
var $author$project$Segment$Msg$UpdateSegment = {$: 'UpdateSegment'};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Attrs = function (a) {
	return {$: 'Attrs', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$attrs = function (attrs_) {
	return $rundis$elm_bootstrap$Bootstrap$Form$Input$Attrs(attrs_);
};
var $rundis$elm_bootstrap$Bootstrap$Form$colLabelSm = function (options) {
	return $rundis$elm_bootstrap$Bootstrap$Form$colLabel(
		A2(
			$elm$core$List$cons,
			$rundis$elm_bootstrap$Bootstrap$Grid$Col$attrs(
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('col-form-label-sm')
					])),
			options));
};
var $rundis$elm_bootstrap$Bootstrap$Form$label = F2(
	function (attributes, children) {
		return A2(
			$elm$html$Html$label,
			A2(
				$elm$core$List$cons,
				$elm$html$Html$Attributes$class('form-control-label'),
				attributes),
			children);
	});
var $author$project$Segment$SegmentUI$segmentIdSelection = function (model) {
	return A2(
		$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
		_List_fromArray(
			[
				$rundis$elm_bootstrap$Bootstrap$Form$Select$id('segmentId'),
				$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$Segment$Msg$SetSegmentId)
			]),
		A2(
			$author$project$Common$UIFunctions$selectItems,
			model.segment.id,
			$elm$core$Set$toList(model.subSegmentList)));
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$Size = function (a) {
	return {$: 'Size', a: a};
};
var $rundis$elm_bootstrap$Bootstrap$Form$Input$small = $rundis$elm_bootstrap$Bootstrap$Form$Input$Size($rundis$elm_bootstrap$Bootstrap$General$Internal$SM);
var $author$project$Segment$Msg$SetSourceId = function (a) {
	return {$: 'SetSourceId', a: a};
};
var $author$project$Segment$SegmentUI$sourceSelection = function (model) {
	return A2(
		$rundis$elm_bootstrap$Bootstrap$Form$Select$select,
		_List_fromArray(
			[
				$rundis$elm_bootstrap$Bootstrap$Form$Select$id('sourceId'),
				$rundis$elm_bootstrap$Bootstrap$Form$Select$onChange($author$project$Segment$Msg$SetSourceId)
			]),
		A2(
			$author$project$Common$UIFunctions$selectItems,
			model.segment.sourceId,
			A2(
				$elm$core$List$map,
				function (segment) {
					return segment.id;
				},
				model.kompost.sources)));
};
var $author$project$Segment$SegmentUI$segmentForm = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Editing Segment')
					])),
				A2(
				$rundis$elm_bootstrap$Bootstrap$Form$form,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('container')
					]),
				_List_fromArray(
					[
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$label,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$for('segmentId')
							]),
						_List_Nil),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$row,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabel,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs2]),
								_List_fromArray(
									[
										$elm$html$Html$text('Segment ID')
									])),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$checkbox,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$onCheck($author$project$Segment$Msg$SegmentSearchVisible),
												$rundis$elm_bootstrap$Bootstrap$Form$Checkbox$checked(model.checkboxVisible)
											]),
										'Search')
									]))
							])),
						model.checkboxVisible ? A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$author$project$Segment$SegmentUI$sourceSelection(model),
								$author$project$Segment$SegmentUI$segmentIdSelection(model)
							])) : A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$row,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Form$col,
										_List_fromArray(
											[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs8]),
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Input$text(
												_List_fromArray(
													[
														$rundis$elm_bootstrap$Bootstrap$Form$Input$id('id'),
														$rundis$elm_bootstrap$Bootstrap$Form$Input$value(model.segment.id),
														$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Segment$Msg$SetSegmentId)
													]))
											]))
									]))
							])),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$row,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabelSm,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
								_List_fromArray(
									[
										$elm$html$Html$text('Start')
									])),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabelSm,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
								_List_fromArray(
									[
										$elm$html$Html$text('Duration')
									])),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabelSm,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
								_List_fromArray(
									[
										$elm$html$Html$text('End')
									]))
							])),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$row,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabelSm,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Input$small,
												$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
												$elm$core$String$fromInt(model.segment.start)),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Segment$Msg$SetSegmentStart),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$attrs(
												_List_fromArray(
													[
														$elm$html$Html$Attributes$placeholder('Start')
													]))
											]))
									])),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Input$small,
												$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
												$elm$core$String$fromInt(model.segment.duration)),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Segment$Msg$SetSegmentDuration),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$attrs(
												_List_fromArray(
													[
														$elm$html$Html$Attributes$placeholder('Duration')
													]))
											]))
									])),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										$rundis$elm_bootstrap$Bootstrap$Form$Input$number(
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Form$Input$small,
												$rundis$elm_bootstrap$Bootstrap$Form$Input$value(
												$elm$core$String$fromInt(model.segment.end)),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$onInput($author$project$Segment$Msg$SetSegmentEnd),
												$rundis$elm_bootstrap$Bootstrap$Form$Input$attrs(
												_List_fromArray(
													[
														$elm$html$Html$Attributes$placeholder('End')
													]))
											]))
									]))
							])),
						A2(
						$rundis$elm_bootstrap$Bootstrap$Form$row,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$colLabel,
								_List_fromArray(
									[$rundis$elm_bootstrap$Bootstrap$Grid$Col$xs4]),
								_List_Nil),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$primary,
												$rundis$elm_bootstrap$Bootstrap$Button$small,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Segment$Msg$UpdateSegment)
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Back')
											]))
									])),
								A2($rundis$elm_bootstrap$Bootstrap$Form$col, _List_Nil, _List_Nil),
								A2(
								$rundis$elm_bootstrap$Bootstrap$Form$col,
								_List_Nil,
								_List_fromArray(
									[
										A2(
										$rundis$elm_bootstrap$Bootstrap$Button$button,
										_List_fromArray(
											[
												$rundis$elm_bootstrap$Bootstrap$Button$warning,
												$rundis$elm_bootstrap$Bootstrap$Button$small,
												$rundis$elm_bootstrap$Bootstrap$Button$onClick($author$project$Segment$Msg$DeleteSegment)
											]),
										_List_fromArray(
											[
												$elm$html$Html$text('Remove')
											]))
									]))
							]))
					]))
			]));
};
var $author$project$Main$findOutWhatPageToView = function (model) {
	var _v0 = A2($elm$core$Debug$log, 'Moving on to ', model.activePage);
	return _List_fromArray(
		[
			function () {
			var _v1 = model.activePage;
			switch (_v1.$) {
				case 'ListingsUI':
					return $author$project$Main$pageWrapper(
						$author$project$UI$KompostListingsUI$listings(model));
				case 'KompostUI':
					return $author$project$Main$pageWrapper(
						$author$project$UI$KompostUI$kompost(model));
				case 'KompositionJsonUI':
					return $elm$html$Html$text(
						$author$project$Models$JsonCoding$kompositionEncoder(model.kompost));
				case 'SegmentUI':
					return A2(
						$elm$html$Html$map,
						$author$project$Models$Msg$SegmentMsg,
						$author$project$Main$pageWrapper(
							$author$project$Segment$SegmentUI$segmentForm(model)));
				case 'DvlSpecificsUI':
					return A2(
						$elm$html$Html$map,
						$author$project$Models$Msg$DvlSpecificsMsg,
						$author$project$Main$pageWrapper(
							$author$project$DvlSpecifics$DvlSpecificsUI$editSpecifics(model.kompost)));
				case 'MediaFileUI':
					return A2(
						$elm$html$Html$map,
						$author$project$Models$Msg$SourceMsg,
						$author$project$Main$pageWrapper(
							$author$project$Source$SourcesUI$editSpecifics(model)));
				default:
					return A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Sorry, nothing< here :(')
							]));
			}
		}()
		]);
};
var $author$project$Main$view = function (model) {
	return {
		body: $author$project$Main$findOutWhatPageToView(model),
		title: 'KompostEdit'
	};
};
var $author$project$Main$main = $elm$browser$Browser$application(
	{init: $author$project$Main$init, onUrlChange: $author$project$Models$Msg$ChangedUrl, onUrlRequest: $author$project$Models$Msg$ClickedLink, subscriptions: $author$project$Main$subscriptions, update: $author$project$Main$update, view: $author$project$Main$view});
_Platform_export({'Main':{'init':$author$project$Main$main($elm$json$Json$Decode$string)(0)}});}(this));