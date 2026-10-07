package com.sulake.habbo.communication.messages.incoming.error
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.error.ErrorReportMessageParser;

     class ErrorReportEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, ErrorReportMessageParser);
        }

        public function getParser():ErrorReportMessageParser
        {
            return Std.downcast(this._parser , ErrorReportMessageParser);
        }
    }

