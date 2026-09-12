package com.sulake.habbo.groups.badge
;
     class BadgeLayerOptions 
    {
        var _layerIndex:Int = -1;
        var _partIndex:Int = -1;
        var _colorIndex:Int = -1;
        var _gridX:Int = -1;
        var _gridY:Int = -1;


        public function _Str_25730(k:Int)
        {
            this._gridX = Std.int(Math.ffloor((k % 3)));
            this._gridY = Std.int(Math.ffloor((k / 3)));
        }

        public function clone():BadgeLayerOptions
        {
            var k= new BadgeLayerOptions();
            k._layerIndex = this._layerIndex;
            k._partIndex = this._partIndex;
            k._colorIndex = this._colorIndex;
            k._gridX = this._gridX;
            k._gridY = this._gridY;
            return k;
        }

        public function _Str_23286(k:BadgeLayerOptions):Bool
        {
            if (((((k == null) || (!(this._gridX == k._Str_7460))) || (!(this._gridY == k._Str_8051))) || (!(this._colorIndex == k.colorIndex))))
            {
                return false;
            }
            if ((((this._layerIndex == 0) && (!(k._Str_3617 == 0))) || ((!(this._layerIndex == 0)) && (k._Str_3617 == 0))))
            {
                return false;
            }
            return true;
        }

        public function _Str_22335(k:BadgeLayerOptions):Bool
        {
            if (((k._Str_7460 == this._gridX) && (k._Str_8051 == this._gridY)))
            {
                return true;
            }
            return false;
        }

        
        public var _Str_3617(get,set):Int;
public function  get__Str_3617():Int
        {
            return this._layerIndex;
        }
public function  set__Str_3617(k:Int):Int        {
            return this._layerIndex = k;
        }

        
        public var _Str_3324(get,set):Int;
public function  get__Str_3324():Int
        {
            return this._partIndex;
        }
public function  set__Str_3324(k:Int):Int        {
            return this._partIndex = k;
        }

        
        public var colorIndex(get,set):Int;
public function  get_colorIndex():Int
        {
            return this._colorIndex;
        }
public function  set_colorIndex(k:Int):Int        {
            return this._colorIndex = k;
        }

        
        public var _Str_7460(get,set):Int;
public function  get__Str_7460():Int
        {
            return this._gridX;
        }
public function  set__Str_7460(k:Int):Int        {
            return this._gridX = k;
        }

        
        public var _Str_8051(get,set):Int;
public function  get__Str_8051():Int
        {
            return this._gridY;
        }
public function  set__Str_8051(k:Int):Int        {
            return this._gridY = k;
        }

        public var position(get,never):Int;
public function  get_position():Int
        {
            return (this._Str_8051 * 3) + this._Str_7460;
        }
public function new(){}
    }

