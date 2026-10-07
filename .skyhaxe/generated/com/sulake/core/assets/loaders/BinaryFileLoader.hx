package com.sulake.core.assets.loaders
;
    import flash.net.URLLoader;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.net.URLLoaderDataFormat;

     class BinaryFileLoader extends AssetLoaderEventBroker implements IAssetLoader 
    {
        public static inline final CROSS_DOMAIN_XML= "/crossdomain.xml";

        var _url:String;
        var _type:String;
        var _data:ASObject;
        var _loader:URLLoader;
        var _cacheKey:String = null;
        var _cacheRevision:Int = -1;
        var _fromCache:Bool = false;
        var _id:Int = 0;

        public function new(k:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:Int=-1, data:com.sulake.core.utils.ByteArray=null, id:Int=-1)
        {
var timer:Timer  = null;            super();
            this._url = ((urlRequest == null) ? "" : urlRequest.url);
            this._type = k;
            this._loader = new URLLoader();
            this._loader.addEventListener(Event.COMPLETE, (loadEventHandler : ASAny));
            this._loader.addEventListener(Event.UNLOAD, (loadEventHandler : ASAny));
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, (loadEventHandler : ASAny));
            this._loader.addEventListener(ProgressEvent.PROGRESS, (loadEventHandler : ASAny));
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, (loadEventHandler : ASAny));
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.securityErrorEventHandler : ASAny));
            this._cacheKey = cacheKey;
            this._cacheRevision = cacheRevision;
            this._id = id;
            if (((!(data == null)) && (data.length > 0)))
            {
                this._fromCache = true;
                this._data = data;
timer= new Timer(10, 1);
                timer.addEventListener(TimerEvent.TIMER, (this.timerEventHandler : ASAny));
                timer.start();
                return;
            }
            if (urlRequest != null)
            {
                this.load(urlRequest);
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
            return this._data ? this._data : ((this._loader != null) ? this._loader.data : null);
        }

        public var bytes(get,never):com.sulake.core.utils.ByteArray;
public function  get_bytes():com.sulake.core.utils.ByteArray
        {
            return (this._loader != null) ? this._loader.data : null;
        }

        public var mimeType(get,never):String;
public function  get_mimeType():String
        {
            return this._type;
        }

        public var bytesLoaded(get,never):UInt;
public function  get_bytesLoaded():UInt
        {
            return ASCompat.toUInt((this._loader != null) ? this._loader.bytesLoaded : 0);
        }

        public var bytesTotal(get,never):UInt;
public function  get_bytesTotal():UInt
        {
            return ASCompat.toUInt((this._loader != null) ? this._loader.bytesTotal : 0);
        }

        public var fromCache(get,never):Bool;
public function  get_fromCache():Bool
        {
            return this._fromCache;
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

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public function load(urlRequest:URLRequest)
        {
            this._url = urlRequest.url;
            this._data = null;
            _retries = 0;
            this._loader.dataFormat = URLLoaderDataFormat.BINARY;
            this._loader.load(urlRequest);
        }

        override function retry():Bool
        {
            if (!_disposed)
            {
                if (++_retries <= _attempts)
                {
                    try
                    {
                        this._loader.close();
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                    this._loader.load(new URLRequest((((this._url + ((this._url.indexOf("?") == -1) ? "?" : "&")) + "retry=") + Std.string(_retries))));
                    return true;
                }
            }
            return false;
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                super.dispose();
                this._loader.removeEventListener(Event.COMPLETE, (loadEventHandler : ASAny));
                this._loader.removeEventListener(Event.UNLOAD, (loadEventHandler : ASAny));
                this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, (loadEventHandler : ASAny));
                this._loader.removeEventListener(ProgressEvent.PROGRESS, (loadEventHandler : ASAny));
                this._loader.removeEventListener(IOErrorEvent.IO_ERROR, (loadEventHandler : ASAny));
                this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.securityErrorEventHandler : ASAny));
                try
                {
                    this._loader.close();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }                this._loader = null;
                this._type = null;
                this._data = null;
                this._url = null;
            }
        }

        function securityErrorEventHandler(event:SecurityErrorEvent)
        {
            if (!_disposed)
            {
                loadEventHandler(event);
            }
        }

        function timerEventHandler(event:TimerEvent)
        {
            var timer= ASCompat.dynamicAs(event.target , Timer);
            if (timer != null)
            {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, (this.timerEventHandler : ASAny));
            }
            if (!_disposed)
            {
                loadEventHandler(new Event(Event.COMPLETE));
            }
        }
    }

