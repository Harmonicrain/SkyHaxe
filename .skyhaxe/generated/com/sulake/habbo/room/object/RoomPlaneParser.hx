package com.sulake.habbo.room.object
;
    import com.sulake.core.utils.Map;
    import flash.geom.Point;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.XMLValidator;

     class RoomPlaneParser 
    {
        static inline final FLOOR_THICKNESS= 0.25;
        static inline final WALL_THICKNESS= 0.25;
        static inline final MAX_WALL_ADDITIONAL_HEIGHT:Float = 20;
        public static inline final TILE_BLOCKED= -110;
        public static inline final TILE_HOLE= -100;

        var _tileMatrix:Array<ASAny>;
        var _tileMatrixOriginal:Array<ASAny>;
        var _width:Int = 0;
        var _height:Int = 0;
        var _minX:Int = 0;
        var _maxX:Int = 0;
        var _minY:Int = 0;
        var _maxY:Int = 0;
        var _planes:Array<ASAny>;
        var _wallHeight:Float = 0;
        var _wallThicknessMultiplier:Float = 1;
        var _floorThicknessMultiplier:Float = 1;
        var _fixedWallHeight:Int = -1;
        var _floorHeight:Float = 0;
        var _floorHoles:Map = null;
        var _invertedFloorHoles:Map = null;
        var _floorHoleMatrix:Array<ASAny>;
        var _expandedFloorTiles:Vector<Vector<Int>>;
        var _temporaryHighlightPlanes:Array<ASAny> = [];

        public function new()
        {
            this._tileMatrix = [];
            this._tileMatrixOriginal = [];
            this._planes = [];
            this._floorHoleMatrix = [];
            this._wallHeight = 3.6;
            this._wallThicknessMultiplier = 1;
            this._floorThicknessMultiplier = 1;
            this._floorHoles = new Map();
            this._invertedFloorHoles = new Map();
        }

        static function getFloorHeight(k:Array<ASAny>):Float
        {
            var _local_8 = 0;
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:Array<ASAny> = null;
            var _local_5= k.length;
            var _local_6 = 0;
            if (_local_5 == 0)
            {
                return 0;
            }
            var _local_7:Float = 0;
            _local_3 = 0;
            while (_local_3 < _local_5)
            {
                _local_4 = ASCompat.dynamicAs(k[_local_3] , Array);
                _local_2 = 0;
                while (_local_2 < _local_4.length)
                {
                    _local_8 = Std.int(ASCompat.toNumber(_local_4[_local_2]));
                    if (_local_8 > _local_7)
                    {
                        _local_7 = _local_8;
                    }
                    _local_2++;
                }
                _local_3++;
            }
            return _local_7;
        }

        static function findEntranceTile(k:Array<ASAny>):Point
        {
            if (k == null)
            {
                return null;
            }
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:Array<ASAny> = null;
            var _local_5= k.length;
            if (_local_5 == 0)
            {
                return null;
            }
            var _local_6:Array<ASAny> = [];
            _local_3 = 0;
            while (_local_3 < _local_5)
            {
                _local_4 = ASCompat.dynamicAs(k[_local_3] , Array);
                if (((_local_4 == null) || (_local_4.length == 0)))
                {
                    return null;
                }
                _local_2 = 0;
                while (_local_2 < _local_4.length)
                {
                    if (ASCompat.toNumber(_local_4[_local_2]) >= 0)
                    {
                        _local_6.push(_local_2);
                        break;
                    }
                    _local_2++;
                }
                if (_local_6.length < (_local_3 + 1))
                {
                    _local_6.push((_local_4.length + 1));
                }
                _local_3++;
            }
            _local_3 = 1;
            while (_local_3 < (_local_6.length - 1))
            {
                if (((ASCompat.toInt(_local_6[_local_3]) <= (ASCompat.toInt(_local_6[(_local_3 - 1)]) - 1)) && (ASCompat.toInt(_local_6[_local_3]) <= (ASCompat.toInt(_local_6[(_local_3 + 1)]) - 1))))
                {
                    return new Point(ASCompat.toInt(_local_6[_local_3]), _local_3);
                }
                _local_3++;
            }
            return null;
        }

        static function expandFloorTiles(k:Vector<Vector<Int>>):Vector<Vector<Int>>
        {
            var _local_2:UInt = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17 = 0;
            _local_2 = k.length;
            var _local_3:UInt = k[0].length;
            var _local_4= new Vector<Vector<Int>>((_local_2 * 4));
            _local_6 = 0;
            while ((_local_6 : UInt) < (_local_2 * 4))
            {
                _local_4[_local_6] = new Vector<Int>((_local_3 * 4));
                _local_6++;
            }
            var _local_9 = 0;
            _local_6 = 0;
            while ((_local_6 : UInt) < _local_2)
            {
                _local_10 = 0;
                _local_5 = 0;
                while ((_local_5 : UInt) < _local_3)
                {
                    _local_11 = k[_local_6][_local_5];
                    if (((_local_11 < 0) || (_local_11 <= 0xFF)))
                    {
                        _local_8 = 0;
                        while (_local_8 < 4)
                        {
                            _local_7 = 0;
                            while (_local_7 < 4)
                            {
                                _local_4[(_local_9 + _local_8)][(_local_10 + _local_7)] = ((_local_11 < 0) ? _local_11 : (_local_11 * 4));
                                _local_7++;
                            }
                            _local_8++;
                        }
                    }
                    else
                    {
                        _local_12 = ((_local_11 & 0xFF) * 4);
                        _local_13 = (_local_12 + (((_local_11 >> 11) & 0x01) * 3));
                        _local_14 = (_local_12 + (((_local_11 >> 10) & 0x01) * 3));
                        _local_15 = (_local_12 + (((_local_11 >> 9) & 0x01) * 3));
                        _local_16 = (_local_12 + (((_local_11 >> 8) & 0x01) * 3));
                        _local_7 = 0;
                        while (_local_7 < 3)
                        {
                            _local_17 = (_local_7 + 1);
                            _local_4[_local_9][(_local_10 + _local_7)] = Std.int(((_local_13 * (3 - _local_7)) + (_local_14 * _local_7)) / 3);
                            _local_4[(_local_9 + 3)][(_local_10 + _local_17)] = Std.int(((_local_15 * (3 - _local_17)) + (_local_16 * _local_17)) / 3);
                            _local_4[(_local_9 + _local_17)][_local_10] = Std.int(((_local_13 * (3 - _local_17)) + (_local_15 * _local_17)) / 3);
                            _local_4[(_local_9 + _local_7)][(_local_10 + 3)] = Std.int(((_local_14 * (3 - _local_7)) + (_local_16 * _local_7)) / 3);
                            _local_7++;
                        }
                        _local_4[(_local_9 + 1)][(_local_10 + 1)] = ((_local_13 > _local_12) ? (_local_12 + 2) : (_local_12 + 1));
                        _local_4[(_local_9 + 1)][(_local_10 + 2)] = ((_local_14 > _local_12) ? (_local_12 + 2) : (_local_12 + 1));
                        _local_4[(_local_9 + 2)][(_local_10 + 1)] = ((_local_15 > _local_12) ? (_local_12 + 2) : (_local_12 + 1));
                        _local_4[(_local_9 + 2)][(_local_10 + 2)] = ((_local_16 > _local_12) ? (_local_12 + 2) : (_local_12 + 1));
                    }
                    _local_10 = (_local_10 + 4);
                    _local_5++;
                }
                _local_9 = (_local_9 + 4);
                _local_6++;
            }
            return _local_4;
        }

        static function addTileTypes(k:Vector<Vector<Int>>)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17 = 0;
            var _local_2:UInt = (k.length - 1);
            var _local_3:UInt = (k[0].length - 1);
            _local_5 = 1;
            while ((_local_5 : UInt) < _local_2)
            {
                _local_4 = 1;
                while ((_local_4 : UInt) < _local_3)
                {
                    _local_6 = k[_local_5][_local_4];
                    if (_local_6 < 0)
                    {
                    }
                    else
                    {
                        _local_7 = (k[(_local_5 - 1)][(_local_4 - 1)] & 0xFF);
                        _local_8 = (k[(_local_5 - 1)][_local_4] & 0xFF);
                        _local_9 = (k[(_local_5 - 1)][(_local_4 + 1)] & 0xFF);
                        _local_10 = (k[_local_5][(_local_4 - 1)] & 0xFF);
                        _local_11 = (k[_local_5][(_local_4 + 1)] & 0xFF);
                        _local_12 = (k[(_local_5 + 1)][(_local_4 - 1)] & 0xFF);
                        _local_13 = (k[(_local_5 + 1)][_local_4] & 0xFF);
                        _local_14 = (k[(_local_5 + 1)][(_local_4 + 1)] & 0xFF);
                        _local_15 = (_local_6 + 1);
                        _local_16 = (_local_6 - 1);
                        _local_17 = (((((((_local_7 == _local_15) || (_local_8 == _local_15)) || (_local_10 == _local_15)) ? 8 : 0) | ((((_local_9 == _local_15) || (_local_8 == _local_15)) || (_local_11 == _local_15)) ? 4 : 0)) | ((((_local_12 == _local_15) || (_local_13 == _local_15)) || (_local_10 == _local_15)) ? 2 : 0)) | ((((_local_14 == _local_15) || (_local_13 == _local_15)) || (_local_11 == _local_15)) ? 1 : 0));
                        if (_local_17 == 15)
                        {
                            _local_17 = 0;
                        }
                        k[_local_5][_local_4] = (_local_6 | (_local_17 << 8));
                    }
                    _local_4++;
                }
                _local_5++;
            }
        }

        static function unpadHeightMap(k:Vector<Vector<Int>>)
        {
            var _local_2:Vector<Int> = null;
            k.shift();
            k.pop();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_2.shift();
                _local_2.pop();
            }
        }

        static function padHeightMap(k:Vector<Vector<Int>>)
        {
            var _local_4:Vector<Int> = null;
            var _local_5 = 0;
            var _local_2= new Vector<Int>(0);
            var _local_3= new Vector<Int>(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _local_4.push(TILE_BLOCKED);
                _local_4.unshift(TILE_BLOCKED);
            }
            final _iter_ = k[0]; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_2.push(TILE_BLOCKED);
                _local_3.push(TILE_BLOCKED);
            }
            k.push(_local_3);
            k.unshift(_local_2);
        }


        public var minX(get,never):Int;
