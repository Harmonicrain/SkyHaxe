package com.sulake.core.utils
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.Loader;
    import deng.fzip.FZip;
    import flash.system.LoaderContext;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.display.MovieClip;
    import flash.display.FrameLabel;
    import deng.fzip.FZipFile;
    import com.sulake.core.Core;
    import com.sulake.habbo.utils.HabboWebTools;

     class LibraryLoader extends EventDispatcherWrapper implements IDisposable 
    {
        static inline final STATE_EVENT_COMPLETE:UInt = 1;
        static inline final STATE_EVENT_INIT:UInt = 2;
        static inline final STATE_EVENT_FRAME:UInt = 4;
        static inline final STATE_ANALYZE:UInt = 3;
        static inline final STATE_READY:UInt = 7;
        static inline final ZIP_STATE_READY:UInt = 8;
        public static inline final DEFAULT_MAX_RETRIES= 5;
        public static inline final LIBRARY_LOADER_FINALIZE= "LIBRARY_LOADER_FINALIZE";
        public static inline final USE_DOWNLOAD_THROTTLING= true;
        public static inline final MAX_SIMULTANEOUS_DOWNLOADS= 6;
        static var _throttleQueue:Array<ASAny> = new Array();
        static var _activeDownloads:Array<ASAny> = new Array();

        var _loader:Loader;
        var _zipLoader:FZip;
        var _context:LoaderContext;
        var _status:Int = 0;
        var _request:URLRequest;
        var _manifest:com.sulake.core.utils.xml.XML;
        var _resource:Class<Dynamic>;
        var _process:UInt = 0;
        var _name:String;
        var _ready:Bool = false;
        var _debug:Bool = false;
        var _paused:Bool = false;
        var _errorMsg:String = "";
        var _debugMsg:String = "";
        var _downloadStartTime:Int = 0;
        var _downloadEndTime:Int = 0;
        var _downloadRetriesLeft:Int = 0;
        var _analyzeAttempts:UInt = 0;

        public function new(k:LoaderContext=null, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super();
            if (k == null)
            {
                this._context = new LoaderContext();
                this._context.applicationDomain = ApplicationDomain.currentDomain;
            }
            else
            {
                this._context = k;
            }
            try { this._context.allowCodeImport = true; } catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); {}
 }            this._paused = _arg_2;
            this._debug = _arg_3;
            this._status = 0;
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.INIT, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(Event.UNLOAD, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.loadEventHandler : ASAny));
            this._loader.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (this.uncaughtErrorHandler : ASAny));
        }

        static function addRequestCounterToUrlRequest(request:URLRequest, counter:Int)
        {
var p:String  = null;            var index = 0;
            if (((request.url == null) || (request.url == "")))
            {
                return;
            }
            var parameters:Array<ASAny> = (cast request.url.split("?"));
            var firstParameter:String = parameters[0];
            var remainingParameters= ((parameters.length > 1) ? parameters[1] : "");
            var newParameterName= "counterparameter";
            var params:Array<ASAny> = (cast remainingParameters.split("&"));
            var hasCounter = false;
            index = 0;
            while (index < params.length)
            {
p= params[index];
                if (p.indexOf((newParameterName + "=")) >= 0)
                {
                    p = ((newParameterName + "=") + Std.string(counter));
                    params[index] = p;
                    hasCounter = true;
                    break;
                }
                index++;
            }
            if (!hasCounter)
            {
                params.push(((newParameterName + "=") + Std.string(counter)));
            }
            index = 0;
            while (index < params.length)
            {
                firstParameter = (firstParameter + (((index == 0) ? "?" : "&") + params[index]));
                index++;
            }
            request.url = firstParameter;
        }

        static function parseNameFromUrl(url:String):String
        {
            var index = 0;
            index = url.indexOf("?", 0);
            if (index > -1)
            {
                url = url.substring(0, index);
            }
            index = url.lastIndexOf(".");
            if (index > -1)
            {
                url = url.substring(0, index);
            }
            index = url.lastIndexOf("/");
            if (index > -1)
            {
                url = url.substring((index + 1), url.length);
            }
            return url;
        }

        static function queue(loader:LibraryLoader)
        {
            if (USE_DOWNLOAD_THROTTLING)
            {
                if (_throttleQueue.indexOf(loader) == -1)
                {
                    _throttleQueue.push(loader);
                }
                throttle();
            }
            else
            {
                loader._loader.load(loader._request, loader._context);
            }
        }

        static function throttle()
        {
var loader:LibraryLoader = null, activeDownloadsCounter = 0;            if (USE_DOWNLOAD_THROTTLING)
            {
loader;
activeDownloadsCounter= (_activeDownloads.length - 1);
                while (activeDownloadsCounter > -1)
                {
                    loader = ASCompat.dynamicAs(_activeDownloads[activeDownloadsCounter] , LibraryLoader);
                    if (((loader != null) && (loader.ready || loader.disposed)))
                    {
                        _activeDownloads.splice(activeDownloadsCounter, 1);
                    }
                    activeDownloadsCounter--;
                }
                while (((_activeDownloads.length < MAX_SIMULTANEOUS_DOWNLOADS) && (_throttleQueue.length > 0)))
                {
                    loader = ASCompat.dynamicAs(_throttleQueue.shift() , LibraryLoader);
                    if (((!loader.ready) && (!loader.disposed)))
                    {
                        _activeDownloads.push(loader);
                        loader._loader.load(loader._request, loader._context);
                    }
                }
            }
        }


        public var url(get,never):String;
