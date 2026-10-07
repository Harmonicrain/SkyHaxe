package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPresentEvent extends RoomSessionEvent 
    {
        public static inline final RSPE_PRESENT_OPENED= "RSPE_PRESENT_OPENED";

        var _classId:Int = 0;
        var _itemType:String = "";
        var _productCode:String;
        var _placedItemId:Int = 0;
        var _placedItemType:String = "";
        var _placedInRoom:Bool = false;
        var _petFigureString:String;

        public function new(k:String, _arg_2:IRoomSession, _arg_3:Int, _arg_4:String, _arg_5:String, _arg_6:Int, _arg_7:String, _arg_8:Bool, _arg_9:String, _arg_10:Bool=false, _arg_11:Bool=false)
        {
            super(k, _arg_2, _arg_10, _arg_11);
            this._classId = _arg_3;
            this._itemType = _arg_4;
            this._productCode = _arg_5;
            this._placedItemId = _arg_6;
            this._placedItemType = _arg_7;
            this._placedInRoom = _arg_8;
            this._petFigureString = _arg_9;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
        }

        public var itemType(get,never):String;
public function  get_itemType():String
        {
            return this._itemType;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var placedItemId(get,never):Int;
public function  get_placedItemId():Int
        {
            return this._placedItemId;
        }

        public var isPlacedInRoom(get,never):Bool;
public function  get_isPlacedInRoom():Bool
        {
            return this._placedInRoom;
        }

        public var placedItemType(get,never):String;
public function  get_placedItemType():String
        {
            return this._placedItemType;
        }

        public var petFigureString(get,never):String;
public function  get_petFigureString():String
        {
            return this._petFigureString;
        }
    }

