@:callable // TODO it's a bit unsafe because @:callable takes and returns Dynamic, not ASAny
           // I'm not sure how much can we do about it, maybe wrap the TTAny arguments and the return value in ASAny on the converter level?
abstract ASAny(Dynamic)
	from Dynamic
{
	public inline function new() this = cast {};

	@:noCompletion
	public inline function ___keys() {
		#if flash
		return new NativePropertyIterator<ASAny>(this);
		#else
		return (cast this : haxe.DynamicAccess<ASAny>).keys();
		#end
	}

	@:to public inline function iterator() {
		#if flash
		return new NativeValueIterator<ASAny>(this);
		#else
		return (cast this : haxe.DynamicAccess<ASAny>).iterator();
		#end
	}

	public function hasOwnProperty(name:String):Bool {
		if (Reflect.hasField(this, name)) {
			return true;
		}
		var clazz = Type.getClass(this);
		if (clazz != null) {
			var fields = Type.getInstanceFields(clazz);
			return fields.indexOf(name) > -1 || fields.indexOf("get_" + name) > -1 || fields.indexOf("set_" + name) > -1;
		}
		return false;
	}

	#if flash
	@:to public function ___toString():String return cast this;
	@:to function ___toBool():Bool return cast this;
	@:to function ___toFloat():Float return cast this;
	@:to function ___toInt():Int return cast this;
	#elseif js
	@:to public inline function ___toString():String return if (this == null) null else "" + this;
	@:to inline function ___toBool():Bool return js.Syntax.code("Boolean")(this);
	@:to inline function ___toFloat():Float return js.Syntax.code("Number")(this);
	@:to inline function ___toInt():Int return Std.int(___toFloat());
	#else
	@:to function ___toBool():Bool {
		if (this == null) {
			return false;
		}
		if (Std.is(this, Float)) {
			var v:Float = cast this;
			return v != 0 && !Math.isNaN(v);
		}
		return cast this;
	}

	@:to function ___toFloat():Float {
		throw "TODO";
	}

	@:to function ___toInt():Int {
		if (this == null) {
			return 0;
		}
		if (Std.is(this, Int)) {
			return cast this;
		}
		if (Std.is(this, Float)) {
			var v:Float = cast this;
			return if (Math.isNaN(v)) 0 else Std.int(v);
		}
		if (Std.is(this, String)) {
			var i = Std.parseInt(cast this);
			return if (i == null) 0 else i;
		}
		if (Std.is(this, Bool)) {
			return if (cast this) 1 else 0;
		}
		return 0;
	}
	#end

	@:to inline function ___toOther():Dynamic {
		return this;
	}

	// use use native equality check, because AS3 and JS behave the same
	// but if we want to build for other targets, we gotta implement the loose equality crap
	// (or not, because there should be no ASAny in the final code)
	@:op(a == b) inline function ___eq(that:Dynamic):Bool return this == that;
	@:op(a != b) inline function ___neq(that:Dynamic):Bool return this != that;

	@:op(a.b) inline function ___get(name:String):ASAny return ASAny.getPropertyOrBoundMethod(this, name);

	#if flash inline #end
	public static function getPropertyOrBoundMethod(obj:Any, name:String):ASAny {
		#if flash
		return Reflect.getProperty(obj, name);
		#else
		var value:Dynamic = Reflect.getProperty(obj, name);
		if (Reflect.isFunction(value))
			return value.bind(obj); // TODO: maybe we should (ab)use Haxe/JS $bind here for caching the bound methods?
		else
			return value;
		#end
	}

	@:op(a.b) function ___set(name:String, value:ASAny):ASAny {
		Reflect.setProperty(this, name, value);
		return value;
	}

	@:op(!a) function __not():Bool {
		return !___toBool();
	}

	@:op(a || b) static inline function __orBool(a:Bool, b:ASAny):ASAny {
		return if (a) a else b;
	}

	@:op(a || b) static inline function __or(a:ASAny, b:ASAny):ASAny {
		return if (a.___toBool()) a else b;
	}

	@:op(a && b) static inline function __andBool(a:Bool, b:ASAny):ASAny {
		return if (a) b else a;
	}

	@:op(a && b) static inline function __and(a:ASAny, b:ASAny):ASAny {
		return if (a.___toBool()) b else a;
	}

	// TODO: this (with Dynamic) will only really work on JS and Flash, but oh well
	@:op(a - b) static inline function ___subAny(a:ASAny, b:ASAny):ASAny return (a:Dynamic) - (b:Dynamic);
	@:op(a + b) static inline function ___addAny(a:ASAny, b:ASAny):ASAny return (a:Dynamic) + (b:Dynamic);
	@:op(a / b) static inline function ___divAny(a:ASAny, b:ASAny):ASAny return (a:Dynamic) / (b:Dynamic);
	@:op(a * b) static inline function ___mulAny(a:ASAny, b:ASAny):ASAny return (a:Dynamic) * (b:Dynamic);

	// Patched for M2: see evidence/m2_patch_ax3.py
	//
	// The four above cover dynamic-on-dynamic, but the client mixes freely -- `(_local_7 -
	// _local_3) / 255` in AvatarDataContainer, `(k.totalMemory - k.freeMemory) / 1024` in
	// PurgeTrigger -- so the mixed forms and `%` are needed too. Deferring to Dynamic keeps AS3
	// semantics: both languages coerce with ToNumber on the target.
	@:op(a % b) static inline function ___modAny(a:ASAny, b:ASAny):ASAny return (a:Dynamic) % (b:Dynamic);

	@:op(a - b) static inline function ___subF(a:ASAny, b:Float):Float return a.___toFloat() - b;
	@:op(a / b) static inline function ___divF(a:ASAny, b:Float):Float return a.___toFloat() / b;
	@:op(a * b) static inline function ___mulF(a:ASAny, b:Float):Float return a.___toFloat() * b;
	@:op(a % b) static inline function ___modF(a:ASAny, b:Float):Float return a.___toFloat() % b;

	@:op(a - b) static inline function ___subF2(a:Float, b:ASAny):Float return a - b.___toFloat();
	@:op(a / b) static inline function ___divF2(a:Float, b:ASAny):Float return a / b.___toFloat();
	@:op(a * b) static inline function ___mulF2(a:Float, b:ASAny):Float return a * b.___toFloat();
	@:op(a % b) static inline function ___modF2(a:Float, b:ASAny):Float return a % b.___toFloat();

	// `+` stays dynamic in the mixed cases: AS3 decides concat vs addition at runtime from the
	// operand's actual type, and so does the target. Forcing Float here would turn a string
	// concatenation into NaN.
	@:op(a + b) static inline function ___addF(a:ASAny, b:Float):ASAny return (a:Dynamic) + b;
	@:op(a + b) static inline function ___addF2(a:Float, b:ASAny):ASAny return a + (b:Dynamic);
	@:op(a + b) static inline function ___addS(a:ASAny, b:String):ASAny return (a:Dynamic) + b;
	@:op(a + b) static inline function ___addS2(a:String, b:ASAny):ASAny return a + (b:Dynamic);

	@:op(a > b) static function ___gt(a:ASAny, b:Float):Bool return a.___toFloat() > b;
	@:op(a < b) static function ___lt(a:ASAny, b:Float):Bool return a.___toFloat() < b;
	@:op(a >= b) static function ___gte(a:ASAny, b:Float):Bool return a.___toFloat() >= b;
	@:op(a <= b) static function ___lte(a:ASAny, b:Float):Bool return a.___toFloat() <= b;

	@:op(a > b) static function ___gt2(a:Float, b:ASAny):Bool return a > b.___toFloat();
	@:op(a < b) static function ___lt2(a:Float, b:ASAny):Bool return a < b.___toFloat();
	@:op(a >= b) static function ___gte2(a:Float, b:ASAny):Bool return a >= b.___toFloat();
	@:op(a <= b) static function ___lte2(a:Float, b:ASAny):Bool return a <= b.___toFloat();

	@:op([]) inline function ___arrayGet(name:ASAny):ASAny return ___get(name);
	@:op([]) inline function ___arraySet(name:ASAny, value:ASAny):ASAny return ___set(name, value);
}
