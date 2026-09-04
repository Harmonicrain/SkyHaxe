package com.sulake.habbo.communication.messages.incoming.inventory.clothes
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.clothing.FigureSetIdsMessageParser;

     class FigureSetIdsEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FigureSetIdsMessageParser);
        }

        public function getParser():FigureSetIdsMessageParser
        {
            return Std.downcast(_parser , FigureSetIdsMessageParser);
        }
    }

