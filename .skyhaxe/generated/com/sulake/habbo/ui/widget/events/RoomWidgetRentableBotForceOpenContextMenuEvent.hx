package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetRentableBotForceOpenContextMenuEvent extends RoomWidgetUpdateEvent
    {
        public static inline final OPEN= "RWRBFOCME_OPEN";

        var _botId:Int = 0;

        public function new(k:Int)
        {
            this._botId = k;
            super(OPEN);
        }

        public var botId(get,never):Int;
public function  get_botId():Int
        {
            return this._botId;
        }
    }

