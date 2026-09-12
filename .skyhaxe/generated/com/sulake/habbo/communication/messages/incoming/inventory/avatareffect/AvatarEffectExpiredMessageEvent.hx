package com.sulake.habbo.communication.messages.incoming.inventory.avatareffect
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.avatareffect.AvatarEffectExpiredMessageParser;

     class AvatarEffectExpiredMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvatarEffectExpiredMessageParser);
        }

        public function getParser():AvatarEffectExpiredMessageParser
        {
            return Std.downcast(_parser , AvatarEffectExpiredMessageParser);
        }
    }

