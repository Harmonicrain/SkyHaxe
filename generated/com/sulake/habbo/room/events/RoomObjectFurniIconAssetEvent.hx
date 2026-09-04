package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectFurniIconAssetEvent extends RoomObjectEvent
    {
        public static inline final LOAD_FURNI_ICON= "ROFIAE_LOAD_FURNI_ICON";

        var _wallItem:Bool = false;
        var _typeId:Int = 0;
        var _extra:String;

        public function new(type:String, object:IRoomObject, wallItem:Bool, typeId:Int, extra:String, bubbles:Bool=false, cancelable:Bool=false)
        {
            super(type, object, bubbles, cancelable);
            this._wallItem = wallItem;
            this._typeId = typeId;
            this._extra = extra == null ? "" : extra;
        }

        public var wallItem(get,never):Bool;
function  get_wallItem():Bool
        {
            return this._wallItem;
        }

        public var typeId(get,never):Int;
function  get_typeId():Int
        {
            return this._typeId;
        }

        public var extra(get,never):String;
function  get_extra():String
        {
            return this._extra;
        }
    }

