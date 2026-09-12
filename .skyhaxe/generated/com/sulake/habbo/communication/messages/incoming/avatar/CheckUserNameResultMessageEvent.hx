package com.sulake.habbo.communication.messages.incoming.avatar
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.avatar.CheckUserNameResultMessageParser;

     class CheckUserNameResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public static var NAME_OK:Int = 0;
        public static var ERROR_NAME_REQUIRED:Int = 1;
        public static var ERROR_NAME_TOO_SHORT:Int = 2;
        public static var ERROR_NAME_TOO_LONG:Int = 3;
        public static var ERROR_NAME_NOT_VALID:Int = 4;
        public static var ERROR_NAME_IN_USE:Int = 5;

        public function new(k:ASFunction)
        {
            super(k, CheckUserNameResultMessageParser);
        }

        public function getParser():CheckUserNameResultMessageParser
        {
            return Std.downcast(_parser , CheckUserNameResultMessageParser);
        }
    }

