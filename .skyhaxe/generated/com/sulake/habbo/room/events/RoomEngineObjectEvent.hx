package com.sulake.habbo.room.events
;
     class RoomEngineObjectEvent extends RoomEngineEvent 
    {
        public static inline final SELECTED= "REOE_SELECTED";
        public static inline final DESELECTED= "REOE_DESELECTED";
        public static inline final ADDED= "REOE_ADDED";
        public static inline final REMOVED= "REOE_REMOVED";
        public static inline final PLACED= "REOE_PLACED";
        public static inline final PLACED_ON_USER= "REOE_PLACED_ON_USER";
        public static inline final UPDATED= "REOE_UPDATED";
        public static inline final CONTENT_UPDATED= "REOE_CONTENT_UPDATED";
        public static inline final REQUEST_MOVE= "REOE_REQUEST_MOVE";
        public static inline final REQUEST_ROTATE= "REOE_REQUEST_ROTATE";
        public static inline final MOUSE_ENTER= "REOE_MOUSE_ENTER";
        public static inline final MOUSE_LEAVE= "REOE_MOUSE_LEAVE";

        var _objectId:Int = 0;
        var _category:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_5, _arg_6);
            this._objectId = _arg_3;
            this._category = _arg_4;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }
    }

