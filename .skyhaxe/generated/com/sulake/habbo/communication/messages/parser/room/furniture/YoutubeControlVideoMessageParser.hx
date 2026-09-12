package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class YoutubeControlVideoMessageParser implements IMessageParser
    {
        var _furniId:Int = 0;
        var _Str_9152:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._furniId = k.readInteger();
            this._Str_9152 = k.readInteger();
            return true;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var commandId(get,never):Int;
public function  get_commandId():Int
        {
            return this._Str_9152;
        }

	public function new() {}
    }

