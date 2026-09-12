package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.room.IStuffData;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindowContainer;

     interface IProduct extends IGetImageListener extends  IDisposable 
    {
        var productType(get,never):String;
        var productClassId(get,never):Int;
                var extraParam(get,set):String;
        var productCount(get,never):Int;
        var productData(get,never):IProductData;
        var furnitureData(get,never):IFurnitureData;
        var isUniqueLimitedItem(get,never):Bool;
        var isColorable(get,never):Bool;
        var uniqueLimitedItemSeriesSize(get,never):Int;
                var uniqueLimitedItemsLeft(get,set):Int;
        function initIcon(_arg_1:IProductContainer, _arg_2:IGetImageListener=null, _arg_3:IAvatarImageListener=null, _arg_4:IPurchasableOffer=null, _arg_5:IBitmapWrapperWindow=null, _arg_6:IStuffData=null, _arg_7:ASFunction=null):BitmapData;
        var view(never,set):IWindowContainer;
        var grid(never,set):_Str_4311;
    }

