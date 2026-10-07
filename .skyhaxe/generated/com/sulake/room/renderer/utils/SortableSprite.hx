package com.sulake.room.renderer.utils
;
    import com.sulake.room.object.visualization.ISortableSprite;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class SortableSprite implements ISortableSprite 
    {
        public static inline final Z_INFINITY:Float = 100000000;

        var _x:Int = 0;
        var _y:Int = 0;
        var _z:Float = 0;
        public var name:String = "";
        var _sprite:IRoomObjectSprite = null;


        public function dispose()
        {
            this._sprite = null;
            this._z = -Z_INFINITY;
        }

        
        public var x(get,set):Int;
public function  get_x():Int
        {
            return this._x;
        }
public function  set_x(k:Int):Int        {
            return this._x = k;
        }

        
        public var y(get,set):Int;
public function  get_y():Int
        {
            return this._y;
        }
public function  set_y(k:Int):Int        {
            return this._y = k;
        }

        
        public var z(get,set):Float;
public function  get_z():Float
        {
            return this._z;
        }
public function  set_z(k:Float):Float        {
            return this._z = k;
        }

        
        public var sprite(get,set):IRoomObjectSprite;
public function  get_sprite():IRoomObjectSprite
        {
            return this._sprite;
        }
public function  set_sprite(k:IRoomObjectSprite):IRoomObjectSprite        {
            return this._sprite = k;
        }
public function new(){}
    }

