package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetChatSelectAvatarMessage extends RoomWidgetMessage 
    {
        public static inline final RWCSAM_MESSAGE_SELECT_AVATAR= "RWCSAM_MESSAGE_SELECT_AVATAR";

        var _objectId:Int = 0;
        var _userName:String;
        var _roomId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            super(k);
            this._objectId = _arg_2;
            this._roomId = _arg_4;
            this._userName = _arg_3;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

