package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetChangeMottoMessage extends RoomWidgetMessage 
    {
        public static inline final RWVM_CHANGE_MOTTO_MESSAGE= "RWVM_CHANGE_MOTTO_MESSAGE";

        var _motto:String;

        public function new(k:String)
        {
            super(RWVM_CHANGE_MOTTO_MESSAGE);
            this._motto = k;
        }

        public var motto(get,never):String;
public function  get_motto():String
        {
            return this._motto;
        }
    }

