package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import flash.events.Event;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;

     interface ICatalogViewer 
    {
        function _Str_19388(_arg_1:Int, _arg_2:String, _arg_3:IPageLocalization, _arg_4:Vector<IPurchasableOffer>, _arg_5:Int, _arg_6:Bool):Void;
        function dispatchWidgetEvent(_arg_1:Event):Bool;
        var catalog(get,never):IHabboCatalog;
        var roomEngine(get,never):IRoomEngine;
        function dispose():Void;
        function getCurrentLayoutCode():String;
        var _Str_20991(get,never):Array<ASAny>;
    }

