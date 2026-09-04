package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectWidgetRequestEvent extends RoomObjectEvent 
    {
        public static inline final OPEN_WIDGET= "ROWRE_OPEN_WIDGET";
        public static inline final CLOSE_WIDGET= "ROWRE_CLOSE_WIDGET";
        public static inline final OPEN_FURNI_CONTEXT_MENU= "ROWRE_OPEN_FURNI_CONTEXT_MENU";
        public static inline final CLOSE_FURNI_CONTEXT_MENU= "ROWRE_CLOSE_FURNI_CONTEXT_MENU";
        public static inline final PLACEHOLDER= "ROWRE_PLACEHOLDER";
        public static inline final CREDITFURNI= "ROWRE__CREDITFURNI";
        public static inline final STICKIE= "ROWRE__STICKIE";
        public static inline final PRESENT= "ROWRE_PRESENT";
        public static inline final TROPHY= "ROWRE_TROPHY";
        public static inline final TEASER= "ROWRE_TEASER";
        public static inline final ECOTRONBOX= "ROWRE_ECOTRONBOX";
        public static inline final DIMMER= "ROWRE_DIMMER";
        public static inline final WIDGET_REMOVE_DIMMER= "ROWRE_WIDGET_REMOVE_DIMMER";
        public static inline final CLOTHING_CHANGE= "ROWRE_CLOTHING_CHANGE";
        public static inline final JUKEBOX_PLAYLIST_EDITOR= "ROWRE_JUKEBOX_PLAYLIST_EDITOR";
        public static inline final MANNEQUIN= "ROWRE_MANNEQUIN";
        public static inline final PET_PRODUCT_MENU= "ROWRE_PET_PRODUCT_MENU";
        public static inline final GUILD_FURNI_CONTEXT_MENU= "ROWRE_GUILD_FURNI_CONTEXT_MENU";
        public static inline final MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG= "ROWRE_MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG";
        public static inline final PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG= "ROWRE_PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG";
        public static inline final BACKGROUND_COLOR= "ROWRE_BACKGROUND_COLOR";
        public static inline final AREA_HIDE= "ROWRE_HIDE_AREA";
        public static inline final MYSTERYBOX_OPEN_DIALOG= "ROWRE_MYSTERYBOX_OPEN_DIALOG";
        public static inline final EFFECTBOX_OPEN_DIALOG= "ROWRE_EFFECTBOX_OPEN_DIALOG";
        public static inline final MYSTERYTROPHY_OPEN_DIALOG= "ROWRE_MYSTERYTROPHY_OPEN_DIALOG";
        public static inline final ACHIEVEMENT_RESOLUTION_OPEN= "ROWRE_ACHIEVEMENT_RESOLUTION_OPEN";
        public static inline final ACHIEVEMENT_RESOLUTION_ENGRAVING= "ROWRE_ACHIEVEMENT_RESOLUTION_ENGRAVING";
        public static inline final ACHIEVEMENT_RESOLUTION_FAILED= "ROWRE_ACHIEVEMENT_RESOLUTION_FAILED";
        public static inline final FRIEND_FURNITURE_CONFIRM= "ROWRE_FRIEND_FURNITURE_CONFIRM";
        public static inline final FRIEND_FURNITURE_ENGRAVING= "ROWRE_FRIEND_FURNITURE_ENGRAVING";
        public static inline final BADGE_DISPLAY_ENGRAVING= "ROWRE_BADGE_DISPLAY_ENGRAVING";
        public static inline final HIGH_SCORE_DISPLAY= "ROWRE_HIGH_SCORE_DISPLAY";
        public static inline final HIDE_HIGH_SCORE_DISPLAY= "ROWRE_HIDE_HIGH_SCORE_DISPLAY";
        public static inline final INERNAL_LINK= "ROWRE_INTERNAL_LINK";
        public static inline final ROOM_LINK= "ROWRE_ROOM_LINK";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

