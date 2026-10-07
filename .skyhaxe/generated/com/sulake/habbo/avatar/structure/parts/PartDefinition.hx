package com.sulake.habbo.avatar.structure.parts
;
     class PartDefinition 
    {
        var _setType:String;
        var _flippedSetType:String;
        var _removeSetType:String;
        var _appendToFigure:Bool = false;
        var _staticId:Int = -1;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._setType = k.attribute("set-type").toString();
            this._flippedSetType = k.attribute("flipped-set-type").toString();
            this._removeSetType = k.attribute("remove-set-type").toString();
            this._appendToFigure = false;
        }

        public function hasStaticId():Bool
        {
            return this._staticId >= 0;
        }

        
        public var _Str_1734(get,set):Int;
public function  get__Str_1734():Int
        {
            return this._staticId;
        }
public function  set__Str_1734(k:Int):Int        {
            return this._staticId = k;
        }

        public var setType(get,never):String;
public function  get_setType():String
        {
            return this._setType;
        }

        
        public var _Str_1693(get,set):String;
public function  get__Str_1693():String
        {
            return this._flippedSetType;
        }

        public var removeSetType(get,never):String;
public function  get_removeSetType():String
        {
            return this._removeSetType;
        }

        
        public var _Str_1583(get,set):Bool;
public function  get__Str_1583():Bool
        {
            return this._appendToFigure;
        }
public function  set__Str_1583(k:Bool):Bool        {
            return this._appendToFigure = k;
        }
public function  set__Str_1693(k:String):String        {
            return this._flippedSetType = k;
        }
    }

