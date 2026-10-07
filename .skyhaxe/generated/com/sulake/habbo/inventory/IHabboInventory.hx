package com.sulake.habbo.inventory
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.inventory.items.IFurnitureItem;

     interface IHabboInventory extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        var clubDays(get,never):Int;
        var clubPeriods(get,never):Int;
        var clubPastPeriods(get,never):Int;
        var clubLevel(get,never):Int;
        var clubHasEverBeenMember(get,never):Bool;
        var clubIsExpiring(get,never):Bool;
        var citizenshipVipIsExpiring(get,never):Bool;
        var clubMinutesUntilExpiration(get,never):Int;
        var tradingActive(get,never):Bool;
        var hasRoomSession(get,never):Bool;
        var unseenItemTracker(get,never):IUnseenItemTracker;
        function getAllMyBadgeIds(_arg_1:Array<ASAny>):Array<ASAny>;
        function getActivatedAvatarEffects():Array<ASAny>;
        function getAvatarEffects():Array<ASAny>;
        function requestSelectedFurniToMover(_arg_1:IFurnitureItem):Bool;
        function getFloorItemById(_arg_1:Int):IFurnitureItem;
        function getWallItemById(_arg_1:Int):IFurnitureItem;
        function placePetToRoom(_arg_1:Int, _arg_2:Bool=false):Bool;
        function setEffectSelected(_arg_1:Int):Void;
        function getLastActivatedEffect():Int;
        function setEffectDeselected(_arg_1:Int):Void;
        function deselectAllEffects(_arg_1:Bool=false):Void;
        function getAvatarEffect(_arg_1:Int):IAvatarEffect;
        function setupTrading(_arg_1:Int, _arg_2:String):Void;
        function toggleInventoryPage(_arg_1:String, _arg_2:String=null, _arg_3:Bool=false):Void;
        function toggleInventorySubPage(_arg_1:String):Void;
        function _Str_20251(_arg_1:Bool):Void;
        function _Str_15313():Int;
        function returnInventoryFurniFromRecycler(_arg_1:Int):Bool;
        function getItemWithStripId(_arg_1:Int):Bool;
        function removeUnseenFurniCounter(_arg_1:Int):Bool;
        function hasFigureSetIdInInventory(_arg_1:Int):Bool;
        function hasBoundFigureSetFurniture(_arg_1:String):Bool;
        function checkCategoryInitilization(_arg_1:String):Bool;
        function getNonRentedInventoryIds(_arg_1:String, _arg_2:Int):Array<ASAny>;
    }

