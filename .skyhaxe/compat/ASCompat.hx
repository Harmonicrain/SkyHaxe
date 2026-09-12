#if macro
import haxe.macro.Expr;
#end

import haxe.Constraints.Function;

class ASCompat {
	/** OpenFL narrows LoaderInfo.parameters to Dynamic<String>; Flash exposes an Object property bag. */
	public static inline function loaderParameters(loader:Dynamic):ASObject {
		return loader == null ? null : cast Reflect.field(loader, "parameters");
	}

	public static inline function setLoaderParameters(loader:Dynamic, value:Dynamic):Dynamic {
		if (loader != null) Reflect.setField(loader, "parameters", value);
		return value;
	}

	public static inline function classProperty(owner:Dynamic, name:String):Dynamic {
		return owner == null ? null : Reflect.getProperty(owner, name);
	}

	public static inline function setDynamicProperty(owner:Dynamic, name:String, value:Dynamic):Dynamic {
		if (owner != null) Reflect.setProperty(owner, name, value);
		return value;
	}

	public static inline function getDynamicProperty(owner:Dynamic, name:String):ASAny {
		return owner == null ? null : Reflect.getProperty(owner, name);
	}

	public static inline function hasOwnProperty(owner:Dynamic, name:Dynamic):Bool {
		return owner != null && Reflect.hasField(owner, toString(name));
	}

	public static function dateFromValue(value:Dynamic):Date {
		#if js
		return cast js.Syntax.code("new Date({0})", value);
		#else
		return Date.fromTime(toNumber(value));
		#end
	}

	public static inline function textFormatDisplay(format:Dynamic):Dynamic {
		return format == null ? null : Reflect.field(format, "display");
	}

	public static inline function setTextFormatDisplay(format:Dynamic, value:Dynamic):Dynamic {
		if (format != null) Reflect.setField(format, "display", value);
		return value;
	}

	/** Flash Date's seventh constructor argument is milliseconds; Haxe stops at seconds. */
	public static function newDateWithMilliseconds(year:Dynamic, month:Dynamic, day:Dynamic = 1,
			hour:Dynamic = 0, minute:Dynamic = 0, second:Dynamic = 0, millisecond:Dynamic = 0):Date {
		var base = new Date(toInt(year), toInt(month), toInt(day), toInt(hour), toInt(minute), toInt(second));
		return Date.fromTime(base.getTime() + toInt(millisecond));
	}

	public static function dateParse(value:String):Float {
		return Date.fromString(value).getTime();
	}

	public static function byteArrayWriteBytes(target:Dynamic, source:Dynamic,
			offset:Int = 0, length:Int = 0):Void {
		var output:openfl.utils.ByteArray = cast target;
		var input:openfl.utils.ByteArray = cast source;
		output.writeBytes(input, offset, length);
	}

	public static function stringMatch(value:String, pattern:Dynamic):Array<String> {
		#if js
		return js.Syntax.code("{0}.match({1})", value, pattern);
		#elseif flash
		return untyped value.match(pattern);
		#else
		throw "String.match requires a supported VM boundary";
		#end
	}

	public static inline function stringSearch(value:String, pattern:Dynamic):Int {
		#if js
		return js.Syntax.code("{0}.search({1})", value, pattern);
		#elseif flash
		return untyped value.search(pattern);
		#else
		throw "AS3 String.search requires an ECMAScript target";
		#end
	}

	public static function xmlDescendants(value:Dynamic, name:String):com.sulake.core.utils.xml.XMLList {
		if (Std.isOfType(value, com.sulake.core.utils.xml.XML)) return (cast value : com.sulake.core.utils.xml.XML).descendants(name);
		if (Std.isOfType(value, com.sulake.core.utils.xml.XMLList)) return (cast value : com.sulake.core.utils.xml.XMLList).descendants(name);
		throw new openfl.errors.TypeError("Descendant access requires XML or XMLList");
	}

	public static function inOperator(property:Dynamic, object:Dynamic):Bool {
		#if js
		return js.Syntax.code("{0} in {1}", property, object);
		#elseif flash
		return untyped property in object;
		#else
		return Reflect.hasField(object, Std.string(property));
		#end
	}

