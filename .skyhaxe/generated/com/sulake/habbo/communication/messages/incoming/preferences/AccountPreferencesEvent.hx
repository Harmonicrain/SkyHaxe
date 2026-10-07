package com.sulake.habbo.communication.messages.incoming.preferences
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.preferences.AccountPreferencesParser;

     class AccountPreferencesEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, AccountPreferencesParser);
        }

        public function getParser():AccountPreferencesParser
        {
            return Std.downcast(this._parser , AccountPreferencesParser);
        }
    }

