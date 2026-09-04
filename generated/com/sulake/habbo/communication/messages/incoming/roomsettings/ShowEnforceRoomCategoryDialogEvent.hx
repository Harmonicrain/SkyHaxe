package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.ShowEnforceRoomCategoryDialogParser;

     class ShowEnforceRoomCategoryDialogEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ShowEnforceRoomCategoryDialogParser);
        }

        public function getParser():ShowEnforceRoomCategoryDialogParser
        {
            return Std.downcast(this._parser , ShowEnforceRoomCategoryDialogParser);
        }
    }

