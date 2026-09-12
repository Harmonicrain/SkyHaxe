package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.NavigatorSettingsMessageParser;

     class NavigatorSettingsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NavigatorSettingsMessageParser);
        }

        public function getParser():NavigatorSettingsMessageParser
        {
            return Std.downcast(this._parser , NavigatorSettingsMessageParser);
        }
    }

