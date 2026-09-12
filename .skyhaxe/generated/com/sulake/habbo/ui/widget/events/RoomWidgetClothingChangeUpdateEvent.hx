package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetClothingChangeUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWCCUE_SHOW_GENDER_SELECTION= "RWCCUE_SHOW_GENDER_SELECTION";
        public static inline final RWCCUE_SHOW_CLOTHING_EDITOR= "RWCCUE_SHOW_CLOTHING_EDITOR";

        var _objectId:Int = -1;
        var _objectCategory:Int = -1;
        var _roomId:Int = -1;

        public function new(k:String, _arg_2:Int=0, _arg_3:Int=0, _arg_4:Int=0, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._objectId = _arg_2;
            this._objectCategory = _arg_3;
            this._roomId = _arg_4;
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
    }

