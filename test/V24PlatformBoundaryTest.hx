class V24PlatformBoundaryTest {
    static function main() {
        if (com.sulake.habbo.utils.HabboWebTools.isAirMobile) throw "HTML5 marked as AIR mobile";
        if (com.sulake.habbo.android.AndroidRoomGestureController.create(null, null) != null)
            throw "Original AIR controller must be absent on HTML5";
        if ((openfl.events.GesturePhase.BEGIN : String) != "begin" || (openfl.events.GesturePhase.END : String) != "end")
            throw "Gesture vocabulary changed";
        var rejected = false;
        try { new openfl.events.TransformGestureEvent(openfl.events.TransformGestureEvent.GESTURE_ZOOM); }
        catch (error:openfl.errors.IllegalOperationError) { rejected = true; }
        if (!rejected) throw "Unsupported AIR gesture must fail explicitly";
        js.Browser.document.body.textContent = "V24_PLATFORM_PASS";
    }
}
