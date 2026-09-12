package com.sulake.habbo.communication.messages.incoming.advertisement
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.advertisement.InterstitialMessageParser;

     class InterstitialMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, InterstitialMessageParser);
        }

        public function getParser():InterstitialMessageParser
        {
            return Std.downcast(this._parser , InterstitialMessageParser);
        }
    }

