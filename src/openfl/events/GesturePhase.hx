package openfl.events;

/** AIR event vocabulary; HTML5 does not synthesize AIR gestures. */
enum abstract GesturePhase(String) to String {
    var ALL = "all";
    var BEGIN = "begin";
    var END = "end";
    var UPDATE = "update";
}
