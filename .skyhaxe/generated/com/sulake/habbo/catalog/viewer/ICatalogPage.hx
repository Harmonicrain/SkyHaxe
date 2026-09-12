package com.sulake.habbo.catalog.viewer
;
    import flash.events.Event;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;

     interface ICatalogPage 
    {
        function dispose():Void;
        function init():Void;
        function closed():Void;
        function dispatchWidgetEvent(_arg_1:Event):Bool;
        var window(get,never):IWindowContainer;
        var viewer(get,never):ICatalogViewer;
        var pageId(get,never):Int;
        var offers(get,never):Vector<IPurchasableOffer>;
        var localization(get,never):IPageLocalization;
        var layoutCode(get,never):String;
        var hasLinks(get,never):Bool;
        var links(get,never):Array<ASAny>;
        function selectOffer(_arg_1:Int):Void;
        function replaceOffers(_arg_1:Vector<IPurchasableOffer>, _arg_2:Bool=false):Void;
        function _Str_19621(_arg_1:Int, _arg_2:Int):Void;
        var acceptSeasonCurrencyAsCredits(get,never):Bool;
        var _Str_21031(get,never):Bool;
        var _Str_22520(never,set):Int;
        var mode(get,never):Int;
        var _Str_21286(get,never):Bool;
    }

