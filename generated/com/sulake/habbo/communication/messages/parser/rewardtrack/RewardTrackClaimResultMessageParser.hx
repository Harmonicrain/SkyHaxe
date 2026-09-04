package com.sulake.habbo.communication.messages.parser.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class RewardTrackClaimResultMessageParser implements IMessageParser
    {
        public static inline final SUCCESS= 0;

        var _trackId:String;
        var _rewardId:String;
        var _resultCode:Int = 0;

        public function flush():Bool
        {
            this._trackId = null;
            this._rewardId = null;
            this._resultCode = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._trackId = wrapper.readString();
            this._rewardId = wrapper.readString();
            this._resultCode = wrapper.readInteger();
            return true;
        }

        public var trackId(get,never):String;
function  get_trackId():String
        {
            return this._trackId;
        }

        public var rewardId(get,never):String;
function  get_rewardId():String
        {
            return this._rewardId;
        }

        public var resultCode(get,never):Int;
function  get_resultCode():Int
        {
            return this._resultCode;
        }

	public function new() {}
    }

