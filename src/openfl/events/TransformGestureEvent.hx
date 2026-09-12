package openfl.events;

/** Type boundary for AIR-only consumers, not a browser gesture implementation.
    AndroidRoomGestureController.create returns null on this target before attaching.
    Fail explicitly if another caller tries to construct an unsupported AIR event. */
class TransformGestureEvent extends Event {
    public static inline var GESTURE_ZOOM = "gestureZoom";
    public var phase(default, null):String;
    public var scaleX(default, null):Float;
    public var scaleY(default, null):Float;
    public var stageX(default, null):Float;
    public var stageY(default, null):Float;

    public function new(type:String) {
        super(type);
        throw new openfl.errors.IllegalOperationError("AIR TransformGestureEvent is unsupported on HTML5; use the non-AIR controller path");
    }
}
