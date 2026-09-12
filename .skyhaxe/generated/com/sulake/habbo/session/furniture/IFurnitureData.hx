package com.sulake.habbo.session.furniture
;
     interface IFurnitureData 
    {
        var type(get,never):String;
        var id(get,never):Int;
        var className(get,never):String;
        var fullName(get,never):String;
        var hasIndexedColor(get,never):Bool;
        var colourIndex(get,never):Int;
        var revision(get,never):Int;
        var tileSizeX(get,never):Int;
        var tileSizeY(get,never):Int;
        var tileSizeZ(get,never):Int;
        var colours(get,never):Array<ASAny>;
        var localizedName(get,never):String;
        var description(get,never):String;
        var adUrl(get,never):String;
        var purchaseOfferId(get,never):Int;
        var bcOfferId(get,never):Int;
        var rentOfferId(get,never):Int;
        var customParams(get,never):String;
        var category(get,never):Int;
        var purchaseCouldBeUsedForBuyout(get,never):Bool;
        var rentCouldBeUsedForBuyout(get,never):Bool;
        var availableForBuildersClub(get,never):Bool;
        var canStandOn(get,never):Bool;
        var canSitOn(get,never):Bool;
        var canLayOn(get,never):Bool;
        var isExternalImageType(get,never):Bool;
        var excludedFromDynamic(get,never):Bool;
        var furniLine(get,never):String;
        var tradeable(get,never):Bool;
    }

