package com.sulake.habbo.communication.messages.incoming.shockwavesnowstorm
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.shockwavesnowstorm.SnowStormMessageParser;

    /** Shared typed base; each wire header has its own concrete event class for the registry. */
     class SnowStormMessageEvent extends MessageEvent
    {
        public function new(callback:ASFunction)
        { super(callback, SnowStormMessageParser); }
        public function getParser():SnowStormMessageParser
        { return Std.downcast(this._parser , SnowStormMessageParser); }
    }

