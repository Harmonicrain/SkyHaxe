package com.sulake.habbo.catalog.offers
;
    import com.sulake.core.runtime.IDisposable;

     interface IOfferProvider extends IDisposable 
    {
        var enabled(get,never):Bool;
        function load():Void;
        function showVideo():Void;
        var _Str_15510(get,never):Bool;
        var _Str_16897(get,never):Bool;
    }

