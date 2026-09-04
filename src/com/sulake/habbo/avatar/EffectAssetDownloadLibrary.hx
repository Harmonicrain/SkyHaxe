package com.sulake.habbo.avatar;

#if html5
import com.sulake.core.Core;
import com.sulake.core.assets.AssetLibraryCollection;
import com.sulake.core.assets.IAssetLibrary;
import com.sulake.core.assets.swf.SwfAssetLibrary;
import com.sulake.core.runtime.events.EventDispatcherWrapper;
import com.sulake.core.utils.xml.XML;
import openfl.events.Event;

/**
 * One effect library -- a dance, a ride, a costume -- on the same download seam as
 * [AvatarAssetDownloadLibrary], which documents why the AS3 LibraryLoader path is not followed.
 *
 * The one difference is `animation`: an effect SWF carries an animation XML alongside its bitmaps,
 * and the AS3 read it off the loaded SWF's document class, unwrapping either a live XML property
 * or a ByteArray class it had to instantiate. Reading the binary blob straight out of the
 * container gets to the same bytes without a player to run.
 */
class EffectAssetDownloadLibrary extends EventDispatcherWrapper {
    static inline var STATE_IDLE = 0;
    static inline var STATE_LOADING = 1;
    static inline var STATE_READY = 2;

    public var name(get, never):String;
    public var isReady(get, never):Bool;
    public var animation(get, never):Null<XML>;

    final _name:String;
    final _revision:String;
    final _downloadUrl:String;
    final _assets:IAssetLibrary;
    var _state:Int;
    var _animation:Null<XML>;

    public function new(name:String, revision:String, downloadUrl:String, assets:IAssetLibrary,
            nameTemplate:String) {
        super();
        _state = STATE_IDLE;
        _assets = assets;
        _name = Std.string(name);
        _revision = Std.string(revision);
        _downloadUrl = StringTools.replace(
            StringTools.replace(downloadUrl + nameTemplate, "%libname%", _name),
            "%revision%", _revision);
    }

    function get_name():String return _name;
    function get_isReady():Bool return _state == STATE_READY;
    function get_animation():Null<XML> return _animation;

    public function startDownloading():Void {
        if (_state == STATE_READY) {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }
        _state = STATE_LOADING;
        SwfAssetLibrary.load(_name, _downloadUrl, function(library) {
            var collection = Std.downcast(cast _assets, AssetLibraryCollection);
            if (collection != null) collection.addAssetLibrary(library);
            _animation = library.manifest;
            _state = STATE_READY;
            dispatchEvent(new Event(Event.COMPLETE));
        }, function(error) {
            Core.error('Could not load effect asset library $_name from $_downloadUrl: '
                + Std.string(error), false, Core.ERROR_CATEGORY_DOWNLOAD_CONFIGURATION);
        });
    }

    public function toString():String {
        return _name + (isReady ? "[x]" : "[ ]");
    }
}
#end