	public static function typeOf(value:Dynamic):String {
		#if js
		if (Std.isOfType(value, com.sulake.core.utils.xml.XML) || Std.isOfType(value, com.sulake.core.utils.xml.XMLList)) return "xml";
		if (value != null && Reflect.field(value, "__name__") != null) return "object";
		return js.Syntax.code("typeof {0}", value);
		#else
		return untyped __global__["typeof"](value);
		#end
	}
	public static inline function stringReplace(value:String, pattern:Dynamic, replacement:Dynamic):String {
		#if js
		return js.Syntax.code("{0}.replace({1}, {2})", value, pattern, replacement);
		#elseif flash
		return untyped value.replace(pattern, replacement);
		#else
		throw "AS3 String.replace requires an ECMAScript target";
		#end
	}
	public static inline function undefinedValue():ASAny {
		#if js
		return js.Syntax.code("undefined");
		#else
		return null;
		#end
	}
	public static inline final MAX_UINT:UInt = 0xFFFFFFFF;
	public static inline final MIN_UINT:UInt = 0;
	public static inline final MAX_INT = 2147483647;
	public static inline final MIN_INT = -2147483648;

	public static inline final MAX_FLOAT = 1.79e+308;
	public static inline final MIN_FLOAT = -1.79E+308;

	/**
		AS3 iterates a null collection zero times, so this guard reproduces a language rule
		rather than catching a mistake -- `WindowController._children` is declared without an
		initialiser in the original too. It stays silent for that reason: the upstream FIXME
		trace fires on legitimate code, once per loop, into a console the component embed
		system already floods.
	**/
	public static inline function checkNullIteratee<T>(v:Null<T>, ?pos:haxe.PosInfos):Bool {
		return v != null;
	}

	static function reportNullIteratee(pos:haxe.PosInfos) {
		haxe.Log.trace("FIXME: Null value passed as an iteratee for for-in/for-each expression!", pos);
	}

	public static inline function escape(s:String):String {
		#if flash
		return untyped __global__["escape"](s);
		#else
		return js.Lib.global.escape(s);
		#end
	}

	/**
		A Flash global function, by name.
		
		ax3's generated Globals module reaches the Flash player's module-level functions through
		`untyped __global__[name]`, which does not exist off Flash. Each name the client actually
		reaches is given a JS equivalent here; an unimplemented one throws by name rather than
		returning null, because a global that silently does nothing is a worse failure than a
		loud one.
	**/
	public static function globalFunction(name:String):Dynamic {
		#if flash
		return untyped __global__[name];
		#else
		return switch name {
			case "flash.utils.getQualifiedClassName": getQualifiedClassName;
			case "escape": escape;
			case "unescape": unescape;
			case "encodeURIComponent": encodeURIComponent;
			case "decodeURIComponent": decodeURIComponent;
			case "decodeURI": decodeURI;
			case _: throw new haxe.Exception("no JS equivalent for the Flash global " + name);
		};
		#end
	}

	/**
		AS3's flash.utils.getQualifiedClassName.
		
		AS3 spells a qualified name `package::Class`, and callers use it as an identity key --
		Component keys its required dependencies by it. So the separator matters only in that it
		has to match what other AS3 code would produce, and the value has to be stable.
	**/
	public static function getQualifiedClassName(value:Any):String {
		if (value == null) return "null";
		var path = Std.isOfType(value, Class) ? Type.getClassName(cast value) : Type.getClassName(Type.getClass(value));
		if (path == null) return Std.string(value);
		var dot = path.lastIndexOf(".");
		return dot < 0 ? path : path.substr(0, dot) + "::" + path.substr(dot + 1);
	}

	/**
		AS3's String.fromCharCode.

		AS3 converts every argument with ToUint16, so an out-of-range code wraps instead of
		failing: `String.fromCharCode(-1)` is charCode 65535. Haxe compiles its own
		String.fromCharCode to String.fromCodePoint on JS, which throws RangeError on exactly those
		values. `HabboCommunicationManager.getKeyValue` depends on the wrap -- it builds obfuscated
		property names from `65290 - value + index--`, which counts down through zero -- so the
		difference aborts the component graph before the client can connect.

		JavaScript's own String.fromCharCode applies the same ToUint16 conversion AS3 does, which
		makes the native call the faithful one rather than a masked approximation.
	**/
	public static function stringFromCharCode(code:Int):String {
		#if flash
		return String.fromCharCode(code);
		#else
		return js.Syntax.code("String.fromCharCode({0})", code);
		#end
	}

	/**
		AS3's coercion of an XML or XMLList value to String.

		Indexing past the end of an XMLList yields `undefined` in AS3, and assigning that to a
		String gives null rather than failing -- `XMLVariableParser.parseVariableToken` reads
		`k.child(KEY)[0]` exactly that way for tokens that carry no key. Calling toString on
		the absent element instead throws, and the throw escapes into the component graph.

		These are the client's own XML classes, which is what the converter's TTXML/TTXMLList
		resolve to here -- not the compat abstracts.
	**/
	public static inline function xmlToString(value:Null<com.sulake.core.utils.xml.XML>):Null<String> {
		return value == null ? null : value.toString();
	}

