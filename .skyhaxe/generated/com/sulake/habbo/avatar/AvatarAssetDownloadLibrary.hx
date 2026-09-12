package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.AssetLibraryCollection;
    import flash.net.URLRequest;
    import com.sulake.core.utils.LibraryLoader;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import com.sulake.core.Core;
    import com.sulake.habbo.utils.HabboWebTools;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

     class AvatarAssetDownloadLibrary extends EventDispatcherWrapper 
    {
        static var STATE_IDLE:Int = 0;
        static var _Str_997:Int = 1;
        static var _Str_599:Int = 2;

        var _state:Int = 0;
        var _libraryName:String;
        var _revision:String;
        var _downloadUrl:String;
        var _assets:IAssetLibrary;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:IAssetLibrary, _arg_5:String)
        {
            super();
            this._state = STATE_IDLE;
            this._assets = _arg_4;
            this._libraryName = k;
            this._revision = _arg_2;
            this._downloadUrl = (_arg_3 + _arg_5);
            this._downloadUrl = ASCompat.stringReplace(this._downloadUrl, "%libname%", this._libraryName);
            this._downloadUrl = ASCompat.stringReplace(this._downloadUrl, "%revision%", this._revision);
            var _local_6= Std.downcast(this._assets , AssetLibraryCollection);
            var _local_7= _local_6.getAssetLibraryByUrl((this._libraryName + ".swf"));
            if (_local_7 != null)
            {
                this._state = _Str_599;
                HabboWebTools.recordAvatarAssetDiagnostic("cached", this._libraryName, this._downloadUrl);
            }
        }

        override public function dispose()
        {
            super.dispose();
        }

        public function startDownloading()
        {
            this._state = _Str_997;
            var k= new URLRequest(this._downloadUrl);
            var _local_3= new LoaderContext(false, new ApplicationDomain(null), null);
            var _local_2= new LibraryLoader(_local_3);
            HabboWebTools.recordAvatarAssetDiagnostic("start", this._libraryName, this._downloadUrl);
            this._assets.loadFromFile(_local_2, true);
            _local_2.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.onLoaderComplete);
            _local_2.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.onLoaderError);
            _local_2.load(k);
        }

        function onLoaderError(k:LibraryLoaderEvent)
        {
            HabboWebTools.recordAvatarAssetDiagnostic("error", this._libraryName, this._downloadUrl, (((("status=" + Std.string(k.status)) + " bytes=") + Std.string(k.bytesLoaded)) + "/") + Std.string(k.bytesTotal));
            Core.error(((((((((("Could not load avatar asset library " + this._libraryName) + " from URL ") + this._downloadUrl) + " HTTP status ") + Std.string(k.status)) + " bytes loaded ") + Std.string(k.bytesLoaded)) + "/") + Std.string(k.bytesTotal)), false, Core.ERROR_CATEGORY_DOWNLOAD_LIBRARY);
        }

        function onLoaderComplete(k:Event)
        {
            var _local_2= ASCompat.dynamicAs(k.target , LibraryLoader);
            _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.onLoaderComplete);
            _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.onLoaderError);
            HabboWebTools.recordAvatarAssetDiagnostic("complete", this._libraryName, this._downloadUrl, (((("bytes=" + Std.string(_local_2.bytesLoaded)) + "/") + Std.string(_local_2.bytesTotal)) + " url=") + _local_2.url);
            this._state = _Str_599;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public var libraryName(get,never):String;
public function  get_libraryName():String
        {
            return this._libraryName;
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._state == _Str_599;
        }

        public function toString():String
        {
            var k= this._libraryName;
            k = (k + (this.isReady ? "[x]" : "[ ]"));
            return k;
        }
    }

