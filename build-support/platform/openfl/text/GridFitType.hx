package openfl.text;

/**
	Flash-compatible replacement for OpenFL's integer-backed `GridFitType`.

	See `AntiAliasType`: the converted client round-trips this value as a Flash string, and
	`fromString(1)` turned a cloned field's PIXEL into null, which the Habbo HTML5 native
	renderer rejects. String backing makes those round trips an identity.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GridFitType(Null<String>)
{
	public var NONE = "none";
	public var PIXEL = "pixel";
	public var SUBPIXEL = "subpixel";

	@:from private static function fromString(value:String):GridFitType
	{
		return switch (value)
		{
			case "none": NONE;
			case "pixel": PIXEL;
			case "subpixel": SUBPIXEL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return this;
	}
}
