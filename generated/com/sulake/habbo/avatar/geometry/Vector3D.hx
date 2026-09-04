package com.sulake.habbo.avatar.geometry
;
     class Vector3D 
    {
        var _x:Float = Math.NaN;
        var _y:Float = Math.NaN;
        var _z:Float = Math.NaN;

        public function new(k:Float=0, _arg_2:Float=0, _arg_3:Float=0)
        {
            this._x = k;
            this._y = _arg_2;
            this._z = _arg_3;
        }

        public static function _Str_2224Of(k:Vector3D, _arg_2:Vector3D):Float
        {
            return ((k.x * _arg_2.x) + (k.y * _arg_2.y)) + (k.z * _arg_2.z);
        }

        public static function _Str_1645Of(k:Vector3D, _arg_2:Vector3D):Vector3D
        {
            var _local_3= Type.createInstance(Vector3D, []);
            _local_3.x = ((k.y * _arg_2.z) - (k.z * _arg_2.y));
            _local_3.y = ((k.z * _arg_2.x) - (k.x * _arg_2.z));
            _local_3.z = ((k.x * _arg_2.y) - (k.y * _arg_2.x));
            return _local_3;
        }

        public static function subtractOf(k:Vector3D, _arg_2:Vector3D):Vector3D
        {
            return new Vector3D((k.x - _arg_2.x), (k.y - _arg_2.y), (k.z - _arg_2.z));
        }


        public function _Str_2224(k:Vector3D):Float
        {
            return ((this._x * k.x) + (this._y * k.y)) + (this._z * k.z);
        }

        public function _Str_1645(k:Vector3D):Vector3D
        {
            var _local_2= new Vector3D();
            _local_2.x = ((this._y * k.z) - (this._z * k.y));
            _local_2.y = ((this._z * k.x) - (this._x * k.z));
            _local_2.z = ((this._x * k.y) - (this._y * k.x));
            return _local_2;
        }

        public function subtract(k:Vector3D)
        {
            this._x = (this._x - k.x);
            this._y = (this._y - k.y);
            this._z = (this._z - k.z);
        }

        public function add(k:Vector3D)
        {
            this._x = (this._x + k.x);
            this._y = (this._y + k.y);
            this._z = (this._z + k.z);
        }

        public function normalize()
        {
            var k= (1 / this.length());
            this._x = (this._x * k);
            this._y = (this._y * k);
            this._z = (this._z * k);
        }

        public function length():Float
        {
            return Math.sqrt((((this._x * this._x) + (this._y * this._y)) + (this._z * this._z)));
        }

        public function toString():String
        {
            var k:ASAny = (((((("Vector3D: (" + this._x) + ",") + this._y) + ",") + this._z) + ")");
            return k;
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
function  set_x(k:Float):Float        {
            return this._x = k;
        }
function  set_y(k:Float):Float        {
            return this._y = k;
        }
function  set_z(k:Float):Float        {
            return this._z = k;
        }
    }

