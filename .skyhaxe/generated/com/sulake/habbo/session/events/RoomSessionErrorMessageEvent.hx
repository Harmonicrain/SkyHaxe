package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionErrorMessageEvent extends RoomSessionEvent 
    {
        public static inline final RSEME_KICKED= "RSEME_KICKED";
        public static inline final RSEME_PETS_FORBIDDEN_IN_HOTEL= "RSEME_PETS_FORBIDDEN_IN_HOTEL";
        public static inline final RSEME_PETS_FORBIDDEN_IN_FLAT= "RSEME_PETS_FORBIDDEN_IN_FLAT";
        public static inline final RSEME_MAX_PETS= "RSEME_MAX_PETS";
        public static inline final RSEME_MAX_NUMBER_OF_OWN_PETS= "RSEME_MAX_NUMBER_OF_OWN_PETS";
        public static inline final RSEME_NO_FREE_TILES_FOR_PET= "RSEME_NO_FREE_TILES_FOR_PET";
        public static inline final RSEME_SELECTED_TILE_NOT_FREE_FOR_PET= "RSEME_SELECTED_TILE_NOT_FREE_FOR_PET";
        public static inline final RSEME_BOTS_FORBIDDEN_IN_HOTEL= "RSEME_BOTS_FORBIDDEN_IN_HOTEL";
        public static inline final RSEME_BOTS_FORBIDDEN_IN_FLAT= "RSEME_BOTS_FORBIDDEN_IN_FLAT";
        public static inline final RSEME_BOT_LIMIT_REACHED= "RSEME_BOT_LIMIT_REACHED";
        public static inline final RSEME_SELECTED_TILE_NOT_FREE_FOR_BOT= "RSEME_SELECTED_TILE_NOT_FREE_FOR_BOT";
        public static inline final RSEME_BOT_NAME_NOT_ACCEPTED= "RSEME_BOT_NAME_NOT_ACCEPTED";

        var _message:String;

        public function new(k:String, _arg_2:IRoomSession, _arg_3:String=null, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_2, _arg_4, _arg_5);
            this._message = _arg_3;
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }
    }

