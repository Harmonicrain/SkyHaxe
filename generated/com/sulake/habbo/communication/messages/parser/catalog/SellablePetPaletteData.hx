package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SellablePetPaletteData
    {
        var _type:Int = 0;
        var _Str_3717:Int = 0;
        var _paletteId:Int = 0;
        var _sellable:Bool = false;
        var _rare:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._type = k.readInteger();
            this._Str_3717 = k.readInteger();
            this._paletteId = k.readInteger();
            this._sellable = k.readBoolean();
            this._rare = k.readBoolean();
        }

        public var type(get,never):Int;
function  get_type():Int
        {
            return this._type;
        }

        public var breedId(get,never):Int;
function  get_breedId():Int
        {
            return this._Str_3717;
        }

        public var paletteId(get,never):Int;
function  get_paletteId():Int
        {
            return this._paletteId;
        }

        public var sellable(get,never):Bool;
function  get_sellable():Bool
        {
            return this._sellable;
        }

        public var rare(get,never):Bool;
function  get_rare():Bool
        {
            return this._rare;
        }
    }

