package com.sulake.habbo.ui.widget.events
;
     class _Str_3345 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWREUE_GAME_MODE= "RWREUE_GAME_MODE";
        public static inline final RWREUE_NORMAL_MODE= "RWREUE_NORMAL_MODE";

        var _roomId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._roomId = _arg_2;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

