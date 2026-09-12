package com.sulake.habbo.catalog.habbicons
;
    import com.sulake.core.runtime.IUnknown;

     interface IHabbiconController extends IUnknown
    {
        var hasLoadedShopData(get,never):Bool;
        var ownedHabbicons(get,never):Array<ASAny>;
        var recentHabbiconIds(get,never):Array<ASAny>;
        var shopCollections(get,never):Vector<HabbiconCollectionData>;
        var unseenHabbiconCount(get,never):Int;
        function addEventListener(type:String, listener:ASFunction):Void;
        function removeEventListener(type:String, listener:ASFunction):Void;
        function openHabbiconHub():Void;
        function getShopData(force:Bool = false):Void;
        function getHabbiconInfo(habbiconId:Int):Void;
        function noteHabbiconUsed(habbiconId:Int):Void;
        function isUnseenHabbicon(habbiconId:Int):Bool;
        function removeUnseenHabbicon(habbiconId:Int):Void;
        function resetUnseenHabbicons():Void;
        function buyHabbicon(habbiconId:Int):Void;
        function buyHabbiconCollection(collectionId:Int):Void;
        function claimHabbicon(habbiconId:Int):Void;
        function favoriteHabbicon(habbiconId:Int):Void;
        function unfavoriteHabbicon(habbiconId:Int):Void;
        function useHabbiconInRoom(habbiconId:Int):Void;
        function sendHabbiconInstantMessage(chatId:Int, habbiconId:Int, confirmationId:Int):Void;
        function tryGetOwnedHabbicon(habbiconId:Int):HabbiconOwnedItem;
        function tryGetShopItem(habbiconId:Int):HabbiconShopItem;
    }

