package com.sulake.core.assets.loaders
;
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.IDisposable;
    import flash.net.URLRequest;

     interface IAssetLoader extends IEventDispatcher extends  IDisposable 
    {
        var url(get,never):String;
        var content(get,never):ASObject;
        var mimeType(get,never):String;
        var bytesLoaded(get,never):UInt;
        var bytesTotal(get,never):UInt;
        var errorCode(get,never):UInt;
        var cacheKey(get,never):String;
        var cacheRevision(get,never):Int;
        var fromCache(get,never):Bool;
        var id(get,never):Int;
        function load(urlRequest:URLRequest):Void;
    }

