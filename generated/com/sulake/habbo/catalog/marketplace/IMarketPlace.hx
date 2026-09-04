package com.sulake.habbo.catalog.marketplace
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.utils.Map;

     interface IMarketPlace 
    {
        var windowManager(get,never):IHabboWindowManager;
        var localization(get,never):IHabboLocalizationManager;
        function registerVisualization(_arg_1:IMarketPlaceVisualization=null):Void;
        function onOffers(_arg_1:IMessageEvent):Void;
        function onOwnOffers(_arg_1:IMessageEvent):Void;
        function onBuyResult(_arg_1:IMessageEvent):Void;
        function onCancelResult(_arg_1:IMessageEvent):Void;
        function requestOffersByName(_arg_1:String):Void;
        function requestOffersByPrice(_arg_1:Int):Void;
        function requestOffers(_arg_1:Int, _arg_2:Int, _arg_3:String, _arg_4:Int):Void;
        function refreshOffers():Void;
        function requestOwnItems():Void;
        function requestItemStats(_arg_1:Int, _arg_2:Int):Void;
        function buyOffer(_arg_1:Int):Void;
        function redeemExpiredOffer(_arg_1:Int):Void;
        function redeemSoldOffers():Void;
        function latestOffers():Map;
        function latestOwnOffers():Map;
        function totalItemsFound():Int;
                var itemStats(get,set):MarketplaceItemStats;
        var creditsWaiting(get,never):Int;
                var averagePricePeriod(get,set):Int;
        function getNameLocalizationKey(_arg_1:IMarketPlaceOfferData):String;
        function getDescriptionLocalizationKey(_arg_1:IMarketPlaceOfferData):String;
        function isAccountSafetyLocked():Bool;
    }

