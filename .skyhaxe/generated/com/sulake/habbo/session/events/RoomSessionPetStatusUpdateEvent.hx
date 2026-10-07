package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetStatusUpdateEvent extends RoomSessionEvent 
    {
        public static inline final RSPFUE_PET_STATUS_UPDATE= "RSPFUE_PET_STATUS_UPDATE";

        var _petId:Int = 0;
        var _canBreed:Bool = false;
        var _canHarvest:Bool = false;
        var _canRevive:Bool = false;
        var _hasBreedingPermission:Bool = false;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(RSPFUE_PET_STATUS_UPDATE, k, _arg_7, _arg_8);
            this._petId = _arg_2;
            this._canBreed = _arg_3;
            this._canHarvest = _arg_4;
            this._canRevive = _arg_5;
            this._hasBreedingPermission = _arg_6;
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

