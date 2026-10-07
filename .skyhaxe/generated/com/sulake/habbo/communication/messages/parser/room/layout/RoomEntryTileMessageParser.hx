package com.sulake.habbo.communication.messages.parser.room.layout
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomEntryTileMessageParser implements IMessageParser
    {
        var _x:Int = 0;
        var _y:Int = 0;
        var _dir:UInt = 0;


        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._y;
        }

        public var dir(get,never):UInt;
public function  get_dir():UInt
        {
            return this._dir;
        }

        public function flush():Bool
        {
            this._x = 0;
            this._y = 0;
            this._dir = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._x = k.readInteger();
            this._y = k.readInteger();
            this._dir = k.readInteger();
            return true;
        }

	public function new() {}
    }

