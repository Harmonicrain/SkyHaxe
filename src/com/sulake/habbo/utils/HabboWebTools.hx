package com.sulake.habbo.utils;

import js.Browser;

/**
 * Browser bridge seam.
 *
 * The AS3 class talks to the page through ExternalInterface -- opening URLs, posting event logs
 * back to Habbo's servers, driving the AIR debug console. The port reaches the two logging calls
 * below, from the asset download managers, and openWebPage, from the billboard furniture's logic.
 *
 * There is no reason to route those anywhere but the browser console yet. When SkyHaxe grows a
 * real event-log destination this is the one place that changes.
 */
class HabboWebTools {
    /** HabboWebTools.as:12 -- the window name an ad opens into. */
    public static inline var ADVERTISEMENT = "advertisement";
    public static inline var OPENLINK = "openlink";
    public static inline var isAirApplication:Bool = false;
    public static var renderAirLoginBackgroundCallback:Null<openfl.display.BitmapData -> Bool>;
    public static var setAirWindowTitleCallback:Null<String -> Void>;
    public static var returnToAirLoginCallback:Null<Void -> Void>;
    public static var reloadAirClientCallback:Null<Void -> Void>;
    static var _isSpaWeb = false;
    public static var isSpaWeb(never, set):Bool;
    static inline function set_isSpaWeb(value:Bool):Bool return _isSpaWeb = value;

    public static function renderAirLoginBackground(target:openfl.display.BitmapData):Bool {
        return renderAirLoginBackgroundCallback != null && renderAirLoginBackgroundCallback(target);
    }

    public static function navigateToURL(url:String, target:String = null):Void {
        Browser.window.open(url, target == null ? "_blank" : target);
    }

    /** Host-page operations remain host-page operations; never invent an in-client habblet. */
    static function hostCall(method:String, args:Array<Dynamic>):Void {
        var host:Dynamic = Reflect.field(Browser.window, "FlashExternalInterface");
        var fn:Dynamic = host == null ? null : Reflect.field(host, method);
        if (!Reflect.isFunction(fn)) {
            Browser.console.warn("SKYHAXE_HOST_UNAVAILABLE " + method);
            return;
        }
        try { Reflect.callMethod(host, fn, args); }
        catch (error:Dynamic) { Browser.console.warn("SKYHAXE_HOST_FAILED " + method); }
    }

    public static function openWebPageAndMinimizeClient(pageUrl:String):Void {
        hostCall("openWebPageAndMinimizeClient", [pageUrl]);
    }

    public static function openHabblet(name:String, param:String = null):Void {
        hostCall("openHabblet", [name, param]);
    }

    public static function closeWebPageAndRestoreClient():Void {
        hostCall("closeWebPageAndRestoreClient", []);
    }

    public static function returnToAirLogin():Void {
        if (reloadAirClientCallback != null) {
            haxe.Timer.delay(reloadAirClientCallback, 1);
        } else if (returnToAirLoginCallback != null) {
            returnToAirLoginCallback();
        } else {
            hostCall("returnToAirLogin", []);
        }
    }

    public static function openAvatars():Void {
        if (_isSpaWeb) hostCall("openAvatars", []);
        else openHabblet("avatars");
    }

    /** Preserve the original SPA/non-SPA host routing used by the converted friend list. */
    public static function openMinimail(target:String):Void {
        if (_isSpaWeb) hostCall("openMinimail", [target]);
        else openHabblet("minimail", target);
    }

    public static function setAirWindowTitleForUser(userName:String):Void {
        if (setAirWindowTitleCallback != null) setAirWindowTitleCallback(userName);
    }

    public static function roomVisited(roomId:Int):Void {
        hostCall("roomVisited", [roomId]);
    }

    public static function updateFigure(figure:String):Void {
        if (_isSpaWeb) hostCall("updateFigure", [figure]);
    }

    /** Browser builds are never the AIR mobile shell. Mirrors the original static flag. */
    public static inline var isAirMobile:Bool = false;

    /**
     * Open a page (HabboWebTools.as:237).
     *
     * The AS3 version picks between ExternalInterface's `window.open`, an IE-specific
     * `setWMWindow` shim and `navigateToURL` by sniffing the user agent, because it is a SWF
     * inside a page and cannot call the browser directly. This runs *as* the page, so the branch
     * the AS3 was choosing between is just `window.open`. The empty-target default is kept.
     */
    public static function openWebPage(url:String, targetWindow:String = ""):Void {
        if (targetWindow == null || targetWindow == "") targetWindow = ADVERTISEMENT;
        Browser.window.open(url, targetWindow);
    }

    public static function logEventLog(data:String):Void {
        Browser.console.info("SKYHAXE_EVENT_LOG " + data);
    }

    public static function airDebug(message:String):Void {
        Browser.console.debug("SKYHAXE_AIR_DEBUG " + message);
    }
}
