package com.sulake.habbo.room.events
;
     class RoomEngineAreaHideStateWidgetEvent extends RoomEngineObjectEvent
    {
        public static inline final UPDATE_STATE_AREA_HIDE= "RETWE_UPDATE_STATE_AREA_HIDE";

        var _isOn:Bool = false;

        public function new(k:Int, objectId:Int, category:Int, isOn:Bool)
        {
            super(UPDATE_STATE_AREA_HIDE, k, objectId, category);
            this._isOn = isOn;
        }

        public var isOn(get,never):Bool;
public function  get_isOn():Bool
        {
            return this._isOn;
        }
    }