	public static inline function xmlListToString(value:Null<com.sulake.core.utils.xml.XMLList>):Null<String> {
		return value == null ? null : value.toString();
	}

	/** AS3 String.split(separator, limit); Haxe's String.split omits `limit`. */
	public static function stringSplit(s:String, delimiter:String, limit:Int):Array<String> {
		if (limit == 0) return [];
		var parts = s.split(delimiter);
		return limit < 0 || parts.length <= limit ? parts : parts.slice(0, limit);
	}

	public static inline function unescape(s:String):String {
		#if flash
		return untyped __global__["unescape"](s);
		#else
		return js.Lib.global.unescape(s);
		#end
	}

	/*
		AS3's URI globals. Haxe's StringTools.urlEncode/urlDecode are not equivalent -- they
		percent-escape characters (`!`, `~`, `*`, `'`) that encodeURIComponent leaves alone, which
		would change the bytes the client puts on the wire. Call the host functions instead, the
		same way escape/unescape above do.
	*/
	public static inline function encodeURIComponent(s:String):String {
		#if flash
		return untyped __global__["encodeURIComponent"](s);
		#else
		return js.Lib.global.encodeURIComponent(s);
		#end
	}

	public static inline function decodeURIComponent(s:String):String {
		#if flash
		return untyped __global__["decodeURIComponent"](s);
		#else
		return js.Lib.global.decodeURIComponent(s);
		#end
	}

	public static inline function decodeURI(s:String):String {
		#if flash
		return untyped __global__["decodeURI"](s);
		#else
		return js.Lib.global.decodeURI(s);
		#end
	}

	/**
		AS3's global `parseInt(text, radix)`.

		`Std.parseInt` has no radix parameter and only recognises a leading `0x` for hex, so
		mapping AS3 calls straight onto it would compile and then silently misread every value the
		client parses in another base -- furniture colours use base 16, floor height maps use
		base 36. Radix 0 or 10 keeps Std.parseInt's own behaviour, including its `0x` handling.
	**/
	public static function parseInt(text:String, ?radix:Int):Null<Int> {
		if (text == null) return null;
		if (radix == null || radix == 0 || radix == 10) return Std.parseInt(text);
		var trimmed = StringTools.trim(text);
		var negative = StringTools.startsWith(trimmed, "-");
		if (negative || StringTools.startsWith(trimmed, "+")) trimmed = trimmed.substr(1);
		if (radix == 16 && trimmed.substr(0, 2).toLowerCase() == "0x") trimmed = trimmed.substr(2);
		var value = 0;
		var any = false;
		for (index in 0...trimmed.length) {
			var digit = digitValue(trimmed.charCodeAt(index));
			// AS3 stops at the first character that is not a digit in this radix and returns what
			// it has, rather than failing. NaN only when nothing at all parsed.
			if (digit == null || digit >= radix) break;
			value = value * radix + digit;
			any = true;
		}
		if (!any) return null;
		return negative ? -value : value;
	}

	static inline function digitValue(code:Null<Int>):Null<Int> {
		if (code == null) return null;
		if (code >= "0".code && code <= "9".code) return code - "0".code;
		if (code >= "a".code && code <= "z".code) return code - "a".code + 10;
		if (code >= "A".code && code <= "Z".code) return code - "A".code + 10;
		return null;
	}

	#if flash
	public static inline function describeType(value:Any):compat.XML {
		return flash.Lib.describeType(value);
	}

