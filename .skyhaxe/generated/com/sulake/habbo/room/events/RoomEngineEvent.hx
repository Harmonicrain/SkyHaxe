package com.sulake.habbo.room.events
;
    import flash.events.Event;

     class RoomEngineEvent extends Event 
    {
        public static inline final ENGINE_INITIALIZED= "REE_ENGINE_INITIALIZED";
        public static inline final INITIALIZED= "REE_INITIALIZED";
        public static inline final DISPOSED= "REE_DISPOSED";
        public static inline final GAME_MODE= "REE_GAME_MODE";
        public static inline final NORMAL_MODE= "REE_NORMAL_MODE";
        public static inline final OBJECTS_INITIALIZED= "REE_OBJECTS_INITIALIZED";
        public static inline final ROOM_ZOOMED= "REE_ROOM_ZOOMED";

        var _roomId:Int = 0;

        public function new(k:String, roomId:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._roomId = roomId;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

