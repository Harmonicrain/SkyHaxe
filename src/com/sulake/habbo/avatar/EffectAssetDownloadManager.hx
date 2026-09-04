package com.sulake.habbo.avatar;

#if html5
/**
 * Boundary for optional avatar-effect downloads.
 *
 * The AS3 implementation loads `hh_human_fx_*` SWFs through Flash's AssetLoaderStruct stack.
 * SkyHaxe's first avatar milestone is the ordinary standing figure, which never asks for an
 * effect. Keeping this explicit seam prevents that optional downloader from dragging the Flash
 * component/loader runtime into the compositor closure. Effects remain deliberately unavailable
 * until their SWFs are connected through SwfAssetLibrary.
 */
class EffectAssetDownloadManager {
    public function new() {}

    public function isReady(effectId:Int):Bool {
        return effectId <= 0;
    }

    public function _Str_1914(effectId:Int, listener:_Str_936):Void {
        throw 'Avatar effect $effectId was requested before the HTML5 effect-library path exists';
    }
}
#end
