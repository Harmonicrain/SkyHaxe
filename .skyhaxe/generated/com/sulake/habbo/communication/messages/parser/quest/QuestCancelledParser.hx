package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestCancelledParser implements IMessageParser 
    {
        var _expired:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._expired = k.readBoolean();
            return true;
        }

        public var expired(get,never):Bool;
public function  get_expired():Bool
        {
            return this._expired;
        }

	public function new() {}
    }

