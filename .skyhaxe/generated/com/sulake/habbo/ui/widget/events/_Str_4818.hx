package com.sulake.habbo.ui.widget.events
;
     class _Str_4818 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPLUE_PET_LEVEL_UPDATE= "RWPLUE_PET_LEVEL_UPDATE";

        var _petId:Int = 0;
        var _level:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RWPLUE_PET_LEVEL_UPDATE, _arg_3, _arg_4);
            this._petId = k;
            this._level = _arg_2;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }
    }

