package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;
    import flash.geom.Point;

     class PlaneMaterialCellColumn 
    {
        public static inline final REPEAT_MODE_NONE= 0;
        public static inline final REPEAT_MODE_ALL= 1;
        public static inline final REPEAT_MODE_BORDERS= 2;
        public static inline final REPEAT_MODE_CENTER= 3;
        public static inline final REPEAT_MODE_FIRST= 4;
        public static inline final REPEAT_MODE_LAST= 5;

        var _cells:Array<ASAny>;
        var _repeatMode:Int = 1;
        var _width:Int = 1;
        var _cachedBitmapData:BitmapData;
        var _cachedBitmapNormal:Vector3d = null;
        var _cachedBitmapDataOffsetX:Int = 0;
        var _cachedBitmapDataOffsetY:Int = 0;
        var _isCached:Bool = false;
        var _isStatic:Bool = true;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:Int=1)
        {
            var _local_4:Int;
            var _local_5:PlaneMaterialCell;
            this._cells = [];
            if (k < 1)
            {
                k = 1;
            }
            this._width = k;
            if (_arg_2 != null)
            {
                _local_4 = 0;
                while (_local_4 < _arg_2.length)
                {
                    _local_5 = ASCompat.dynamicAs(_arg_2[_local_4] , PlaneMaterialCell);
                    if (_local_5 != null)
                    {
                        this._cells.push(_local_5);
                        if (!_local_5.isStatic)
                        {
                            this._isStatic = false;
                        }
                    }
                    _local_4++;
                }
            }
            this._repeatMode = _arg_3;
        }

        public var isStatic(get,never):Bool;
function  get_isStatic():Bool
        {
            return this._isStatic;
        }

        public function _Str_24523():Bool
        {
            return !(this._repeatMode == REPEAT_MODE_NONE);
        }

        public var width(get,never):Int;
