package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.habbo.room.IStuffData;

     interface IFurnitureItemData 
    {
        var itemId(get,never):Int;
        var furniType(get,never):String;
        var ref(get,never):Int;
        var spriteId(get,never):Int;
        var category(get,never):Int;
        var stuffData(get,never):IStuffData;
        var isGroupable(get,never):Bool;
        var isRecycleable(get,never):Bool;
        var tradable(get,never):Bool;
        var sellable(get,never):Bool;
        var secondsToExpiration(get,never):Int;
        var flatId(get,never):Int;
        var slotId(get,never):String;
        var songId(get,never):Int;
        var extra(get,never):Int;
        var rentable(get,never):Bool;
        var isWallItem(get,never):Bool;
        var hasRentPeriodStarted(get,never):Bool;
        var expirationTimeStamp(get,never):Int;
        var creationDay(get,never):Int;
        var creationMonth(get,never):Int;
        var creationYear(get,never):Int;
        var isExternalImageFurni(get,never):Bool;
    }

