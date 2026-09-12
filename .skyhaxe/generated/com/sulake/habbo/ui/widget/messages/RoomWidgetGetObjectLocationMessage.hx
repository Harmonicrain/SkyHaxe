package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetGetObjectLocationMessage extends RoomWidgetMessage 
    {
        public static inline final RWGOI_MESSAGE_GET_OBJECT_LOCATION= "RWGOI_MESSAGE_GET_OBJECT_LOCATION";
        public static inline final RWGOI_MESSAGE_GET_GAME_OBJECT_LOCATION= "RWGOI_MESSAGE_GET_GAME_OBJECT_LOCATION";

        var _objectId:Int = 0;
        var _objectType:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int)
        {
            super(k);
            this._objectId = _arg_2;
            this._objectType = _arg_3;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var objectType(get,never):Int;
public function  get_objectType():Int
        {
            return this._objectType;
        }
    }

