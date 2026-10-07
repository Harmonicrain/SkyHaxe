package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class YoutubeDisplayVideoMessageParser implements IMessageParser
    {
        var _furniId:Int = 0;
        var _videoId:String;
        var _Str_21563:Int = 0;
        var _Str_20588:Int = 0;
        var _state:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._furniId = k.readInteger();
            this._videoId = k.readString();
            this._Str_21563 = k.readInteger();
            this._Str_20588 = k.readInteger();
            this._state = k.readInteger();
            return true;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var videoId(get,never):String;
public function  get_videoId():String
        {
            return this._videoId;
        }

        public var _Str_25795(get,never):Int;
public function  get__Str_25795():Int
        {
            return this._Str_21563;
        }

        public var _Str_23507(get,never):Int;
public function  get__Str_23507():Int
        {
            return this._Str_20588;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

	public function new() {}
    }

