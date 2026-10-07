package com.sulake.habbo.communication.messages.incoming.inventory.avatareffect
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.avatareffect.AvatarEffectAddedMessageParser;

     class AvatarEffectAddedMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvatarEffectAddedMessageParser);
        }

        public function getParser():AvatarEffectAddedMessageParser
        {
            return Std.downcast(_parser , AvatarEffectAddedMessageParser);
        }
    }

