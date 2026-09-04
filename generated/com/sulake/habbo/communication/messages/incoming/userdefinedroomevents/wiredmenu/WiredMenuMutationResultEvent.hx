package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuMutationResultParser;
     final class WiredMenuMutationResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuMutationResultParser); }
        public function getParser():WiredMenuMutationResultParser { return Std.downcast(_parser , WiredMenuMutationResultParser); }
    }

