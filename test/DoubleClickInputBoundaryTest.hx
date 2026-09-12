import com.sulake.core.window.utils.MouseEventQueue;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;

/** Verifies the OpenFL-to-Flash double-click event-order boundary used by the full client. */
class DoubleClickInputBoundaryTest extends openfl.display.Sprite {
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, run);
    }

    function run(_:Event):Void {
        try {
            verify();
            js.Browser.document.body.textContent = "DOUBLE_CLICK_INPUT_PASS";
        } catch (error:Dynamic) {
            js.Browser.document.body.textContent = "DOUBLE_CLICK_INPUT_FAIL " + Std.string(error);
        }
    }

    function verify():Void {
        var dispatcher = new EventDispatcher();
        var queue = new MouseEventQueue(dispatcher);
        var input = [
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.CLICK,
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.CLICK,
            MouseEvent.DOUBLE_CLICK
        ];
        for (type in input) {
            var event = new MouseEvent(type, false, false, 12, 34);
            @:privateAccess event.stageX = 56;
            @:privateAccess event.stageY = 78;
            dispatcher.dispatchEvent(event);
        }

        var expected = [
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.CLICK,
            MouseEvent.MOUSE_DOWN,
            MouseEvent.MOUSE_UP,
            MouseEvent.DOUBLE_CLICK
        ];
        queue.begin();
        for (type in expected) {
            var event:MouseEvent = cast queue.next();
            if (event == null || event.type != type)
                throw 'Expected $type, got ${event == null ? "null" : event.type}';
        }
        if (queue.next() != null) throw "Second click was not removed";
        queue.dispose();
    }
}
