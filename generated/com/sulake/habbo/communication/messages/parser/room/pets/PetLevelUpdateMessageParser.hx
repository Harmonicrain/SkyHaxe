package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetLevelUpdateMessageParser implements IMessageParser
    {
        var _roomIndex:Int = 0;
        var _petId:Int = 0;
        var _level:Int = 0;


        public var roomIndex(get,never):Int;
function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var petId(get,never):Int;
function  get_petId():Int
        {
            return this._petId;
        }

        public var level(get,never):Int;
function  get_level():Int
        {
            return this._level;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomIndex = k.readInteger();
            this._petId = k.readInteger();
            this._level = k.readInteger();
            return true;
        }

	public function new() {}
    }

