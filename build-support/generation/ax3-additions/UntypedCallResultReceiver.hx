package ax3.filters;

/**
	Keep a method bound to its receiver when that receiver is the result of an untyped call.

	Calling an AS3 `Function` (or `*`) value converts to a call on the `@:callable` ASFunction or
	ASAny abstract, and `@:callable` returns plain Dynamic rather than ASAny. A method call on that
	result is then a raw Dynamic field call. When Haxe must hoist the call's arguments into
	temporaries to keep evaluation order, it reads the method into a variable first and calls it
	unbound, so the method runs without `this`:

		var f = this._services.text("gs_bot_name").replace;
		f("%index%", Std.string(-id)); // String.prototype.replace called on null or undefined

	That crashed SnowStorm the moment a bot joined. Retyping the receiver to ASAny routes the
	method read through ASAny.getPropertyOrBoundMethod, which binds it, so any hoisting is safe.
	AS3 always called these methods on their receiver, so this is the faithful translation.
**/
class UntypedCallResultReceiver extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			case TECall(eMethod = {kind: TEField({kind: TOExplicit(dot, receiver = {kind: TECall({type: TTFunction | TTAny}, _), type: TTAny})}, fieldName, fieldToken)}, args):
				var retyped = mk(TEHaxeRetype(receiver.with(expectedType = TTAny)), TTAny, TTAny);
				var method = eMethod.with(kind = TEField({kind: TOExplicit(dot, retyped), type: TTAny}, fieldName, fieldToken));
				e.with(kind = TECall(method, args));
			case _:
				e;
		}
	}
}
