package compat;

import haxe.extern.EitherType;
import haxe.Constraints.Function;

private typedef RegExpImpl = #if js js.lib.RegExp #else flash.utils.RegExp #end;

@:forward(lastIndex)
abstract RegExp(RegExpImpl) {
	public inline function new(pattern, options = "") {
		this = create(pattern, options);
	}

	/**
		AS3 patterns in this corpus carry inline flags -- `new RegExp("(?i).*[.](mp4|flv)")` --
		which JavaScript's engine rejects as an invalid group. Lifting the leading flags into
		real flags keeps those patterns usable instead of throwing the moment they are built.

		It also has to stay a real call rather than an inlined constructor. Closure folds an
		inlined `new RegExp("literal")` into a regex literal, and a literal is validated when
		the script is parsed -- so a single unreachable video-ad pattern took down the whole
		release bundle before `lime` could load, while the debug build ran fine because nothing
		ever executed that line.
	**/
	static function create(pattern:Dynamic, options:String):RegExpImpl {
		if (!Std.isOfType(pattern, String)) return new RegExpImpl(pattern, options);
		var text:String = cast pattern;
		while (StringTools.startsWith(text, "(?")) {
			var close = text.indexOf(")");
			if (close <= 2) break;
			var flags = text.substring(2, close);
			var letters = true;
			for (index in 0...flags.length) {
				var code = flags.charCodeAt(index);
				if (!((code >= 97 && code <= 122) || (code >= 65 && code <= 90))) letters = false;
			}
			if (!letters) break;
			for (index in 0...flags.length) {
				var flag = flags.charAt(index);
				if (options.indexOf(flag) == -1) options += flag;
			}
			text = text.substring(close + 1);
		}
		return new RegExpImpl(text, options);
	}

	public inline function exec(s:String) /*infer the type from `return`*/ {
		return this.exec(s);
	}

	public inline function test(s:String):Bool {
		return this.test(s);
	}

	public inline function match(s:String):Array<String> {
		#if flash
		return (cast s).match(this);
		#else
		var match = (cast s).match(this);
		return if (match == null) [] else match;
		#end
	}

	public inline function search(s:String):Int {
		return (cast s).search(this);
	}

	// TODO: have separate function for String and Function values of `by`?
	public inline function replace(s:String, by:EitherType<String,Function>):String {
		return (cast s).replace(this, by);
	}

	public inline function split(s:String):Array<String> {
		return (cast s).split(this);
	}
}