function  get_width():Int
        {
            return this._width;
        }

        public function dispose()
        {
            var k:Int;
            var _local_2:PlaneMaterialCell;
            if (this._cells != null)
            {
                k = 0;
                while (k < this._cells.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._cells[k] , PlaneMaterialCell);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._cells = null;
            }
            if (this._cachedBitmapData != null)
            {
                this._cachedBitmapData.dispose();
                this._cachedBitmapData = null;
            }
            if (this._cachedBitmapNormal != null)
            {
                this._cachedBitmapNormal = null;
            }
        }

        public function clearCache()
        {
            var k:Int;
            var _local_2:PlaneMaterialCell;
            if (!this._isCached)
            {
                return;
            }
            if (this._cachedBitmapData != null)
            {
                this._cachedBitmapData.dispose();
                this._cachedBitmapData = null;
            }
            if (this._cachedBitmapNormal != null)
            {
                this._cachedBitmapNormal.x = 0;
                this._cachedBitmapNormal.y = 0;
                this._cachedBitmapNormal.z = 0;
            }
            if (this._cells != null)
            {
                k = 0;
                while (k < this._cells.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._cells[k] , PlaneMaterialCell);
                    if (_local_2 != null)
                    {
                        _local_2.clearCache();
                    }
                    k++;
                }
            }
            this._isCached = false;
        }

        public function render(height:Int, normal:IVector3d, offsetX:Int, offsetY:Int):BitmapData
        {
            var ht:Int;
            if (this._repeatMode == REPEAT_MODE_NONE)
            {
                ht = this.getCellsHeight(this._cells, normal);
                height = ht;
            }
            if (this._cachedBitmapNormal == null)
            {
                this._cachedBitmapNormal = new Vector3d();
            }
            if (this.isStatic)
            {
                if (this._cachedBitmapData != null)
                {
                    if (((((this._cachedBitmapData.height == height) && Vector3d.isEqual(this._cachedBitmapNormal, normal)) && (this._cachedBitmapDataOffsetX == offsetX)) && (this._cachedBitmapDataOffsetY == offsetY)))
                    {
                        return this._cachedBitmapData;
                    }
                    this._cachedBitmapData.dispose();
                    this._cachedBitmapData = null;
                }
            }
            else
            {
                if (this._cachedBitmapData != null)
                {
                    if (this._cachedBitmapData.height == height)
                    {
                        this._cachedBitmapData.fillRect(this._cachedBitmapData.rect, 0xFFFFFF);
                    }
                    else
                    {
                        this._cachedBitmapData.dispose();
                        this._cachedBitmapData = null;
                    }
                }
            }
            this._isCached = true;
            if (this._cachedBitmapData == null)
            {
                try
                {
                    this._cachedBitmapData = new BitmapData(this._width, height, true, 0xFFFFFF);
                }
                catch(e:ASError)
                {
                    return null;
                }
            }
            this._cachedBitmapNormal.assign(normal);
            this._cachedBitmapDataOffsetX = offsetX;
            this._cachedBitmapDataOffsetY = offsetY;
            if (this._cells.length == 0)
            {
                return this._cachedBitmapData;
            }
            switch (this._repeatMode)
            {
                case REPEAT_MODE_NONE:
                    this.renderRepeatNone(normal);
                    
                case REPEAT_MODE_BORDERS:
                    this._Str_18476(normal);
                    
                case REPEAT_MODE_CENTER:
                    this._Str_17295(normal);
                    
                case REPEAT_MODE_FIRST:
                    this._Str_18019(normal);
                    
                case REPEAT_MODE_LAST:
                    this._Str_16099(normal);
                    
                default:
                    this._Str_18711(normal, offsetX, offsetY);
            }
            return this._cachedBitmapData;
        }

        function getCellsHeight(k:Array<ASAny>, _arg_2:IVector3d):Int
        {
            var _local_5:PlaneMaterialCell;
            var _local_6:Int;
            if (((k == null) || (k.length == 0)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4 = 0;
            while (_local_4 < k.length)
            {
                _local_5 = ASCompat.dynamicAs(k[_local_4] , PlaneMaterialCell);
                if (_local_5 != null)
                {
                    _local_6 = _local_5.getHeight(_arg_2);
                    _local_3 = (_local_3 + _local_6);
                }
                _local_4++;
            }
            return _local_3;
        }

        function renderCells(k:Array<ASAny>, _arg_2:Int, _arg_3:Bool, _arg_4:IVector3d, _arg_5:Int=0, _arg_6:Int=0):Int
        {
            if ((((k == null) || (k.length == 0)) || (this._cachedBitmapData == null)))
            {
                return _arg_2;
            }
            var _local_7:PlaneMaterialCell;
            var _local_8:BitmapData;
            var _local_9 = 0;
            while (_local_9 < k.length)
            {
                if (_arg_3)
                {
                    _local_7 = ASCompat.dynamicAs(k[_local_9] , PlaneMaterialCell);
                }
                else
                {
                    _local_7 = ASCompat.dynamicAs(k[((k.length - 1) - _local_9)] , PlaneMaterialCell);
                }
                if (_local_7 != null)
                {
                    _local_8 = _local_7.render(_arg_4, _arg_5, _arg_6);
                    if (_local_8 != null)
                    {
                        if (!_arg_3)
                        {
                            _arg_2 = (_arg_2 - _local_8.height);
                        }
                        this._cachedBitmapData.copyPixels(_local_8, _local_8.rect, new Point(0, _arg_2), _local_8, null, true);
                        if (_arg_3)
                        {
                            _arg_2 = (_arg_2 + _local_8.height);
                        }
                        if (((_arg_3 && (_arg_2 >= this._cachedBitmapData.height)) || ((!_arg_3) && (_arg_2 <= 0))))
                        {
                            return _arg_2;
                        }
                    }
                }
                _local_9++;
            }
            return _arg_2;
        }

        function renderRepeatNone(k:IVector3d)
        {
            if (((this._cells.length == 0) || (this._cachedBitmapData == null)))
            {
                return;
            }
            this.renderCells(this._cells, 0, true, k);
        }

        function _Str_18711(k:IVector3d, _arg_2:Int, _arg_3:Int)
        {
            if (((this._cells.length == 0) || (this._cachedBitmapData == null)))
            {
                return;
            }
            var _local_4= this.getCellsHeight(this._cells, k);
            var _local_5 = 0;
            if (_local_4 > this._cachedBitmapData.height)
            {
            }
            while (_local_5 < this._cachedBitmapData.height)
            {
                _local_5 = this.renderCells(this._cells, _local_5, true, k, _arg_2, _arg_3);
                if (_local_5 == 0)
                {
                    return;
                }
            }
        }

        function _Str_18476(k:IVector3d)
        {
            if (((this._cells.length == 0) || (this._cachedBitmapData == null)))
            {
                return;
            }
            var _local_2:PlaneMaterialCell;
            var _local_3:BitmapData;
            var _local_4:Array<ASAny> = [];
            var _local_5 = 0;
            var _local_6:Int;
            var _local_7:Int;
            _local_7 = 1;
            while (_local_7 < (this._cells.length - 1))
            {
                _local_2 = ASCompat.dynamicAs(this._cells[_local_7] , PlaneMaterialCell);
                if (_local_2 != null)
                {
                    _local_6 = _local_2.getHeight(k);
                    if (_local_6 > 0)
                    {
                        _local_5 = (_local_5 + _local_6);
                        _local_4.push(_local_2);
                    }
                }
                _local_7++;
            }
            if (this._cells.length == 1)
            {
                _local_2 = ASCompat.dynamicAs(this._cells[0] , PlaneMaterialCell);
                if (_local_2 != null)
                {
                    _local_6 = _local_2.getHeight(k);
                    if (_local_6 > 0)
                    {
                        _local_5 = (_local_5 + _local_6);
                        _local_4.push(_local_2);
                    }
                }
            }
            var _local_8:ASAny = ((this._cachedBitmapData.height - _local_5) >> 1);
            var _local_9= this.renderCells(_local_4, ASCompat.toInt(_local_8), true, k);
            _local_2 = ASCompat.dynamicAs(this._cells[0] , PlaneMaterialCell);
            if (_local_2 != null)
            {
                _local_4 = [_local_2];
                while (_local_8 >= 0)
                {
                    _local_8 = this.renderCells(_local_4, ASCompat.toInt(_local_8), false, k);
                }
            }
            _local_2 = ASCompat.dynamicAs(this._cells[(this._cells.length - 1)] , PlaneMaterialCell);
            if (_local_2 != null)
            {
                _local_4 = [_local_2];
                while (_local_9 < this._cachedBitmapData.height)
                {
                    _local_9 = this.renderCells(_local_4, _local_9, true, k);
                }
            }
        }

        function _Str_17295(k:IVector3d)
        {
            var _local_13:Int;
            var _local_14:Int;
            var _local_15:Int;
            var _local_16:Array<ASAny>;
            if (((this._cells.length == 0) || (this._cachedBitmapData == null)))
            {
                return;
            }
            var _local_2:PlaneMaterialCell;
            var _local_3:BitmapData;
            var _local_4:Array<ASAny> = [];
            var _local_5:Array<ASAny> = [];
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:Int;
            var _local_9:Int;
            _local_9 = 0;
            while (_local_9 < (this._cells.length >> 1))
            {
                _local_2 = ASCompat.dynamicAs(this._cells[_local_9] , PlaneMaterialCell);
                if (_local_2 != null)
                {
                    _local_8 = _local_2.getHeight(k);
                    if (_local_8 > 0)
                    {
                        _local_6 = (_local_6 + _local_8);
                        _local_4.push(_local_2);
                    }
                }
                _local_9++;
            }
            _local_9 = ((this._cells.length >> 1) + 1);
            while (_local_9 < this._cells.length)
            {
                _local_2 = ASCompat.dynamicAs(this._cells[_local_9] , PlaneMaterialCell);
                if (_local_2 != null)
                {
                    _local_8 = _local_2.getHeight(k);
                    if (_local_8 > 0)
                    {
                        _local_7 = (_local_7 + _local_8);
                        _local_5.push(_local_2);
                    }
                }
                _local_9++;
            }
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12= this._cachedBitmapData.height;
            if ((_local_6 + _local_7) > this._cachedBitmapData.height)
            {
                _local_10 = ((_local_6 + _local_7) - this._cachedBitmapData.height);
                _local_11 = (_local_11 - (_local_10 >> 1));
                _local_12 = (_local_12 + (_local_10 - (_local_10 >> 1)));
            }
            if (_local_10 == 0)
            {
                _local_2 = ASCompat.dynamicAs(this._cells[(this._cells.length >> 1)] , PlaneMaterialCell);
                if (_local_2 != null)
                {
                    _local_8 = _local_2.getHeight(k);
                    if (_local_8 > 0)
                    {
                        _local_13 = (this._cachedBitmapData.height - (_local_6 + _local_7));
                        _local_14 = Std.int(Math.fceil((_local_13 / _local_8)) * _local_8);
                        _local_11 = (_local_6 - ((_local_14 - _local_13) >> 1));
                        _local_15 = (_local_11 + _local_14);
                        _local_16 = [_local_2];
                        while (_local_11 < _local_15)
                        {
                            _local_11 = this.renderCells(_local_16, _local_11, true, k);
                        }
                    }
                }
            }
            _local_11 = 0;
            this.renderCells(_local_4, _local_11, true, k);
            this.renderCells(_local_5, _local_12, false, k);
        }

        function _Str_18019(k:IVector3d)
        {
            var _local_4:Array<ASAny>;
            if (((this._cells.length == 0) || (this._cachedBitmapData == null)))
            {
                return;
            }
            var _local_2:PlaneMaterialCell;
            var _local_3= this._cachedBitmapData.height;
            _local_3 = this.renderCells(this._cells, _local_3, false, k);
            _local_2 = ASCompat.dynamicAs(this._cells[0] , PlaneMaterialCell);
            if (_local_2 != null)
            {
                _local_4 = [_local_2];
                while (_local_3 >= 0)
                {
                    _local_3 = this.renderCells(_local_4, _local_3, false, k);
                }
            }
        }

        function _Str_16099(k:IVector3d)
        {
            var _local_4:Array<ASAny>;
            if (((this._cells.length == 0) || (this._cachedBitmapData == null)))
            {
                return;
            }
            var _local_2:PlaneMaterialCell;
            var _local_3 = 0;
            _local_3 = this.renderCells(this._cells, _local_3, true, k);
            _local_2 = ASCompat.dynamicAs(this._cells[(this._cells.length - 1)] , PlaneMaterialCell);
            if (_local_2 != null)
            {
                _local_4 = [_local_2];
                while (_local_3 < this._cachedBitmapData.height)
                {
                    _local_3 = this.renderCells(_local_4, _local_3, true, k);
                }
            }
        }

        public function _Str_22299():Array<ASAny>
        {
            return this._cells;
        }
    }

