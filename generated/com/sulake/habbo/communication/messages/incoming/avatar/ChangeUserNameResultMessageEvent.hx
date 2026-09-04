package com.sulake.habbo.communication.messages.incoming.avatar
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.avatar.ChangeUserNameResultMessageParser;

     class ChangeUserNameResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public static var NAME_OK:Int = 0;
        public static var ERROR_NAME_REQUIRED:Int = 1;
        public static var ERROR_NAME_TOO_SHORT:Int = 2;
        public static var ERROR_NAME_TOO_LONG:Int = 3;
        public static var ERROR_NAME_NOT_VALID:Int = 4;
        public static var ERROR_NAME_IN_USE:Int = 5;
        public static var ERROR_NAME_CHANGE_NOT_ALLOWED:Int = 6;
        public static var ERROR_MERGE_HOTEL_DOWN:Int = 7;

        public function new(k:ASFunction)
        {
            super(k, ChangeUserNameResultMessageParser);
        }

        public function getParser():ChangeUserNameResultMessageParser
        {
            return Std.downcast(_parser , ChangeUserNameResultMessageParser);
        }
    }

