package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuVariableHoldersParser;
     final class WiredMenuVariableHoldersEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuVariableHoldersParser); }
        public function getParser():WiredMenuVariableHoldersParser { return Std.downcast(_parser , WiredMenuVariableHoldersParser); }
    }

