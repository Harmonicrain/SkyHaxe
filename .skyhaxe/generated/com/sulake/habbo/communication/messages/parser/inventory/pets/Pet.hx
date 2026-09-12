package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Pet 
    {
        var _id:Int = 0;
        var _name:String;
        var _figureData:PetFigureData;
        var _level:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._name = k.readString();
            this._figureData = new PetFigureData(k);
            this._level = k.readInteger();
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._figureData.typeId;
        }

        public var paletteId(get,never):Int;
public function  get_paletteId():Int
        {
            return this._figureData.paletteId;
        }

        public var color(get,never):String;
public function  get_color():String
        {
            return this._figureData.color;
        }

        public var breedId(get,never):Int;
public function  get_breedId():Int
        {
            return this._figureData.breedId;
        }

        public var customPartCount(get,never):Int;
public function  get_customPartCount():Int
        {
            return this._figureData.customPartCount;
        }

        public var figureString(get,never):String;
public function  get_figureString():String
        {
            return this._figureData.figuredata;
        }

        public var figureData(get,never):PetFigureData;
public function  get_figureData():PetFigureData
        {
            return this._figureData;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }
    }

