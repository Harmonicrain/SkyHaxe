package snowwar._str_254
;
	import com.sulake.core.runtime.IDisposable;

     class Location implements IDisposable //_SafeStr_4026
    {
        var _x:Int = 0;
        var _y:Int = 0;
        var _z:Int = 0;
        var _disposed:Bool = false;

        public function new(x:Int, y:Int, z:Int)
        {
            this._x = x;
            this._y = y;
            this._z = z;
        }

        public static function _SafeStr_18786(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool
        {
            var _local_6= (_arg_3 - k);
            if (_local_6 < 0)
            {
                _local_6 = -_local_6;
            }
            var _local_7= (_arg_4 - _arg_2);
            if (_local_7 < 0)
            {
                _local_7 = -_local_7;
            }
            if (((_local_7 > _arg_5) || (_local_6 > _arg_5)))
            {
                return false;
            }
            if (((_local_6 * _local_6) + (_local_7 * _local_7)) < (_arg_5 * _arg_5))
            {
                return true;
            }
            return false;
        }

        public function dispose()
        {
            this._x = 0;
            this._y = 0;
            this._z = 0;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._y;
        }

        public var z(get,never):Int;
public function  get_z():Int
        {
            return this._z;
        }

        public function setLocation(x:Int, y:Int, z:Int) //_SafeStr_18787
        {
            this._x = x;
            this._y = y;
            this._z = z;
        }

        public function setPosition(x:Int, y:Int) //_SafeStr_18788
        {
            this._x = x;
            this._y = y;
        }

        public function fromLocation(location:Location) //_SafeStr_18789
        {
            this._x = location._x;
            this._y = location._y;
            this._z = location._z;
        }

        public function distanceTo(location:Location):Int
        {
            var dX= (location._x - this._x);
            var dY= (location._y - this._y);
            var dZ= (location._z - this._z);
            return Std.int((Math.abs(dX) + Math.abs(dY)) + Math.abs(dZ));
        }

        public function directionTo(location:Location):Direction8
        {
            if (((location._x == this._x) && (location._y == this._y)))
            {
                return null;
            }
            var dX= (location._x - this._x);
            var dY= (location._y - this._y);
            var rotation= Direction360._SafeStr_18792(dX, dY);
            return Direction360.direction360ValueToDirection8(rotation);
        }

        public function equalLocation(object:ASObject):Bool //_SafeStr_6265
        {
            if (this == object)
            {
                return true;
            }
            if (!Std.is(object , Location))
            {
                return false;
            }
            var location= cast(object, Location);
			return this._x == location._x && this._y == location._y && this._z == location._z;
			
            /* Old. Before refactored.
			 * if (this._x != location._x)
            {
                return false;
            }
            if (this._y != location._y)
            {
                return false;
            }
            if (this._z != location._z)
            {
                return false;
            }
            return true;*/
        }

        public function _SafeStr_18790():Int //Probably hashcode just like Direction8._SafeStr_18790
        {
            var k = 0;
            k = this._x;
            k = ((29 * k) + this._y);
            k = ((29 * k) + this._z);
            return k;
        }

        public function toString():String
        {
            return (((("_x:" + Std.string(this._x)) + "yy:") + Std.string(this._y)) + "_zz:") + Std.string(this._z);
        }

        public function _SafeStr_18791(k:Location, _arg_2:Int):Bool
        {
            return _SafeStr_18786(this._x, this._y, k._x, k._y, _arg_2);
        }
    }

