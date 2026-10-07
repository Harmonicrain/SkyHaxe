package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetLetUserInMessage extends RoomWidgetMessage 
    {
        public static inline final RWLUIM_LET_USER_IN= "RWLUIM_LET_USER_IN";

        var _userName:String;
        var _canEnter:Bool = false;

        public function new(k:String, _arg_2:Bool)
        {
            super(RWLUIM_LET_USER_IN);
            this._userName = k;
            this._canEnter = _arg_2;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var _Str_23117(get,never):Bool;
public function  get__Str_23117():Bool
        {
            return this._canEnter;
        }
    }

