package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.habbo.communication.messages.incoming.moderation.INamed;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.AssetLibraryCollection;
    import flash.net.URLRequest;
    import com.sulake.core.utils.LibraryLoader;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import com.sulake.core.Core;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

     class EffectAssetDownloadLibrary extends EventDispatcherWrapper implements INamed
    {
        static var STATE_IDLE:Int = 0;
        static var _Str_997:Int = 1;
        static var _Str_599:Int = 2;

        var _state:Int = 0;
        var _name:String;
        var _revision:String;
        var _downloadUrl:String;
        var _assets:IAssetLibrary;
        var _animation:com.sulake.core.utils.xml.XML;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:IAssetLibrary, _arg_5:String)
        {
            super();
            this._state = STATE_IDLE;
            this._assets = _arg_4;
            this._name = k;
            this._revision = _arg_2;
            this._downloadUrl = (_arg_3 + _arg_5);
            this._downloadUrl = ASCompat.stringReplace(this._downloadUrl, "%libname%", this._name);
            this._downloadUrl = ASCompat.stringReplace(this._downloadUrl, "%revision%", this._revision);
            var _local_6= Std.downcast(this._assets , AssetLibraryCollection);
            var _local_7= _local_6.getAssetLibraryByUrl((this._name + ".swf"));
            if (_local_7 != null)
            {
                this._state = _Str_599;
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
            this._assets.loadFromFile(_local_2, true);
            _local_2.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.onLoaderComplete);
            _local_2.addEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.onLoaderError);
            _local_2.load(k);
        }

        function onLoaderError(k:LibraryLoaderEvent)
        {
            Core.error(((((((((("Could not load effect asset library " + this._name) + " from URL ") + this._downloadUrl) + " HTTP status ") + Std.string(k.status)) + " bytes loaded ") + Std.string(k.bytesLoaded)) + "/") + Std.string(k.bytesTotal)), false, Core.ERROR_CATEGORY_DOWNLOAD_LIBRARY);
        }

        function onLoaderComplete(k:Event)
        {
            var _local_4:com.sulake.core.utils.ByteArray = null;
            var _local_2= ASCompat.dynamicAs(k.target , LibraryLoader);
            _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this.onLoaderComplete);
            _local_2.removeEventListener(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this.onLoaderError);
            var _local_3:ASObject = ((_local_2.resource : ASObject) ).animation;
            if (ASCompat.isXML(_local_3 ))
            {
                this._animation = ((_local_3 : com.sulake.core.utils.xml.XML) );
            }
            else
            {
                if (Std.is(_local_3 , Class))
                {
                    _local_4 = ASCompat.asByteArray(Type.createInstance(((_local_3 : Class<Dynamic>) ), []) );
                    this._animation = new com.sulake.core.utils.xml.XML(_local_4.readUTFBytes(_local_4.length));
                }
            }
            this._state = _Str_599;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._state == _Str_599;
        }

        public function toString():String
        {
            var k= this._name;
            k = (k + (this.isReady ? "[x]" : "[ ]"));
            return k;
        }

        public var animation(get,never):com.sulake.core.utils.xml.XML;
public function  get_animation():com.sulake.core.utils.xml.XML
        {
            return this._animation;
        }
    }