public function  get_minX():Int
        {
            return this._minX;
        }

        public var maxX(get,never):Int;
public function  get_maxX():Int
        {
            return this._maxX;
        }

        public var minY(get,never):Int;
public function  get_minY():Int
        {
            return this._minY;
        }

        public var maxY(get,never):Int;
public function  get_maxY():Int
        {
            return this._maxY;
        }

        public var tileMapWidth(get,never):Int;
public function  get_tileMapWidth():Int
        {
            return this._width;
        }

        public var tileMapHeight(get,never):Int;
public function  get_tileMapHeight():Int
        {
            return this._height;
        }

        public var _Str_3828(get,never):Int;
public function  get__Str_3828():Int
        {
            return this._planes.length;
        }

        public var floorHeight(get,never):Float;
public function  get_floorHeight():Float
        {
            if (this._fixedWallHeight != -1)
            {
                return this._fixedWallHeight;
            }
            return this._floorHeight;
        }

        
        public var wallHeight(get,set):Float;
public function  get_wallHeight():Float
        {
            if (this._fixedWallHeight != -1)
            {
                return this._fixedWallHeight + 3.6;
            }
            return this._wallHeight;
        }
public function  set_wallHeight(k:Float):Float        {
            if (k < 0)
            {
                k = 0;
            }
            return this._wallHeight = k;
        }

        
        public var wallThicknessMultiplier(get,set):Float;
public function  get_wallThicknessMultiplier():Float
        {
            return this._wallThicknessMultiplier;
        }
public function  set_wallThicknessMultiplier(k:Float):Float        {
            if (k < 0)
            {
                k = 0;
            }
            return this._wallThicknessMultiplier = k;
        }

        
        public var floorThicknessMultiplier(get,set):Float;
public function  get_floorThicknessMultiplier():Float
        {
            return this._floorThicknessMultiplier;
        }
