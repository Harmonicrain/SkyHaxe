package com.sulake.habbo.avatar.structure.figure
;
     class FigurePart implements IFigurePart 
    {
        var _id:Int = 0;
        var _type:String;
        var _breed:Int = -1;
        var _colorLayerIndex:Int = 0;
        var _index:Int = 0;
        var _paletteMapId:Int = -1;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._id = ASCompat.parseInt(k.attribute("id").toString());
            this._type = k.attribute("type").toString();
            this._index = ASCompat.parseInt(k.attribute("index").toString());
            this._colorLayerIndex = ASCompat.parseInt(k.attribute("colorindex").toString());
            var _local_2= k.attribute("palettemapid").toString();
            if (_local_2 != "")
            {
                this._paletteMapId = ASCompat.toInt(_local_2);
            }
            var _local_3= k.attribute("breed").toString();
            if (_local_3 != "")
            {
                this._breed = ASCompat.toInt(_local_3);
            }
        }

        public function dispose()
        {
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var breed(get,never):Int;
public function  get_breed():Int
        {
            return this._breed;
        }

        public var _Str_827(get,never):Int;
public function  get__Str_827():Int
        {
            return this._colorLayerIndex;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }

        public var paletteMap(get,never):Int;
public function  get_paletteMap():Int
        {
            return this._paletteMapId;
        }
    }

