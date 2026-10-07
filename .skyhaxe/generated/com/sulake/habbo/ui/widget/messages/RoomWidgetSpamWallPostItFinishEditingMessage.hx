package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetSpamWallPostItFinishEditingMessage extends RoomWidgetMessage 
    {
        public static inline final RWSWPFEE_SEND_POSTIT_DATA= "RWSWPFEE_SEND_POSTIT_DATA";

        var _objectId:Int = 0;
        var _location:String;
        var _text:String;
        var _colorHex:String;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:String)
        {
            super(k);
            this._objectId = _arg_2;
            this._location = _arg_3;
            this._text = _arg_4;
            this._colorHex = _arg_5;
        }

        public var location(get,never):String;
public function  get_location():String
        {
            return this._location;
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

