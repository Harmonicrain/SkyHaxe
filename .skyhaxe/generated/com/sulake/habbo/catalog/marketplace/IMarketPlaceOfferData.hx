package com.sulake.habbo.catalog.marketplace
;
    import com.sulake.habbo.room.IStuffData;
    import flash.display.BitmapData;

     interface IMarketPlaceOfferData 
    {
                var offerId(get,set):Int;
        var furniId(get,never):Int;
        var furniType(get,never):Int;
        var extraData(get,never):String;
        var stuffData(get,never):IStuffData;
                var price(get,set):Int;
        var averagePrice(get,never):Int;
                var image(get,set):BitmapData;
                var imageCallback(get,set):Int;
        var status(get,never):Int;
                var timeLeftMinutes(get,set):Int;
                var offerCount(get,set):Int;
    }

