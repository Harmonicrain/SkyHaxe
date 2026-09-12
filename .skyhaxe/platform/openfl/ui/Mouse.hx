package openfl.ui;

#if !flash
#if html5
import haxe.crypto.Base64;
import js.Browser;
import js.html.CanvasElement;
import openfl.display.PNGEncoderOptions;
#end
#if lime
import lime.app.Application;
import lime.ui.MouseCursor as LimeMouseCursor;
#end

/**
	The methods of the Mouse class are used to hide and show the mouse pointer,
	or to set the pointer to a specific style. The Mouse class is a top-level
	class whose properties and methods you can access without using a
	constructor. The pointer is visible by default,
	but you can hide it and implement a custom pointer.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Stage)
@:final class Mouse
{
	/**
		Sets or returns the type of cursor, or, for a native cursor, the
		cursor name.
		The default value is `openfl.ui.MouseCursor.AUTO`.

		To set values for this property, use the following string values:

		| String value | Description |
		| --- | --- |
		| `openfl.ui.MouseCursor.AUTO` | Mouse cursor will change automatically based on the object under the mouse. |
		| `openfl.ui.MouseCursor.ARROW` | Mouse cursor will be an arrow. |
		| `openfl.ui.MouseCursor.BUTTON` | Mouse cursor will be a button clicking hand. |
		| `openfl.ui.MouseCursor.HAND` | Mouse cursor will be a dragging hand. |
		| `openfl.ui.MouseCursor.IBEAM` | Mouse cursor will be an I-beam. |

		**Note:** For Flash Player 10.2 or AIR 2.6 and later versions, this
		property sets or gets the cursor name when you are using a native
		cursor. A native cursor name defined using `Mouse.registerCursor()`
		overwrites currently predefined cursor types (such as
		`openfl.ui.MouseCursor.IBEAM`).

		@throws ArgumentError If set to any value which is not a member of
							  `openfl.ui.MouseCursor`, or is not a string
							  specified using the `Mouse.registerCursor()`
							  method.
	**/
	public static var cursor(get, set):MouseCursor;

	/**
		Indicates whether the computer or device displays a persistent cursor.

		The `supportsCursor` property is `true` on most desktop computers and
		`false` on most mobile devices.

		**Note:** Mouse events can be dispatched whether or not this property
		is `true`. However, mouse events may behave differently depending on
		the physical characteristics of the pointing device.
	**/
	public static var supportsCursor(default, null):Bool = #if !mobile true; #else false; #end

	/**
		Indicates whether the current configuration supports native cursors.
	**/
	public static var supportsNativeCursor(default, null):Bool = #if !mobile true; #else false; #end

	@:noCompletion private static var __cursor:MouseCursor = MouseCursor.AUTO;

	@:noCompletion private static var __hidden:Bool;
	@:noCompletion private static var __customCursors:Map<String, String> = new Map();

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Mouse, "cursor", {
			get: function()
			{
				return Mouse.get_cursor();
			},
			set: function(value)
			{
				return Mouse.set_cursor(value);
			}
		});
	}
	#end

	/**
		Hides the pointer. The pointer is visible by default.

		**Note:** You need to call `Mouse.hide()` only once,
		regardless of the number of previous calls to
		`Mouse.show()`.

	**/
	public static function hide():Void
	{
		__hidden = true;

		#if lime
		for (window in Application.current.windows)
		{
			window.cursor = null;
		}
		#end
	}


	/** Register the first Flash native-cursor frame as an HTML5 CSS cursor. */
	public static function registerCursor(name:String, cursor:MouseCursorData):Void
	{
		if (name == null || cursor == null || cursor.data == null || cursor.data.length == 0)
			throw new haxe.Exception("A custom cursor requires a name and bitmap frame");
		#if html5
		var frame = cursor.data[0];
		var png = frame.encode(frame.rect, new PNGEncoderOptions());
		var encoded = Base64.encode(cast png);
		var x = cursor.hotSpot == null ? 0 : Std.int(cursor.hotSpot.x);
		var y = cursor.hotSpot == null ? 0 : Std.int(cursor.hotSpot.y);
		__customCursors.set(name, 'url("data:image/png;base64,$encoded") $x $y, auto');
		#else
		throw new haxe.Exception("Custom bitmap cursors are only available on the HTML5 target");
		#end
	}


	/**
		Displays the pointer. The pointer is visible by default.

		**Note:** You need to call `Mouse.show()` only once,
		regardless of the number of previous calls to
		`Mouse.hide()`.

	**/
	public static function show():Void
	{
		__hidden = false;

		var cacheCursor = __cursor;
		__cursor = null;
		cursor = cacheCursor;
	}


	public static function unregisterCursor(name:String):Void
	{
		if (__cursor == name) cursor = MouseCursor.AUTO;
		__customCursors.remove(name);
	}

	// Get & Set Methods
	@:noCompletion private static function get_cursor():MouseCursor
	{
		return __cursor;
	}

	@:noCompletion private static function set_cursor(value:MouseCursor):MouseCursor
	{
		if (value == null) value = AUTO;


		#if html5
		if (__customCursors.exists(cast value))
		{
			var canvas:CanvasElement = cast Browser.document.querySelector("canvas");
			if (canvas != null) canvas.style.cursor = __customCursors.get(cast value);
			return __cursor = value;
		}
		#end

		#if lime
		var setCursor:LimeMouseCursor = null;

		switch (value)
		{
			case MouseCursor.ARROW:
				setCursor = ARROW;
			case MouseCursor.BUTTON:
				setCursor = POINTER;
			case MouseCursor.HAND:
				setCursor = MOVE;
			case MouseCursor.IBEAM:
				setCursor = TEXT;
			case MouseCursor.__CROSSHAIR:
				setCursor = CROSSHAIR;
			case MouseCursor.__CUSTOM:
				setCursor = CUSTOM;
			case MouseCursor.__RESIZE_NESW:
				setCursor = RESIZE_NESW;
			case MouseCursor.__RESIZE_NS:
				setCursor = RESIZE_NS;
			case MouseCursor.__RESIZE_NWSE:
				setCursor = RESIZE_NWSE;
			case MouseCursor.__RESIZE_WE:
				setCursor = RESIZE_WE;
			case MouseCursor.__WAIT:
				setCursor = WAIT;
			case MouseCursor.__WAIT_ARROW:
				setCursor = WAIT_ARROW;
			default:
		}

		if (setCursor != null && !__hidden)
		{
			for (window in Application.current.windows)
			{
				window.cursor = setCursor;
			}
		}
		#end

		return __cursor = value;
	}
}
#else
typedef Mouse = flash.ui.Mouse;
#end
