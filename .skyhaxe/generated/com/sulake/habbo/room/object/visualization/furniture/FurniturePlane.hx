package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

     class FurniturePlane 
    {
        var _geometryUpdateId:Int = -1;
        var _geometryDirX:Float = 0;
        var _geometryDirY:Float = 0;
        var _geometryDirZ:Float = 0;
        var _geometryScale:Float = 0;
        var _origin:Vector3d = null;
        var _loc:Vector3d = null;
        var _leftSide:Vector3d = null;
        var _rightSide:Vector3d = null;
        var _leftSideOriginal:Vector3d = null;
        var _rightSideOriginal:Vector3d = null;
        var _normal:Vector3d = null;
        var _isVisible:Bool = true;
        var _bitmapData:BitmapData = null;
        var _textures:Map = null;
        var _offset:Point = null;
        var _relativeDepth:Float = 0;
        var _color:UInt = 0;
        var _rotated:Bool = false;
        var _id:String = null;
        var _cornerA:Vector3d = null;
        var _cornerB:Vector3d = null;
        var _cornerC:Vector3d = null;
        var _cornerD:Vector3d = null;
        var _width:Float = 0;
        var _height:Float = 0;

        public function new(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d)
        {
            this._origin = new Vector3d();
            this._loc = new Vector3d();
            this._loc.assign(k);
            this._leftSide = new Vector3d();
            this._leftSide.assign(_arg_2);
            this._rightSide = new Vector3d();
            this._rightSide.assign(_arg_3);
            this._leftSideOriginal = new Vector3d();
            this._leftSideOriginal.assign(_arg_2);
            this._rightSideOriginal = new Vector3d();
            this._rightSideOriginal.assign(_arg_3);
            this._normal = Vector3d.crossProduct(this._leftSide, this._rightSide);
            if (this._normal.length > 0)
            {
                this._normal.mul((1 / this._normal.length));
            }
            this._offset = new Point();
            this._cornerA = new Vector3d();
            this._cornerB = new Vector3d();
            this._cornerC = new Vector3d();
            this._cornerD = new Vector3d();
            this._textures = new Map();
        }

        public var bitmapData(get,never):BitmapData;
public function  get_bitmapData():BitmapData
        {
            if (this._isVisible)
            {
                if (this._bitmapData != null)
                {
                    return this._bitmapData.clone();
                }
            }
            return null;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._isVisible;
        }

        public var offset(get,never):Point;
public function  get_offset():Point
        {
            return this._offset;
        }

        public var relativeDepth(get,never):Float;
public function  get_relativeDepth():Float
        {
            return this._relativeDepth;
        }

        
        public var color(get,set):UInt;
public function  get_color():UInt
        {
            return this._color;
        }
public function  set_color(k:UInt):UInt        {
            return this._color = k;
        }

        public var leftSide(get,never):IVector3d;
public function  get_leftSide():IVector3d
        {
            return this._leftSide;
        }

        public var rightSide(get,never):IVector3d;
public function  get_rightSide():IVector3d
        {
            return this._rightSide;
        }

        public var location(get,never):IVector3d;
public function  get_location():IVector3d
        {
            return this._loc;
        }

        public var normal(get,never):IVector3d;
public function  get_normal():IVector3d
        {
            return this._normal;
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:BitmapData = null;
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
            if (this._textures != null)
            {
                k = 0;
                while ((k : UInt) < this._textures.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._textures.getWithIndex(k) , BitmapData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._textures.dispose();
                this._textures = null;
            }
            this._origin = null;
            this._loc = null;
            this._leftSide = null;
            this._rightSide = null;
            this._leftSideOriginal = null;
            this._rightSideOriginal = null;
            this._normal = null;
            this._cornerA = null;
            this._cornerB = null;
            this._cornerC = null;
            this._cornerD = null;
        }

        public function setRotation(k:Bool)
        {
            if (k != this._rotated)
            {
                if (!k)
                {
                    this._leftSide.assign(this._leftSideOriginal);
                    this._rightSide.assign(this._rightSideOriginal);
                }
                else
                {
                    this._leftSide.assign(this._leftSideOriginal);
                    this._leftSide.mul((this._rightSideOriginal.length / this._leftSideOriginal.length));
                    this._rightSide.assign(this._rightSideOriginal);
                    this._rightSide.mul((this._leftSideOriginal.length / this._rightSideOriginal.length));
                }
                this._geometryUpdateId = -1;
                this._geometryDirX = (this._geometryDirX - 1);
                this._rotated = k;
                this.resetTextureCache();
            }
        }

        function cacheTexture(k:String, _arg_2:BitmapData):Bool
        {
            var _local_3= ASCompat.dynamicAs(this._textures.remove(k) , BitmapData);
            if (((!(_local_3 == null)) && (!(_arg_2 == _local_3))))
            {
                _local_3.dispose();
            }
            this._textures.add(k, _arg_2);
            return true;
        }

        function resetTextureCache()
        {
            var k = 0;
            var _local_2:BitmapData = null;
            if (this._textures != null)
            {
                k = 0;
                while ((k : UInt) < this._textures.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._textures.getWithIndex(k) , BitmapData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._textures.reset();
            }
        }

        function getTextureIdentifier(k:IRoomGeometry):String
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= Std.string(k.scale);
            return _local_2;
        }

        function needsNewTexture(k:IRoomGeometry):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= this.getTextureIdentifier(k);
            var _local_3= ASCompat.dynamicAs(this._textures.getValue(_local_2) , BitmapData);
            if (((this._width > 0) && (this._height > 0)))
            {
                if (_local_3 == null)
                {
                    return true;
                }
            }
            return false;
        }

        function getTexture(k:IRoomGeometry, _arg_2:Int):BitmapData
        {
            var _local_5 = Math.NaN;
            var _local_6 = Math.NaN;
            var _local_7:IVector3d = null;
            if (k == null)
            {
                return null;
            }
            var _local_3= this.getTextureIdentifier(k);
            var _local_4:BitmapData = null;
            if (this.needsNewTexture(k))
            {
                _local_5 = (this._leftSide.length * k.scale);
                _local_6 = (this._rightSide.length * k.scale);
                if (_local_5 < 1)
                {
                    _local_5 = 1;
                }
                if (_local_6 < 1)
                {
                    _local_6 = 1;
                }
                _local_7 = k.getCoordinatePosition(this._normal);
                _local_4 = ASCompat.dynamicAs(this._textures.getValue(_local_3) , BitmapData);
                if (_local_4 == null)
                {
                    _local_4 = new BitmapData(Std.int(_local_5), Std.int(_local_6), true, (ASCompat.toInt(0xFF000000 )| ASCompat.toInt(this._color)));
                    if (_local_4 != null)
                    {
                        this.cacheTexture(_local_3, _local_4);
                    }
                }
            }
            else
            {
                _local_4 = ASCompat.dynamicAs(this._textures.getValue(_local_3) , BitmapData);
            }
            if (_local_4 != null)
            {
                return _local_4;
            }
            return null;
        }

        public function update(k:IRoomGeometry, _arg_2:Int):Bool
        {
            var _local_4:IVector3d = null;
            var _local_5 = Math.NaN;
            var _local_6:IVector3d = null;
            var _local_7 = Math.NaN;
            var _local_8 = Math.NaN;
            var _local_9:BitmapData = null;
            if ((((((k == null) || ((this._loc == null) && (!(this._origin == null)))) || (this._leftSide == null)) || (this._rightSide == null)) || (this._normal == null)))
            {
                return false;
            }
            var _local_3 = false;
            if (k.updateId != this._geometryUpdateId)
            {
                this._geometryUpdateId = k.updateId;
                _local_4 = k.direction;
                if (((!(_local_4 == null)) && ((((!(_local_4.x == this._geometryDirX)) || (!(_local_4.y == this._geometryDirY))) || (!(_local_4.z == this._geometryDirZ))) || (!(k.scale == this._geometryScale)))))
                {
                    this._geometryDirX = _local_4.x;
                    this._geometryDirY = _local_4.y;
                    this._geometryDirZ = _local_4.z;
                    this._geometryScale = k.scale;
                    _local_3 = true;
                    _local_5 = 0;
                    _local_5 = Vector3d.cosAngle(k.directionAxis, this.normal);
                    if (_local_5 > -0.001)
                    {
                        if (this._isVisible)
                        {
                            this._isVisible = false;
                            return true;
                        }
                        return false;
                    }
                    this.updateCorners(k);
                    _local_6 = k.getScreenPosition(this._origin);
                    _local_7 = _local_6.z;
                    _local_8 = Math.max((this._cornerA.z - _local_7), Math.max(Math.max((this._cornerB.z - _local_7), (this._cornerC.z - _local_7)), (this._cornerD.z - _local_7)));
                    this._relativeDepth = _local_8;
                    this._isVisible = true;
                }
            }
            if ((this.needsNewTexture(k) || _local_3))
            {
                if ((((this._bitmapData == null) || (!(this._width == this._bitmapData.width))) || (!(this._height == this._bitmapData.height))))
                {
                    if (this._bitmapData != null)
                    {
                        this._bitmapData.dispose();
                        this._bitmapData = null;
                        if (((this._width < 1) || (this._height < 1)))
                        {
                            return true;
                        }
                    }
                    else
                    {
                        if (((this._width < 1) || (this._height < 1)))
                        {
                            return false;
                        }
                    }
                    this._bitmapData = new BitmapData(Std.int(this._width), Std.int(this._height), true, 0xFFFFFF);
                    this._bitmapData.lock();
                }
                else
                {
                    this._bitmapData.lock();
                    this._bitmapData.fillRect(this._bitmapData.rect, 0xFFFFFF);
                }
                _local_9 = this.getTexture(k, _arg_2);
                if (_local_9 != null)
                {
                    this.renderTexture(k, _local_9);
                }
                this._bitmapData.unlock();
                return true;
            }
            return false;
        }

        function updateCorners(k:IRoomGeometry)
        {
            this._cornerA.assign(k.getScreenPosition(this._loc));
            this._cornerB.assign(k.getScreenPosition(Vector3d.sum(this._loc, this._rightSide)));
            this._cornerC.assign(k.getScreenPosition(Vector3d.sum(Vector3d.sum(this._loc, this._leftSide), this._rightSide)));
            this._cornerD.assign(k.getScreenPosition(Vector3d.sum(this._loc, this._leftSide)));
            this._offset = k.getScreenPoint(this._origin);
            this._cornerA.x = Math.fround(this._cornerA.x);
            this._cornerA.y = Math.fround(this._cornerA.y);
            this._cornerB.x = Math.fround(this._cornerB.x);
            this._cornerB.y = Math.fround(this._cornerB.y);
            this._cornerC.x = Math.fround(this._cornerC.x);
            this._cornerC.y = Math.fround(this._cornerC.y);
            this._cornerD.x = Math.fround(this._cornerD.x);
            this._cornerD.y = Math.fround(this._cornerD.y);
            this._offset.x = Math.fround(this._offset.x);
            this._offset.y = Math.fround(this._offset.y);
            var _local_2= Math.min(this._cornerA.x, Math.min(Math.min(this._cornerB.x, this._cornerC.x), this._cornerD.x));
            var _local_3= Math.max(this._cornerA.x, Math.max(Math.max(this._cornerB.x, this._cornerC.x), this._cornerD.x));
            var _local_4= Math.min(this._cornerA.y, Math.min(Math.min(this._cornerB.y, this._cornerC.y), this._cornerD.y));
            var _local_5= Math.max(this._cornerA.y, Math.max(Math.max(this._cornerB.y, this._cornerC.y), this._cornerD.y));
            _local_3 = (_local_3 - _local_2);
            this._offset.x = (this._offset.x - _local_2);
            this._cornerA.x = (this._cornerA.x - _local_2);
            this._cornerB.x = (this._cornerB.x - _local_2);
            this._cornerC.x = (this._cornerC.x - _local_2);
            this._cornerD.x = (this._cornerD.x - _local_2);
            _local_5 = (_local_5 - _local_4);
            this._offset.y = (this._offset.y - _local_4);
            this._cornerA.y = (this._cornerA.y - _local_4);
            this._cornerB.y = (this._cornerB.y - _local_4);
            this._cornerC.y = (this._cornerC.y - _local_4);
            this._cornerD.y = (this._cornerD.y - _local_4);
            this._width = _local_3;
            this._height = _local_5;
        }

        function renderTexture(k:IRoomGeometry, _arg_2:BitmapData)
        {
            if (((((((this._cornerA == null) || (this._cornerB == null)) || (this._cornerC == null)) || (this._cornerD == null)) || (_arg_2 == null)) || (this._bitmapData == null)))
            {
                return;
            }
            var _local_3= (this._cornerD.x - this._cornerC.x);
            var _local_4= (this._cornerD.y - this._cornerC.y);
            var _local_5= (this._cornerB.x - this._cornerC.x);
            var _local_6= (this._cornerB.y - this._cornerC.y);
            if (Math.abs((_local_5 - _arg_2.width)) <= 1)
            {
                _local_5 = _arg_2.width;
            }
            if (Math.abs((_local_6 - _arg_2.width)) <= 1)
            {
                _local_6 = _arg_2.width;
            }
            if (Math.abs((_local_3 - _arg_2.height)) <= 1)
            {
                _local_3 = _arg_2.height;
            }
            if (Math.abs((_local_4 - _arg_2.height)) <= 1)
            {
                _local_4 = _arg_2.height;
            }
            var _local_7= (_local_5 / _arg_2.width);
            var _local_8= (_local_6 / _arg_2.width);
            var _local_9= (_local_3 / _arg_2.height);
            var _local_10= (_local_4 / _arg_2.height);
            var _local_11= new Matrix();
            _local_11.a = _local_7;
            _local_11.b = _local_8;
            _local_11.c = _local_9;
            _local_11.d = _local_10;
            _local_11.translate(this._cornerC.x, this._cornerC.y);
            this.draw(_arg_2, _local_11);
        }

        function draw(k:BitmapData, _arg_2:Matrix)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = Math.NaN;
            var _local_6 = 0;
            var _local_7 = 0;
            if (this._bitmapData != null)
            {
                if ((((((_arg_2.a == 1) && (_arg_2.d == 1)) && (_arg_2.c == 0)) && (!(_arg_2.b == 0))) && (Math.abs(_arg_2.b) <= 1)))
                {
                    _local_3 = 0;
                    _local_4 = 0;
                    _local_5 = 0;
                    _local_6 = 0;
                    if (_arg_2.b > 0)
                    {
                        _arg_2.ty++;
                    }
                    _local_7 = 0;
                    while (_local_3 < k.width)
                    {
                        _local_3++;
                        _local_5 = (_local_5 + Math.abs(_arg_2.b));
                        if (_local_5 >= 1)
                        {
                            this._bitmapData.copyPixels(k, new Rectangle((_local_4 + _local_6), 0, (_local_3 - _local_4), k.height), new Point((_arg_2.tx + _local_4), (_arg_2.ty + _local_7)), null, null, true);
                            _local_4 = _local_3;
                            if (_arg_2.b > 0)
                            {
                                _local_7++;
                            }
                            else
                            {
                                _local_7--;
                            }
                            _local_5 = 0;
                        }
                    }
                    if (_local_5 > 0)
                    {
                        this._bitmapData.copyPixels(k, new Rectangle(_local_4, 0, (_local_3 - _local_4), k.height), new Point((_arg_2.tx + _local_4), (_arg_2.ty + _local_7)), null, null, true);
                    }
                    return;
                }
                this._bitmapData.draw(k, _arg_2, null, null, null, false);
            }
        }
    }

