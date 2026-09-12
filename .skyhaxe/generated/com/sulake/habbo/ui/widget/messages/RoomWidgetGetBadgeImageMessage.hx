package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetGetBadgeImageMessage extends RoomWidgetMessage 
    {
        public static inline final RWGOI_MESSAGE_GET_BADGE_IMAGE= "RWGOI_MESSAGE_GET_BADGE_IMAGE";

        var _badgeId:String = "";

        public function new(k:String)
        {
            super(RWGOI_MESSAGE_GET_BADGE_IMAGE);
            this._badgeId = k;
        }

        public var badgeId(get,never):String;
public function  get_badgeId():String
        {
            return this._badgeId;
        }
    }

