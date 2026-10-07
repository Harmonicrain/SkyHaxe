package com.sulake.habbo.communication.messages.parser.landingview.votes
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CommunityVoteReceivedParser implements IMessageParser
    {
        var _acknowledged:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._acknowledged = k.readBoolean();
            return true;
        }

        public var acknowledged(get,never):Bool;
public function  get_acknowledged():Bool
        {
            return this._acknowledged;
        }

	public function new() {}
    }

