class V9FurnitureStateSemanticsTest {
    static var assertions:Int = 0;

    public static function main():Void {
        var values = new ASDictionary<ASAny, ASAny>();
        var key = "furniture_automatic_state_index";

        equal(false, values.exists(key), "automatic state starts absent");
        assertTrue(js.Syntax.strictEq(values[key], js.Syntax.code("undefined")),
            "absent Dictionary lookup has Flash undefined semantics");
        assertTrue(Math.isNaN(js.Syntax.code("Number")(values[key])),
            "absent numeric model value remains NaN");

        values[key] = 2;
        equal(true, values.exists(key), "automatic state becomes present");
        equal(2.0, js.Syntax.code("Number")(values[key]),
            "present automatic state retains its number");

        trace('V9_FURNITURE_STATE_SEMANTICS_PASS assertions=$assertions');
    }

    static function assertTrue(value:Bool, message:String):Void {
        assertions++;
        if (!value) throw new haxe.Exception(message);
    }

    static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (expected != actual) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }
}
