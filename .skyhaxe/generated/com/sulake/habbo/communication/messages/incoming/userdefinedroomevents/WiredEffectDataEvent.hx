package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredEffectDataMessageParser;

     class WiredEffectDataEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, WiredEffectDataMessageParser);
        }

        public function getParser():WiredEffectDataMessageParser
        {
            return Std.downcast(this._parser , WiredEffectDataMessageParser);
        }
    }

