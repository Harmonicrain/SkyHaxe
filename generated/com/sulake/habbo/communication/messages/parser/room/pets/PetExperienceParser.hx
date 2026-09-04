package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetExperienceParser implements IMessageParser 
    {
        var _petId:Int = -1;
        var _petRoomIndex:Int = -1;
        var _gainedExperience:Int = 0;


        public var petId(get,never):Int;
function  get_petId():Int
        {
            return this._petId;
        }

        public var petRoomIndex(get,never):Int;
function  get_petRoomIndex():Int
        {
            return this._petRoomIndex;
        }

        public var _Str_18578(get,never):Int;
function  get__Str_18578():Int
        {
            return this._gainedExperience;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._petId = k.readInteger();
            this._petRoomIndex = k.readInteger();
            this._gainedExperience = k.readInteger();
            return true;
        }

	public function new() {}
    }

