package com.sulake.core.assets.loaders
;
    import flash.display.Loader;
    import flash.system.LoaderContext;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.utils.ByteArray;
    import flash.display.Bitmap;
    import com.sulake.core.utils.PlayerVersionCheck;
    import com.sulake.habbo.utils.images.PNGEncoder;
    import flash.events.TimerEvent;
    import flash.system.Security;
    import com.sulake.habbo.utils.HabboWebTools;

     class BitmapFileLoader extends AssetLoaderEventBroker implements IAssetLoader 
    {
        static inline final AIR_BITMAP_USER_AGENT= "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36";
        static inline final AIR_BITMAP_ACCEPT= "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8";
        static inline final AIR_BITMAP_REFERER= "https://swf.nextgenhabbo.com/index.php";

        var _url:String;
        var _type:String;
        var _loader:Loader;
        var _loaderContext:LoaderContext;
        var _cacheKey:String = null;
        var _cacheRevision:Int = -1;
        var _fromCache:Bool = false;
        var _id:Int = -1;
        var _securityPollTimer:Timer;
        var _storedCompleteEvent:Event;
        var _securityPollCount:Int = 0;
        var _airBinaryFallbackLoader:URLLoader;
        var _airBinaryFallbackAttempted:Bool = false;
        var _airBinaryFallbackLoading:Bool = false;
        var _lastRequestedUrl:String;

        public function new(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:Int=-1, buffer:com.sulake.core.utils.ByteArray=null, id:Int=-1)
        {
            super();
            this._url = ((urlRequest == null) ? "" : urlRequest.url);
            this._type = type;
            this._loader = new Loader();
            this._loaderContext = new LoaderContext();
            this._loaderContext.checkPolicyFile = !HabboWebTools.isAirApplication;
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, (this.completeEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(Event.UNLOAD, (this.loaderEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, (this.loaderEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, (this.loaderEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (this.loaderEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.loaderEventHandler : ASAny));
            this._cacheKey = cacheKey;
            this._cacheRevision = cacheRevision;
            this._id = id;
            this._lastRequestedUrl = this._url;
            if (((!(buffer == null)) && (buffer.length > 0)))
            {
                this._fromCache = true;
                this._loader.loadBytes(buffer);
            }
            else
            {
                if (((!(urlRequest == null)) && (!(urlRequest.url == null))))
                {
                    this.loadPreparedRequest(urlRequest, "START");
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
            return (this._loader != null) ? this._loader.content : null;
        }

        public var bytes(get,never):com.sulake.core.utils.ByteArray;
public function  get_bytes():com.sulake.core.utils.ByteArray
        {
            var bitmap= ASCompat.dynamicAs(this.content , Bitmap);
            if (bitmap == null)
            {
                return null;
            }
            if (PlayerVersionCheck.isVersionAtLeast(11, 3))
            {
            }
            return PNGEncoder.encode(bitmap.bitmapData);
        }

        public var mimeType(get,never):String;
public function  get_mimeType():String
        {
            return this._type;
        }

        public var bytesLoaded(get,never):UInt;
public function  get_bytesLoaded():UInt
        {
            return ASCompat.toUInt((this._loader != null) ? this._loader.contentLoaderInfo.bytesLoaded : 0);
        }

        public var bytesTotal(get,never):UInt;
public function  get_bytesTotal():UInt
        {
            return ASCompat.toUInt((this._loader != null) ? this._loader.contentLoaderInfo.bytesTotal : 0);
        }

        public var loaderContext(get,never):LoaderContext;
public function  get_loaderContext():LoaderContext
        {
            return this._loaderContext;
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
            _retries = 0;
            this._airBinaryFallbackAttempted = false;
            this.cleanupAirBinaryFallbackLoader();
            this.loadPreparedRequest(urlRequest, "RELOAD");
        }

        override function retry():Bool
        {
var retryUrl:String  = null;            if (!_disposed)
            {
                if (++_retries <= _attempts)
                {
                    try
                    {
                        this._loader.close();
                        this._loader.unload();
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); 					{
					} };
retryUrl= (((this._url + ((this._url.indexOf("?") == -1) ? "?" : "&")) + "retry=") + Std.string(_retries));
                    this.loadPreparedRequest(new URLRequest(retryUrl), "RETRY_LOAD attempt=" + Std.string(_retries));
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
                this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, (this.completeEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, (this.loaderEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, (this.loaderEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, (this.loaderEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, (this.loaderEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.loaderEventHandler : ASAny));
                if (this._securityPollTimer != null)
                {
                    this._securityPollTimer.stop();
                    this._securityPollTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.securityPollTimerEvent : ASAny));
                    this._securityPollTimer = null;
                }
                this.cleanupAirBinaryFallbackLoader();
                try
                {
                    this._loader.close();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }                this._loader.unload();
                this._loader = null;
                this._type = null;
                this._url = null;
            }
        }

        function completeEventHandler(event:Event)
        {
            if (HabboWebTools.isAirApplication)
            {
                loadEventHandler(event);
                return;
            }
            if (this._url == this._loader.contentLoaderInfo.url)
            {
                loadEventHandler(event);
                return;
            }
            this._storedCompleteEvent = event;
            var pathIndex= this._loader.contentLoaderInfo.url.indexOf("//");
            var crossdomainXml:ASAny = (this._loader.contentLoaderInfo.url.substring(0, (this._loader.contentLoaderInfo.url.indexOf("/", (pathIndex + 3)) + 1)) + "crossdomain.xml");
            Security.loadPolicyFile(crossdomainXml);
            this._securityPollCount = 0;
            this.startSecurityPolling();
        }

        function securityPollTimerEvent(event:TimerEvent)
        {
            this._securityPollCount++;
            if (this._loader.contentLoaderInfo.childAllowsParent)
            {
                loadEventHandler(this._storedCompleteEvent);
            }
            else
            {
                this.startSecurityPolling();
            }
        }

        function startSecurityPolling()
        {
            this._securityPollTimer = new Timer(250, 1);
            this._securityPollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.securityPollTimerEvent : ASAny));
            this._securityPollTimer.start();
        }

        function loaderEventHandler(event:Event)
        {
            if (event.type == HTTPStatusEvent.HTTP_STATUS)
            {
            }
            else if (event.type == IOErrorEvent.IO_ERROR)
            {
                if (this.shouldUseAirBinaryFallback(event))
                {
                    this.startAirBinaryFallback();
                    return;
                }
            }
            else if (event.type == SecurityErrorEvent.SECURITY_ERROR)
            {
            }
            else if (event.type == Event.UNLOAD)
            {
            }
            loadEventHandler(event);
        }

        override function loadEventHandler(event:Event)
        {
            var finalFailure= false;
            if (((event != null) && ((event.type == IOErrorEvent.IO_ERROR) || (event.type == SecurityErrorEvent.SECURITY_ERROR))))
            {
                finalFailure = this._retries >= this._attempts;
            }
            super.loadEventHandler(event);
            if ((finalFailure && HabboWebTools.isAirApplication))
            {
                HabboWebTools.airDebug((((("IMAGE FAIL: " + this.getFailureUrl(event)) + " status=") + Std.string(this._status)) + " event=") + event.type);
            }
        }

        function loadPreparedRequest(urlRequest:URLRequest, label:String)
        {
            var preparedRequest= this.prepareAirBitmapRequest(urlRequest);
            var requestMode= (preparedRequest == urlRequest) ? "default" : "browser_headers";
            this.startLoaderLoad(preparedRequest, urlRequest, label, requestMode);
        }

        function startLoaderLoad(preparedRequest:URLRequest, originalRequest:URLRequest, label:String, requestMode:String)
        {
            try
            {
                this.rememberRequestUrl(preparedRequest, originalRequest);
                this._loader.load(preparedRequest, this._loaderContext);
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                if (preparedRequest != originalRequest)
                {
                    try
                    {
                        this.rememberRequestUrl(originalRequest, preparedRequest);
                        this._loader.load(originalRequest, this._loaderContext);
                        return;
                    }
catch (__as3Caught:Dynamic) { var fallbackError:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                }
                loadEventHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
            }
 }        }

        function prepareAirBitmapRequest(urlRequest:URLRequest):URLRequest
        {
            var preparedRequest:URLRequest = null;
            var headers:Array<ASAny> = null;
            var existingHeader:URLRequestHeader = null;
            if (urlRequest == null || !this.isAirRemoteBitmapUrl(urlRequest.url))
            {
                return urlRequest;
            }
            preparedRequest = new URLRequest(urlRequest.url);
            preparedRequest.data = urlRequest.data;
            preparedRequest.method = urlRequest.method;
            preparedRequest.contentType = urlRequest.contentType;
            headers = [];
            if (urlRequest.requestHeaders != null)
            {
                final _iter_ = urlRequest.requestHeaders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
existingHeader  = _tmp_;
                    if (!this.isManagedAirBitmapHeader(existingHeader.name))
                    {
                        headers.push(existingHeader);
                    }
                }
            }
            headers.push(new URLRequestHeader("User-Agent", AIR_BITMAP_USER_AGENT));
            headers.push(new URLRequestHeader("Accept", AIR_BITMAP_ACCEPT));
            headers.push(new URLRequestHeader("Referer", AIR_BITMAP_REFERER));
            preparedRequest.requestHeaders = (headers : ASAny);
            return preparedRequest;
        }

        function isManagedAirBitmapHeader(name:String):Bool
        {
            var lowerName:String = null;
            if (name == null)
            {
                return false;
            }
            lowerName = name.toLowerCase();
            return lowerName == "user-agent" || lowerName == "accept" || lowerName == "referer";
        }

        function isAirRemoteBitmapUrl(url:String=null):Bool
        {
            var lowerUrl:String = null;
            var value= (url == null) ? this._url : url;
            if (!HabboWebTools.isAirApplication || value == null)
            {
                return false;
            }
            lowerUrl = value.toLowerCase();
            return ((lowerUrl.indexOf("http://") == 0) || (lowerUrl.indexOf("https://") == 0)) && (((lowerUrl.indexOf(".png") >= 0) || (lowerUrl.indexOf(".gif") >= 0)) || ((lowerUrl.indexOf(".jpg") >= 0) || (lowerUrl.indexOf(".jpeg") >= 0)));
        }

        function shouldUseAirBinaryFallback(event:Event):Bool
        {
            return event.type == IOErrorEvent.IO_ERROR && this._status == 403 && this.isAirRemoteBitmapUrl() && !this._airBinaryFallbackAttempted && !this._airBinaryFallbackLoading;
        }

        function startAirBinaryFallback()
        {
            var request= this.prepareAirBitmapRequest(new URLRequest(this._url));
            this._airBinaryFallbackAttempted = true;
            this._airBinaryFallbackLoading = true;
            this._airBinaryFallbackLoader = new URLLoader();
            this._airBinaryFallbackLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this._airBinaryFallbackLoader.addEventListener(Event.COMPLETE, (this.airBinaryFallbackCompleteHandler : ASAny));
            this._airBinaryFallbackLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, (this.airBinaryFallbackStatusHandler : ASAny));
            this._airBinaryFallbackLoader.addEventListener(IOErrorEvent.IO_ERROR, (this.airBinaryFallbackErrorHandler : ASAny));
            this._airBinaryFallbackLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.airBinaryFallbackErrorHandler : ASAny));
            try
            {
                this.rememberRequestUrl(request, null);
                this._airBinaryFallbackLoader.load(request);
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                this.cleanupAirBinaryFallbackLoader(false);
                loadEventHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
            }
 }        }

        function airBinaryFallbackStatusHandler(event:HTTPStatusEvent)
        {
            this._status = event.status;
            loadEventHandler(event);
        }

        function airBinaryFallbackCompleteHandler(event:Event)
        {
            var bytes= ASCompat.asByteArray(this._airBinaryFallbackLoader.data );
            this.cleanupAirBinaryFallbackLoader(false);
            if (bytes != null && bytes.length > 0)
            {
                try
                {
                    bytes.position = 0;
                    this._loader.loadBytes(bytes, this._loaderContext);
                    return;
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
            loadEventHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "AIR binary bitmap fallback produced no usable bytes"));
        }

        function airBinaryFallbackErrorHandler(event:Event)
        {
            this.cleanupAirBinaryFallbackLoader(false);
            loadEventHandler(event);
        }

        function rememberRequestUrl(primary:URLRequest, fallback:URLRequest)
        {
            if (((primary != null) && (primary.url != null) && (primary.url.length > 0)))
            {
                this._lastRequestedUrl = primary.url;
                this._url = primary.url;
                return;
            }
            if (((fallback != null) && (fallback.url != null) && (fallback.url.length > 0)))
            {
                this._lastRequestedUrl = fallback.url;
                this._url = fallback.url;
            }
        }

        function getFailureUrl(event:Event):String
        {
            var text:String = null;
            if (((this._lastRequestedUrl != null) && (this._lastRequestedUrl.length > 0)))
            {
                return this._lastRequestedUrl;
            }
            if (((this._url != null) && (this._url.length > 0)))
            {
                return this._url;
            }
            try
            {
                if (((this._loader != null) && (this._loader.contentLoaderInfo != null) && (this._loader.contentLoaderInfo.url != null) && (this._loader.contentLoaderInfo.url.length > 0)))
                {
                    return this._loader.contentLoaderInfo.url;
                }
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
            }
 }            if (Std.is(event , IOErrorEvent))
            {
                text = cast(event, IOErrorEvent).text;
            }
            else if (Std.is(event , SecurityErrorEvent))
            {
                text = cast(event, SecurityErrorEvent).text;
            }
            if (((text != null) && (text.length > 0)))
            {
                return text;
            }
            return "(unknown)";
        }

        function cleanupAirBinaryFallbackLoader(closeLoader:Bool=true)
        {
            if (this._airBinaryFallbackLoader == null)
            {
                this._airBinaryFallbackLoading = false;
                return;
            }
            this._airBinaryFallbackLoader.removeEventListener(Event.COMPLETE, (this.airBinaryFallbackCompleteHandler : ASAny));
            this._airBinaryFallbackLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, (this.airBinaryFallbackStatusHandler : ASAny));
            this._airBinaryFallbackLoader.removeEventListener(IOErrorEvent.IO_ERROR, (this.airBinaryFallbackErrorHandler : ASAny));
            this._airBinaryFallbackLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.airBinaryFallbackErrorHandler : ASAny));
            if (closeLoader)
            {
                try
                {
                    this._airBinaryFallbackLoader.close();
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
            this._airBinaryFallbackLoader = null;
            this._airBinaryFallbackLoading = false;
        }
    }