public function  get_url():String
        {
            return (this._request != null) ? this._request.url : null;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var ready(get,never):Bool;
public function  get_ready():Bool
        {
            return this._ready;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        public var domain(get,never):ApplicationDomain;
public function  get_domain():ApplicationDomain
        {
            return this._loader.contentLoaderInfo.applicationDomain;
        }

        public var request(get,never):URLRequest;
public function  get_request():URLRequest
        {
            return this._request;
        }

        public var resource(get,never):Class<Dynamic>;
public function  get_resource():Class<Dynamic>
        {
            return this._resource;
        }

        public var manifest(get,never):com.sulake.core.utils.xml.XML;
public function  get_manifest():com.sulake.core.utils.xml.XML
        {
            return this._manifest;
        }

        public var bytesTotal(get,never):UInt;
public function  get_bytesTotal():UInt
        {
            return this._loader.contentLoaderInfo.bytesTotal;
        }

        public var bytesLoaded(get,never):UInt;
public function  get_bytesLoaded():UInt
        {
            return this._loader.contentLoaderInfo.bytesLoaded;
        }

        public var elapsedTime(get,never):UInt;
public function  get_elapsedTime():UInt
        {
            return this._ready ? (this._downloadEndTime - this._downloadStartTime) : (flash.Lib.getTimer() - this._downloadStartTime);
        }

        public var paused(get,never):Bool;
public function  get_paused():Bool
        {
            return this._paused;
        }

        public var zipLoader(get,never):FZip;
public function  get_zipLoader():FZip
        {
            return this._zipLoader;
        }

        var content(get,never):DisplayObject;
function  get_content():DisplayObject
        {
            return this._loader.content;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_DISPOSE, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
                try
                {
                    this._loader.close();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }                try
                {
                    this._loader.unload();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }                this._loader = null;
                this._context = null;
                this._resource = null;
                this._manifest = null;
                super.dispose();
            }
        }

        public function load(k:URLRequest, _arg_2:Int=5)
        {
            this._request = k;
            this._name = parseNameFromUrl(this._request.url);
            this._ready = false;
            this._downloadRetriesLeft = _arg_2;
            ErrorReportStorage.addDebugData("Library url", ("Library url " + k.url));
            ErrorReportStorage.addDebugData("Library name", ("Library name " + this._name));
            if (!this._paused)
            {
                this._paused = true;
                this.resume();
            }
        }

        public function resume()
        {
            if ((this._paused && (!_disposed)))
            {
                this._paused = false;
                if (((!this._ready) && (this._request != null)))
                {
                    this._downloadEndTime = -1;
                    this._downloadStartTime = flash.Lib.getTimer();
                    if (this._zipLoader != null)
                    {
                        this._zipLoader.load(this._request);
                    }
                    else
                    {
                        queue(this);
                    }
                }
            }
        }

        function retry():Bool
        {
            if ((((!this._ready) && (!_disposed)) && (this._downloadRetriesLeft > 0)))
            {
                try
                {
                    this._loader.close();
                    this._loader.unload();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }                addRequestCounterToUrlRequest(this._request, (DEFAULT_MAX_RETRIES - this._downloadRetriesLeft));
                this._downloadRetriesLeft--;
                this._process = 0;
                this._loader.load(this._request, this._context);
                return true;
            }
            return false;
        }

        public function hasDefinition(k:String):Bool
        {
            var definitionFound = false;
            try
            {
                definitionFound = this._loader.contentLoaderInfo.applicationDomain.hasDefinition(k);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return definitionFound;
        }

        public function getDefinition(k:String):ASObject
        {
            var definition:ASObject = null;
            try
            {
                if (this._loader.contentLoaderInfo.applicationDomain.hasDefinition(k))
                {
                    definition = this._loader.contentLoaderInfo.applicationDomain.getDefinition(k);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return definition;
        }

        function loadEventHandler(k:Event)
        {
var timer:Timer = null;            switch (k.type)
            {
                case Event.INIT:
                    this.debug((('Load event INIT for file "' + this.url) + '"'));
                    this._process = (ASCompat.toInt(this._process )| ASCompat.toInt(LibraryLoader.STATE_EVENT_INIT));
                    
                case Event.COMPLETE:
                    this.debug((('Load event COMPLETE for file "' + this.url) + '"'));
                    this._process = (ASCompat.toInt(this._process )| ASCompat.toInt(LibraryLoader.STATE_EVENT_COMPLETE));
                    
                case Event.ENTER_FRAME:
                    
                case HTTPStatusEvent.HTTP_STATUS:
                    this._status = cast(k, HTTPStatusEvent).status;
                    this.debug((((("Load event STATUS " + Std.string(this._status)) + ' for file "') + this.url) + '"'));
                    
                case Event.UNLOAD:
                    this.debug((('Load event UNLOAD for file "' + this.url) + '"'));
                    dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_UNLOAD, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
                    
                case ProgressEvent.PROGRESS:
                    this.debug(((((('Load event PROGRESS for file "' + this.url) + '"  bytes: ') + Std.string(this.bytesLoaded)) + "/") + Std.string(this.bytesTotal)));
                    dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
                    
                case IOErrorEvent.IO_ERROR:
                    this.debug((('Load event IO ERROR for file "' + this.url) + '"'));
                    if (!this.handleHttpStatus(this._status))
                    {
                        this._downloadEndTime = flash.Lib.getTimer();
                        this.failure((('IO Error, send or load operation failed for file "' + this.url) + '"'));
                        this.removeEventListeners();
                    }
                    
                case SecurityErrorEvent.SECURITY_ERROR:
                    this._downloadEndTime = flash.Lib.getTimer();
                    this.failure((('Security Error, security violation with file "' + this.url) + '"'));
                    this.removeEventListeners();
                    
                case TimerEvent.TIMER:
timer;
                    timer = ASCompat.dynamicAs(cast(k, TimerEvent).target , Timer);
                    timer.removeEventListener(TimerEvent.TIMER, (this.loadEventHandler : ASAny));
                    timer.stop();
                    if (!_disposed)
                    {
                        this._process = LibraryLoader.STATE_READY;
                        this.loadEventHandler(new Event(Event.COMPLETE));
                    }
                    return;
            }
            if (this._process == LibraryLoader.STATE_ANALYZE)
            {
                if (this.analyzeLibrary())
                {
                    this._process = (ASCompat.toInt(this._process )| ASCompat.toInt(LibraryLoader.STATE_EVENT_FRAME));
                }
            }
            if (this._process == LibraryLoader.STATE_READY)
            {
                if (this.prepareLibrary())
                {
                    this._ready = true;
                    this._downloadEndTime = flash.Lib.getTimer();
                    this.removeEventListeners();
                    throttle();
                    dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
                    dispatchEvent(new Event(LIBRARY_LOADER_FINALIZE));
                }
            }
        }

        function onUnzipComplete(event:Event)
        {
            var fzip= ASCompat.dynamicAs(event.target , FZip);
            fzip.removeEventListener(Event.COMPLETE, (this.onUnzipComplete : ASAny));
            this._process = LibraryLoader.ZIP_STATE_READY;
            if (this._process == LibraryLoader.ZIP_STATE_READY)
            {
                if (this.prepareZipLibrary())
                {
                    this._ready = true;
                    this._downloadEndTime = flash.Lib.getTimer();
                    this.removeEventListeners();
                    throttle();
                    dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
                    dispatchEvent(new Event(LIBRARY_LOADER_FINALIZE));
                }
            }
        }

        function analyzeLibrary():Bool
        {
var content:MovieClip  = null, index:UInt  = 0, frameLabel:FrameLabel  = null;            this.debug((((('Analyzing library "' + this._name) + '", content ') + (Std.is(this.content , MovieClip) ? "is" : "is not")) + " a MovieClip"));
            this.debug(((("\tBytes loaded: " + Std.string(this._loader.contentLoaderInfo.bytesLoaded)) + "/") + Std.string(this._loader.contentLoaderInfo.bytesTotal)));
            if (Std.is(this.content , MovieClip))
            {
content= Std.downcast(this.content , MovieClip);
                this.debug((((((('\tLibrary "' + this._name) + '" is in frame ') + Std.string(content.currentFrame)) + "(") + content.currentLabel) + ")"));
                if (content.currentLabels.length > 1)
                {
index= 0;
                    while (index < (content.currentLabels.length : UInt))
                    {
frameLabel= ASCompat.dynamicAs(content.currentLabels[ASCompat.toInt(index)] , FrameLabel);
                        if (frameLabel.name == this._name)
                        {
                            if (frameLabel.frame != content.currentFrame)
                            {
                                content.addEventListener(Event.ENTER_FRAME, (this.loadEventHandler : ASAny));
                                return false;
                            }
                        }
                        index++;
                    }
                }
            }
            return true;
        }

        function prepareLibrary():Bool
        {
            var xmlClass:Class<Dynamic> = null;
            this.debug((('Preparing library "' + this._name) + '"'));
            this._resource = this.getDefinition(this._name) ;
            if (this._resource == null)
            {
                if (!this.retry())
                {
                    this.failure((((('Failed to find resource class "' + this._name) + '" from library ') + this._request.url) + "!"));
                }
                return false;
            }
            var result= true;
            try
            {
                xmlClass = ASCompat.classProperty (this._resource, "manifest");
                if (xmlClass == null)
                {
                    return false;
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (!retry())
                {
                    failure((("Failed to find embedded manifest.xml from library " + _request.url) + "!"));
                }
                result = false;
            }
 }            if (!result)
            {
                return false;
            }
            var bytes= ASCompat.asByteArray(Type.createInstance(xmlClass, []) );
            try
            {
                this._manifest = new com.sulake.core.utils.xml.XML(bytes.readUTFBytes(bytes.length));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (!retry())
                {
                    failure(((("Failed to extract manifest.xml from library " + _name) + "!\n") + e.message));
                }
                result = false;
            }
 }            return result;
        }

        function prepareZipLibrary():Bool
        {
            var xmlFile:FZipFile = null;
            this.debug((('Preparing ZIP library "' + this._name) + '"'));
            if (this._zipLoader == null)
            {
                this.failure((((('Failed to find resource class "' + this._name) + '" from ZIP library ') + this._request.url) + "!"));
                return false;
            }
            this._resource = FZip;
            var result= true;
            try
            {
                xmlFile = this._zipLoader._Str_1843("manifest.xml");
                if (xmlFile == null)
                {
                    return false;
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (!retry())
                {
                    failure((("Failed to find embedded manifest.xml from ZIP library " + _request.url) + "!"));
                }
                result = false;
            }
 }            if (!result)
            {
                return false;
            }
            var bytes= xmlFile.content;
            try
            {
                this._manifest = new com.sulake.core.utils.xml.XML(bytes.readUTFBytes(bytes.length));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (!retry())
                {
                    failure(((("Failed to extract manifest.xml from library " + _name) + "!\n") + e.message));
                }
                result = false;
            }
 }            return result;
        }

        function handleHttpStatus(status:Int):Bool
        {
            if (((status == 0) || (status >= 400)))
            {
                if (this.retry())
                {
                    return true;
                }
                this.failure((((("HTTP Error " + Std.string(status)) + ' "') + this._loader.contentLoaderInfo.url) + '"'));
                this.removeEventListeners();
            }
            return false;
        }

        function removeEventListeners()
        {
            if (this._loader != null)
            {
                if (this._loader.content != null)
                {
                    this._loader.content.removeEventListener(Event.ENTER_FRAME, (this.loadEventHandler : ASAny));
                }
                this._loader.contentLoaderInfo.removeEventListener(Event.INIT, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.loadEventHandler : ASAny));
                this._loader.contentLoaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (this.uncaughtErrorHandler : ASAny));
            }
        }

        function uncaughtErrorHandler(event:UncaughtErrorEvent)
        {
            var errorObject:ASObject = event.error;
            var error= ASCompat.dynamicAs(errorObject , ASError);
            var message= "LIBRARY_UNCAUGHT name=" + this._name + " url=" + this.url + " eventType=" + event.type + " errorID=" + Std.string(event.errorID);
            if (error != null)
            {
                message += " errorMessage=" + error.message;
            }
            else if (errorObject != null)
            {
                message += " errorValue=" + ASCompat.toString(errorObject);
            }
            HabboWebTools.airDebug(message);
            if (message.indexOf("#1074") >= 0 && message.indexOf("ByteArrayAsset") >= 0)
            {
                HabboWebTools.recordAvatarAssetDiagnostic("flex-collision", this._name, this.url, message);
                if (event.cancelable)
                {
                    event.preventDefault();
                }
                event.stopImmediatePropagation();
            }
        }

        function debug(debugMsg:String)
        {
            Core.debug(debugMsg);
            this._debugMsg = debugMsg;
            if (this._debug)
            {
                dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_DEBUG, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
            }
        }

        function failure(failureMsg:String)
        {
            Core.warning(failureMsg);
            if (HabboWebTools.isAirApplication)
            {
                HabboWebTools.airDebug("ASSET FAIL: " + failureMsg);
            }
            this._errorMsg = failureMsg;
            throttle();
            dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR, this._status, this.bytesTotal, this.bytesLoaded, this.elapsedTime));
            dispatchEvent(new Event(LIBRARY_LOADER_FINALIZE));
        }

        public function getLastDebugMessage():String
        {
            return this._debugMsg;
        }

        public function getLastErrorMessage():String
        {
            return this._errorMsg;
        }
    }