	// classObject is Any and not Class<Dynamic>, because in Flash we also want to pass Bool to it
	public static inline function registerClassAlias(aliasName:String, classObject:Any) {
		untyped __global__["flash.net.registerClassAlias"](aliasName, classObject);
	}
	#else
	/**
		Browser replacement for Flash describeType.

		Two callers need different halves of this document. JSONEncoder passes an instance and
		reads the `<variable>` nodes. `ClassUtils.implementsInterface` passes a Class and reads
		`<factory><implementsInterface>`, which is how the client decides whether a message event
		class is legal -- emitting only the first half made that check answer false for every
		class, so `MessageClassManager` rejected the first message it was handed and aborted
		`HabboCommunicationManager.initComponent`, and with it the rest of the component graph.

		AS3 describes instance members under `<factory>` when handed a Class and directly under
		`<type>` when handed an instance, so the two cases stay apart rather than collapsing.
	**/
	public static function describeType(value:Any):com.sulake.core.utils.xml.XML {
		var isClass = Std.isOfType(value, Class);
		var cls:Class<Dynamic> = isClass ? cast value : Type.getClass(value);
		var typeName = cls == null ? "Object" : Type.getClassName(cls);
		var body = new StringBuf();
		if (!isClass) {
			var names:Array<String> = [];
			for (name in Reflect.fields(value)) if (names.indexOf(name) < 0) names.push(name);
			if (cls != null) for (name in Type.getInstanceFields(cls)) {
				if (names.indexOf(name) < 0) names.push(name);
			}
			for (name in names) {
				var member:Dynamic = null;
				try member = Reflect.getProperty(value, name) catch (_:Dynamic) continue;
				if (!Reflect.isFunction(member)) {
					body.add('<variable name="' + escapeXmlAttribute(name) + '"/>');
				}
			}
		}
		var interfaces = new StringBuf();
		for (name in implementedInterfaceNames(cls)) {
			interfaces.add('<implementsInterface type="' + escapeXmlAttribute(name) + '"/>');
		}
		var described = isClass
			? '<factory type="' + escapeXmlAttribute(getQualifiedClassName(value)) + '">'
				+ interfaces.toString() + '</factory>'
			: interfaces.toString();
		return new com.sulake.core.utils.xml.XML('<type name="' + escapeXmlAttribute(typeName)
			+ '">' + body.toString() + described + '</type>');
	}

	/**
		Every interface an instance of `cls` satisfies, spelled the way getQualifiedClassName
		spells them so both sides of an implementsInterface comparison agree.

		AS3 reports these transitively, so this walks the superclass chain and follows interface
		inheritance. The visited check removes duplicates and terminates diamonds.
	**/
	static function implementedInterfaceNames(cls:Class<Dynamic>):Array<String> {
		var found:Array<String> = [];
		var current = cls;
		while (current != null) {
			collectInterfaces(untyped current.__interfaces__, found);
			current = Type.getSuperClass(current);
		}
		return found;
	}

	static function collectInterfaces(list:Array<Dynamic>, found:Array<String>):Void {
		if (list == null) return;
		for (item in list) {
			if (item == null) continue;
			var name = getQualifiedClassName(item);
			if (found.indexOf(name) >= 0) continue;
			found.push(name);
			collectInterfaces(untyped item.__interfaces__, found);
		}
	}

	static function escapeXmlAttribute(value:String):String {
		return StringTools.replace(StringTools.replace(StringTools.replace(
			StringTools.replace(value, "&", "&amp;"), "\"", "&quot;"), "<", "&lt;"), ">", "&gt;");
	}

	public static function pauseForGCIfCollectionImminent(_:Float = 0):Void {
		// Browsers intentionally expose no synchronous garbage-collection request.
	}

	public static function dateToLocaleString(value:Date):String {
		return js.Syntax.code("{0}.toLocaleString()", value);
	}

	public static function dateToLocaleDateString(value:Date):String {
		return js.Syntax.code("{0}.toLocaleDateString()", value);
	}

	/** Flash Sound.extract over Howler's decoded WebAudio buffer. */
	public static function extractSound(sound:Dynamic, output:Dynamic, length:Float, startPosition:Float = 0):Float {
		#if (js && html5)
		var start = Std.int(startPosition);
		var openflBuffer = Reflect.field(sound, "__buffer");
		var howl = openflBuffer == null ? null : Reflect.getProperty(openflBuffer, "src");
		var sounds:Dynamic = howl == null ? null : Reflect.field(howl, "_sounds");
		var first:Dynamic = sounds == null || sounds.length == 0 ? null : sounds[0];
		var node = first == null ? null : Reflect.field(first, "_node");
		var decoded = node == null ? null : Reflect.field(node, "buffer");
		if (decoded == null) return 0;
		var available:Int = Std.int(Reflect.field(decoded, "length")) - start;
		var frames = Std.int(Math.max(0, Math.min(length, available)));
		var getChannel:Dynamic = Reflect.field(decoded, "getChannelData");
		var left:Dynamic = Reflect.callMethod(decoded, getChannel, [0]);
		var channelCount:Int = Std.int(Reflect.field(decoded, "numberOfChannels"));
		var right:Dynamic = channelCount > 1 ? Reflect.callMethod(decoded, getChannel, [1]) : left;
		var writeFloat:Dynamic = Reflect.field(output, "writeFloat");
		for (index in 0...frames) {
			Reflect.callMethod(output, writeFloat, [left[start + index]]);
			Reflect.callMethod(output, writeFloat, [right[start + index]]);
		}
		return frames;
		#else
		return 0;
		#end
	}

