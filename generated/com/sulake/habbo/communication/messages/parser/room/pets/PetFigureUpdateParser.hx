package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetFigureData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetFigureUpdateParser implements IMessageParser 
    {
        var _roomIndex:Int = 0;
        var _petId:Int = 0;
        var _figureData:PetFigureData;
        var _hasSaddle:Bool = false;
        var _isRiding:Bool = false;


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

        public var figureData(get,never):PetFigureData;
function  get_figureData():PetFigureData
        {
            return this._figureData;
        }

        public var hasSaddle(get,never):Bool;
function  get_hasSaddle():Bool
        {
            return this._hasSaddle;
        }

        public var isRiding(get,never):Bool;
function  get_isRiding():Bool
        {
            return this._isRiding;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomIndex = k.readInteger();
            this._petId = k.readInteger();
            this._figureData = new PetFigureData(k);
            this._hasSaddle = k.readBoolean();
            this._isRiding = k.readBoolean();
            return true;
        }

	public function new() {}
    }

