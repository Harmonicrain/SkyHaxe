package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.club.ClubBuyOfferData;

     interface IVipBuyCatalogWidget 
    {
        function dispose():Void;
        function init():Bool;
        function reset():Void;
        function _Str_15013(_arg_1:Int):Void;
        function _Str_6059(_arg_1:ClubBuyOfferData):Void;
        var isGift(get,never):Bool;
    }

