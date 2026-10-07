package com.sulake.habbo.communication.messages.incoming.room.action
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.action.AvatarEffectMessageParser;

     class AvatarEffectMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, AvatarEffectMessageParser);
        }

        public function getParser():AvatarEffectMessageParser
        {
            return Std.downcast(_parser , AvatarEffectMessageParser);
        }
    }

