package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetSongUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final PLAYING_CHANGED= "RWSUE_PLAYING_CHANGED";
        public static inline final DATA_RECEIVED= "RWSUE_DATA_RECEIVED";

        var _songId:Int = 0;
        var _songName:String;
        var _songAuthor:String;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._songId = _arg_2;
            this._songName = _arg_3;
            this._songAuthor = _arg_4;
        }

        public var songId(get,never):Int;
public function  get_songId():Int
        {
            return this._songId;
        }

        public var songName(get,never):String;
public function  get_songName():String
        {
            return this._songName;
        }

        public var _Str_20860(get,never):String;
public function  get__Str_20860():String
        {
            return this._songAuthor;
        }
    }

