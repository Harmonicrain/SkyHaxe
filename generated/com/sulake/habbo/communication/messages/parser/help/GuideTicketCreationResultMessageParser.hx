package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideTicketCreationResultMessageParser implements IMessageParser
    {
        static inline final CREATION_RESULT_OK= 0;
        static inline final CREATION_RESULT_UNABLE_TO_REPORT= 1;
        static inline final CREATION_RESULT_NO_CHATLOG_FOUND= 2;
        static inline final CREATION_RESULT_BULLY_ALREADY_REPORTED= 3;

        var _result:Int = -1;


        public function flush():Bool
        {
            this._result = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._result = k.readInteger();
            return true;
        }

        public var localizationCode(get,never):String;
function  get_localizationCode():String
        {
            switch (this._result)
            {
                case CREATION_RESULT_OK:
                    return "sent";
                case CREATION_RESULT_UNABLE_TO_REPORT:
                    return "blocked";
                case CREATION_RESULT_NO_CHATLOG_FOUND:
                    return "nochat";
                case CREATION_RESULT_BULLY_ALREADY_REPORTED:
                    return "alreadyreported";
                default:
                    return "invalid";
            }
        }

	public function new() {}
    }

