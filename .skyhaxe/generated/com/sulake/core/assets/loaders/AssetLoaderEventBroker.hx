package com.sulake.core.assets.loaders
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;
    import flash.events.HTTPStatusEvent;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;

    /*internal*/ class AssetLoaderEventBroker extends EventDispatcherWrapper implements IDisposable 
    {
        public static inline final NONE:UInt = 0;
        public static inline final IO_ERROR:UInt = 1;
        public static inline final SECURITY_ERROR:UInt = 2;

        var _status:Int = 0;
        var _retries:Int = 0;
        var _attempts:Int = 2;
        var _errorCode:UInt = 0;

        public var errorCode(get,never):UInt;
public function  get_errorCode():UInt
        {
            return this._errorCode;
        }

        function loadEventHandler(event:Event)
        {
			try
			{
            switch (event.type)
            {
                case HTTPStatusEvent.HTTP_STATUS:
                    this._status = cast(event, HTTPStatusEvent).status;
                    dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTSTATUS, this._status));
                    return;
                case Event.COMPLETE:
                    dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._status));
                    return;
                case Event.UNLOAD:
                    dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTUNLOAD, this._status));
                    return;
                case Event.OPEN:
                    dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTOPEN, this._status));
                    return;
                case ProgressEvent.PROGRESS:
                    dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTPROGRESS, this._status));
                    return;
                case IOErrorEvent.IO_ERROR:
                    this._errorCode = IO_ERROR;
                    if (!this.retry())
                    {
                        dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._status));
                    }
                    return;
                case SecurityErrorEvent.SECURITY_ERROR:
                    this._errorCode = SECURITY_ERROR;
                    if (!this.retry())
                    {
                        dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._status));
                    }
                    return;
            }
			}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 			{
				Habbo.trackLoginStep("loadEventHandler failed " + ((event == null) ? "null" : event.target) + "|" + ((event == null) ? "null" : event.toString()) + "|" + error.message + "|" + error.getStackTrace());
			}
 }        }

        function retry():Bool
        {
            return false;
        }

	public function new() { super(); }
    }