public function  set_floorThicknessMultiplier(k:Float):Float        {
            if (k < 0)
            {
                k = 0;
            }
            return this._floorThicknessMultiplier = k;
        }

        public function dispose()
        {
            this._planes = null;
            this._tileMatrix = null;
            this._tileMatrixOriginal = null;
            this._floorHoleMatrix = null;
            if (this._floorHoles != null)
            {
                this._floorHoles.dispose();
                this._floorHoles = null;
            }
            if (this._invertedFloorHoles != null)
            {
                this._invertedFloorHoles.dispose();
                this._invertedFloorHoles = null;
            }
        }

        public function reset()
        {
            this._planes = [];
            this._temporaryHighlightPlanes.resize(0);
            this._expandedFloorTiles = null;
            this._tileMatrix = [];
            this._tileMatrixOriginal = [];
            this._tileMatrix = [];
            this._tileMatrixOriginal = [];
            this._width = 0;
            this._height = 0;
            this._minX = 0;
            this._maxX = 0;
            this._minY = 0;
            this._maxY = 0;
            this._floorHeight = 0;
            this._floorHoleMatrix = [];
        }

        public function initializeTileMap(k:Int, _arg_2:Int):Bool
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:Array<ASAny> = null;
            var _local_7 = 0;
            if (k < 0)
            {
                k = 0;
            }
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            }
            this._tileMatrix = [];
            this._tileMatrixOriginal = [];
            this._floorHoleMatrix = [];
            var _local_3 = 0;
            while (_local_3 < _arg_2)
            {
                _local_4 = [];
                _local_5 = [];
                _local_6 = [];
                _local_7 = 0;
                while (_local_7 < k)
                {
                    _local_4[_local_7] = TILE_BLOCKED;
                    _local_5[_local_7] = TILE_BLOCKED;
                    _local_6[_local_7] = false;
                    _local_7++;
                }
                this._tileMatrix.push(_local_4);
                this._tileMatrixOriginal.push(_local_5);
                this._floorHoleMatrix.push(_local_6);
                _local_3++;
            }
            this._width = k;
            this._height = _arg_2;
            this._minX = this._width;
            this._maxX = -1;
            this._minY = this._height;
            this._maxY = -1;
            return true;
        }

        public function _Str_3982(k:Int, _arg_2:Int, _arg_3:Float):Bool
        {
            var _local_4:Array<ASAny> = null;
            var _local_5 = false;
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8 = 0;
            if (((((k >= 0) && (k < this._width)) && (_arg_2 >= 0)) && (_arg_2 < this._height)))
            {
                _local_4 = ASCompat.dynamicAs(this._tileMatrix[_arg_2] , Array);
                _local_4[k] = _arg_3;
                if (_arg_3 >= 0)
                {
                    if (k < this._minX)
                    {
                        this._minX = k;
                    }
                    if (k > this._maxX)
                    {
                        this._maxX = k;
                    }
                    if (_arg_2 < this._minY)
                    {
                        this._minY = _arg_2;
                    }
                    if (_arg_2 > this._maxY)
                    {
                        this._maxY = _arg_2;
                    }
                }
                else
                {
                    if (((k == this._minX) || (k == this._maxX)))
                    {
                        _local_5 = false;
                        _local_6 = this._minY;
                        while (_local_6 < this._maxY)
                        {
                            if (this.getTileHeightInternal(k, _local_6) >= 0)
                            {
                                _local_5 = true;
                                break;
                            }
                            _local_6++;
                        }
                        if (!_local_5)
                        {
                            if (k == this._minX)
                            {
                                this._minX++;
                            }
                            if (k == this._maxX)
                            {
                                this._maxX--;
                            }
                        }
                    }
                    if (((_arg_2 == this._minY) || (_arg_2 == this._maxY)))
                    {
                        _local_7 = false;
                        _local_8 = this._minX;
                        while (_local_8 < this._maxX)
                        {
                            if (this.getTileHeight(_local_8, _arg_2) >= 0)
                            {
                                _local_7 = true;
                                break;
                            }
                            _local_8++;
                        }
                        if (!_local_7)
                        {
                            if (_arg_2 == this._minY)
                            {
                                this._minY++;
                            }
                            if (_arg_2 == this._maxY)
                            {
                                this._maxY--;
                            }
                        }
                    }
                }
                return true;
            }
            return false;
        }

        public function getTileHeight(k:Int, _arg_2:Int):Float
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return TILE_BLOCKED;
            }
            var _local_3:Array<ASAny> = ASCompat.dynamicAs(this._tileMatrix[_arg_2] , Array);
            return Math.abs(ASCompat.asNumber(_local_3[k] ));
        }

        function getTileHeightOriginal(k:Int, _arg_2:Int):Float
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return TILE_BLOCKED;
            }
            if (this._floorHoleMatrix[_arg_2][k])
            {
                return TILE_HOLE;
            }
            var _local_3:Array<ASAny> = ASCompat.dynamicAs(this._tileMatrixOriginal[_arg_2] , Array);
            return ASCompat.asNumber(_local_3[k] );
        }

        function getTileHeightInternal(k:Int, _arg_2:Int):Float
        {
            if (((((k < 0) || (k >= this._width)) || (_arg_2 < 0)) || (_arg_2 >= this._height)))
            {
                return TILE_BLOCKED;
            }
            var _local_3:Array<ASAny> = ASCompat.dynamicAs(this._tileMatrix[_arg_2] , Array);
            return ASCompat.asNumber(_local_3[k] );
        }

        public function initializeFromTileData(k:Int=-1):Bool
        {
            var _local_2 = 0;
            var _local_3 = 0;
            this._fixedWallHeight = k;
            _local_3 = 0;
            while (_local_3 < this._height)
            {
                _local_2 = 0;
                while (_local_2 < this._width)
                {
                    this._tileMatrixOriginal[_local_3][_local_2] = this._tileMatrix[_local_3][_local_2];
                    _local_2++;
                }
                _local_3++;
            }
            var _local_4= findEntranceTile(this._tileMatrix);
            _local_3 = 0;
            while (_local_3 < this._height)
            {
                _local_2 = 0;
                while (_local_2 < this._width)
                {
                    if (this._floorHoleMatrix[_local_3][_local_2])
                    {
                        this._Str_3982(_local_2, _local_3, TILE_HOLE);
                    }
                    _local_2++;
                }
                _local_3++;
            }
            return this.initialize(_local_4);
        }

        function initialize(k:Point):Bool
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:Vector<Vector<Int>> = null;
            var _local_2 = 0;
            if (k != null)
            {
                _local_2 = Std.int(this.getTileHeight(Std.int(k.x), Std.int(k.y)));
                this._Str_3982(Std.int(k.x), Std.int(k.y), TILE_BLOCKED);
            }
            this._floorHeight = getFloorHeight(this._tileMatrix);
            this.createWallPlanes();
            var _local_3= new Vector<Vector<Int>>(0);
            final _iter_ = this._tileMatrix; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_3.push(Vector.ofArray(((cast _local_4) : Array<Int>)));
            }
            padHeightMap(_local_3);
            addTileTypes(_local_3);
            unpadHeightMap(_local_3);
            _local_5 = expandFloorTiles(_local_3);
            this._expandedFloorTiles = _local_5;
            this.extractPlanes(_local_5);
            if (k != null)
            {
                this._Str_3982(Std.int(k.x), Std.int(k.y), _local_2);
                this.addFloor(new Vector3d((k.x + 0.5), (k.y + 0.5), _local_2), new Vector3d(-1, 0, 0), new Vector3d(0, -1, 0), false, false, false, false);
            }
            return true;
        }

        function generateWallData(k:Point, _arg_2:Bool):RoomWallData
        {
            var _local_8 = false;
            var _local_9 = false;
            var _local_10 = 0;
            var _local_11:Point = null;
            var _local_12 = 0;
            var _local_3= new RoomWallData();
            var _local_4:Array<ASAny> = [this.extractTopWall, this.extractRightWall, this.extractBottomWall, this.extractLeftWall];
            var _local_5 = 0;
            var _local_6= new Point(k.x, k.y);
            var _local_7 = 0;
            while (_local_7++ < 1000)
            {
                _local_8 = false;
                _local_9 = false;
                _local_10 = _local_5;
                if (((((_local_6.x < this.minX) || (_local_6.x > this.maxX)) || (_local_6.y < this.minY)) || (_local_6.y > this.maxY)))
                {
                    _local_8 = true;
                }
                _local_11 = _local_4[_local_5](_local_6, _arg_2);
                if (_local_11 == null)
                {
                    return null;
                }
                _local_12 = Std.int(Math.abs((_local_11.x - _local_6.x)) + Math.abs((_local_11.y - _local_6.y)));
                if (((_local_6.x == _local_11.x) || (_local_6.y == _local_11.y)))
                {
                    _local_5 = (((_local_5 - 1) + _local_4.length) % _local_4.length);
                    _local_12 = (_local_12 + 1);
                    _local_9 = true;
                }
                else
                {
                    _local_5 = ((_local_5 + 1) % _local_4.length);
                    _local_12--;
                }
                _local_3._Str_17862(_local_6, _local_10, _local_12, _local_8, _local_9);
                if ((((_local_11.x == k.x) && (_local_11.y == k.y)) && ((!(_local_11.x == _local_6.x)) || (!(_local_11.y == _local_6.y)))))
                {
                    break;
                }
                _local_6 = _local_11;
            }
            if (_local_3.count == 0)
            {
                return null;
            }
            return _local_3;
        }

        function hidePeninsulaWallChains(k:RoomWallData)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8 = 0;
            var _local_2 = 0;
            var _local_3= k.count;
            while (_local_2 < _local_3)
            {
                _local_4 = _local_2;
                _local_5 = _local_2;
                _local_6 = 0;
                _local_7 = false;
                while (((!k.getBorder(_local_2)) && (_local_2 < _local_3)))
                {
                    if (k.getLeftTurn(_local_2))
                    {
                        _local_6++;
                    }
                    else
                    {
                        if (_local_6 > 0)
                        {
                            _local_6--;
                        }
                    }
                    if (_local_6 > 1)
                    {
                        _local_7 = true;
                    }
                    _local_5 = _local_2;
                    _local_2++;
                }
                if (_local_7)
                {
                    _local_8 = _local_4;
                    while (_local_8 <= _local_5)
                    {
                        k.setHideWall(_local_8, true);
                        _local_8++;
                    }
                }
                _local_2++;
            }
        }

        function updateWallsNextToHoles(k:RoomWallData)
        {
            var _local_4:Point = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:IVector3d = null;
            var _local_8:IVector3d = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_2= k.count;
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                if (!k.getHideWall(_local_3))
                {
                    _local_4 = k.getCorner(_local_3);
                    _local_5 = k.getDirection(_local_3);
                    _local_6 = k.getLength(_local_3);
                    _local_7 = RoomWallData.WALL_DIRECTION_VECTORS[_local_5];
                    _local_8 = RoomWallData.WALL_NORMAL_VECTORS[_local_5];
                    _local_9 = 0;
                    _local_10 = 0;
                    while (_local_10 < _local_6)
                    {
                        if (this.getTileHeightInternal(Std.int((_local_4.x + (_local_10 * _local_7.x)) - _local_8.x), Std.int((_local_4.y + (_local_10 * _local_7.y)) - _local_8.y)) == TILE_HOLE)
                        {
                            if (((_local_10 > 0) && (_local_9 == 0)))
                            {
                                k.setLength(_local_3, _local_10);
                                break;
                            }
                            _local_9++;
                        }
                        else
                        {
                            if (_local_9 > 0)
                            {
                                k.moveCorner(_local_3, _local_9);
                                break;
                            }
                        }
                        _local_10++;
                    }
                    if (_local_9 == _local_6)
                    {
                        k.setHideWall(_local_3, true);
                    }
                }
                _local_3++;
            }
        }

        function resolveOriginalWallIndex(k:Point, _arg_2:Point, _arg_3:RoomWallData):Int
        {
            var _local_10:Point = null;
            var _local_11:Point = null;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_4= Std.int(Math.min(k.y, _arg_2.y));
            var _local_5= Std.int(Math.max(k.y, _arg_2.y));
            var _local_6= Std.int(Math.min(k.x, _arg_2.x));
            var _local_7= Std.int(Math.max(k.x, _arg_2.x));
            var _local_8= _arg_3.count;
            var _local_9 = 0;
            while (_local_9 < _local_8)
            {
                _local_10 = _arg_3.getCorner(_local_9);
                _local_11 = _arg_3.getEndPoint(_local_9);
                if (k.x == _arg_2.x)
                {
                    if (((_local_10.x == k.x) && (_local_11.x == k.x)))
                    {
                        _local_12 = Std.int(Math.min(_local_10.y, _local_11.y));
                        _local_13 = Std.int(Math.max(_local_10.y, _local_11.y));
                        if (((_local_12 <= _local_4) && (_local_5 <= _local_13)))
                        {
                            return _local_9;
                        }
                    }
                }
                else
                {
                    if (k.y == _arg_2.y)
                    {
                        if (((_local_10.y == k.y) && (_local_11.y == k.y)))
                        {
                            _local_14 = Std.int(Math.min(_local_10.x, _local_11.x));
                            _local_15 = Std.int(Math.max(_local_10.x, _local_11.x));
                            if (((_local_14 <= _local_6) && (_local_7 <= _local_15)))
                            {
                                return _local_9;
                            }
                        }
                    }
                }
                _local_9++;
            }
            return -1;
        }

        function hideOriginallyHiddenWalls(k:RoomWallData, _arg_2:RoomWallData)
        {
            var _local_5:Point = null;
            var _local_6:Point = null;
            var _local_7:IVector3d = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_3= k.count;
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                if (!k.getHideWall(_local_4))
                {
                    _local_5 = k.getCorner(_local_4);
                    _local_6 = new Point(_local_5.x, _local_5.y);
                    _local_7 = RoomWallData.WALL_DIRECTION_VECTORS[k.getDirection(_local_4)];
                    _local_8 = k.getLength(_local_4);
                    _local_6.x = (_local_6.x + (_local_7.x * _local_8));
                    _local_6.y = (_local_6.y + (_local_7.y * _local_8));
                    _local_9 = this.resolveOriginalWallIndex(_local_5, _local_6, _arg_2);
                    if (_local_9 >= 0)
                    {
                        if (_arg_2.getHideWall(_local_9))
                        {
                            k.setHideWall(_local_4, true);
                        }
                    }
                    else
                    {
                        k.setHideWall(_local_4, true);
                    }
                }
                _local_4++;
            }
        }

        function checkWallHiding(k:RoomWallData, _arg_2:RoomWallData)
        {
            this.hidePeninsulaWallChains(_arg_2);
            this.updateWallsNextToHoles(k);
            this.hideOriginallyHiddenWalls(k, _arg_2);
        }

        function addWalls(k:RoomWallData, _arg_2:RoomWallData)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_8:Point = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11:IVector3d = null;
            var _local_12:IVector3d = null;
            var _local_13 = Math.NaN;
            var _local_14 = 0;
            var _local_15 = Math.NaN;
            var _local_16:Vector3d = null;
            var _local_17 = Math.NaN;
            var _local_18:Vector3d = null;
            var _local_19:Vector3d = null;
            var _local_20 = 0;
            var _local_21:Vector3d = null;
            var _local_22 = false;
            var _local_23 = false;
            var _local_24 = false;
            var _local_25 = false;
            var _local_26 = false;
            var _local_27 = Math.NaN;
            var _local_3= k.count;
            var _local_4= _arg_2.count;
            var _local_7 = 0;
            while (_local_7 < _local_3)
            {
                if (!k.getHideWall(_local_7))
                {
                    _local_8 = k.getCorner(_local_7);
                    _local_9 = k.getDirection(_local_7);
                    _local_10 = k.getLength(_local_7);
                    _local_11 = RoomWallData.WALL_DIRECTION_VECTORS[_local_9];
                    _local_12 = RoomWallData.WALL_NORMAL_VECTORS[_local_9];
                    _local_13 = -1;
                    _local_14 = 0;
                    while (_local_14 < _local_10)
                    {
                        _local_27 = this.getTileHeightInternal(Std.int((_local_8.x + (_local_14 * _local_11.x)) + _local_12.x), Std.int((_local_8.y + (_local_14 * _local_11.y)) + _local_12.y));
                        if (((_local_27 >= 0) && ((_local_27 < _local_13) || (_local_13 < 0))))
                        {
                            _local_13 = _local_27;
                        }
                        _local_14++;
                    }
                    _local_15 = _local_13;
                    _local_16 = new Vector3d(_local_8.x, _local_8.y, _local_15);
                    _local_16 = Vector3d.sum(_local_16, Vector3d.product(_local_12, 0.5));
                    _local_16 = Vector3d.sum(_local_16, Vector3d.product(_local_11, -0.5));
                    _local_17 = ((this.wallHeight + Math.min(MAX_WALL_ADDITIONAL_HEIGHT, this.floorHeight)) - _local_13);
                    _local_18 = Vector3d.product(_local_11, -_local_10);
                    _local_19 = new Vector3d(0, 0, _local_17);
                    _local_16 = Vector3d.dif(_local_16, _local_18);
                    _local_20 = this.resolveOriginalWallIndex(_local_8, k.getEndPoint(_local_7), _arg_2);
                    if (_local_20 >= 0)
                    {
                        _local_5 = _arg_2.getDirection(((_local_20 + 1) % _local_4));
                        _local_6 = _arg_2.getDirection((((_local_20 - 1) + _local_4) % _local_4));
                    }
                    else
                    {
                        _local_5 = k.getDirection(((_local_7 + 1) % _local_3));
                        _local_6 = k.getDirection((((_local_7 - 1) + _local_3) % _local_3));
                    }
                    _local_21 = null;
                    if ((((_local_5 - _local_9) + 4) % 4) == 3)
                    {
                        _local_21 = RoomWallData.WALL_NORMAL_VECTORS[_local_5];
                    }
                    else
                    {
                        if ((((_local_9 - _local_6) + 4) % 4) == 3)
                        {
                            _local_21 = RoomWallData.WALL_NORMAL_VECTORS[_local_6];
                        }
                    }
                    _local_22 = k.getLeftTurn(_local_7);
                    _local_23 = k.getLeftTurn((((_local_7 - 1) + _local_3) % _local_3));
                    _local_24 = k.getHideWall(((_local_7 + 1) % _local_3));
                    _local_25 = k.getManuallyLeftCut(_local_7);
                    _local_26 = k.getManuallyRightCut(_local_7);
                    this._Str_17862(_local_16, _local_18, _local_19, _local_21, ((!_local_23) || _local_25), ((!_local_22) || _local_26), (!_local_24));
                }
                _local_7++;
            }
        }

        function createWallPlanes():Bool
        {
            var _local_13 = 0;
            var _local_14 = 0;
            var k= this._tileMatrix;
            if (k == null)
            {
                return false;
            }
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:Array<ASAny> = null;
            var _local_5= k.length;
            var _local_6 = 0;
            if (_local_5 == 0)
            {
                return false;
            }
            _local_2 = 0;
            while (_local_2 < _local_5)
            {
                _local_4 = ASCompat.dynamicAs(k[_local_2] , Array);
                if (((_local_4 == null) || (_local_4.length == 0)))
                {
                    return false;
                }
                if (_local_6 > 0)
                {
                    _local_6 = Std.int(Math.min(_local_6, _local_4.length));
                }
                else
                {
                    _local_6 = _local_4.length;
                }
                _local_2++;
            }
            var _local_7= Math.min(MAX_WALL_ADDITIONAL_HEIGHT, ((this._fixedWallHeight != -1) ? this._fixedWallHeight : getFloorHeight(k)));
            var _local_8= this.minX;
            var _local_9= this.minY;
            _local_9 = this.minY;
            while (_local_9 <= this.maxY)
            {
                if (this.getTileHeightInternal(_local_8, _local_9) > TILE_HOLE)
                {
                    _local_9--;
                    break;
                }
                _local_9++;
            }
            if (_local_9 > this.maxY)
            {
                return false;
            }
            var _local_10= new Point(_local_8, _local_9);
            var _local_11= this.generateWallData(_local_10, true);
            var _local_12= this.generateWallData(_local_10, false);
            if (_local_11 != null)
            {
                _local_13 = _local_11.count;
                _local_14 = _local_12.count;
                this.checkWallHiding(_local_11, _local_12);
                this.addWalls(_local_11, _local_12);
            }
            _local_3 = 0;
            while (_local_3 < this.tileMapHeight)
            {
                _local_2 = 0;
                while (_local_2 < this.tileMapWidth)
                {
                    if (this.getTileHeightInternal(_local_2, _local_3) < 0)
                    {
                        this._Str_3982(_local_2, _local_3, -(_local_7 + this.wallHeight));
                    }
                    _local_2++;
                }
                _local_3++;
            }
            return true;
        }

        function extractTopWall(k:Point, _arg_2:Bool):Point
        {
            if (k == null)
            {
                return null;
            }
            var _local_3= 1;
            var _local_4= TILE_HOLE;
            if (!_arg_2)
            {
                _local_4 = TILE_BLOCKED;
            }
            while (_local_3 < 1000)
            {
                if (this.getTileHeightInternal(Std.int(k.x + _local_3), Std.int(k.y)) > _local_4)
                {
                    return new Point(((k.x + _local_3) - 1), k.y);
                }
                if (this.getTileHeightInternal(Std.int(k.x + _local_3), Std.int(k.y + 1)) <= _local_4)
                {
                    return new Point((k.x + _local_3), (k.y + 1));
                }
                _local_3++;
            }
            return null;
        }

        function extractRightWall(k:Point, _arg_2:Bool):Point
        {
            if (k == null)
            {
                return null;
            }
            var _local_3= 1;
            var _local_4= TILE_HOLE;
            if (!_arg_2)
            {
                _local_4 = TILE_BLOCKED;
            }
            while (_local_3 < 1000)
            {
                if (this.getTileHeightInternal(Std.int(k.x), Std.int(k.y + _local_3)) > _local_4)
                {
                    return new Point(k.x, (k.y + (_local_3 - 1)));
                }
                if (this.getTileHeightInternal(Std.int(k.x - 1), Std.int(k.y + _local_3)) <= _local_4)
                {
                    return new Point((k.x - 1), (k.y + _local_3));
                }
                _local_3++;
            }
            return null;
        }

        function extractBottomWall(k:Point, _arg_2:Bool):Point
        {
            if (k == null)
            {
                return null;
            }
            var _local_3= 1;
            var _local_4= TILE_HOLE;
            if (!_arg_2)
            {
                _local_4 = TILE_BLOCKED;
            }
            while (_local_3 < 1000)
            {
                if (this.getTileHeightInternal(Std.int(k.x - _local_3), Std.int(k.y)) > _local_4)
                {
                    return new Point((k.x - (_local_3 - 1)), k.y);
                }
                if (this.getTileHeightInternal(Std.int(k.x - _local_3), Std.int(k.y - 1)) <= _local_4)
                {
                    return new Point((k.x - _local_3), (k.y - 1));
                }
                _local_3++;
            }
            return null;
        }

        function extractLeftWall(k:Point, _arg_2:Bool):Point
        {
            if (k == null)
            {
                return null;
            }
            var _local_3= 1;
            var _local_4= TILE_HOLE;
            if (!_arg_2)
            {
                _local_4 = TILE_BLOCKED;
            }
            while (_local_3 < 1000)
            {
                if (this.getTileHeightInternal(Std.int(k.x), Std.int(k.y - _local_3)) > _local_4)
                {
                    return new Point(k.x, (k.y - (_local_3 - 1)));
                }
                if (this.getTileHeightInternal(Std.int(k.x + 1), Std.int(k.y - _local_3)) <= _local_4)
                {
                    return new Point((k.x + 1), (k.y - _local_3));
                }
                _local_3++;
            }
            return null;
        }

        function _Str_17862(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool)
        {
            var _local_12:Vector3d = null;
            this._Str_3453(RoomPlaneData.PLANE_WALL, k, _arg_2, _arg_3, [_arg_4]);
            this._Str_3453(RoomPlaneData.PLANE_LANDSCAPE, k, _arg_2, _arg_3, [_arg_4]);
            var _local_8= (WALL_THICKNESS * this._wallThicknessMultiplier);
            var _local_9= (FLOOR_THICKNESS * this._floorThicknessMultiplier);
            var _local_10= Vector3d.crossProduct(_arg_2, _arg_3);
            var _local_11= Vector3d.product(_local_10, ((1 / _local_10.length) * -_local_8));
            this._Str_3453(RoomPlaneData.PLANE_WALL, Vector3d.sum(k, _arg_3), _arg_2, _local_11, [_local_10, _arg_4]);
            if (_arg_5)
            {
                this._Str_3453(RoomPlaneData.PLANE_WALL, Vector3d.sum(Vector3d.sum(k, _arg_2), _arg_3), Vector3d.product(_arg_3, (-(_arg_3.length + _local_9) / _arg_3.length)), _local_11, [_local_10, _arg_4]);
            }
            if (_arg_6)
            {
                this._Str_3453(RoomPlaneData.PLANE_WALL, Vector3d.sum(k, Vector3d.product(_arg_3, (-_local_9 / _arg_3.length))), Vector3d.product(_arg_3, ((_arg_3.length + _local_9) / _arg_3.length)), _local_11, [_local_10, _arg_4]);
                if (_arg_7)
                {
                    _local_12 = Vector3d.product(_arg_2, (_local_8 / _arg_2.length));
                    this._Str_3453(RoomPlaneData.PLANE_WALL, Vector3d.sum(Vector3d.sum(k, _arg_3), Vector3d.product(_local_12, -1)), _local_12, _local_11, [_local_10, _arg_2, _arg_4]);
                }
            }
        }

        function addFloor(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool, _arg_8:Bool=false)
        {
            var _local_9 = Math.NaN;
            var _local_10:Vector3d = null;
            var _local_11:Vector3d = null;
            var _local_8= this._Str_3453(RoomPlaneData.PLANE_FLOOR, k, _arg_2, _arg_3, null, _arg_8);
            if (_local_8 != null)
            {
                _local_9 = (FLOOR_THICKNESS * this._floorThicknessMultiplier);
                _local_10 = new Vector3d(0, 0, _local_9);
                _local_11 = Vector3d.dif(k, _local_10);
                if (_arg_6)
                {
                    this._Str_3453(RoomPlaneData.PLANE_FLOOR, _local_11, _arg_2, _local_10);
                }
                if (_arg_7)
                {
                    this._Str_3453(RoomPlaneData.PLANE_FLOOR, Vector3d.sum(_local_11, Vector3d.sum(_arg_2, _arg_3)), Vector3d.product(_arg_2, -1), _local_10);
                }
                if (_arg_4)
                {
                    this._Str_3453(RoomPlaneData.PLANE_FLOOR, Vector3d.sum(_local_11, _arg_3), Vector3d.product(_arg_3, -1), _local_10);
                }
                if (_arg_5)
                {
                    this._Str_3453(RoomPlaneData.PLANE_FLOOR, Vector3d.sum(_local_11, _arg_2), _arg_3, _local_10);
                }
            }
        }

        public function initializeFromXML(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:com.sulake.core.utils.xml.XMLList = null;
            var _local_10 = 0;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12 = Math.NaN;
            var _local_13:com.sulake.core.utils.xml.XML = null;
            var _local_14:com.sulake.core.utils.xml.XMLList = null;
            var _local_15 = 0;
            var _local_16:com.sulake.core.utils.xml.XML = null;
            if (k == null)
            {
                return false;
            }
            this.reset();
            this.resetFloorHoles();
            if (!XMLValidator.checkRequiredAttributes(k.child("tileMap").at(0), ["width", "height", "wallHeight"]))
            {
                return false;
            }
            var _local_2= ASCompat.parseInt(k.child("tileMap").attribute("width").toString());
            var _local_3= ASCompat.parseInt(k.child("tileMap").attribute("height").toString());
            var _local_4= Std.parseFloat(k.child("tileMap").attribute("wallHeight").toString());
            var _local_5= ASCompat.parseInt(k.child("tileMap").attribute("fixedWallsHeight").toString());
            this.initializeTileMap(_local_2, _local_3);
            var _local_6= k.child("tileMap").child("tileRow");
            var _local_7 = 0;
            while (_local_7 < _local_6.length())
            {
                _local_8 = _local_6.at(_local_7);
                _local_9 = _local_8.child("tile");
                _local_10 = 0;
                while (_local_10 < _local_9.length())
                {
                    _local_11 = _local_9.at(_local_10);
                    _local_12 = Std.parseFloat(_local_11.attribute("height").toString());
                    this._Str_3982(_local_10, _local_7, _local_12);
                    _local_10++;
                }
                _local_7++;
            }
            if (k.child("holeMap").length() > 0)
            {
                _local_13 = k.child("holeMap").at(0);
                _local_14 = _local_13.child("hole");
                _local_15 = 0;
                while (_local_15 < _local_14.length())
                {
                    _local_16 = _local_14.at(_local_15);
                    if (XMLValidator.checkRequiredAttributes(_local_16, ["id", "x", "y", "width", "height"]))
                    {
                        this.addFloorHole(ASCompat.toInt(_local_16.attribute("id")), ASCompat.toInt(_local_16.attribute("x")), ASCompat.toInt(_local_16.attribute("y")), ASCompat.toInt(_local_16.attribute("width")), ASCompat.toInt(_local_16.attribute("height")), (_local_16.hasOwnProperty("@invert") && _local_16.attribute("invert").toString() == "true"));
                    }
                    _local_15++;
                }
                this.initializeHoleMap();
            }
            this.wallHeight = _local_4;
            this.initializeFromTileData(_local_5);
            return true;
        }

        function _Str_3453(k:Int, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Array<ASAny>=null, _arg_6:Bool=false):RoomPlaneData
        {
            if (((_arg_3.length == 0) || (_arg_4.length == 0)))
            {
                return null;
            }
            var _local_6= new RoomPlaneData(k, _arg_2, _arg_3, _arg_4, _arg_5);
            this._planes.push(_local_6);
            if (_arg_6)
            {
                this._temporaryHighlightPlanes.push(_local_6);
            }
            return _local_6;
        }

        public function initializeHighlightArea(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            this.clearHighlightArea();
            if (this._expandedFloorTiles == null)
            {
                return;
            }
            this.extractPlanes(this._expandedFloorTiles, (k * 4), (_arg_2 * 4), (_arg_3 * 4), (_arg_4 * 4), true);
        }

        public function clearHighlightArea():Int
        {
            var _local_1= this._temporaryHighlightPlanes.length;
            this._planes = this._planes.slice(0, (this._planes.length - this._temporaryHighlightPlanes.length));
            this._temporaryHighlightPlanes.resize(0);
            return _local_1;
        }

        public function isPlaneTemporaryHighlighter(k:Int):Bool
        {
            if ((k < 0) || (k >= this._Str_3828))
            {
                return false;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 == null)
            {
                return false;
            }
            return this._temporaryHighlightPlanes.indexOf(_local_2) != -1;
        }

        public function getXML():com.sulake.core.utils.xml.XML
        {
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:Array<ASAny> = null;
            var _local_9 = 0;
            var _local_10 = Math.NaN;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12:RoomFloorHole = null;
            var _local_13 = 0;
            var _local_14:com.sulake.core.utils.xml.XML = null;
            var k:com.sulake.core.utils.xml.XML = Type.createInstance(com.sulake.core.utils.xml.XML, [(((((((('<tileMap width="' + Std.string(this._width)) + '" height="') + Std.string(this._height)) + '" wallHeight="') + Std.string(this._wallHeight)) + '" fixedWallsHeight="') + Std.string(this._fixedWallHeight)) + '"/>')]);
            var _local_2 = 0;
            while (_local_2 < this._height)
            {
                _local_7 = new com.sulake.core.utils.xml.XML("<tileRow/>")
                ;
                _local_8 = this._tileMatrixOriginal[_local_2];
                _local_9 = 0;
                while (_local_9 < this._width)
                {
                    _local_10 = ASCompat.toNumber(_local_8[_local_9]);
                    _local_11 = Type.createInstance(com.sulake.core.utils.xml.XML, [(('<tile height="' + Std.string(_local_10)) + '"/>')]);
                    _local_7.appendChild(_local_11);
                    _local_9++;
                }
                k.appendChild(_local_7);
                _local_2++;
            }
            var _local_3= new com.sulake.core.utils.xml.XML("<holeMap/>")
            ;
            var _local_4 = 0;
            while ((_local_4 : UInt) < this._floorHoles.length)
            {
                _local_12 = this._floorHoles.getWithIndex(_local_4);
                if (_local_12 != null)
                {
                    _local_13 = ASCompat.toInt(this._floorHoles.getKey(_local_4));
                    _local_14 = new com.sulake.core.utils.xml.XML(("<hole id=\"" + Std.string(_local_13) + "\" x=\"" + Std.string(_local_12.x) + "\" y=\"" + Std.string(_local_12.y) + "\" width=\"" + Std.string(_local_12.width) + "\" height=\"" + Std.string(_local_12.height) + "\" invert=\"false\"/>"));
                    _local_3.appendChild(_local_14);
                }
                _local_4++;
            }
            _local_4 = 0;
            while ((_local_4 : UInt) < this._invertedFloorHoles.length)
            {
                _local_12 = this._invertedFloorHoles.getWithIndex(_local_4);
                if (_local_12 != null)
                {
                    _local_13 = ASCompat.toInt(this._invertedFloorHoles.getKey(_local_4));
                    _local_14 = new com.sulake.core.utils.xml.XML(("<hole id=\"" + Std.string(_local_13) + "\" x=\"" + Std.string(_local_12.x) + "\" y=\"" + Std.string(_local_12.y) + "\" width=\"" + Std.string(_local_12.width) + "\" height=\"" + Std.string(_local_12.height) + "\" invert=\"true\"/>"));
                    _local_3.appendChild(_local_14);
                }
                _local_4++;
            }
            var _local_5= new com.sulake.core.utils.xml.XML("<roomData/>")
            ;
            _local_5.appendChild(k);
            _local_5.appendChild(_local_3);
            var _local_6:com.sulake.core.utils.xml.XML = Type.createInstance(com.sulake.core.utils.xml.XML, [(((((((('<dimensions minX="' + Std.string(this.minX)) + '" maxX="') + Std.string(this.maxX)) + '" minY="') + Std.string(this.minY)) + '" maxY="') + Std.string(this.maxY)) + '"/>')]);
            _local_5.appendChild(_local_6);
            return _local_5;
        }

        public function getPlaneLocation(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.loc;
            }
            return null;
        }

        public function getPlaneNormal(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.normal;
            }
            return null;
        }

        public function getPlaneLeftSide(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.leftSide;
            }
            return null;
        }

        public function getPlaneRightSide(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.rightSide;
            }
            return null;
        }

        public function getPlaneNormalDirection(k:Int):IVector3d
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.normalDirection;
            }
            return null;
        }

        public function getPlaneSecondaryNormals(k:Int):Array<ASAny>
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                _local_3 = [];
                _local_4 = 0;
                while (_local_4 < _local_2.secondaryNormalCount)
                {
                    _local_3.push(_local_2.getSecondaryNormal(_local_4));
                    _local_4++;
                }
                return _local_3;
            }
            return null;
        }

        public function getPlaneType(k:Int):Int
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return RoomPlaneData.PLANE_UNDEFINED;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.type;
            }
            return RoomPlaneData.PLANE_UNDEFINED;
        }

        public function getPlaneMaskCount(k:Int):Int
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return 0;
            }
            var _local_2= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_2 != null)
            {
                return _local_2.maskCount;
            }
            return 0;
        }

        public function getPlaneMaskLeftSideLoc(k:Int, _arg_2:Int):Float
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return -1;
            }
            var _local_3= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_3 != null)
            {
                return _local_3.getMaskLeftSideLoc(_arg_2);
            }
            return -1;
        }

        public function getPlaneMaskRightSideLoc(k:Int, _arg_2:Int):Float
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return -1;
            }
            var _local_3= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_3 != null)
            {
                return _local_3.getMaskRightSideLoc(_arg_2);
            }
            return -1;
        }

        public function getPlaneMaskLeftSideLength(k:Int, _arg_2:Int):Float
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return -1;
            }
            var _local_3= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_3 != null)
            {
                return _local_3.getMaskLeftSideLength(_arg_2);
            }
            return -1;
        }

        public function getPlaneMaskRightSideLength(k:Int, _arg_2:Int):Float
        {
            if (((k < 0) || (k >= this._Str_3828)))
            {
                return -1;
            }
            var _local_3= ASCompat.dynamicAs(this._planes[k] , RoomPlaneData);
            if (_local_3 != null)
            {
                return _local_3.getMaskRightSideLength(_arg_2);
            }
            return -1;
        }

        public function addFloorHole(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Bool=false)
        {
            this.removeFloorHole(k);
            var _local_6= new RoomFloorHole(_arg_2, _arg_3, _arg_4, _arg_5);
            if (_arg_6)
            {
                this._invertedFloorHoles.add(k, _local_6);
            }
            else
            {
                this._floorHoles.add(k, _local_6);
            }
        }

        public function removeFloorHole(k:Int)
        {
            this._floorHoles.remove(k);
            this._invertedFloorHoles.remove(k);
        }

        public function resetFloorHoles()
        {
            this._floorHoles.reset();
            this._invertedFloorHoles.reset();
        }

        function initializeHoleMap()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3:Array<ASAny> = null;
            var _local_5:RoomFloorHole = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10= this._invertedFloorHoles.length > 0;
            _local_2 = 0;
            while (_local_2 < this._height)
            {
                _local_3 = this._floorHoleMatrix[_local_2];
                k = 0;
                while (k < this._width)
                {
                    _local_3[k] = _local_10;
                    k++;
                }
                _local_2++;
            }
            var _local_4 = 0;
            while ((_local_4 : UInt) < this._invertedFloorHoles.length)
            {
                _local_5 = this._invertedFloorHoles.getWithIndex(_local_4);
                if (_local_5 != null)
                {
                    this.initializeHole(_local_5, true);
                }
                _local_4++;
            }
            _local_4 = 0;
            while ((_local_4 : UInt) < this._floorHoles.length)
            {
                _local_5 = this._floorHoles.getWithIndex(_local_4);
                if (_local_5 != null)
                {
                    this.initializeHole(_local_5);
                }
                _local_4++;
            }
        }

        function initializeHole(k:RoomFloorHole, _arg_2:Bool=false)
        {
            var _local_3= Std.int(Math.max(0, k.x));
            var _local_4= Std.int(Math.min((this._width - 1), ((k.x + k.width) - 1)));
            var _local_5= Std.int(Math.max(0, k.y));
            var _local_6= Std.int(Math.min((this._height - 1), ((k.y + k.height) - 1)));
            var _local_7= _local_5;
            var _local_8 = 0;
            var _local_9:Array<ASAny> = null;
            while (_local_7 <= _local_6)
            {
                _local_9 = this._floorHoleMatrix[_local_7];
                _local_8 = _local_3;
                while (_local_8 <= _local_4)
                {
                    _local_9[_local_8] = !_arg_2;
                    _local_8++;
                }
                _local_7++;
            }
        }

        function extractPlanes(k:Vector<Vector<Int>>, _arg_2:Int=0, _arg_3:Int=0, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Bool=false)
        {
            var _local_2:UInt = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = false;
            var _local_12 = false;
            var _local_13 = false;
            var _local_14 = false;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17 = false;
            var _local_18 = Math.NaN;
            var _local_19 = Math.NaN;
            var _local_20 = Math.NaN;
            var _local_21 = Math.NaN;
            _local_2 = k.length;
            var _local_3:UInt = k[0].length;
            var _local_22= ASCompat.toUInt((_arg_5 == -1) ? _local_2 : Math.min(_local_2, (_arg_3 + _arg_5)));
            var _local_23= ASCompat.toUInt((_arg_4 == -1) ? _local_3 : Math.min(_local_3, (_arg_2 + _arg_4)));
            var _local_4= new Vector<Vector<Bool>>(_local_22);
            var _local_5 = 0;
            while ((_local_5 : UInt) < _local_22)
            {
                _local_4[_local_5] = new Vector<Bool>(_local_23);
                _local_5++;
            }
            var _local_6= _arg_3;
            while ((_local_6 : UInt) < _local_22)
            {
                _local_7 = _arg_2;
                while ((_local_7 : UInt) < _local_23)
                {
                    _local_8 = k[_local_6][_local_7];
                    if (((_local_8 < 0) || _local_4[_local_6][_local_7]))
                    {
                    }
                    else
                    {
                        _local_11 = ((_local_7 == 0) || (!(k[_local_6][(_local_7 - 1)] == _local_8)));
                        _local_12 = ((_local_6 == 0) || (!(k[(_local_6 - 1)][_local_7] == _local_8)));
                        _local_9 = (_local_7 + 1);
                        while ((_local_9 : UInt) < _local_23)
                        {
                            if ((((!(k[_local_6][_local_9] == _local_8)) || _local_4[_local_6][_local_9]) || ((_local_6 > 0) && ((k[(_local_6 - 1)][_local_9] == _local_8) == _local_12))))
                            {
                                break;
                            }
                            _local_9++;
                        }
                        _local_13 = (((_local_9 : UInt) == _local_3) || (!(k[_local_6][_local_9] == _local_8)));
                        _local_17 = false;
                        _local_10 = (_local_6 + 1);
                        while ((((_local_10 : UInt) <= _local_22) && (!_local_17)))
                        {
                            _local_14 = (((_local_10 : UInt) == _local_2) || (!(k[_local_10][_local_7] == _local_8)));
                            _local_17 = (((((_local_10 : UInt) == _local_22) || _local_14) || ((_local_7 > 0) && ((k[_local_10][(_local_7 - 1)] == _local_8) == _local_11))) || (((_local_9 : UInt) < _local_3) && ((k[_local_10][_local_9] == _local_8) == _local_13)));
                            if ((_local_10 : UInt) == _local_2)
                            {
                                break;
                            }
                            _local_15 = _local_7;
                            while (_local_15 < _local_9)
                            {
                                if ((k[_local_10][_local_15] == _local_8) == _local_14)
                                {
                                    _local_17 = true;
                                    _local_9 = _local_15;
                                    break;
                                }
                                _local_15++;
                            }
                            if (_local_17)
                            {
                                break;
                            }
                            _local_10++;
                        }
                        if (!_local_14)
                        {
                            _local_14 = ((_local_10 : UInt) == _local_2);
                        }
                        _local_13 = (((_local_9 : UInt) == _local_3) || (!(k[_local_6][_local_9] == _local_8)));
                        _local_16 = _local_6;
                        while (_local_16 < _local_10)
                        {
                            _local_15 = _local_7;
                            while (_local_15 < _local_9)
                            {
                                _local_4[_local_16][_local_15] = true;
                                _local_15++;
                            }
                            _local_16++;
                        }
                        _local_18 = ((_local_7 / 4) - 0.5);
                        _local_19 = ((_local_6 / 4) - 0.5);
                        _local_20 = ((_local_9 - _local_7) / 4);
                        _local_21 = ((_local_10 - _local_6) / 4);
                        this.addFloor(new Vector3d((_local_18 + _local_20), (_local_19 + _local_21), (_local_8 / 4)), new Vector3d(-_local_20, 0, 0), new Vector3d(0, -_local_21, 0), _local_13, _local_11, _local_14, _local_12, _arg_6);
                    }
                    _local_7++;
                }
                _local_6++;
            }
        }
    }

