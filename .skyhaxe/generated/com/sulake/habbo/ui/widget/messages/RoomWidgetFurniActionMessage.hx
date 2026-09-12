package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetFurniActionMessage extends RoomWidgetMessage 
    {
        public static inline final RWFUAM_ROTATE= "RWFUAM_ROTATE";
        public static inline final RWFAM_MOVE= "RWFAM_MOVE";
        public static inline final RWFAM_PICKUP= "RWFAM_PICKUP";
        public static inline final RWFAM_EJECT= "RWFAM_EJECT";
        public static inline final RWFAM_USE= "RWFAM_USE";
        public static inline final RWFAM_OPEN_WELCOME_GIFT= "RWFAM_OPEN_WELCOME_GIFT";
        public static inline final RWFAM_SAVE_STUFF_DATA= "RWFAM_SAVE_STUFF_DATA";
        public static inline final RWFAM_WIRED_INSPECT= "RWFAM_WIRED_INSPECT";

        var _furniId:Int = 0;
        var _furniCategory:Int = 0;
        var _offerId:Int = 0;
        var _objectData:String;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int=-1, _arg_5:String=null)
        {
            super(k);
            this._furniId = _arg_2;
            this._furniCategory = _arg_3;
            this._offerId = _arg_4;
            this._objectData = _arg_5;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var furniCategory(get,never):Int;
public function  get_furniCategory():Int
        {
            return this._furniCategory;
        }

        public var objectData(get,never):String;
public function  get_objectData():String
        {
            return this._objectData;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }
    }

