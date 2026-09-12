package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetFurniToWidgetMessage extends RoomWidgetMessage 
    {
        public static inline final RWFWM_MESSAGE_REQUEST_CREDITFURNI= "RWFWM_MESSAGE_REQUEST_CREDITFURNI";
        public static inline final RWFWM_MESSAGE_REQUEST_STICKIE= "RWFWM_MESSAGE_REQUEST_STICKIE";
        public static inline final RWFWM_MESSAGE_REQUEST_PRESENT= "RWFWM_MESSAGE_REQUEST_PRESENT";
        public static inline final RWFWM_MESSAGE_REQUEST_TROPHY= "RWFWM_MESSAGE_REQUEST_TROPHY";
        public static inline final RWFWM_MESSAGE_REQUEST_TEASER= "RWFWM_MESSAGE_REQUEST_TEASER";
        public static inline final RWFWM_MESSAGE_REQUEST_ECOTRONBOX= "RWFWM_MESSAGE_REQUEST_ECOTRONBOX";
        public static inline final RWFWM_MESSAGE_REQUEST_DIMMER= "RWFWM_MESSAGE_REQUEST_DIMMER";
        public static inline final RWFWM_MESSAGE_REQUEST_PLACEHOLDER= "RWFWM_MESSAGE_REQUEST_PLACEHOLDER";
        public static inline final RWFWM_MESSAGE_REQUEST_CLOTHING_CHANGE= "RWFWM_MESSAGE_REQUEST_CLOTHING_CHANGE";
        public static inline final RWFWM_MESSAGE_REQUEST_PLAYLIST_EDITOR= "RWFWM_MESSAGE_REQUEST_PLAYLIST_EDITOR";
        public static inline final RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING= "RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING";
        public static inline final RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED= "RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED";
        public static inline final RWFWM_WIDGET_MESSAGE_REQUEST_BADGE_DISPLAY_ENGRAVING= "RWFWM_WIDGET_MESSAGE_REQUEST_BADGE_DISPLAY_ENGRAVING";

        var _id:Int = 0;
        var _category:Int = 0;
        var _roomId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            super(k);
            this._id = _arg_2;
            this._category = _arg_3;
            this._roomId = _arg_4;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

