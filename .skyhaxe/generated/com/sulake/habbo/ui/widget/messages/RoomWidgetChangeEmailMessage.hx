package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetChangeEmailMessage extends RoomWidgetMessage 
    {
        public static inline final RWCEM_CHANGE_EMAIL= "rwcem_change_email";

        var _newEmail:String;

        public function new(k:String)
        {
            super(RWCEM_CHANGE_EMAIL);
            this._newEmail = k;
        }

        public var _Str_22654(get,never):String;
public function  get__Str_22654():String
        {
            return this._newEmail;
        }
    }

