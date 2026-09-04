package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuUserVariablesPageParser;
     final class WiredMenuUserVariablesPageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction){super(callback,WiredMenuUserVariablesPageParser);}
        public function getParser():WiredMenuUserVariablesPageParser{return Std.downcast(_parser , WiredMenuUserVariablesPageParser);}
    }

