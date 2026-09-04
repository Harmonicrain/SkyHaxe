package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredRewardResultMessageParser;

     class WiredRewardResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public static inline final _Str_18436= 6;
        public static inline final _Str_17787= 7;

        public function new(k:ASFunction)
        {
            super(k, WiredRewardResultMessageParser);
        }

        public function getParser():WiredRewardResultMessageParser
        {
            return Std.downcast(this._parser , WiredRewardResultMessageParser);
        }
    }

