package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.BCPlacementWarningMessageParser;

     class BCPlacementWarningMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BCPlacementWarningMessageParser);
        }

        public function getParser():BCPlacementWarningMessageParser
        {
            return Std.downcast(this._parser , BCPlacementWarningMessageParser);
        }
    }

