package com.sulake.habbo.inventory.items
;
    import com.sulake.habbo.room.IStuffData;

     interface IFurnitureItem 
    {
        var id(get,never):Int;
        var ref(get,never):Int;
        var type(get,never):Int;
        var stuffData(get,never):IStuffData;
        var extra(get,never):Float;
        var category(get,never):Int;
        var recyclable(get,never):Bool;
        var tradeable(get,never):Bool;
        var groupable(get,never):Bool;
        var sellable(get,never):Bool;
                var locked(get,set):Bool;
        var isWallItem(get,never):Bool;
    }

