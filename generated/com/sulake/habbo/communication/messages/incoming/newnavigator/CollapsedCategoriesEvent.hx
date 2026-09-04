package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.newnavigator.CollapsedCategoriesMessageParser;

     class CollapsedCategoriesEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CollapsedCategoriesMessageParser);
        }

        public function getParser():CollapsedCategoriesMessageParser
        {
            return Std.downcast(parser , CollapsedCategoriesMessageParser);
        }
    }

