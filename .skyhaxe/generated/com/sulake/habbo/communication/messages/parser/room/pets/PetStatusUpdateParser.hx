package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetStatusUpdateParser implements IMessageParser 
    {
        var _roomIndex:Int = 0;
        var _petId:Int = 0;
        var _canBreed:Bool = false;
        var _canHarvest:Bool = false;
        var _canRevive:Bool = false;
        var _hasBreedingPermission:Bool = false;


        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
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

        public function flush():Bool
        {
            return true;
        }

        public var hasBreedingPermission(get,never):Bool;
public function  get_hasBreedingPermission():Bool
        {
            return this._hasBreedingPermission;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomIndex = k.readInteger();
            this._petId = k.readInteger();
            this._canBreed = k.readBoolean();
            this._canHarvest = k.readBoolean();
            this._canRevive = k.readBoolean();
            this._hasBreedingPermission = k.readBoolean();
            return true;
        }

	public function new() {}
    }

