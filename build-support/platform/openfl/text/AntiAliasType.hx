package openfl.text;

/**
	Flash-compatible replacement for OpenFL's integer-backed `AntiAliasType`.

	The converted client treats this value as the Flash string it always was. It reads it back
	through `TextController.properties`, stores it in untyped `PropertyStruct`s and `TextStyle`s,
	feeds it to `clone()`, and tests it with `!value`. With OpenFL's `ADVANCED = 0`, every one of
	those round trips failed: `fromString(0)` is null, so a cloned advanced field became NORMAL,
	and `0` is falsy, so an explicit advanced looked unset. Ubuntu at NORMAL is outside the Habbo
	HTML5 native renderer's support, so cloned windows (navigator rows, wired editor views) fell
	back to Canvas text.

	Backing the abstract with the Flash strings makes every round trip an identity. OpenFL itself
	only compares against these constants, which keep their names.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AntiAliasType(Null<String>)
{
	public var ADVANCED = "advanced";
	public var NORMAL = "normal";

	@:from private static function fromString(value:String):AntiAliasType
	{
		return switch (value)
		{
			case "advanced": ADVANCED;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return this;
	}
}
