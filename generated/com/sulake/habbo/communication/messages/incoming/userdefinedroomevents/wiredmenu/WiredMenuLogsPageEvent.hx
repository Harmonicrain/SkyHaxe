package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuLogsPageParser;
     final class WiredMenuLogsPageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction){super(callback,WiredMenuLogsPageParser);}
        public function getParser():WiredMenuLogsPageParser{return Std.downcast(_parser , WiredMenuLogsPageParser);}
    }

