package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetClothingChangeMessage extends RoomWidgetMessage 
    {
        public static inline final RWCCM_REQUEST_EDITOR= "RWCCM_REQUEST_EDITOR";

        var _objectId:Int = 0;
        var _objectCategory:Int = 0;
        var _roomId:Int = 0;
        var _gender:String = "";

        public function new(k:String, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            super(k);
            this._gender = _arg_2;
            this._objectId = _arg_3;
            this._objectCategory = _arg_4;
            this._roomId = _arg_5;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var objectCategory(get,never):Int;
public function  get_objectCategory():Int
        {
            return this._objectCategory;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }
    }

