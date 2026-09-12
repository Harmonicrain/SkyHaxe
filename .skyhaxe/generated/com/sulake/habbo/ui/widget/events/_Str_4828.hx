package com.sulake.habbo.ui.widget.events
;
     class _Str_4828 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPIUE_PET_STATUS_UPDATE= "RWPIUE_PET_STATUS_UPDATE";

        var _petId:Int = 0;
        var _canBreed:Bool = false;
        var _canHarvest:Bool = false;
        var _canRevive:Bool = false;
        var _hasBreedingPermission:Bool = false;

        public function new(k:Int, _arg_2:Bool, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(RWPIUE_PET_STATUS_UPDATE, _arg_6, _arg_7);
            this._petId = k;
            this._canBreed = _arg_2;
            this._canHarvest = _arg_3;
            this._canRevive = _arg_4;
            this._hasBreedingPermission = _arg_5;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }

        public var canBreed(get,never):Bool;
public function  get_canBreed():Bool
        {
            return this._canBreed;
        }

        public var canHarvest(get,never):Bool;
public function  get_canHarvest():Bool
        {
            return this._canHarvest;
        }

        public var canRevive(get,never):Bool;
public function  get_canRevive():Bool
        {
            return this._canRevive;
        }

        public var hasBreedingPermission(get,never):Bool;
public function  get_hasBreedingPermission():Bool
        {
            return this._hasBreedingPermission;
        }
    }

