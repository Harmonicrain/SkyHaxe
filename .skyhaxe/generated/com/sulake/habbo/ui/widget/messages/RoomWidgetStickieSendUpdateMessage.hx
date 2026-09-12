package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetStickieSendUpdateMessage extends RoomWidgetMessage 
    {
        public static inline final RWSUM_STICKIE_SEND_UPDATE= "RWSUM_STICKIE_SEND_UPDATE";
        public static inline final RWSUM_STICKIE_SEND_DELETE= "RWSUM_STICKIE_SEND_DELETE";

        var _objectId:Int = 0;
        var _text:String;
        var _colorHex:String;

        public function new(k:String, _arg_2:Int, _arg_3:String="", _arg_4:String="")
        {
            super(k);
            this._objectId = _arg_2;
            this._text = _arg_3;
            this._colorHex = _arg_4;
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

        public var colorHex(get,never):String;
public function  get_colorHex():String
        {
            return this._colorHex;
        }
    }

