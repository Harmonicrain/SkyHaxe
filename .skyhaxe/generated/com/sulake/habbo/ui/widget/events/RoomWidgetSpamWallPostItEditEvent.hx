package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetSpamWallPostItEditEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWSWPUE_OPEN_EDITOR= "RWSWPUE_OPEN_EDITOR";

        var _objectId:Int = 0;
        var _location:String;
        var _objectType:String;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._objectId = _arg_2;
            this._location = _arg_3;
            this._objectType = _arg_4;
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

        public var objectType(get,never):String;
public function  get_objectType():String
        {
            return this._objectType;
        }
    }

