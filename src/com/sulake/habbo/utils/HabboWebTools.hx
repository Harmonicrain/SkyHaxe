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
