package com.sulake.core.assets.loaders
;
    import flash.media.Sound;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;

     class SoundFileLoader extends AssetLoaderEventBroker implements IAssetLoader 
    {
        var _url:String;
        var _type:String;
        var _soundLoader:Sound;
        var _cacheKey:String;
        var _cacheRevision:Int = 0;
        var _fromCache:Bool = false;
        var _id:Int = 0;

        public function new(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:Int=-1, buffer:com.sulake.core.utils.ByteArray=null, id:Int=-1)
        {
            super();
            this._url = ((urlRequest == null) ? "" : urlRequest.url);
            this._type = type;
            this._soundLoader = new Sound(null, null);
            this._soundLoader.addEventListener(Event.ID3, (loadEventHandler : ASAny));
            this._soundLoader.addEventListener(Event.OPEN, (loadEventHandler : ASAny));
            this._soundLoader.addEventListener(Event.COMPLETE, (loadEventHandler : ASAny));
            this._soundLoader.addEventListener(IOErrorEvent.IO_ERROR, (loadEventHandler : ASAny));
            this._soundLoader.addEventListener(ProgressEvent.PROGRESS, (loadEventHandler : ASAny));
            this._cacheKey = cacheKey;
            this._cacheRevision = cacheRevision;
            this._id = id;
            if (((!(buffer == null)) && (buffer.length > 0)))
            {
                this._fromCache = true;
                this._soundLoader.loadPCMFromByteArray(buffer, buffer.length);
            }
            else
            {
                if (urlRequest != null)
                {
                    this.load(urlRequest);
                }
            }
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return this._url;
        }

        public var content(get,never):ASObject;
public function  get_content():ASObject
        {
            return this._soundLoader;
        }

        public var bytes(get,never):com.sulake.core.utils.ByteArray;
public function  get_bytes():com.sulake.core.utils.ByteArray
        {
            var k= new com.sulake.core.utils.ByteArray();
ASCompat.extractSound(            this._soundLoader, k, this._soundLoader.length);
            return k;
        }

        public var mimeType(get,never):String;
public function  get_mimeType():String
        {
            return this._type;
        }

        public var bytesLoaded(get,never):UInt;
public function  get_bytesLoaded():UInt
        {
            return ASCompat.toUInt((this._soundLoader != null) ? this._soundLoader.bytesLoaded : 0);
        }

        public var bytesTotal(get,never):UInt;
public function  get_bytesTotal():UInt
        {
            return (this._soundLoader != null) ? this._soundLoader.bytesTotal : 0;
        }

        public var cacheKey(get,never):String;
public function  get_cacheKey():String
        {
            return this._cacheKey;
        }

        public var cacheRevision(get,never):Int;
public function  get_cacheRevision():Int
        {
            return this._cacheRevision;
        }

        public var fromCache(get,never):Bool;
public function  get_fromCache():Bool
        {
            return this._fromCache;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._soundLoader.removeEventListener(Event.ID3, (loadEventHandler : ASAny));
                this._soundLoader.removeEventListener(Event.OPEN, (loadEventHandler : ASAny));
                this._soundLoader.removeEventListener(Event.COMPLETE, (loadEventHandler : ASAny));
                this._soundLoader.removeEventListener(IOErrorEvent.IO_ERROR, (loadEventHandler : ASAny));
                this._soundLoader.removeEventListener(ProgressEvent.PROGRESS, (loadEventHandler : ASAny));
                this._soundLoader = null;
                this._type = null;
                this._url = null;
                super.dispose();
            }
        }

        public function load(urlRequest:URLRequest)
        {
            this._url = urlRequest.url;
            this._soundLoader.load(urlRequest, null);
        }
    }

