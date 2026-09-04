package com.sulake.habbo.avatar;

#if html5
import com.sulake.core.Core;
import com.sulake.core.assets.AssetLibraryCollection;
import com.sulake.core.assets.IAssetLibrary;
import com.sulake.core.assets.swf.SwfAssetLibrary;
import com.sulake.core.runtime.events.EventDispatcherWrapper;
import openfl.events.Event;

/**
 * One avatar asset library -- `hh_human_body`, `hh_human_shirt`, and so on -- fetched and made
 * available under the names the compositor asks for.
 *
 * This is the download seam. The AS3 class does the same job through `LibraryLoader`, which unzips
 * the SWF with a vendored copy of FZip and hands it to the Flash player to run; the port reads the
 * container directly with `SwfFile`, so following the AS3 here would have dragged a zip decoder
 * and the whole component runtime into the avatar closure for no benefit.
 *
 * What is kept exactly is the shape the generated `AvatarAssetDownloadManager` compiles against
 * and depends on: the constructor arguments, `startDownloading`, `libraryName`, `isReady`, and an
 * `Event.COMPLETE` when the library is ready. The manager tracks which parts are still missing by
 * listening for that event, so dispatching it at the wrong time would stall the queue.
 *
 * The URL is built the way the AS3 built it, from `flash.dynamic.avatar.download.url` and the
 * `%libname%`/`%revision%` template in `flash.dynamic.avatar.download.name.template`.
 */
class AvatarAssetDownloadLibrary extends EventDispatcherWrapper {
    static inline var STATE_IDLE = 0;
    static inline var STATE_LOADING = 1;
    static inline var STATE_READY = 2;

    public var libraryName(get, never):String;
    public var isReady(get, never):Bool;

    final _libraryName:String;
    final _revision:String;
    final _downloadUrl:String;
    final _assets:IAssetLibrary;
    var _state:Int;

    public function new(libraryName:String, revision:String, downloadUrl:String,
            assets:IAssetLibrary, nameTemplate:String) {
        super();
        _state = STATE_IDLE;
        _assets = assets;
        _libraryName = Std.string(libraryName);
        _revision = Std.string(revision);
        _downloadUrl = StringTools.replace(
            StringTools.replace(downloadUrl + nameTemplate, "%libname%", _libraryName),
            "%revision%", _revision);

        // Already registered by an earlier request for a different part in the same library.
        var collection = collectionOf(assets);
        if (collection != null && collection.getAssetLibrary(_libraryName) != null) {
            _state = STATE_READY;
        }
    }

    function get_libraryName():String return _libraryName;
    function get_isReady():Bool return _state == STATE_READY;

    public function startDownloading():Void {
        if (_state == STATE_READY) {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }
        _state = STATE_LOADING;
        SwfAssetLibrary.load(_libraryName, _downloadUrl, function(library) {
            var collection = collectionOf(_assets);
            if (collection != null) collection.addAssetLibrary(library);
            _state = STATE_READY;
            dispatchEvent(new Event(Event.COMPLETE));
        }, function(error) {
            // Left in STATE_LOADING deliberately: the library is not ready, and reporting it ready
            // would let the manager render an avatar with missing parts and no explanation.
            Core.error('Could not load avatar asset library $_libraryName from $_downloadUrl: '
                + Std.string(error), false, Core.ERROR_CATEGORY_DOWNLOAD_CONFIGURATION);
        });
    }

    static function collectionOf(assets:IAssetLibrary):Null<AssetLibraryCollection> {
        return Std.downcast(cast assets, AssetLibraryCollection);
    }

    public function toString():String {
        return _libraryName + (isReady ? "[x]" : "[ ]");
    }
}
#end
