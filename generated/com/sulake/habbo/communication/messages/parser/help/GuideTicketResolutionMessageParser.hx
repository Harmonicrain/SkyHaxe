package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideTicketResolutionMessageParser implements IMessageParser
    {
        static inline final RESOLUTION_GUARDIANS_TOOK_ACTION= 0;
        static inline final RESOLUTION_FORWARDED_TO_MODERATORS= 1;
        static inline final RESOLUTION_REPORTER_IS_ABUSIVE= 2;

        var _resolution:Int = -1;


        public function flush():Bool
        {
            this._resolution = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._resolution = k.readInteger();
            return true;
        }

        public var localizationCode(get,never):String;
function  get_localizationCode():String
        {
            if (((this._resolution == RESOLUTION_GUARDIANS_TOOK_ACTION) || (this._resolution == RESOLUTION_FORWARDED_TO_MODERATORS)))
            {
                return "valid";
            }
            return "invalid";
        }

	public function new() {}
    }

