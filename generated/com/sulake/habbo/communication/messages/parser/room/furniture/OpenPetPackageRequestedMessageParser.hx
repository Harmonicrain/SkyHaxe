package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetFigureData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OpenPetPackageRequestedMessageParser implements IMessageParser
    {
        var _objectId:Int = -1;
        var _figureData:PetFigureData;


        public var objectId(get,never):Int;
function  get_objectId():Int
        {
            return this._objectId;
        }

        public var figureData(get,never):PetFigureData;
function  get_figureData():PetFigureData
        {
            return this._figureData;
        }

        public function flush():Bool
        {
            this._objectId = -1;
            this._figureData = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._objectId = k.readInteger();
            if (k.bytesAvailable == 0)
            {
                return true;
            }
            this._figureData = new PetFigureData(k);
            return true;
        }

	public function new() {}
    }

