package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuRoomSettingsParser;
     final class WiredMenuRoomSettingsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuRoomSettingsParser); }
        public function getParser():WiredMenuRoomSettingsParser { return Std.downcast(_parser , WiredMenuRoomSettingsParser); }
    }

