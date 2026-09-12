package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetChatInputContentUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWWCIDE_CHAT_INPUT_CONTENT= "RWWCIDE_CHAT_INPUT_CONTENT";
        public static inline final WHISPER= "whisper";
        public static inline final SHOUT= "shout";

        var _messageType:String = "";
        var _userName:String = "";

        public function new(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RWWCIDE_CHAT_INPUT_CONTENT, _arg_3, _arg_4);
            this._messageType = k;
            this._userName = _arg_2;
        }

        public var _Str_23621(get,never):String;
public function  get__Str_23621():String
        {
            return this._messageType;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

