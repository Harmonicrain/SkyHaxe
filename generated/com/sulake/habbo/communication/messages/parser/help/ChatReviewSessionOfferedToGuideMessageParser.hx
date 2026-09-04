package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatReviewSessionOfferedToGuideMessageParser implements IMessageParser
    {
        var _acceptanceTimeout:Int = 0;


        public function flush():Bool
        {
            this._acceptanceTimeout = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._acceptanceTimeout = k.readInteger();
            return true;
        }

        public var _Str_23730(get,never):Int;
function  get__Str_23730():Int
        {
            return this._acceptanceTimeout;
        }

	public function new() {}
    }

