package com.sulake.habbo.communication.messages.incoming.inventory.avatareffect
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.avatareffect.AvatarEffectsMessageParser;

     class AvatarEffectsMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvatarEffectsMessageParser);
        }

        public function getParser():AvatarEffectsMessageParser
        {
            return Std.downcast(_parser , AvatarEffectsMessageParser);
        }
    }