	#end

	// int(d), uint(d)
	public static inline function toInt(d:Dynamic):Int {
		#if flash
		return d;
		#else
		return Std.int(toNumber(d));
		#end
	}

	// uint(d). Keep this distinct from int(d): Haxe parses decimal literals above 0x7fffffff as
	// Float, while AS3 coerces them modulo 2^32. The JS bitwise conversion preserves those bits.
	// The parentheses are part of the emitted fragment on purpose: this body is inlined, and
	// js.Syntax.code is printed verbatim, so without them a surrounding operator binds wrong.
	public static inline function toUInt(d:Dynamic):UInt {
		#if flash
		return d;
		#else
		return cast (js.Syntax.code("(Number({0}) >>> 0)", d));
		#end
	}

	// Number(d)
	public static inline function toNumber(d:Dynamic):Float {
		#if flash
		return d;
		#else
		return js.Syntax.code("Number")(d);
		#end
	}

	// Boolean(d)
	public static inline function toBool(d:Dynamic):Bool {
		#if flash
		return d;
		#else
		return js.Syntax.code("Boolean")(d);
		#end
	}

	// String(d)
	public static inline function toString(d:Dynamic):String {
		#if flash
		return d;
		#else
		return js.Syntax.code("String")(d);
		#end
	}

	public static inline function asString(value:Dynamic):String
		return typeOf(value) == "string" ? value : null;
	public static inline function asNumber(value:Dynamic):Float
		return typeOf(value) == "number" ? value : null;
	public static inline function asInt(value:Dynamic):Int
		return typeOf(value) == "number" && Math.isFinite(value) && value == Std.int(value)
			&& value >= -2147483648.0 && value <= 2147483647.0 ? value : null;
	public static inline function asUint(value:Dynamic):UInt
		return typeOf(value) == "number" && Math.isFinite(value) && value == Math.floor(value)
			&& value >= 0 && value <= 4294967295.0 ? value : null;
	public static inline function asBoolean(value:Dynamic):Bool
		return typeOf(value) == "boolean" ? value : null;

	public static inline function as<T>(v:Dynamic, c:Class<T>):T {
		return flash.Lib.as(v, c);
	}

	public static inline function dynamicAs<T>(v:Dynamic, c:Class<T>):T {
		return flash.Lib.as(v, c);
	}

	public static inline function reinterpretAs<T>(v:Dynamic, c:Class<T>):T {
		return flash.Lib.as(v, c);
	}

	public static inline function toExponential(n:Float, ?digits:Int):String {
		return (cast n).toExponential(digits);
	}

	public static inline function toFixed(n:Float, ?digits:Int):String {
		return (cast n).toFixed(digits);
	}

	public static inline function toPrecision(n:Float, precision:Int):String {
		return (cast n).toPrecision(precision);
	}

	public static inline function toRadix(n:Float, radix:Int = 10):String {
		return (cast n).toString(radix);
	}

	// TODO: this is temporary
	public static inline function thisOrDefault<T>(value:T, def:T):T {
		return if ((value : ASAny)) value else def;
	}

	public static inline function stringAsBool(s:Null<String>):Bool {
		return (s : ASAny);
	}

	public static inline function floatAsBool(f:Null<Float>):Bool {
		return (f : ASAny);
	}

	public static inline function intAsBool(i:Null<Int>):Bool {
		return (i : ASAny);
	}

	public static inline function allocArray<T>(length:Int):Array<T> {
		var a = new Array<T>();
		a.resize(length);
		return a;
	}

	public static inline function arraySetLength<T>(a:Array<T>, newLength:Int):Int {
		a.resize(newLength);
		return newLength;
	}

	public static function arrayConcat(source:Array<Dynamic>, value:Dynamic):Array<Dynamic> {
		var result = source.copy();
		if (Std.isOfType(value, Array)) {
			for (item in (cast value : Array<Dynamic>)) result.push(item);
		} else {
			result.push(value);
		}
		return result;
	}

	public static inline function arraySpliceAll<T>(a:Array<T>, startIndex:Int):Array<T> {
		return a.splice(startIndex, a.length);
	}

