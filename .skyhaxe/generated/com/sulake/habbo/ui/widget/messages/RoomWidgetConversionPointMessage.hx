package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetConversionPointMessage extends RoomWidgetMessage 
    {
        public static inline final RWCPM_CONVERSION_POINT= "RWCPM_CONVERSION_POINT";

        var _category:String;
        var _pointType:String;
        var _action:String;
        var _extraString:String;
        var _extraInt:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String="", _arg_6:Int=0)
        {
            super(k);
            this._category = _arg_2;
            this._pointType = _arg_3;
            this._action = _arg_4;
            this._extraString = (ASCompat.stringAsBool(_arg_5) ? _arg_5 : "");
            this._extraInt = ((_arg_6 != 0) ? _arg_6 : 0);
        }

        public var category(get,never):String;
public function  get_category():String
        {
            return this._category;
        }

        public var _Str_23854(get,never):String;
public function  get__Str_23854():String
        {
            return this._pointType;
        }

        public var action(get,never):String;
public function  get_action():String
        {
            return this._action;
        }

        public var _Str_22656(get,never):String;
public function  get__Str_22656():String
        {
            return this._extraString;
        }

        public var _Str_24399(get,never):Int;
public function  get__Str_24399():Int
        {
            return this._extraInt;
        }
    }

