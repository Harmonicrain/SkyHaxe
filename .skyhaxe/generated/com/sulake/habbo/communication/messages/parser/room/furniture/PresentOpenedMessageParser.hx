package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PresentOpenedMessageParser implements IMessageParser
    {
        var _itemType:String;
        var _classId:Int = 0;
        var _productCode:String;
        var _placedItemId:Int = 0;
        var _placedItemType:String;
        var _placedInRoom:Bool = false;
        var _petFigureString:String;


        public var itemType(get,never):String;
public function  get_itemType():String
        {
            return this._itemType;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
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

        public var placedItemType(get,never):String;
public function  get_placedItemType():String
        {
            return this._placedItemType;
        }

        public var isPlacedInRoom(get,never):Bool;
public function  get_isPlacedInRoom():Bool
        {
            return this._placedInRoom;
        }

        public var petFigureString(get,never):String;
public function  get_petFigureString():String
        {
            return this._petFigureString;
        }

        public function flush():Bool
        {
            this._itemType = "";
            this._classId = 0;
            this._productCode = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._itemType = k.readString();
            this._classId = k.readInteger();
            this._productCode = k.readString();
            this._placedItemId = k.readInteger();
            this._placedItemType = k.readString();
            this._placedInRoom = k.readBoolean();
            this._petFigureString = k.readString();
            return true;
        }

	public function new() {}
    }

