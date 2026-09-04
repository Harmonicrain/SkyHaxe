package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HeightMapUpdateMessageParser implements IMessageParser
    {
        var _data:IMessageDataWrapper;
        var _count:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _value:Int = 0;


        public function next():Bool
        {
            if (this._count == 0)
            {
                return false;
            }
            this._count--;
            this._x = this._data.readByte();
            this._y = this._data.readByte();
            this._value = this._data.readShort();
            return true;
        }

        public var x(get,never):Int;
function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
function  get_y():Int
        {
            return this._y;
        }

        public var tileHeight(get,never):Float;
function  get_tileHeight():Float
        {
            return HeightMapMessageParser.decodeTileHeight(this._value);
        }

        public var isStackingBlocked(get,never):Bool;
function  get_isStackingBlocked():Bool
        {
            return HeightMapMessageParser.decodeIsStackingBlocked(this._value);
        }

        public var isRoomTile(get,never):Bool;
function  get_isRoomTile():Bool
        {
            return HeightMapMessageParser.decodeIsRoomTile(this._value);
        }

        public function flush():Bool
        {
            this._count = 0;
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._data = k;
            this._count = k.readByte();
            return true;
        }

	public function new() {}
    }

