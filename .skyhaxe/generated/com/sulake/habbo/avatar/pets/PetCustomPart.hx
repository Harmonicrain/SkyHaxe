package com.sulake.habbo.avatar.pets
;
     class PetCustomPart 
    {
        var _layerId:Int = 0;
        var _partId:Int = 0;
        var _paletteId:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._layerId = k;
            this._partId = _arg_2;
            this._paletteId = _arg_3;
        }

        
        public var paletteId(get,set):Int;
public function  get_paletteId():Int
        {
            return this._paletteId;
        }
public function  set_paletteId(k:Int):Int        {
            return this._paletteId = k;
        }

        
        public var partId(get,set):Int;
public function  get_partId():Int
        {
            return this._partId;
        }
public function  set_partId(k:Int):Int        {
            return this._partId = k;
        }

        
        public var _Str_11008(get,set):Int;
public function  get__Str_11008():Int
        {
            return this._layerId;
        }
public function  set__Str_11008(k:Int):Int        {
            return this._layerId = k;
        }
    }

