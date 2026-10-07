package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetStickieDataUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWSDUE_STICKIE_DATA= "RWSDUE_STICKIE_DATA";

        var _objectId:Int = -1;
        var _objectType:String;
        var _text:String;
        var _colorHex:String;
        var _controller:Bool = false;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Bool, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_7, _arg_8);
            this._objectId = _arg_2;
            this._objectType = _arg_3;
            this._text = _arg_4;
            this._colorHex = _arg_5;
            this._controller = _arg_6;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var objectType(get,never):String;
public function  get_objectType():String
        {
            return this._objectType;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var colorHex(get,never):String;
public function  get_colorHex():String
        {
            return this._colorHex;
        }

        public var controller(get,never):Bool;
public function  get_controller():Bool
        {
            return this._controller;
        }
    }

