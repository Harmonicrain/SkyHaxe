package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetRoomObjectUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final OBJECT_SELECTED= "RWROUE_OBJECT_SELECTED";
        public static inline final OBJECT_DESELECTED= "RWROUE_OBJECT_DESELECTED";
        public static inline final USER_REMOVED= "RWROUE_USER_REMOVED";
        public static inline final FURNI_REMOVED= "RWROUE_FURNI_REMOVED";
        public static inline final FURNI_ADDED= "RWROUE_FURNI_ADDED";
        public static inline final USER_ADDED= "RWROUE_USER_ADDED";
        public static inline final OBJECT_ROLL_OVER= "RWROUE_OBJECT_ROLL_OVER";
        public static inline final OBJECT_ROLL_OUT= "RWROUE_OBJECT_ROLL_OUT";

        var _id:Int = 0;
        var _category:Int = 0;
        var _roomId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._id = _arg_2;
            this._category = _arg_3;
            this._roomId = _arg_4;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

