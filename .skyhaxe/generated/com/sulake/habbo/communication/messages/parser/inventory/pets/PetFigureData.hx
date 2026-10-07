package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetFigureData 
    {
        var _typeId:Int = 0;
        var _paletteId:Int = 0;
        var _color:String;
        var _breedId:Int = 0;
        var _customPartCount:Int = 0;
        var _customParts:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._typeId = k.readInteger();
            this._paletteId = k.readInteger();
            this._color = k.readString();
            this._breedId = k.readInteger();
            this._customParts = [];
            this._customPartCount = k.readInteger();
            var _local_2 = 0;
            while (_local_2 < this._customPartCount)
            {
                this._customParts.push(k.readInteger());
                this._customParts.push(k.readInteger());
                this._customParts.push(k.readInteger());
                _local_2++;
            }
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._typeId;
        }

        public var paletteId(get,never):Int;
public function  get_paletteId():Int
        {
            return this._paletteId;
        }

        public var color(get,never):String;
public function  get_color():String
        {
            return this._color;
        }

        public var breedId(get,never):Int;
public function  get_breedId():Int
        {
            return this._breedId;
        }

        public var figuredata(get,never):String;
public function  get_figuredata():String
        {
            var _local_2 = 0;
            var k= ((((Std.string(this.typeId) + " ") + Std.string(this.paletteId)) + " ") + this.color);
            k = (k + (" " + Std.string(this.customPartCount)));
            final _iter_ = this._Str_3542; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                k = (k + (" " + Std.string(_local_2)));
            }
            return k;
        }

        public var _Str_3542(get,never):Array<ASAny>;
public function  get__Str_3542():Array<ASAny>
        {
            return this._customParts;
        }

        public var customPartCount(get,never):Int;
public function  get_customPartCount():Int
        {
            return this._customPartCount;
        }
    }

