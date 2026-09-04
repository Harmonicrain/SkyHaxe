package com.sulake.habbo.room.events
;
     class RoomEngineTriggerWidgetEvent extends RoomEngineObjectEvent 
    {
        public static inline final OPEN_WIDGET= "RETWE_OPEN_WIDGET";
        public static inline final CLOSE_WIDGET= "RETWE_CLOSE_WIDGET";
        public static inline final RETWE_OPEN_FURNI_CONTEXT_MENU= "RETWE_OPEN_FURNI_CONTEXT_MENU";
        public static inline final RETWE_CLOSE_FURNI_CONTEXT_MENU= "RETWE_CLOSE_FURNI_CONTEXT_MENU";
        public static inline final RETWE_REQUEST_PLACEHOLDER= "RETWE_REQUEST_PLACEHOLDER";
        public static inline final RETWE_REQUEST_CREDITFURNI= "RETWE_REQUEST_CREDITFURNI";
        public static inline final RETWE_REQUEST_STICKIE= "RETWE_REQUEST_STICKIE";
        public static inline final RETWE_REQUEST_PRESENT= "RETWE_REQUEST_PRESENT";
        public static inline final RETWE_REQUEST_TROPHY= "RETWE_REQUEST_TROPHY";
        public static inline final RETWE_REQUEST_TEASER= "RETWE_REQUEST_TEASER";
        public static inline final RETWE_REQUEST_ECOTRONBOX= "RETWE_REQUEST_ECOTRONBOX";
        public static inline final RETWE_REQUEST_DIMMER= "RETWE_REQUEST_DIMMER";
        public static inline final RETWE_REMOVE_DIMMER= "RETWE_REMOVE_DIMMER";
        public static inline final RETWE_REQUEST_CLOTHING_CHANGE= "RETWE_REQUEST_CLOTHING_CHANGE";
        public static inline final RETWE_REQUEST_PLAYLIST_EDITOR= "RETWE_REQUEST_PLAYLIST_EDITOR";
        public static inline final RETWE_REQUEST_MANNEQUIN= "RETWE_REQUEST_MANNEQUIN";
        public static inline final ROWRE_REQUEST_MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG= "ROWRE_REQUEST_MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG";
        public static inline final ROWRE_REQUEST_PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG= "ROWRE_REQUEST_PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG";
        public static inline final RETWE_REQUEST_BACKGROUND_COLOR= "RETWE_REQUEST_BACKGROUND_COLOR";
        public static inline final RETWE_REQUEST_AREA_HIDE= "RETWE_REQUEST_AREA_HIDE";
        public static inline final RETWE_REQUEST_MYSTERYBOX_OPEN_DIALOG= "RETWE_REQUEST_MYSTERYBOX_OPEN_DIALOG";
        public static inline final RETWE_REQUEST_EFFECTBOX_OPEN_DIALOG= "RETWE_REQUEST_EFFECTBOX_OPEN_DIALOG";
        public static inline final RETWE_REQUEST_MYSTERYTROPHY_OPEN_DIALOG= "RETWE_REQUEST_MYSTERYTROPHY_OPEN_DIALOG";
        public static inline final RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING= "RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING";
        public static inline final RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED= "RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED";
        public static inline final RETWE_REQUEST_FRIEND_FURNITURE_CONFIRM= "RETWE_REQUEST_FRIEND_FURNITURE_CONFIRM";
        public static inline final RETWE_REQUEST_FRIEND_FURNITURE_ENGRAVING= "RETWE_REQUEST_FRIEND_FURNITURE_ENGRAVING";
        public static inline final RETWE_REQUEST_BADGE_DISPLAY_ENGRAVING= "RETWE_REQUEST_BADGE_DISPLAY_ENGRAVING";
        public static inline final RETWE_REQUEST_HIGH_SCORE_DISPLAY= "RETWE_REQUEST_HIGH_SCORE_DISPLAY";
        public static inline final RETWE_REQUEST_HIDE_HIGH_SCORE_DISPLAY= "RETWE_REQUEST_HIDE_HIGH_SCORE_DISPLAY";
        public static inline final RETWE_REQUEST_INTERNAL_LINK= "RETWE_REQUEST_INTERNAL_LINK";
        public static inline final RETWE_REQUEST_ROOM_LINK= "RETWE_REQUEST_ROOM_LINK";

        var _widget:String;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String=null, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_6, _arg_7);
            this._widget = _arg_5;
        }

        public var widget(get,never):String;
function  get_widget():String
        {
            return this._widget;
        }

        public var contextMenu(get,never):String;
function  get_contextMenu():String
        {
            return this._widget;
        }
    }