	public static function arraySplice<T>(a:Array<T>, startIndex:Int, deleteCount:Int, ?values:Array<T>):Array<T> {
		var result = a.splice(startIndex, deleteCount);
		if (values != null) {
			for (i in 0...values.length) {
				a.insert(startIndex + i, values[i]);
			}
		}
		return result;
	}

	public static inline function vectorSpliceAll<T>(a:flash.Vector<T>, startIndex:Int):flash.Vector<T> {
		return a.splice(startIndex, a.length);
	}

	public static function vectorSplice<T>(a:flash.Vector<T>, startIndex:Int, deleteCount:Int, ?values:Array<T>):flash.Vector<T> {
		var result = a.splice(startIndex, deleteCount);
		if (values != null) {
			for (i in 0...values.length) {
				a.insertAt(startIndex + i, values[i]);
			}
		}
		return result;
	}

	public static macro function vectorClass<T>(typecheck:Expr):ExprOf<Class<flash.Vector<T>>>;
	public static macro function asVector<T>(value:Expr, typecheck:Expr):ExprOf<Null<flash.Vector<T>>>;
	public static macro function isVector<T>(value:Expr, typecheck:Expr):ExprOf<Bool>;

	#if !flash
	// Patched for OpenFL 9.5.2: Vector is an abstract, not a runtime class with isVector.
	@:noCompletion public static inline function _asVector<T>(value:Any):Null<flash.Vector<T>> return if (_isVector(value)) cast value else null;
	@:noCompletion public static inline function _isVector(value:Any):Bool return value != null && Reflect.hasField(value, "fixed") && Reflect.hasField(value, "length") && Reflect.hasField(value, "push");

	// Patched for M2: AS3 `is XML` must recognise the XML the port actually carries.
	//
	// Converted code never holds a haxe.Xml -- RewriteE4X rewrites every AS3 XML expression onto
	// com.sulake.core.utils.xml.XML, the E4X shim. Testing only haxe.Xml therefore made `is XML`
	// answer false for every value the client can produce, and XMLValidator's sole type test is
	// this one: checkRequiredAttributes fell through to its XMLList branch, found no match, and
	// returned false for documents whose attributes were all present. That is a silent no --
	// RoomVisualization drops a whole room's planes on it without an error.
	public static inline function isXML(value:Any):Bool
		return Std.isOfType(value, Xml) || Std.isOfType(value, com.sulake.core.utils.xml.XML);
	public static inline function isByteArray(value:Any):Bool return Std.isOfType(value, openfl.utils.ByteArray.ByteArrayData);
	public static inline function asByteArray(value:Any):Null<com.sulake.core.utils.ByteArray> return isByteArray(value) ? cast value : null;
	#end

	public static inline function asFunction(v:Any):Null<ASFunction> {
		return if (Reflect.isFunction(v)) v else null;
	}

	public static macro function setTimeout(closure:ExprOf<haxe.Constraints.Function>, delay:ExprOf<Float>, arguments:Array<Expr>):ExprOf<UInt>;

	public static inline function clearTimeout(id:UInt):Void {
		#if flash
		untyped __global__["flash.utils.clearTimeout"](id);
		#else
		js.Browser.window.clearTimeout(id);
		#end
	}

	public static macro function setInterval(closure:ExprOf<haxe.Constraints.Function>, delay:ExprOf<Float>, arguments:Array<Expr>):ExprOf<UInt>;

	public static inline function clearInterval(id:UInt):Void {
		#if flash
		untyped __global__["flash.utils.clearInterval"](id);
		#else
		js.Browser.window.clearInterval(id);
		#end
	}

	public static macro function processNull<T>(e:ExprOf<Null<T>>):ExprOf<T>;

	public static inline function processNullInt(v:Null<Int>):Int {
		#if flash
		return v;
		#else
		return cast v | 0;
		#end
	}

	public static inline function processNullFloat(v:Null<Float>):Float {
		#if flash
		return v;
		#else
		return js.Syntax.code("Number")(v);
		#end
	}

	public static inline function processNullBool(v:Null<Bool>):Bool {
		#if flash
		return v;
		#else
		return !!v;
		#end
	}
}

class ASArray {
	public static inline final CASEINSENSITIVE = 1;
	public static inline final DESCENDING = 2;
	public static inline final NUMERIC = 16;
	public static inline final RETURNINDEXEDARRAY = 8;
	public static inline final UNIQUESORT = 4;

	public static inline function sort<T>(a:Array<T>, f:Dynamic):Array<T> {
		a.sort(function(left, right) {
			var result:Float = f(left, right);
			return result < 0 ? -1 : (result > 0 ? 1 : 0);
		});
		return a;
	}

