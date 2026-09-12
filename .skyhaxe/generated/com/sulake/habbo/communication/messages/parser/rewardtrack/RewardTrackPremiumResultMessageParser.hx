package com.sulake.habbo.communication.messages.parser.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class RewardTrackPremiumResultMessageParser implements IMessageParser
    {
        public static inline final SUCCESS= 0;

        var _trackId:String;
        var _resultCode:Int = 0;
        var _points:Int = 0;

        public function flush():Bool
        {
            this._trackId = null;
            this._resultCode = 0;
            this._points = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._trackId = wrapper.readString();
            this._resultCode = wrapper.readInteger();
            this._points = wrapper.readInteger();
            return true;
        }

        public var trackId(get,never):String;
public function  get_trackId():String
        {
            return this._trackId;
        }

        public var resultCode(get,never):Int;
public function  get_resultCode():Int
        {
            return this._resultCode;
        }

        public var points(get,never):Int;
public function  get_points():Int
        {
            return this._points;
        }

	public function new() {}
    }

