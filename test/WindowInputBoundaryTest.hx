import com.sulake.core.window.utils.MouseEventQueue;
import com.sulake.core.window.services.WindowMouseOperator;
import openfl.events.MouseEvent;

@:access(com.sulake.core.window.services.WindowMouseOperator)
class WindowInputBoundaryTest extends openfl.display.Sprite {
    public function new() {
        super();
        addEventListener(openfl.events.Event.ADDED_TO_STAGE, run);
    }
    function run(_):Void {
        try { verify(); } catch (error:Dynamic) {
            js.Browser.document.body.textContent = "WINDOW_INPUT_FAIL " + Std.string(error);
        }
    }
    function verify():Void {
        var dictionary = new ASDictionary<Dynamic, Dynamic>();
        var identity = {};
        dictionary["1"] = "string";
        dictionary[1] = "number";
        dictionary[identity] = "object";
        dictionary["__proto__"] = null;
        dictionary["1"] = "updated";
        if (dictionary[1] != "number" || dictionary["1"] != "updated"
            || dictionary[identity] != "object" || !dictionary.exists("__proto__"))
            throw "Indexed dictionary key semantics changed";
        if (!Math.isNaN(ASCompat.toNumber(dictionary["missing"])))
            throw "Dictionary missing key must remain undefined";
        var keys = [for (key in dictionary.keys()) key];
        if (keys.length != 4 || keys[0] != "1" || keys[2] != identity)
            throw "Dictionary update changed enumeration order";
        dictionary.remove("1");
        if (dictionary.exists("1")) throw "Dictionary index retained deleted key";
        dictionary["1"] = "reinserted";
        if (dictionary["1"] != "reinserted") throw "Dictionary reinsertion failed";
        if (ASCompat.toInt(ASCompat.parseInt("0xff418db0", 16)) != 0xff418db0
            || ASCompat.parseInt("-0X10", 16) != -16
            || ASCompat.parseInt("ff", 16) != 255
            || ASCompat.parseInt("10z", 16) != 16)
            throw "Hex prefix, sign or partial parsing regression";
        var dispatcher = new openfl.events.EventDispatcher();
        var queue = new MouseEventQueue(dispatcher);
        var original = new MouseEvent(MouseEvent.MOUSE_DOWN, false, false, 12, 34);
        @:privateAccess original.stageX = 56;
        @:privateAccess original.stageY = 78;
        dispatcher.dispatchEvent(original);
        var stageX = original.stageX;
        var stageY = original.stageY;
        original.localX = 999;
        original.localY = 999;
        queue.begin();
        var retained:MouseEvent = cast queue.next();
        if (retained == original || retained.localX != 12 || retained.localY != 34
            || retained.stageX != stageX || retained.stageY != stageY)
            throw 'Queued mouse event was not snapshotted: ${retained.stageX},${retained.stageY} vs $stageX,$stageY';
        queue.dispose();

        // OpenFL emits the second CLICK immediately before DOUBLE_CLICK. Flash's Habbo window
        // processor expects the second release to arrive as DOUBLE_CLICK instead, otherwise the
        // extra CLICK clears lastClickTarget and the double-click is discarded. The boundary
        // queue must remove only that adjacent duplicate and preserve the rest of the sequence.
        var doubleDispatcher = new openfl.events.EventDispatcher();
        var doubleQueue = new MouseEventQueue(doubleDispatcher);
        var types = [
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.CLICK,
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.CLICK,
            MouseEvent.DOUBLE_CLICK
        ];
        for (type in types) {
            var event = new MouseEvent(type, false, false, 12, 34);
            @:privateAccess event.stageX = 56;
            @:privateAccess event.stageY = 78;
            doubleDispatcher.dispatchEvent(event);
        }
        var expected = [
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.CLICK,
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.DOUBLE_CLICK
        ];
        doubleQueue.begin();
        for (type in expected) {
            var event:MouseEvent = cast doubleQueue.next();
            if (event == null || event.type != type)
                throw 'Double-click normalization failed at $type';
        }
        if (doubleQueue.next() != null) throw "Double-click normalization retained the second click";
        doubleQueue.dispose();
        var dragService = new WindowMouseOperator(this);
        if (dragService._root != stage) throw "Drag release is not attached to stage";
        dragService.dispose();
        js.Browser.document.body.textContent = "WINDOW_INPUT_PASS hex-colour event-snapshot double-click stage-release";
    }
}
