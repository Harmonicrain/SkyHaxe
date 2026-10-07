package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RequestSpamWallPostItMessageParser implements IMessageParser
    {
        var _itemId:Int = 0;
        var _location:String;


        public var itemId(get,never):Int;
public function  get_itemId():Int
        {
            return this._itemId;
        }

        public var location(get,never):String;
public function  get_location():String
        {
            return this._location;
        }

        public function flush():Bool
        {
            this._itemId = -1;
            this._location = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._itemId = k.readInteger();
            this._location = k.readString();
            return true;
        }

	public function new() {}
    }

