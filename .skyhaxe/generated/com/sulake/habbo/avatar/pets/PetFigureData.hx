package com.sulake.habbo.avatar.pets
;
     class PetFigureData 
    {
        var _typeId:Int = 0;
        var _paletteId:Int = 0;
        var _color:Int = 0;
        var _customParts:Array<ASAny>;
        var _customLayerIds:Array<ASAny>;
        var _customPartIds:Array<ASAny>;
        var _customPaletteIds:Array<ASAny>;
        var _headOnly:Bool = false;

        public function new(k:String)
        {
            this._typeId = this._Str_19576(k);
            this._paletteId = this.getPaletteId(k);
            this._color = this.getColor(k);
            this._headOnly = this.getHeadOnly(k);
            var _local_2= this.getCustomData(k);
            this._customLayerIds = this.getCustomLayerIds(_local_2);
            this._customPartIds = this.getCustomPartIds(_local_2);
            this._customPaletteIds = this.getCustomPaletteIds(_local_2);
            this._customParts = [];
            var _local_3 = 0;
            while (_local_3 < this._customLayerIds.length)
            {
                this._customParts.push(new PetCustomPart(ASCompat.toInt(this._customLayerIds[_local_3]), ASCompat.toInt(this._customPartIds[_local_3]), ASCompat.toInt(this._customPaletteIds[_local_3])));
                _local_3++;
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

        public var color(get,never):Int;
public function  get_color():Int
        {
            return this._color;
        }

        public var customLayerIds(get,never):Array<ASAny>;
public function  get_customLayerIds():Array<ASAny>
        {
            return this._customLayerIds;
        }

        public var customPartIds(get,never):Array<ASAny>;
public function  get_customPartIds():Array<ASAny>
        {
            return this._customPartIds;
        }

        public var customPaletteIds(get,never):Array<ASAny>;
public function  get_customPaletteIds():Array<ASAny>
        {
            return this._customPaletteIds;
        }

        public var _Str_3542(get,never):Array<ASAny>;
public function  get__Str_3542():Array<ASAny>
        {
            return this._customParts;
        }

        public function getCustomPart(k:Int):PetCustomPart
        {
            var _local_2:PetCustomPart = null;
            if (this._customParts != null)
            {
                final _iter_ = this._customParts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2._Str_11008 == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public var hasCustomParts(get,never):Bool;
public function  get_hasCustomParts():Bool
        {
            return (!(this._customLayerIds == null)) && (this._customLayerIds.length > 0);
        }

        public var headOnly(get,never):Bool;
public function  get_headOnly():Bool
        {
            return this._headOnly;
        }

        public var figureString(get,never):String;
public function  get_figureString():String
        {
            var _local_2:PetCustomPart = null;
            var k= ((((Std.string(this.typeId) + " ") + Std.string(this.paletteId)) + " ") + ASCompat.toRadix(this.color, 16));
            k = (k + (" " + Std.string(this._Str_3542.length)));
            final _iter_ = this._Str_3542; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (k + (((((" " + Std.string(_local_2._Str_11008)) + " ") + Std.string(_local_2.partId)) + " ") + Std.string(_local_2.paletteId)));
            }
            return k;
        }

        function getCustomData(k:String):Array<ASAny>
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_2:Array<ASAny> = [];
            if (k != null)
            {
                _local_3 = (cast k.split(" "));
                _local_4 = (this._headOnly ? 1 : 0);
                _local_5 = (4 + _local_4);
                if (_local_3.length > _local_5)
                {
                    _local_6 = (3 + _local_4);
                    _local_7 = ASCompat.parseInt(_local_3[_local_6]);
                    _local_2 = _local_3.slice(_local_5, (_local_5 + (_local_7 * 3)));
                }
            }
            return _local_2;
        }

        function getCustomLayerIds(k:Array<ASAny>):Array<ASAny>
        {
            var _local_2:Array<ASAny> = [];
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_2.push(ASCompat.parseInt(k[(_local_3 + 0)]));
                _local_3 = (_local_3 + 3);
            }
            return _local_2;
        }

        function getCustomPartIds(k:Array<ASAny>):Array<ASAny>
        {
            var _local_2:Array<ASAny> = [];
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_2.push(ASCompat.parseInt(k[(_local_3 + 1)]));
                _local_3 = (_local_3 + 3);
            }
            return _local_2;
        }

        function getCustomPaletteIds(k:Array<ASAny>):Array<ASAny>
        {
            var _local_2:Array<ASAny> = [];
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_2.push(ASCompat.parseInt(k[(_local_3 + 2)]));
                _local_3 = (_local_3 + 3);
            }
            return _local_2;
        }

        function _Str_19576(k:String):Int
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = (cast k.split(" "));
                if (_local_2.length >= 1)
                {
                    return ASCompat.parseInt(_local_2[0]);
                }
            }
            return 0;
        }

        function getPaletteId(k:String):Int
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = (cast k.split(" "));
                if (_local_2.length >= 2)
                {
                    return ASCompat.parseInt(_local_2[1]);
                }
            }
            return 0;
        }

        function getColor(k:String):Int
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = (cast k.split(" "));
                if (_local_2.length >= 3)
                {
                    return ASCompat.parseInt(_local_2[2], 16);
                }
            }
            return 0xFFFFFF;
        }

        function getHeadOnly(k:String):Bool
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = (cast k.split(" "));
                if (_local_2.length >= 4)
                {
                    return _local_2[3] == "head";
                }
            }
            return false;
        }
    }

