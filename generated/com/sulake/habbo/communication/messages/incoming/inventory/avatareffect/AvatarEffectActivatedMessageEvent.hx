package com.sulake.habbo.communication.messages.incoming.inventory.avatareffect
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.avatareffect.AvatarEffectActivatedMessageParser;

     class AvatarEffectActivatedMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvatarEffectActivatedMessageParser);
        }

        public function getParser():AvatarEffectActivatedMessageParser
        {
            return Std.downcast(_parser , AvatarEffectActivatedMessageParser);
        }
    }

