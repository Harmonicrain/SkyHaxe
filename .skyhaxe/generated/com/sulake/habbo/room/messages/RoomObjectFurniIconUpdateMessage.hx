package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectFurniIconUpdateMessage extends RoomObjectUpdateMessage
    {
        public static inline final FURNI_ICON_LOADED= "ROFIUM_FURNI_ICON_LOADED";

        var _assetName:String;
        var _wallItem:Bool = false;
        var _typeId:Int = 0;
        var _extra:String;

        public function new(assetName:String, wallItem:Bool, typeId:Int, extra:String)
        {
            super(null, null);
            this._assetName = assetName == null ? "" : assetName;
            this._wallItem = wallItem;
            this._typeId = typeId;
            this._extra = extra == null ? "" : extra;
        }

        public var assetName(get,never):String;
public function  get_assetName():String
        {
            return this._assetName;
        }

        public var wallItem(get,never):Bool;
public function  get_wallItem():Bool
        {
            return this._wallItem;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._typeId;
        }

        public var extra(get,never):String;
public function  get_extra():String
        {
            return this._extra;
        }
    }

