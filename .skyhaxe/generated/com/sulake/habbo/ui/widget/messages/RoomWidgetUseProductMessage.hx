package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetUseProductMessage extends RoomWidgetMessage 
    {
        public static inline final RWUPM_PET_PRODUCT= "RWUPM_PET_PRODUCT";
        public static inline final MONSTERPLANT_SEED= "RWUPM_MONSTERPLANT_SEED";

        var _roomObjectId:Int = 0;
        var _petId:Int = -1;

        public function new(k:String, _arg_2:Int, _arg_3:Int=-1)
        {
            super(k);
            this._roomObjectId = _arg_2;
            this._petId = _arg_3;
        }

        public var roomObjectId(get,never):Int;
public function  get_roomObjectId():Int
        {
            return this._roomObjectId;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }
    }

