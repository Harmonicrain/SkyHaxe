package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.BuildersClubSubscriptionStatusMessageParser;

     class BuildersClubSubscriptionStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BuildersClubSubscriptionStatusMessageParser);
        }

        public function getParser():BuildersClubSubscriptionStatusMessageParser
        {
            return Std.downcast(this._parser , BuildersClubSubscriptionStatusMessageParser);
        }
    }

