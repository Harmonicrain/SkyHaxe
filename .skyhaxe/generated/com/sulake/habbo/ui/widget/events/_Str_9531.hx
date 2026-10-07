package com.sulake.habbo.ui.widget.events
;
     class _Str_9531 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWUE_REQUEST_ME_MENU_TOOLBAR_CLICKED= "RWUE_REQUEST_ME_MENU_TOOLBAR_CLICKED";
        public static inline final ICON_TYPE_ME_MENU= "ICON_TYPE_ME_MENU";
        public static inline final ICON_TYPE_ROOM_INFO= "ICON_TYPE_ROOM_INFO";

        var _Str_22092:String;
        var _active:Bool = false;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RWUE_REQUEST_ME_MENU_TOOLBAR_CLICKED, _arg_3, _arg_4);
            this._Str_22092 = k;
            this._active = _arg_2;
        }

        public var active(get,never):Bool;
public function  get_active():Bool
        {
            return this._active;
        }

        public var _Str_25981(get,never):String;
public function  get__Str_25981():String
        {
            return this._Str_22092;
        }
    }

