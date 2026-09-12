package com.sulake.habbo.avatar.geometry
;
     class Matrix4x4 
    {
        public static final IDENTITY:Matrix4x4 = new Matrix4x4(1, 0, 0, 0, 1, 0, 0, 0, 1);
        static inline final TOLERANS= 1E-18;

        var _data:Array<ASAny>;

        public function new(k:Float=0, _arg_2:Float=0, _arg_3:Float=0, _arg_4:Float=0, _arg_5:Float=0, _arg_6:Float=0, _arg_7:Float=0, _arg_8:Float=0, _arg_9:Float=0)
        {
            this._data = [k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9];
        }

        public static function getXRotationMatrix(k:Float):Matrix4x4
        {
            var _local_2= ((k * Math.PI) / 180);
            var _local_3= Math.cos(_local_2);
            var _local_4= Math.sin(_local_2);
            var _local_5= new Matrix4x4(1, 0, 0, 0, _local_3, -_local_4, 0, _local_4, _local_3);
            return _local_5;
        }

        public static function getYRotationMatrix(k:Float):Matrix4x4
        {
            var _local_2= ((k * Math.PI) / 180);
            var _local_3= Math.cos(_local_2);
            var _local_4= Math.sin(_local_2);
            var _local_5= new Matrix4x4(_local_3, 0, _local_4, 0, 1, 0, -_local_4, 0, _local_3);
            return _local_5;
        }

        public static function getZRotationMatrix(k:Float):Matrix4x4
        {
            var _local_2= ((k * Math.PI) / 180);
            var _local_3= Math.cos(_local_2);
            var _local_4= Math.sin(_local_2);
            var _local_5= new Matrix4x4(_local_3, -_local_4, 0, _local_4, _local_3, 0, 0, 0, 1);
            return _local_5;
        }


        public function identity():Matrix4x4
        {
            this._data = [1, 0, 0, 0, 1, 0, 0, 0, 1];
            return this;
        }

        public function vectorMultiplication(k:Vector3D):Vector3D
        {
            var _local_2= ASCompat.toNumber(((k.x * ASCompat.toNumber(this._data[0])) + (k.y * ASCompat.toNumber(this._data[3]))) + (k.z * ASCompat.toNumber(this._data[6])));
            var _local_3= ASCompat.toNumber(((k.x * ASCompat.toNumber(this._data[1])) + (k.y * ASCompat.toNumber(this._data[4]))) + (k.z * ASCompat.toNumber(this._data[7])));
            var _local_4= ASCompat.toNumber(((k.x * ASCompat.toNumber(this._data[2])) + (k.y * ASCompat.toNumber(this._data[5]))) + (k.z * ASCompat.toNumber(this._data[8])));
            return new Vector3D(_local_2, _local_3, _local_4);
        }

        public function multiply(k:Matrix4x4):Matrix4x4
        {
            var _local_2= ASCompat.toNumber(((ASCompat.toNumber(this._data[0]) * ASCompat.toNumber(k.data[0])) + (ASCompat.toNumber(this._data[1]) * ASCompat.toNumber(k.data[3]))) + (ASCompat.toNumber(this._data[2]) * ASCompat.toNumber(k.data[6])));
            var _local_3= ASCompat.toNumber(((ASCompat.toNumber(this._data[0]) * ASCompat.toNumber(k.data[1])) + (ASCompat.toNumber(this._data[1]) * ASCompat.toNumber(k.data[4]))) + (ASCompat.toNumber(this._data[2]) * ASCompat.toNumber(k.data[7])));
            var _local_4= ASCompat.toNumber(((ASCompat.toNumber(this._data[0]) * ASCompat.toNumber(k.data[2])) + (ASCompat.toNumber(this._data[1]) * ASCompat.toNumber(k.data[5]))) + (ASCompat.toNumber(this._data[2]) * ASCompat.toNumber(k.data[8])));
            var _local_5= ASCompat.toNumber(((ASCompat.toNumber(this._data[3]) * ASCompat.toNumber(k.data[0])) + (ASCompat.toNumber(this._data[4]) * ASCompat.toNumber(k.data[3]))) + (ASCompat.toNumber(this._data[5]) * ASCompat.toNumber(k.data[6])));
            var _local_6= ASCompat.toNumber(((ASCompat.toNumber(this._data[3]) * ASCompat.toNumber(k.data[1])) + (ASCompat.toNumber(this._data[4]) * ASCompat.toNumber(k.data[4]))) + (ASCompat.toNumber(this._data[5]) * ASCompat.toNumber(k.data[7])));
            var _local_7= ASCompat.toNumber(((ASCompat.toNumber(this._data[3]) * ASCompat.toNumber(k.data[2])) + (ASCompat.toNumber(this._data[4]) * ASCompat.toNumber(k.data[5]))) + (ASCompat.toNumber(this._data[5]) * ASCompat.toNumber(k.data[8])));
            var _local_8= ASCompat.toNumber(((ASCompat.toNumber(this._data[6]) * ASCompat.toNumber(k.data[0])) + (ASCompat.toNumber(this._data[7]) * ASCompat.toNumber(k.data[3]))) + (ASCompat.toNumber(this._data[8]) * ASCompat.toNumber(k.data[6])));
            var _local_9= ASCompat.toNumber(((ASCompat.toNumber(this._data[6]) * ASCompat.toNumber(k.data[1])) + (ASCompat.toNumber(this._data[7]) * ASCompat.toNumber(k.data[4]))) + (ASCompat.toNumber(this._data[8]) * ASCompat.toNumber(k.data[7])));
            var _local_10= ASCompat.toNumber(((ASCompat.toNumber(this._data[6]) * ASCompat.toNumber(k.data[2])) + (ASCompat.toNumber(this._data[7]) * ASCompat.toNumber(k.data[5]))) + (ASCompat.toNumber(this._data[8]) * ASCompat.toNumber(k.data[8])));
            return new Matrix4x4(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
        }

        public function scalarMultiply(k:Float)
        {
            var _local_2 = 0;
            while (_local_2 < this._data.length)
            {
                this._data[_local_2] = (ASCompat.toNumber(this._data[_local_2]) * k);
                _local_2++;
            }
        }

        public function rotateX(k:Float):Matrix4x4
        {
            var _local_2= ((k * Math.PI) / 180);
            var _local_3= Math.cos(_local_2);
            var _local_4= Math.sin(_local_2);
            var _local_5= new Matrix4x4(1, 0, 0, 0, _local_3, -_local_4, 0, _local_4, _local_3);
            return _local_5.multiply(this);
        }

        public function rotateY(k:Float):Matrix4x4
        {
            var _local_2= ((k * Math.PI) / 180);
            var _local_3= Math.cos(_local_2);
            var _local_4= Math.sin(_local_2);
            var _local_5= new Matrix4x4(_local_3, 0, _local_4, 0, 1, 0, -_local_4, 0, _local_3);
            return _local_5.multiply(this);
        }

        public function rotateZ(k:Float):Matrix4x4
        {
            var _local_2= ((k * Math.PI) / 180);
            var _local_3= Math.cos(_local_2);
            var _local_4= Math.sin(_local_2);
            var _local_5= new Matrix4x4(_local_3, -_local_4, 0, _local_4, _local_3, 0, 0, 0, 1);
            return _local_5.multiply(this);
        }

        public function skew()
        {
        }

        public function transpose():Matrix4x4
        {
            return new Matrix4x4(ASCompat.toNumber(this._data[0]), ASCompat.toNumber(this._data[3]), ASCompat.toNumber(this._data[6]), ASCompat.toNumber(this._data[1]), ASCompat.toNumber(this._data[4]), ASCompat.toNumber(this._data[7]), ASCompat.toNumber(this._data[2]), ASCompat.toNumber(this._data[5]), ASCompat.toNumber(this._data[8]));
        }

        public function equals(k:Matrix4x4):Bool
        {
            return false;
        }

        public var data(get,never):Array<ASAny>;
public function  get_data():Array<ASAny>
        {
            return this._data;
        }
    }

