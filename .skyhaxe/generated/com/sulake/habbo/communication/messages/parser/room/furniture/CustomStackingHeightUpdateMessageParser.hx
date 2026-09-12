package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CustomStackingHeightUpdateMessageParser implements IMessageParser
    {
        var _furniId:Int = 0;
        var _height:Float = Math.NaN;


        public function flush():Bool
        {
            this._furniId = -1;
            this._height = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._furniId = k.readInteger();
            var _local_2= k.readInteger();
            this._height = (_local_2 / 100);
            return true;
        }

        public var height(get,never):Float;
public function  get_height():Float
        {
            return this._height;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

	public function new() {}
    }

