package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetFigureData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetLevelNotificationParser implements IMessageParser
    {
        var _petId:Int = 0;
        var _petName:String;
        var _level:Int = 0;
        var _figureData:PetFigureData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._petId = k.readInteger();
            this._petName = k.readString();
            this._level = k.readInteger();
            this._figureData = new PetFigureData(k);
            return true;
        }

        public var petId(get,never):Int;
function  get_petId():Int
        {
            return this._petId;
        }

        public var petName(get,never):String;
function  get_petName():String
        {
            return this._petName;
        }

        public var level(get,never):Int;
function  get_level():Int
        {
            return this._level;
        }

        public var figureData(get,never):PetFigureData;
function  get_figureData():PetFigureData
        {
            return this._figureData;
        }

	public function new() {}
    }

