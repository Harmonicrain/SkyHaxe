package com.sulake.habbo.inventory.trading
;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.habbo.room.IStuffData;

    /**
     * Common inventory contract used by ordinary and July Wired Trading.
     */
     interface ITradingModel
    {
        function requestAddItemsToTrading(
            itemIds:Vector<Int>,
            isWallItem:Bool,
            type:Int,
            category:Int,
            groupable:Bool,
            stuffData:IStuffData):Void;

        function requestRemoveItemFromTrading(index:Int):Void;
        function getOwnItemIdsInTrade():Array<ASAny>;
        function getInventory():HabboInventory;
    }

