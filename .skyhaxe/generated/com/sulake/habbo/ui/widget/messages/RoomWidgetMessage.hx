package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetMessage 
    {
        public static inline final RWM_MESSAGE_TEST= "RWM_MESSAGE_TEST";

        var _type:String = "";

        public function new(k:String)
        {
            this._type = k;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }
    }

