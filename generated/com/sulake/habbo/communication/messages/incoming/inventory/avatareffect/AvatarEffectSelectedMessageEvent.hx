package com.sulake.habbo.communication.messages.incoming.inventory.avatareffect
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.avatareffect.AvatarEffectSelectedMessageParser;

     class AvatarEffectSelectedMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvatarEffectSelectedMessageParser);
        }

        public function getParser():AvatarEffectSelectedMessageParser
        {
            return Std.downcast(_parser , AvatarEffectSelectedMessageParser);
        }
    }

