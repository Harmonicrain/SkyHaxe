package com.sulake.core;

import js.Browser;
import openfl.display.DisplayObjectContainer;

/**
 * Error reporting and OpenFL root-display boundary.
 *
 * The AS3 `Core` is the component runtime: it owns the context, the component registry, the
 * profiler and the SWF loader, and it is 900 lines of machinery SkyHaxe does not use. The avatar
 * closure reaches it for one reason only -- `EventDispatcherWrapper` calls `Core.crash` from its
 * listener error handler, and `AvatarStructureDownload` calls `Core.error` when its download
 * fails. Converting the real class to satisfy four call sites would drag the whole runtime, its
 * profiler and the vendored FZip zip reader into the port.
 *
 * The original window motion timer additionally reads the actual OpenFL root/stage here.
 * Registry, SWF loading and animation behavior are not implemented in this boundary.
 * `purge` is a no-op rather than a lie about
 * releasing caches: nothing in SkyHaxe registers with a Core to be purged, so there is nothing to
 * release, and a silent no-op that pretends otherwise would be worse than an honest one.
 */
class Core {
    public static var instance(default, null):Core = new Core();
    /** The real OpenFL root, not a detached placeholder. Access after application boot. */
    public var displayObjectContainer(get, never):DisplayObjectContainer;
    inline function get_displayObjectContainer():DisplayObjectContainer return openfl.Lib.current;

    public function new() {
    }
    /** Matches the AS3 constant; AvatarStructureDownload passes it to error(). */
    public static inline var ERROR_CATEGORY_DOWNLOAD_CONFIGURATION:Int = 1;
    public static inline var ERROR_CATEGORY_DOWNLOAD_LIBRARY:Int = 2;
    public static inline var ERROR_CATEGORY_DOWNLOAD_CRITICAL_ASSET:Int = 3;
    public static inline var ERROR_CATEGORY_DOWNLOAD_LOCALIZATION:Int = 8;
    public static inline var ERROR_CATEGORY_PRODUCT_DATA:Int = 7;
    public static inline var ERROR_CATEGORY_FURNIDATA_DOWNLOAD:Int = 12;
    public static inline var ERROR_CATEGORY_DOWNLOAD_EXTERNAL_VARIABLES:Int = 20;
    public static inline var ERROR_CATEGORY_COMMMUNICATION_INIT:Int = 29;
    public static inline var ERROR_CATEGORY_CONNECT_TO_PROXY:Int = 30;

    public static function error(message:String, fatal:Bool, category:Int = -1,
            cause:Dynamic = null):Void {
        var text = 'SKYHAXE_CORE_ERROR category=$category fatal=$fatal: $message';
        if (fatal) Browser.console.error(text, cause);
        else Browser.console.warn(text, cause);
    }

    public static function crash(message:String, errorId:Int, cause:Dynamic = null):Void {
        Browser.console.error('SKYHAXE_CORE_CRASH id=$errorId: $message', cause);
    }

    public static function warning(message:String):Void {
        Browser.console.warn(message);
    }

    public static function debug(message:String):Void {
        Browser.console.debug(message);
    }

    private var _hibernating = false;
    public function hibernate(level:Int, duration:Int = 1):Void {
        _hibernating = true;
    }
    public function resume():Void {
        _hibernating = false;
    }

    /** No-op: SkyHaxe has no component registry holding purgeable caches. */
    public static function purge():Void {}
}
