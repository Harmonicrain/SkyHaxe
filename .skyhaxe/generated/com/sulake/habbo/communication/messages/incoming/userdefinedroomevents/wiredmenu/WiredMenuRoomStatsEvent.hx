package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuRoomStatsParser;
     final class WiredMenuRoomStatsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuRoomStatsParser); }
        public function getParser():WiredMenuRoomStatsParser { return Std.downcast(_parser , WiredMenuRoomStatsParser); }
    }

