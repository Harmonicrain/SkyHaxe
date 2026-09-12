package com.sulake.habbo.room.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

     class LegacyWallGeometry implements IDisposable 
    {
        static inline final L= "l";
        static inline final R= "r";

        var _isDisposed:Bool = false;
        var _scale:Int = 64;
        var _heightMap:Array<ASAny>;
        var _width:Int = 0;
        var _height:Int = 0;
        var _floorHeight:Int = 0;

        public function new()
        {
            this._heightMap = [];
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        
        public var scale(get,set):Int;
public function  get_scale():Int
        {
            return this._scale;
        }
public function  set_scale(k:Int):Int        {
            return this._scale = k;
        }

        public function dispose()
        {
            this.reset();
            this._isDisposed = true;
        }

        public function initialize(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_5:Array<ASAny> = null;
            var _local_6 = 0;
            if (((k <= this._width) && (_arg_2 <= this._height)))
            {
                this._width = k;
                this._height = _arg_2;
                this._floorHeight = _arg_3;
                return;
            }
            this.reset();
            var _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                _local_5 = [];
                this._heightMap.push(_local_5);
                _local_6 = 0;
                while (_local_6 < k)
                {
                    _local_5.push(0);
                    _local_6++;
                }
                _local_4++;
            }
            this._width = k;
            this._height = _arg_2;
            this._floorHeight = _arg_3;
        }

        function reset()
        {
            var k = 0;
            var _local_2:Array<ASAny> = null;
            if (this._heightMap != null)
            {
                k = 0;
                while (k < this._heightMap.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._heightMap[k] , Array);
                    k++;
                }
                this._heightMap = [];
            }
        }

        public function _Str_3982(k:Int, _arg_2:Int, _arg_3:Float):Bool
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return false;
            }
            var _local_4:Array<ASAny> = ASCompat.dynamicAs(this._heightMap[_arg_2] , Array);
            if (_local_4 != null)
            {
                _local_4[k] = _arg_3;
                return true;
            }
            return false;
        }

        public function getTileHeight(k:Int, _arg_2:Int):Float
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return 0;
            }
            var _local_3:Array<ASAny> = ASCompat.dynamicAs(this._heightMap[_arg_2] , Array);
            if (_local_3 != null)
            {
                return ASCompat.asNumber(_local_3[k] );
            }
            return 0;
        }

        public function getLocation(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String):IVector3d
        {
            var _local_12 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            if (((k == 0) && (_arg_2 == 0)))
            {
                k = this._width;
                _arg_2 = this._height;
                _local_12 = Std.int(Math.fround((this.scale / 10)));
                if (_arg_5 == R)
                {
                    _local_7 = (this._width - 1);
                    while (_local_7 >= 0)
                    {
                        _local_6 = 1;
                        while (_local_6 < this._height)
                        {
                            if (this.getTileHeight(_local_7, _local_6) <= this._floorHeight)
                            {
                                if ((_local_6 - 1) < _arg_2)
                                {
                                    k = _local_7;
                                    _arg_2 = (_local_6 - 1);
                                }
                                break;
                            }
                            _local_6++;
                        }
                        _local_7--;
                    }
                    _arg_4 = Std.int(_arg_4 + ((this.scale / 4) - (_local_12 / 2)));
                    _arg_3 = Std.int(_arg_3 + (this.scale / 2));
                }
                else
                {
                    _local_6 = (this._height - 1);
                    while (_local_6 >= 0)
                    {
                        _local_7 = 1;
                        while (_local_7 < this._width)
                        {
                            if (this.getTileHeight(_local_7, _local_6) <= this._floorHeight)
                            {
                                if ((_local_7 - 1) < k)
                                {
                                    k = (_local_7 - 1);
                                    _arg_2 = _local_6;
                                }
                                break;
                            }
                            _local_7++;
                        }
                        _local_6--;
                    }
                    _arg_4 = Std.int(_arg_4 + ((this.scale / 4) - (_local_12 / 2)));
                    _arg_3 = (_arg_3 - _local_12);
                }
            }
            var _local_8:Float = k;
            var _local_9:Float = _arg_2;
            var _local_10= this.getTileHeight(k, _arg_2);
            if (_arg_5 == R)
            {
                _local_8 = (_local_8 + ((_arg_3 / (this._scale / 2)) - 0.5));
                _local_9 = (_local_9 + 0.5);
                _local_10 = (_local_10 - ((_arg_4 - (_arg_3 / 2)) / (this._scale / 2)));
            }
            else
            {
                _local_9 = (_local_9 + ((((this._scale / 2) - _arg_3) / (this._scale / 2)) - 0.5));
                _local_8 = (_local_8 + 0.5);
                _local_10 = (_local_10 - ((_arg_4 - (((this._scale / 2) - _arg_3) / 2)) / (this._scale / 2)));
            }
            var _local_11= new Vector3d(_local_8, _local_9, _local_10);
            return _local_11;
        }

        public function getLocationOldFormat(k:Float, _arg_2:Float, _arg_3:String):IVector3d
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:Float = 0;
            var _local_7:Float = 0;
            _local_5 = Std.int(Math.fceil(k));
            _local_6 = (_local_5 - k);
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12:Float = 0;
            _local_4 = 0;
            while (_local_4 < this._width)
            {
                if (((_local_5 >= 0) && (_local_5 < this._height)))
                {
                    if (this.getTileHeight(_local_4, _local_5) <= this._floorHeight)
                    {
                        _local_8 = (_local_4 - 1);
                        _local_9 = _local_5;
                        _local_7 = _local_4;
                        _arg_3 = L;
                        break;
                    }
                    if (this.getTileHeight(_local_4, (_local_5 + 1)) <= this._floorHeight)
                    {
                        _local_8 = _local_4;
                        _local_9 = _local_5;
                        _local_7 = (_local_9 - k);
                        _arg_3 = R;
                        break;
                    }
                }
                _local_5++;
                _local_4++;
            }
            _local_10 = Std.int((this.scale / 2) * _local_6);
            var _local_13= ((-_local_7 * this.scale) / 2);
            _local_13 = (_local_13 + ((((-_arg_2 * 18) / 32) * this.scale) / 2));
            _local_12 = this.getTileHeight(_local_8, _local_9);
            _local_11 = Std.int(((_local_12 * this.scale) / 2) + _local_13);
            if (_arg_3 == R)
            {
                _local_11 = Std.int(_local_11 + ((_local_6 * this.scale) / 4));
            }
            else
            {
                _local_11 = Std.int(_local_11 + (((1 - _local_6) * this.scale) / 4));
            }
            return this.getLocation(_local_8, _local_9, _local_10, _local_11, _arg_3);
        }

        public function getOldLocation(k:IVector3d, _arg_2:Float):Array<ASAny>
        {
            if (k == null)
            {
                return null;
            }
            var _local_3:Float = 0;
            var _local_4:Float = 0;
            var _local_5:Float = 0;
            var _local_6:Float = 0;
            var _local_7= "";
            var _local_8:Float = 0;
            if (_arg_2 == 90)
            {
                _local_3 = Math.ffloor((k.x - 0.5));
                _local_4 = Math.ffloor((k.y + 0.5));
                _local_8 = this.getTileHeight(Std.int(_local_3), Std.int(_local_4));
                _local_5 = ((this._scale / 2) - (((k.y - _local_4) + 0.5) * (this._scale / 2)));
                _local_6 = (((_local_8 - k.z) * (this._scale / 2)) + (((this._scale / 2) - _local_5) / 2));
                _local_7 = L;
            }
            else
            {
                if (_arg_2 == 180)
                {
                    _local_3 = Math.ffloor((k.x + 0.5));
                    _local_4 = Math.ffloor((k.y - 0.5));
                    _local_8 = this.getTileHeight(Std.int(_local_3), Std.int(_local_4));
                    _local_5 = (((k.x + 0.5) - _local_3) * (this._scale / 2));
                    _local_6 = (((_local_8 - k.z) * (this._scale / 2)) + (_local_5 / 2));
                    _local_7 = R;
                }
                else
                {
                    return null;
                }
            }
            return [_local_3, _local_4, _local_5, _local_6, _local_7];
        }

        public function getOldLocationString(k:IVector3d, _arg_2:Float):String
        {
            var _local_3= this.getOldLocation(k, _arg_2);
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= ASCompat.toInt(_local_3[0]);
            var _local_5= ASCompat.toInt(_local_3[1]);
            var _local_6= ASCompat.toInt(_local_3[2]);
            var _local_7= ASCompat.toInt(_local_3[3]);
            var _local_8:String = _local_3[4];
            var _local_9= (((((((((":w=" + Std.string(_local_4)) + ",") + Std.string(_local_5)) + " l=") + Std.string(_local_6)) + ",") + Std.string(_local_7)) + " ") + _local_8);
            return _local_9;
        }

        public function getDirection(k:String):Float
        {
            if (k == R)
            {
                return 180;
            }
            return 90;
        }

        public function getFloorAltitude(k:Int, _arg_2:Int):Float
        {
            var _local_3 = 0;
            _local_3 = Std.int(this.getTileHeight(k, _arg_2));
            var _local_4= (_local_3 + 1);
            return _local_3 + (((((((((Std.int(this.getTileHeight((k - 1), (_arg_2 - 1))) == _local_4) || (Std.int(this.getTileHeight(k, (_arg_2 - 1))) == _local_4)) || (Std.int(this.getTileHeight((k + 1), (_arg_2 - 1))) == _local_4)) || (Std.int(this.getTileHeight((k - 1), _arg_2)) == _local_4)) || (Std.int(this.getTileHeight((k + 1), _arg_2)) == _local_4)) || (Std.int(this.getTileHeight((k - 1), (_arg_2 + 1))) == _local_4)) || (Std.int(this.getTileHeight(k, (_arg_2 + 1))) == _local_4)) || (Std.int(this.getTileHeight((k + 1), (_arg_2 + 1))) == _local_4)) ? 0.5 : 0);
        }

        public function isRoomTile(k:Int, _arg_2:Int):Bool
        {
            return ((((k >= 0) && (k < this._width)) && (_arg_2 >= 0)) && (_arg_2 < this._height)) && (this._heightMap[_arg_2][k] >= 0);
        }
    }

