package com.sulake.habbo.roomevents.wired_trading
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.UbuntuWiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July uses a dedicated Ubuntu style for Wired trading surfaces. */
     class UbuntuPresetManager extends PresetManager
    {
        var _style:WiredStyle;
        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            super(roomEvents);
            this._style = new UbuntuWiredStyle(roomEvents);
        }
        override public function  get_wiredStyle():WiredStyle { return this._style; }
    }

