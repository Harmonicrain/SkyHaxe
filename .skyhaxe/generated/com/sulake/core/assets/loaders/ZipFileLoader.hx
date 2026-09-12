package com.sulake.core.assets.loaders
;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;

     class ZipFileLoader extends AssetLoaderEventBroker implements IAssetLoader 
    {
        var _url:String;
        var _type:String;
        var _stream:URLStream;
        var _data:com.sulake.core.utils.ByteArray;
        var _cacheKey:String;
        var _cacheRevision:Int = 0;
        var _fromCache:Bool = false;
        var _id:Int = 0;

        public function new(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:Int=-1, buffer:com.sulake.core.utils.ByteArray=null, id:Int=-1)
        {
var timer:Timer  = null;            super();
            this._url = ((urlRequest == null) ? "" : urlRequest.url);
            this._type = type;
            this._stream = new URLStream();
            this._stream.addEventListener(Event.COMPLETE, (loadEventHandler : ASAny));
            this._stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, (loadEventHandler : ASAny));
            this._stream.addEventListener(IOErrorEvent.IO_ERROR, (loadEventHandler : ASAny));
            this._stream.addEventListener(Event.OPEN, (loadEventHandler : ASAny));
            this._stream.addEventListener(ProgressEvent.PROGRESS, (loadEventHandler : ASAny));
            this._stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (loadEventHandler : ASAny));
            this._cacheKey = cacheKey;
            this._cacheRevision = cacheRevision;
            this._id = id;
            if (((!(buffer == null)) && (buffer.length > 0)))
            {
                this._fromCache = true;
                this._data = buffer;
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
            return (this._data != null) ? this._data : this._stream;
        }

        public var bytes(get,never):com.sulake.core.utils.ByteArray;
public function  get_bytes():com.sulake.core.utils.ByteArray
        {
            if (this._data != null)
            {
                return this._data;
            }
            var k= new com.sulake.core.utils.ByteArray();
            this._stream.readBytes(k);
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
            return this._stream.bytesAvailable;
        }

        public var bytesTotal(get,never):UInt;
public function  get_bytesTotal():UInt
        {
            return this._stream.bytesAvailable;
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

        public function load(urlRequest:URLRequest)
        {
            this._url = urlRequest.url;
            this._stream.load(urlRequest);
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                super.dispose();
                this._stream.removeEventListener(Event.COMPLETE, (loadEventHandler : ASAny));
                this._stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, (loadEventHandler : ASAny));
                this._stream.removeEventListener(IOErrorEvent.IO_ERROR, (loadEventHandler : ASAny));
                this._stream.removeEventListener(Event.OPEN, (loadEventHandler : ASAny));
                this._stream.removeEventListener(ProgressEvent.PROGRESS, (loadEventHandler : ASAny));
                this._stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (loadEventHandler : ASAny));
                this._stream.close();
                this._stream = null;
                this._type = null;
                this._url = null;
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

