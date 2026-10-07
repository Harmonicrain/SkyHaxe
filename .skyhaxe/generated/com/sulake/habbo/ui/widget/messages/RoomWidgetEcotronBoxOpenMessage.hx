package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetEcotronBoxOpenMessage extends RoomWidgetMessage 
    {
        public static inline final RWEBOM_OPEN_ECOTRONBOX= "RWEBOM_OPEN_ECOTRONBOX";

        var _objectId:Int = 0;

        public function new(k:String, _arg_2:Int)
        {
            super(k);
            this._objectId = _arg_2;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }
    }

