package com.sulake.habbo.ui.widget.events
;
     class _Str_3301 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPLENPE_USER_PLAY_SONG= "RWPLENPE_USER_PLAY_SONG";
        public static inline final RWPLENPW_USER_STOP_SONG= "RWPLENPW_USER_STOP_SONG";
        public static inline final RWPLENPE_SONG_CHANGED= "RWPLENPE_SONG_CHANGED";

        var _id:Int = 0;
        var _position:Int = 0;
        var _priority:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._id = _arg_2;
            this._position = _arg_3;
            this._priority = _arg_4;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var position(get,never):Int;
public function  get_position():Int
        {
            return this._position;
        }

        public var priority(get,never):Int;
public function  get_priority():Int
        {
            return this._priority;
        }
    }

