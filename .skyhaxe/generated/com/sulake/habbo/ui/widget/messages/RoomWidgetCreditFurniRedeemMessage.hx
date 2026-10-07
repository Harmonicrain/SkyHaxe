package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetCreditFurniRedeemMessage extends RoomWidgetMessage 
    {
        public static inline final RWFCRM_REDEEM= "RWFCRM_REDEEM";

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

