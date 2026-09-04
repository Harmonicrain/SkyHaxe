package com.sulake.room.utils
;
     class Vector3d implements IVector3d 
    {
        var _x:Float = Math.NaN;
        var _y:Float = Math.NaN;
        var _z:Float = Math.NaN;
        var _length:Float = Math.NaN;

        public function new(k:Float=0, _arg_2:Float=0, _arg_3:Float=0)
        {
            this._x = k;
            this._y = _arg_2;
            this._z = _arg_3;
        }

        public static function sum(k:IVector3d, _arg_2:IVector3d):Vector3d
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return null;
            }
            var _local_3= new Vector3d((k.x + _arg_2.x), (k.y + _arg_2.y), (k.z + _arg_2.z));
            return _local_3;
        }

        public static function dif(k:IVector3d, _arg_2:IVector3d):Vector3d
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return null;
            }
            var _local_3= new Vector3d((k.x - _arg_2.x), (k.y - _arg_2.y), (k.z - _arg_2.z));
            return _local_3;
        }

        public static function product(k:IVector3d, _arg_2:Float):Vector3d
        {
            if (k == null)
            {
                return null;
            }
            var _local_3= new Vector3d((k.x * _arg_2), (k.y * _arg_2), (k.z * _arg_2));
            return _local_3;
        }

        public static function dotProduct(k:IVector3d, _arg_2:IVector3d):Float
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return 0;
            }
            return ((k.x * _arg_2.x) + (k.y * _arg_2.y)) + (k.z * _arg_2.z);
        }

        public static function crossProduct(k:IVector3d, _arg_2:IVector3d):Vector3d
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return null;
            }
            var _local_3= new Vector3d(((k.y * _arg_2.z) - (k.z * _arg_2.y)), ((k.z * _arg_2.x) - (k.x * _arg_2.z)), ((k.x * _arg_2.y) - (k.y * _arg_2.x)));
            return _local_3;
        }

        public static function scalarProjection(k:IVector3d, _arg_2:IVector3d):Float
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return -1;
            }
            var _local_3= _arg_2.length;
            if (_local_3 > 0)
            {
                return (((k.x * _arg_2.x) + (k.y * _arg_2.y)) + (k.z * _arg_2.z)) / _local_3;
            }
            return -1;
        }

        public static function cosAngle(k:IVector3d, _arg_2:IVector3d):Float
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return 0;
            }
            var _local_3= (k.length * _arg_2.length);
            if (_local_3 == 0)
            {
                return 0;
            }
            return Vector3d.dotProduct(k, _arg_2) / _local_3;
        }

        public static function isEqual(k:IVector3d, _arg_2:IVector3d):Bool
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            if ((((k.x == _arg_2.x) && (k.y == _arg_2.y)) && (k.z == _arg_2.z)))
            {
                return true;
            }
            return false;
        }


        
        public var x(get,set):Float;
function  get_x():Float
        {
            return this._x;
        }

        
        public var y(get,set):Float;
function  get_y():Float
        {
            return this._y;
        }

        
        public var z(get,set):Float;
function  get_z():Float
        {
            return this._z;
        }

        public var length(get,never):Float;
function  get_length():Float
        {
            if (Math.isNaN(this._length))
            {
                this._length = Math.sqrt((((this._x * this._x) + (this._y * this._y)) + (this._z * this._z)));
            }
            return this._length;
        }
function  set_x(k:Float):Float        {
            this._x = k;
            this._length = Math.NaN;
return k;
        }
function  set_y(k:Float):Float        {
            this._y = k;
            this._length = Math.NaN;
return k;
        }
function  set_z(k:Float):Float        {
            this._z = k;
            this._length = Math.NaN;
return k;
        }

        public function negate()
        {
            this._x = -this._x;
            this._y = -this._y;
            this._z = -this._z;
        }

        public function add(k:IVector3d)
        {
            if (k == null)
            {
                return;
            }
            this._x = (this._x + k.x);
            this._y = (this._y + k.y);
            this._z = (this._z + k.z);
            this._length = Math.NaN;
        }

        public function sub(k:IVector3d)
        {
            if (k == null)
            {
                return;
            }
            this._x = (this._x - k.x);
            this._y = (this._y - k.y);
            this._z = (this._z - k.z);
            this._length = Math.NaN;
        }

        public function mul(k:Float)
        {
            this._x = (this._x * k);
            this._y = (this._y * k);
            this._z = (this._z * k);
            this._length = Math.NaN;
        }

        public function div(k:Float)
        {
            if (k != 0)
            {
                this._x = (this._x / k);
                this._y = (this._y / k);
                this._z = (this._z / k);
                this._length = Math.NaN;
            }
        }

        public function assign(k:IVector3d)
        {
            if (k == null)
            {
                return;
            }
            this._x = k.x;
            this._y = k.y;
            this._z = k.z;
            this._length = Math.NaN;
        }

        public function toString():String
        {
            return ("(" + [this._x, this._y, this._z].join(",")) + ")";
        }
    }

