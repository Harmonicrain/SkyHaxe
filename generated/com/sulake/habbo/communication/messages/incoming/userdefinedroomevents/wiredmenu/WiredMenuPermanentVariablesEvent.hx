package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuPermanentVariablesParser;
     final class WiredMenuPermanentVariablesEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction){super(callback,WiredMenuPermanentVariablesParser);}
        public function getParser():WiredMenuPermanentVariablesParser{return Std.downcast(_parser , WiredMenuPermanentVariablesParser);}
    }

