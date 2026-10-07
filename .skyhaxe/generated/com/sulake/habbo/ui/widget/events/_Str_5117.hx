package com.sulake.habbo.ui.widget.events
;
     class _Str_5117 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWARTDUE_TROPHY_DATA= "RWARTDUE_TROPHY_DATA";

        var _color:Float = Math.NaN;
        var _name:String;
        var _date:String;
        var _message:String;
        var _Str_3918:Int = 0;

        public function new(k:String, _arg_2:Float, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_7, _arg_8);
            this._color = _arg_2;
            this._name = _arg_3;
            this._date = _arg_4;
            this._message = _arg_5;
            this._Str_3918 = _arg_6;
        }

        public var color(get,never):Float;
public function  get_color():Float
        {
            return this._color;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var date(get,never):String;
public function  get_date():String
        {
            return this._date;
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }

        public var _Str_16299(get,never):Int;
public function  get__Str_16299():Int
        {
            return this._Str_3918;
        }
    }

