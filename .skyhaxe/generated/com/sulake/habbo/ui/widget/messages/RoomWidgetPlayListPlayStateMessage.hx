package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetPlayListPlayStateMessage extends RoomWidgetMessage 
    {
        public static inline final RWPLPS_TOGGLE_PLAY_PAUSE= "RWPLPS_TOGGLE_PLAY_PAUSE";

        var _furniId:Int = 0;
        var _position:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int=-1)
        {
            super(k);
            this._furniId = _arg_2;
            this._position = _arg_3;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var position(get,never):Int;
public function  get_position():Int
        {
            return this._position;
        }
    }

