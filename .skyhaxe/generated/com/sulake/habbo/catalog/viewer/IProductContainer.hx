package com.sulake.habbo.catalog.viewer
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;

     interface IProductContainer extends IDisposable 
    {
        function initProductIcon(_arg_1:IRoomEngine, _arg_2:IStuffData=null):Void;
        function activate():Void;
        var products(get,never):Vector<IProduct>;
        var _Str_6851(get,never):IProduct;
                var view(get,set):IWindowContainer;
        var grid(never,set):_Str_4311;
        function _Str_15497(_arg_1:Int):Void;
        var offer(get,never):IPurchasableOffer;
    }

