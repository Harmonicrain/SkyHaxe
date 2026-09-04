package com.sulake.core;

import js.Browser;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

/**
 * Error reporting seam.
 *
 * The AS3 `Core` is the component runtime: it owns the context, the component registry, the
 * profiler and the SWF loader, and it is 900 lines of machinery SkyHaxe does not use. The avatar
 * closure reaches it for one reason only -- `EventDispatcherWrapper` calls `Core.crash` from its
 * listener error handler, and `AvatarStructureDownload` calls `Core.error` when its download
 * fails. Converting the real class to satisfy four call sites would drag the whole runtime, its
 * profiler and the vendored FZip zip reader into the port.
 *
 * So this is the reporting half, and only that. `purge` is a no-op rather than a lie about
 * releasing caches: nothing in SkyHaxe registers with a Core to be purged, so there is nothing to
 * release, and a silent no-op that pretends otherwise would be worse than an honest one.
 */
class Core {
    public static var instance(default, null):Core = new Core();
    public var displayObjectContainer(default, null):DisplayObjectContainer;

    public function new() {
        displayObjectContainer = new Sprite();
    }
    /** Matches the AS3 constant; AvatarStructureDownload passes it to error(). */
    public static inline var ERROR_CATEGORY_DOWNLOAD_CONFIGURATION:Int = 1;

    public static function error(message:String, fatal:Bool, category:Int = -1,
            cause:Dynamic = null):Void {
        var text = 'SKYHAXE_CORE_ERROR category=$category fatal=$fatal: $message';
        if (fatal) Browser.console.error(text, cause);
        else Browser.console.warn(text, cause);
    }

    public static function crash(message:String, errorId:Int, cause:Dynamic = null):Void {
        Browser.console.error('SKYHAXE_CORE_CRASH id=$errorId: $message', cause);
    }

    /** No-op: SkyHaxe has no component registry holding purgeable caches. */
    public static function purge():Void {}
}
