package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionPartnerIsTypingMessageParser implements IMessageParser 
    {
        var _isTyping:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._isTyping = k.readBoolean();
            return true;
        }

        public var isTyping(get,never):Bool;
public function  get_isTyping():Bool
        {
            return this._isTyping;
        }

	public function new() {}
    }

