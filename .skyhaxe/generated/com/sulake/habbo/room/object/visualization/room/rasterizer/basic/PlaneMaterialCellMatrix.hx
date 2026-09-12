package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.object.visualization.room.utils.Randomizer;
    import com.sulake.room.utils.IVector3d;
    import flash.geom.Rectangle;
    import flash.geom.Point;

     class PlaneMaterialCellMatrix 
    {
        public static inline final REPEAT_MODE_ALL= 1;
        public static inline final REPEAT_MODE_BORDERS= 2;
        public static inline final REPEAT_MODE_CENTER= 3;
        public static inline final REPEAT_MODE_FIRST= 4;
        public static inline final REPEAT_MODE_LAST= 5;
        public static inline final REPEAT_MODE_RANDOM= 6;
        public static final REPEAT_MODE_DEFAULT:Int = REPEAT_MODE_ALL;//1
        public static inline final MIN_NORMAL_COORDINATE_VALUE:Float = -1;
        public static inline final MAX_NORMAL_COORDINATE_VALUE:Float = 1;
        public static inline final ALIGN_TOP= 1;
        public static inline final ALIGN_BOTTOM= 2;
        public static final ALIGN_DEFAULT:Int = ALIGN_TOP;//1

        var _columns:Array<ASAny>;
        var _repeatMode:Int = 1;
        var _align:Int = 1;
        var _cachedBitmapData:BitmapData;
        var _cachedBitmapNormal:Vector3d = null;
        var _cachedBitmapHeight:Int = 0;
        var _isCached:Bool = false;
        var _isStatic:Bool = true;
        var _normalMinX:Float = -1;
        var _normalMaxX:Float = 1;
        var _normalMinY:Float = -1;
        var _normalMaxY:Float = 1;

        public function new(k:Int, _arg_2:Int=1, _arg_3:Int=1, _arg_4:Float=-1, _arg_5:Float=1, _arg_6:Float=-1, _arg_7:Float=1)
        {
            this._columns = [];
            if (k < 1)
            {
                k = 1;
            }
            var _local_8 = 0;
            while (_local_8 < k)
            {
                this._columns.push(null);
                _local_8++;
            }
            this._repeatMode = _arg_2;
            this._align = _arg_3;
            this._normalMinX = _arg_4;
            this._normalMaxX = _arg_5;
            this._normalMinY = _arg_6;
            this._normalMaxY = _arg_7;
            if (this._repeatMode == REPEAT_MODE_RANDOM)
            {
                this._isStatic = false;
            }
        }

        static function _Str_12526(k:Int):Int
        {
            var _local_2= Randomizer.getValues(1, 0, (k * 17631));
            return ASCompat.toInt(ASCompat.toNumber(_local_2[0]) % k);
        }


        public var normalMinX(get,never):Float;
public function  get_normalMinX():Float
        {
            return this._normalMinX;
        }

        public var normalMaxX(get,never):Float;
public function  get_normalMaxX():Float
        {
            return this._normalMaxX;
        }

        public var normalMinY(get,never):Float;
public function  get_normalMinY():Float
        {
            return this._normalMinY;
        }

        public var normalMaxY(get,never):Float;
public function  get_normalMaxY():Float
        {
            return this._normalMaxY;
        }

        public function _Str_14945():Bool
        {
            return this._align == ALIGN_BOTTOM;
        }

        public var isStatic(get,never):Bool;
public function  get_isStatic():Bool
        {
            return this._isStatic;
        }

        public function dispose()
        {
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
            var _local_2:PlaneMaterialCellColumn = null;
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
            this._cachedBitmapHeight = 0;
            var k = 0;
            while (k < this._columns.length)
            {
                _local_2 = ASCompat.dynamicAs(this._columns[k] , PlaneMaterialCellColumn);
                if (_local_2 != null)
                {
                    _local_2.clearCache();
                }
                k++;
            }
            this._isCached = false;
        }

        public function createColumn(k:Int, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Int=1):Bool
        {
            if (((k < 0) || (k >= this._columns.length)))
            {
                return false;
            }
            var _local_5= new PlaneMaterialCellColumn(_arg_2, _arg_3, _arg_4);
            var _local_6= ASCompat.dynamicAs(this._columns[k] , PlaneMaterialCellColumn);
            if (_local_6 != null)
            {
                _local_6.dispose();
            }
            this._columns[k] = _local_5;
            if (((!(_local_5 == null)) && (!_local_5.isStatic)))
            {
                this._isStatic = false;
            }
            return true;
        }

        public function render(canvas:BitmapData, width:Int, height:Int, normal:IVector3d, useTexture:Bool, offsetX:Int, offsetY:Int, topAlign:Bool):BitmapData
        {
            var column:PlaneMaterialCellColumn = null;
            var columnBitmapData:BitmapData = null;
            if (width < 1)
            {
                width = 1;
            }
            if (height < 1)
            {
                height = 1;
            }
            if ((((canvas == null) || (!(canvas.width == width))) || (!(canvas.height == height))))
            {
                canvas = null;
            }
            if (this._cachedBitmapNormal == null)
            {
                this._cachedBitmapNormal = new Vector3d();
            }
            if (this.isStatic)
            {
                if (this._cachedBitmapData != null)
                {
                    if ((((this._cachedBitmapData.width == width) && (this._cachedBitmapData.height == height)) && Vector3d.isEqual(this._cachedBitmapNormal, normal)))
                    {
                        if (canvas != null)
                        {
                            this.copyCachedBitmapOnCanvas(canvas, this._cachedBitmapHeight, offsetY, topAlign);
                            return canvas;
                        }
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
                    if (((this._cachedBitmapData.width == width) && (this._cachedBitmapData.height == height)))
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
            this._cachedBitmapNormal.assign(normal);
            if (!useTexture)
            {
                this._cachedBitmapHeight = height;
                if (this._cachedBitmapData == null)
                {
                    try
                    {
                        this._cachedBitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                        return null;
                    }
 }                }
                else
                {
                    this._cachedBitmapData.fillRect(this._cachedBitmapData.rect, 0xFFFFFFFF);
                }
                if (canvas != null)
                {
                    this.copyCachedBitmapOnCanvas(canvas, height, offsetY, topAlign);
                    return canvas;
                }
                return this._cachedBitmapData;
            }
            if (this._cachedBitmapData == null)
            {
                this._cachedBitmapHeight = height;
                try
                {
                    this._cachedBitmapData = new BitmapData(width, height, true, 0xFFFFFF);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    _cachedBitmapData = null;
                    return null;
                }
 }            }
            var columns:Array<ASAny> = [];
            var i = 0;
            while (i < this._columns.length)
            {
                column = ASCompat.dynamicAs(this._columns[i] , PlaneMaterialCellColumn);
                if (column != null)
                {
                    columnBitmapData = column.render(height, normal, offsetX, offsetY);
                    if (columnBitmapData != null)
                    {
                        columns.push(columnBitmapData);
                    }
                }
                i = (i + 1);
            }
            if (columns.length == 0)
            {
                if (canvas != null)
                {
                    return canvas;
                }
                return this._cachedBitmapData;
            }
            var maxColumnHeight = 0;
            switch (this._repeatMode)
            {
                case REPEAT_MODE_BORDERS:
                    maxColumnHeight = this._Str_18476(this._cachedBitmapData, columns);
                    
                case REPEAT_MODE_CENTER:
                    maxColumnHeight = this._Str_17295(this._cachedBitmapData, columns);
                    
                case REPEAT_MODE_FIRST:
                    maxColumnHeight = this._Str_18019(this._cachedBitmapData, columns);
                    
                case REPEAT_MODE_LAST:
                    maxColumnHeight = this._Str_16099(this._cachedBitmapData, columns);
                    
                case REPEAT_MODE_RANDOM:
                    maxColumnHeight = this.renderRepeatRandom(this._cachedBitmapData, columns);
                    
                default:
                    maxColumnHeight = this._Str_18711(this._cachedBitmapData, columns);
            }
            this._cachedBitmapHeight = maxColumnHeight;
            if (canvas != null)
            {
                this.copyCachedBitmapOnCanvas(canvas, maxColumnHeight, offsetY, topAlign);
                return canvas;
            }
            return this._cachedBitmapData;
        }

        function copyCachedBitmapOnCanvas(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:Bool)
        {
            if ((((k == null) || (this._cachedBitmapData == null)) || (k == this._cachedBitmapData)))
            {
                return;
            }
            if (!_arg_4)
            {
                _arg_3 = ((k.height - _arg_2) - _arg_3);
            }
            var _local_5:Rectangle = null;
            if (this._align == ALIGN_TOP)
            {
                _local_5 = new Rectangle(0, 0, this._cachedBitmapData.width, this._cachedBitmapHeight);
            }
            else
            {
                _local_5 = new Rectangle(0, (this._cachedBitmapData.height - this._cachedBitmapHeight), this._cachedBitmapData.width, this._cachedBitmapHeight);
            }
            k.copyPixels(this._cachedBitmapData, _local_5, new Point(0, _arg_3), null, null, true);
        }

        function getColumnsWidth(k:Array<ASAny>):Int
        {
            var _local_4:BitmapData = null;
            if (((k == null) || (k.length == 0)))
            {
                return 0;
            }
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_4 = ASCompat.dynamicAs(k[_local_3] , BitmapData);
                if (_local_4 != null)
                {
                    _local_2 = (_local_2 + _local_4.width);
                }
                _local_3++;
            }
            return _local_2;
        }

        function renderColumns(k:BitmapData, _arg_2:Array<ASAny>, _arg_3:Int, _arg_4:Bool):Point
        {
            var _local_8 = 0;
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return new Point(_arg_3, 0);
            }
            var _local_5 = 0;
            var _local_6:BitmapData = null;
            var _local_7 = 0;
            while (_local_7 < _arg_2.length)
            {
                if (_arg_4)
                {
                    _local_6 = ASCompat.dynamicAs(_arg_2[_local_7] , BitmapData);
                }
                else
                {
                    _local_6 = ASCompat.dynamicAs(_arg_2[((_arg_2.length - 1) - _local_7)] , BitmapData);
                }
                if (_local_6 != null)
                {
                    if (!_arg_4)
                    {
                        _arg_3 = (_arg_3 - _local_6.width);
                    }
                    _local_8 = 0;
                    if (this._align == ALIGN_BOTTOM)
                    {
                        _local_8 = (k.height - _local_6.height);
                    }
                    k.copyPixels(_local_6, _local_6.rect, new Point(_arg_3, _local_8), _local_6, null, true);
                    if (_local_6.height > _local_5)
                    {
                        _local_5 = _local_6.height;
                    }
                    if (_arg_4)
                    {
                        _arg_3 = (_arg_3 + _local_6.width);
                    }
                    if (((_arg_4 && (_arg_3 >= k.width)) || ((!_arg_4) && (_arg_3 <= 0))))
                    {
                        return new Point(_arg_3, _local_5);
                    }
                }
                _local_7++;
            }
            return new Point(_arg_3, _local_5);
        }

        function _Str_18711(k:BitmapData, _arg_2:Array<ASAny>):Int
        {
            var _local_6:Point = null;
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4= this.getColumnsWidth(_arg_2);
            var _local_5 = 0;
            if (_local_4 > k.width)
            {
            }
            while (_local_5 < k.width)
            {
                _local_6 = this.renderColumns(k, _arg_2, _local_5, true);
                _local_5 = Std.int(_local_6.x);
                if (_local_6.y > _local_3)
                {
                    _local_3 = Std.int(_local_6.y);
                }
                if (_local_6.x == 0)
                {
                    return _local_3;
                }
            }
            return _local_3;
        }

        function _Str_18476(k:BitmapData, _arg_2:Array<ASAny>):Int
        {
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4:BitmapData = null;
            var _local_5:Array<ASAny> = [];
            var _local_6 = 0;
            var _local_7 = 0;
            _local_7 = 1;
            while (_local_7 < (_arg_2.length - 1))
            {
                _local_4 = ASCompat.dynamicAs(_arg_2[_local_7] , BitmapData);
                if (_local_4 != null)
                {
                    _local_6 = (_local_6 + _local_4.width);
                    _local_5.push(_local_4);
                }
                _local_7++;
            }
            if (this._columns.length == 1)
            {
                _local_4 = ASCompat.dynamicAs(this._columns[0] , BitmapData);
                if (_local_4 != null)
                {
                    _local_6 = _local_4.width;
                    _local_5.push(_local_4);
                }
            }
            var _local_8:ASAny = ((k.width - _local_6) >> 1);
            var _local_9:Point = null;
            _local_9 = this.renderColumns(k, _local_5, ASCompat.toInt(_local_8), true);
            var _local_10= Std.int(_local_9.x);
            if (_local_9.y > _local_3)
            {
                _local_3 = Std.int(_local_9.y);
            }
            _local_4 = ASCompat.dynamicAs(_arg_2[0] , BitmapData);
            if (_local_4 != null)
            {
                _local_5 = [_local_4];
                while (_local_8 >= 0)
                {
                    _local_9 = this.renderColumns(k, _local_5, ASCompat.toInt(_local_8), false);
                    _local_8 = _local_9.x;
                    if (_local_9.y > _local_3)
                    {
                        _local_3 = Std.int(_local_9.y);
                    }
                }
            }
            _local_4 = ASCompat.dynamicAs(_arg_2[(_arg_2.length - 1)] , BitmapData);
            if (_local_4 != null)
            {
                _local_5 = [_local_4];
                while (_local_10 < k.height)
                {
                    _local_9 = this.renderColumns(k, _local_5, _local_10, true);
                    _local_10 = Std.int(_local_9.x);
                    if (_local_9.y > _local_3)
                    {
                        _local_3 = Std.int(_local_9.y);
                    }
                }
            }
            return _local_3;
        }

        function _Str_17295(k:BitmapData, _arg_2:Array<ASAny>):Int
        {
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_17 = 0;
            var _local_18:Array<ASAny> = null;
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4:BitmapData = null;
            var _local_5:Array<ASAny> = [];
            var _local_6:Array<ASAny> = [];
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            _local_9 = 0;
            while (_local_9 < (_arg_2.length >> 1))
            {
                _local_4 = ASCompat.dynamicAs(_arg_2[_local_9] , BitmapData);
                if (_local_4 != null)
                {
                    _local_7 = (_local_7 + _local_4.width);
                    _local_5.push(_local_4);
                }
                _local_9++;
            }
            _local_9 = ((_arg_2.length >> 1) + 1);
            while (_local_9 < _arg_2.length)
            {
                _local_4 = ASCompat.dynamicAs(_arg_2[_local_9] , BitmapData);
                if (_local_4 != null)
                {
                    _local_8 = (_local_8 + _local_4.width);
                    _local_6.push(_local_4);
                }
                _local_9++;
            }
            var _local_10:Point = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13= k.width;
            if ((_local_7 + _local_8) > k.width)
            {
                _local_11 = ((_local_7 + _local_8) - k.width);
                _local_12 = (_local_12 - (_local_11 >> 1));
                _local_13 = (_local_13 + (_local_11 - (_local_11 >> 1)));
            }
            if (_local_11 == 0)
            {
                _local_4 = ASCompat.dynamicAs(_arg_2[(_arg_2.length >> 1)] , BitmapData);
                if (_local_4 != null)
                {
                    _local_14 = _local_4.width;
                    _local_15 = (k.width - (_local_7 + _local_8));
                    _local_16 = Std.int(Math.fceil((_local_15 / _local_14)) * _local_14);
                    _local_12 = (_local_7 - ((_local_16 - _local_15) >> 1));
                    _local_17 = (_local_12 + _local_16);
                    _local_18 = [_local_4];
                    while (_local_12 < _local_17)
                    {
                        _local_10 = this.renderColumns(k, _local_18, _local_12, true);
                        _local_12 = Std.int(_local_10.x);
                        if (_local_10.y > _local_3)
                        {
                            _local_3 = Std.int(_local_10.y);
                        }
                    }
                }
            }
            _local_12 = 0;
            _local_10 = this.renderColumns(k, _local_5, _local_12, true);
            if (_local_10.y > _local_3)
            {
                _local_3 = Std.int(_local_10.y);
            }
            _local_10 = this.renderColumns(k, _local_6, _local_13, false);
            if (_local_10.y > _local_3)
            {
                _local_3 = Std.int(_local_10.y);
            }
            return _local_3;
        }

        function _Str_18019(k:BitmapData, _arg_2:Array<ASAny>):Int
        {
            var _local_7:Array<ASAny> = null;
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4:BitmapData = null;
            var _local_5= k.width;
            var _local_6= this.renderColumns(k, _arg_2, _local_5, false);
            _local_5 = Std.int(_local_6.x);
            if (_local_6.y > _local_3)
            {
                _local_3 = Std.int(_local_6.y);
            }
            _local_4 = ASCompat.dynamicAs(_arg_2[0] , BitmapData);
            if (_local_4 != null)
            {
                _local_7 = [_local_4];
                while (_local_5 >= 0)
                {
                    _local_6 = this.renderColumns(k, _local_7, _local_5, false);
                    _local_5 = Std.int(_local_6.x);
                    if (_local_6.y > _local_3)
                    {
                        _local_3 = Std.int(_local_6.y);
                    }
                }
            }
            return _local_3;
        }

        function _Str_16099(k:BitmapData, _arg_2:Array<ASAny>):Int
        {
            var _local_7:Array<ASAny> = null;
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4:BitmapData = null;
            var _local_5 = 0;
            var _local_6= this.renderColumns(k, _arg_2, _local_5, true);
            _local_5 = Std.int(_local_6.x);
            if (_local_6.y > _local_3)
            {
                _local_3 = Std.int(_local_6.y);
            }
            _local_4 = ASCompat.dynamicAs(_arg_2[(_arg_2.length - 1)] , BitmapData);
            if (_local_4 != null)
            {
                _local_7 = [_local_4];
                while (_local_5 < k.width)
                {
                    _local_6 = this.renderColumns(k, _local_7, _local_5, true);
                    _local_5 = Std.int(_local_6.x);
                    if (_local_6.y > _local_3)
                    {
                        _local_3 = Std.int(_local_6.y);
                    }
                }
            }
            return _local_3;
        }

        function renderRepeatRandom(k:BitmapData, _arg_2:Array<ASAny>):Int
        {
            var _local_6:Array<ASAny> = null;
            var _local_7:Point = null;
            if ((((_arg_2 == null) || (_arg_2.length == 0)) || (k == null)))
            {
                return 0;
            }
            var _local_3 = 0;
            var _local_4:BitmapData = null;
            var _local_5 = 0;
            while (_local_5 < k.width)
            {
                _local_4 = ASCompat.dynamicAs(_arg_2[_Str_12526(_arg_2.length)] , BitmapData);
                if (_local_4 != null)
                {
                    _local_6 = [_local_4];
                    _local_7 = this.renderColumns(k, _local_6, _local_5, true);
                    _local_5 = Std.int(_local_7.x);
                    if (_local_7.y > _local_3)
                    {
                        _local_3 = Std.int(_local_7.y);
                    }
                }
                else
                {
                    return _local_3;
                }
            }
            return _local_3;
        }

        public function _Str_23721(k:Int):Array<ASAny>
        {
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            var _local_4:PlaneMaterialCellColumn = null;
            if (this._repeatMode == REPEAT_MODE_RANDOM)
            {
                _local_2 = [];
                _local_3 = 0;
                while (_local_3 < k)
                {
                    _local_4 = this._columns[_Str_12526(this._columns.length)];
                    if (_local_4 != null)
                    {
                        _local_2.push(_local_4);
                        if (_local_4.width > 1)
                        {
                            _local_3 = (_local_3 + _local_4.width);
                        }
                        else
                        {
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                }
                return _local_2;
            }
            return this._columns;
        }
    }

