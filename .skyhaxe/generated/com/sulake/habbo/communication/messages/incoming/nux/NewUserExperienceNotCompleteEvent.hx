package com.sulake.habbo.communication.messages.incoming.nux
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.nux.NewUserExperienceNotCompleteParser;

     class NewUserExperienceNotCompleteEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NewUserExperienceNotCompleteParser);
        }

        public function getParser():NewUserExperienceNotCompleteParser
        {
            return Std.downcast(_parser , NewUserExperienceNotCompleteParser);
        }
    }

