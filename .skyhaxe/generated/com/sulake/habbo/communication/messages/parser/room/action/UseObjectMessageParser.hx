package com.sulake.habbo.communication.messages.parser.room.action
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UseObjectMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _itemType:Int = 0;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var itemType(get,never):Int;
public function  get_itemType():Int
        {
            return this._itemType;
        }

        public function flush():Bool
        {
            this._userId = 0;
            this._itemType = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._itemType = k.readInteger();
            return true;
        }

	public function new() {}
    }