	public static function filter<T>(a:Array<T>, callback:(item:T, index:Int, array:Array<T>)->Bool):Array<T> {
		var result = new Array<T>();
		for (index in 0...a.length) if (callback(a[index], index, a)) result.push(a[index]);
		return result;
	}

	/**
		AS3's `Array.sortOn(fieldName, options)`.

		Upstream ax3 ships this as a stub that calls through to the Flash-only method, with a TODO
		saying it exists so JS *compiles*. It does compile, and then throws the moment it runs --
		which is exactly what happened when the converted RoomSpriteCanvas took over the room: it
		sorts its sprite list by depth every frame, threw every frame, and the room stayed black.

		Same shape as sortWithOptions below, but ordering by a named field rather than by the
		elements themselves. RETURNINDEXEDARRAY and UNIQUESORT change what the call returns, so
		they are refused rather than quietly ignored.
	**/
	public static function sortOn<T>(a:Array<T>, fieldName:Dynamic, options:Dynamic):Array<T> {
		var fields:Array<Dynamic> = Std.isOfType(fieldName, Array)
			? cast fieldName : [fieldName];
		var optionList:Array<Dynamic> = Std.isOfType(options, Array)
			? cast options : [options];
		for (option in optionList) {
			var flags = Std.int(option);
			if ((flags & RETURNINDEXEDARRAY) != 0 || (flags & UNIQUESORT) != 0) {
				throw "ASArray.sortOn: RETURNINDEXEDARRAY and UNIQUESORT are not implemented";
			}
		}
		a.sort(function(left, right) {
			for (index in 0...fields.length) {
				var field = Std.string(fields[index]);
				var flags = Std.int(optionList.length == 1 ? optionList[0]
					: (index < optionList.length ? optionList[index] : 0));
				var lf = Reflect.getProperty(left, field);
				var rf = Reflect.getProperty(right, field);
				var result:Int;
				if ((flags & NUMERIC) != 0) {
					var l:Float = ASCompat.toNumber(lf);
					var r:Float = ASCompat.toNumber(rf);
					result = l < r ? -1 : (l > r ? 1 : 0);
				} else {
					var l = lf == null ? "" : Std.string(lf);
					var r = rf == null ? "" : Std.string(rf);
					if ((flags & CASEINSENSITIVE) != 0) {
						l = l.toLowerCase();
						r = r.toLowerCase();
					}
					result = l < r ? -1 : (l > r ? 1 : 0);
				}
				if (result != 0) return (flags & DESCENDING) != 0 ? -result : result;
			}
			return 0;
		});
		return a;
	}

	#if flash
	public static inline function sortWithOptions<T>(a:Array<T>, options:Int):Array<T> {
		return (cast a).sort(options);
	}
	#else
	/**
		AS3's `Array.sort(options)`.

		Added for M2: the guest-room closure needs it -- FurnitureVisualizationData sorts its size
		list with Array.NUMERIC -- and it existed only under `#if flash`.

		RETURNINDEXEDARRAY and UNIQUESORT change what the call *returns* rather than how it
		orders, so quietly ignoring them would hand back a plausible array that is not what the
		caller asked for. Nothing in the corpus uses either; if that changes, this says so.
	**/
	public static function sortWithOptions<T>(a:Array<T>, options:Int):Array<T> {
		if ((options & RETURNINDEXEDARRAY) != 0 || (options & UNIQUESORT) != 0) {
			throw "ASArray.sortWithOptions: RETURNINDEXEDARRAY and UNIQUESORT are not implemented";
		}
		var numeric = (options & NUMERIC) != 0;
		var descending = (options & DESCENDING) != 0;
		var caseInsensitive = (options & CASEINSENSITIVE) != 0;
		a.sort(function(left, right) {
			var result;
			if (numeric) {
				var l:Float = cast left;
				var r:Float = cast right;
				result = l < r ? -1 : (l > r ? 1 : 0);
			} else {
				var l = Std.string(left);
				var r = Std.string(right);
				if (caseInsensitive) {
					l = l.toLowerCase();
					r = r.toLowerCase();
				}
				result = l < r ? -1 : (l > r ? 1 : 0);
			}
			return descending ? -result : result;
		});
		return a;
	}
	#end

	public static macro function pushMultiple<T>(a:ExprOf<Array<T>>, first:ExprOf<T>, rest:Array<ExprOf<T>>):ExprOf<Int>;
	public static macro function unshiftMultiple<T>(a:ExprOf<Array<T>>, first:ExprOf<T>, rest:Array<ExprOf<T>>):ExprOf<Int>;
}


