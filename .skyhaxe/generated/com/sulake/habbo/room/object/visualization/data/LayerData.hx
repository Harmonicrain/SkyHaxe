package com.sulake.habbo.room.object.visualization.data
;
     class LayerData 
    {
        public static inline final DEFAULT_TAG= "";
        public static inline final DEFAULT_INK= 0;
        public static inline final DEFAULT_ALPHA= 0xFF;
        public static inline final DEFAULT_IGNORE_MOUSE= false;
        public static inline final DEFAULT_X_OFFSET= 0;
        public static inline final DEFAULT_Y_OFFSET= 0;
        public static inline final DEFAULT_Z_OFFSET= 0;
        public static inline final INK_ADD= 1;
        public static inline final INK_SUBTRACT= 2;
        public static inline final INK_DARKEN= 3;

        var _tag:String = "";
        var _ink:Int = 0;
        var _alpha:Int = 0xFF;
        var _ignoreMouse:Bool = false;
        var _xOffset:Int = 0;
        var _yOffset:Int = 0;
        var _zOffset:Float = 0;


        
        public var tag(get,set):String;
public function  set_tag(k:String):String        {
            return this._tag = k;
        }
public function  get_tag():String
        {
            return this._tag;
        }

        
        public var ink(get,set):Int;
public function  set_ink(k:Int):Int        {
            return this._ink = k;
        }
public function  get_ink():Int
        {
            return this._ink;
        }

        
        public var alpha(get,set):Int;
public function  set_alpha(k:Int):Int        {
            return this._alpha = k;
        }
public function  get_alpha():Int
        {
            return this._alpha;
        }

        
        public var ignoreMouse(get,set):Bool;
public function  set_ignoreMouse(k:Bool):Bool        {
            return this._ignoreMouse = k;
        }
public function  get_ignoreMouse():Bool
        {
            return this._ignoreMouse;
        }

        
        public var _Str_11051(get,set):Int;
public function  set__Str_11051(k:Int):Int        {
            return this._xOffset = k;
        }
public function  get__Str_11051():Int
        {
            return this._xOffset;
        }

        
        public var _Str_10285(get,set):Int;
public function  set__Str_10285(k:Int):Int        {
            return this._yOffset = k;
        }
public function  get__Str_10285():Int
        {
            return this._yOffset;
        }

        
        public var _Str_12320(get,set):Float;
public function  set__Str_12320(k:Float):Float        {
            return this._zOffset = k;
        }
public function  get__Str_12320():Float
        {
            return this._zOffset;
        }

        public function _Str_17122(k:LayerData)
        {
            if (k != null)
            {
                this.tag = k.tag;
                this.ink = k.ink;
                this.alpha = k.alpha;
                this.ignoreMouse = k.ignoreMouse;
                this._Str_11051 = k._Str_11051;
                this._Str_10285 = k._Str_10285;
                this._Str_12320 = k._Str_12320;
            }
        }
public function new(){}
    }

