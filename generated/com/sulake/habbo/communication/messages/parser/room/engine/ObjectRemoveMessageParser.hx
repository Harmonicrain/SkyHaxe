package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ObjectRemoveMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _isExpired:Bool = false;
        var _pickerId:Int = 0;
        var _delay:Int = 0;


        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var isExpired(get,never):Bool;
function  get_isExpired():Bool
        {
            return this._isExpired;
        }

        public var pickerId(get,never):Int;
function  get_pickerId():Int
        {
            return this._pickerId;
        }

        public var delay(get,never):Int;
function  get_delay():Int
        {
            return this._delay;
        }

        public function flush():Bool
        {
            this._id = 0;
            this._delay = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._id = ASCompat.toInt(k.readString());
            this._isExpired = k.readBoolean();
            this._pickerId = k.readInteger();
            this._delay = k.readInteger();
            return true;
        }

	public function new() {}
    }

