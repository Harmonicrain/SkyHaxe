package com.sulake.habbo.communication.messages.incoming.nux
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.nux.NewUserExperienceGiftOfferParser;

     class NewUserExperienceGiftOfferEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, NewUserExperienceGiftOfferParser);
        }

        public function getParser():NewUserExperienceGiftOfferParser
        {
            return Std.downcast(_parser , NewUserExperienceGiftOfferParser);
        }
    }

