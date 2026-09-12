package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class InfoFeedEnableMessageParser implements IMessageParser
    {
        var _enabled:Bool = false;


        public function flush():Bool
        {
            this._enabled = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._enabled = k.readBoolean();
            return true;
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._enabled;
        }

	public function new() {}
    }

