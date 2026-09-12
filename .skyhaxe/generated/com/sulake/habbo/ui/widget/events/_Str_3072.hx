package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;

     class _Str_3072 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWEBDUE_PACKAGEINFO= "RWEBDUE_PACKAGEINFO";
        public static inline final RWEBDUE_CONTENTS= "RWEBDUE_CONTENTS";

        var _objectId:Int = -1;
        var _text:String;
        var _Str_6880:String;
        var _controller:Bool = false;
        var _Str_12168:BitmapData;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:Bool=false, _arg_6:BitmapData=null, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_7, _arg_8);
            this._objectId = _arg_2;
            this._text = _arg_3;
            this._Str_6880 = _arg_4;
            this._controller = _arg_5;
            this._Str_12168 = _arg_6;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var controller(get,never):Bool;
public function  get_controller():Bool
        {
            return this._controller;
        }

        public var _Str_11625(get,never):BitmapData;
public function  get__Str_11625():BitmapData
        {
            return this._Str_12168;
        }

        public var _Str_17878(get,never):String;
public function  get__Str_17878():String
        {
            return this._Str_6880;
        }
    }