class ASVector {
	public static inline function sort<T>(a:flash.Vector<T>, f:Dynamic):flash.Vector<T> {
		a.sort(function(left, right) {
			var result:Float = f(left, right);
			return result < 0 ? -1 : (result > 0 ? 1 : 0);
		});
		return a;
	}

	#if flash // TODO: implement for other targets
	public static inline function sortWithOptions<T>(a:flash.Vector<T>, options:Int):flash.Vector<T> {
		return (cast a).sort(options);
	}
	#end
}

class ASVectorTools {
	#if flash inline #end
	public static function forEach<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Void):Void {
		#if flash
		(cast v).forEach(callback);
		#else
		for (i in 0...v.length) {
			callback(v[i], i, v);
		}
		#end
	}

	#if flash inline #end
	public static function filter<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Bool):flash.Vector<T> {
		#if flash
		return (cast v).filter(callback);
		#else
		var result = new flash.Vector<T>();
		for (i in 0...v.length) {
			var item = v[i];
			if (callback(item, i, v)) {
				result.push(item);
			}
		}
		return result;
		#end
	}

	#if flash inline #end
	public static function map<T,T2>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->T2):flash.Vector<T2> {
		#if flash
		return (cast v).map(callback);
		#else
		var result = new flash.Vector<T2>(v.length);
		for (i in 0...v.length) {
			result[i] = callback(v[i], i, v);
		}
		return result;
		#end
	}

	#if flash inline #end
	public static function every<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Bool):Bool {
		#if flash
		return (cast v).every(callback);
		#else
		for (i in 0...v.length) {
			if (!callback(v[i], i, v)) {
				return false;
			}
		}
		return true;
		#end
	}

	#if flash inline #end
	public static function some<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Bool):Bool {
		#if flash
		return (cast v).some(callback);
		#else
		for (i in 0...v.length) {
			if (callback(v[i], i, v)) {
				return true;
			}
		}
		return false;
		#end
	}
}

class ASDate {
	public static inline function toDateString(d:Date):String {
		return DateTools.format(Date.fromTime(0), "%a %b %d %Y");
	}

	#if (flash || js) // TODO: implement this for other platforms
	public static inline function setTime(d:Date, millisecond:Float):Float {
		return (cast d).setTime(millisecond);
	}

	public static inline function setDate(d:Date, day:Float):Float {
		return (cast d).setDate(day);
	}

	public static inline function setMonth(d:Date, month:Float, ?day:Float):Float {
		return (cast d).setMonth(month, day);
	}

	public static inline function setHours(d:Date, hour:Int, ?minute:Int, ?second:Int, ?millisecond:Int):Float {
		return (cast d).setHours(hour, minute, second, millisecond);
	}

	public static inline function setMinutes(d:Date, minute:Float, ?second:Float, ?millisecond:Float):Float {
		return (cast d).setMinutes(minute, second, millisecond);
	}

	public static inline function setSeconds(d:Date, second:Float, ?millisecond:Float):Float {
		return (cast d).setSeconds(second, millisecond);
	}

	public static inline function setUTCDate(d:Date, day:Float):Float {
		return (cast d).setUTCDate(day);
	}

	public static inline function setFullYear(d:Date, year:Float, ?month:Float, ?day:Float):Float {
		return (cast d).setFullYear(year, month, day);
	}

	public static inline function setUTCFullYear(d:Date, year:Float, ?month:Float, ?day:Float):Float {
		return (cast d).setUTCFullYear(year, month, day);
	}

	public static inline function setUTCHours(d:Date, hour:Float, ?minute:Float, ?second:Float, ?millisecond:Float):Float {
		return (cast d).setUTCHours(hour, minute, second, millisecond);
	}

	public static inline function getUTCMilliseconds(d:Date):Float {
		return (cast d).getUTCMilliseconds();
	}

	public static inline function setUTCMilliseconds(d:Date, millisecond:Float):Float {
		return (cast d).setUTCMilliseconds(millisecond);
	}

	public static inline function setUTCMinutes(d:Date, minute:Float, ?second:Float, ?millisecond:Float):Float {
		return (cast d).setUTCMinutes(minute, second, millisecond);
	}

	public static inline function setUTCMonth(d:Date, month:Float, ?day:Float):Float {
		return (cast d).setUTCMonth(month, day);
	}

	public static inline function setUTCSeconds(d:Date, second:Float, ?millisecond:Float):Float {
		return (cast d).setUTCSeconds(second, millisecond);
	}
	#end
}
