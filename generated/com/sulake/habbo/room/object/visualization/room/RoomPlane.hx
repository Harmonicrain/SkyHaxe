package com.sulake.habbo.room.object.visualization.room
;
    import com.sulake.room.object.visualization.IRoomPlane;
    import flash.geom.Point;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.IPlaneRasterizer;
    import com.sulake.habbo.room.object.visualization.room.mask.PlaneMaskManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.utils.Canvas;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.room.object.visualization.room.mask.PlaneMask;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneVisualizationLayer;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneMaterialCellMatrix;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneMaterialCellColumn;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.PlaneMaterialCell;
    import com.sulake.habbo.room.object.visualization.room.utils.Randomizer;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;

     class RoomPlane implements IRoomPlane 
    {
        static final ZERO_POINT:Point = new Point(0, 0);
        public static inline final TYPE_UNDEFINED= 0;
        public static inline final TYPE_WALL= 1;
        public static inline final TYPE_FLOOR= 2;
        public static inline final TYPE_LANDSCAPE= 3;
        static var _Str_10032:Int = 1;

        var _disposed:Bool = false;
        var _randomSeed:Int = 0;
        var _origin:Vector3d = null;
        var _location:Vector3d = null;
        var _leftSide:Vector3d = null;
        var _rightSide:Vector3d = null;
        var _normal:Vector3d = null;
        var _secondaryNormals:Array<ASAny>;
        var FLOOR_COLOR:Int = -1;
        var _type:Int = 0;
        var _isVisible:Bool = false;
        var _bitmapData:BitmapData = null;
        var _hasTexture:Bool = true;
        var _offset:Point = null;
        var _relativeDepth:Float = 0;
        var _extraDepth:Float = 0;
        var _isHighlighter:Bool = false;
        var _color:UInt = 0;
        var _rasterizer:IPlaneRasterizer = null;
        var _maskManager:PlaneMaskManager = null;
        var _id:String = null;
        var _uniqueId:Int = 0;
        var _textureOffsetX:Float = 0;
        var _textureOffsetY:Float = 0;
        var _textureMaxX:Float = 0;
        var _textureMaxY:Float = 0;
        var _textures:Map = null;
        var _activeTexture:PlaneBitmapData = null;
        var _useMask:Bool = false;
        var _bitmapMasks:Array<ASAny>;
        var _rectangleMasks:Array<ASAny>;
        var _maskChanged:Bool = false;
        var _maskBitmapData:BitmapData = null;
        var _maskBufferBitmapData:BitmapData = null;
        var _bitmapMasksOld:Array<ASAny>;
        var _rectangleMasksOld:Array<ASAny>;
        var _cornerA:Vector3d = null;
        var _cornerB:Vector3d = null;
        var _cornerC:Vector3d = null;
        var _cornerD:Vector3d = null;
        var _width:Float = 0;
        var _height:Float = 0;
        var _canBeVisible:Bool = true;

        public function new(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Int, _arg_6:Bool, _arg_7:Array<ASAny>, _arg_8:Int, _arg_9:Float=0, _arg_10:Float=0, _arg_11:Float=0, _arg_12:Float=0)
        {
            var _local_13:Int;
            var _local_14:IVector3d;
            var _local_15:Vector3d;
            this._secondaryNormals = [];
            this._bitmapMasks = [];
            this._rectangleMasks = [];
            this._bitmapMasksOld = [];
            this._rectangleMasksOld = [];
            this._randomSeed = _arg_8;
            this._origin = new Vector3d();
            this._origin.assign(k);
            this._location = new Vector3d();
            this._location.assign(_arg_2);
            this._leftSide = new Vector3d();
            this._leftSide.assign(_arg_3);
            this._rightSide = new Vector3d();
            this._rightSide.assign(_arg_4);
            this._normal = Vector3d.crossProduct(this._leftSide, this._rightSide);
            if (this._normal.length > 0)
            {
                this._normal.mul((1 / this._normal.length));
            }
            if (_arg_7 != null)
            {
                _local_13 = 0;
                while (_local_13 < _arg_7.length)
                {
                    _local_14 = ASCompat.dynamicAs(_arg_7[_local_13] , IVector3d);
                    if (_local_14 != null)
                    {
                        _local_15 = new Vector3d();
                        _local_15.assign(_local_14);
                        this._secondaryNormals.push(_local_15);
                    }
                    _local_13++;
                }
            }
            this._offset = new Point();
            this._type = _arg_5;
            this._textures = new Map();
            this._cornerA = new Vector3d();
            this._cornerB = new Vector3d();
            this._cornerC = new Vector3d();
            this._cornerD = new Vector3d();
            this._textureOffsetX = _arg_9;
            this._textureOffsetY = _arg_10;
            this._textureMaxX = _arg_11;
            this._textureMaxY = _arg_12;
            this._useMask = _arg_6;
            this._uniqueId = _Str_10032++;
        }

        static function blend(k:UInt, _arg_2:UInt):UInt
        {
            return Canvas.colorize(_arg_2, (k | 0xFF000000)) & 0xFFFFFF;
        }


        
        public var _Str_14801(get,set):Bool;
function  set__Str_14801(k:Bool):Bool        {
            if (k != this._canBeVisible)
            {
                if (!this._canBeVisible)
                {
                    this.resetTextureCache();
                }
                this._canBeVisible = k;
            }
return k;
        }
function  get__Str_14801():Bool
        {
            return this._canBeVisible;
        }

        public var bitmapData(get,never):BitmapData;
function  get_bitmapData():BitmapData
        {
            var bitmap:BitmapData = null;
            if (this.visible)
            {
                if (this._bitmapData != null)
                {
                    try
                    {
                        bitmap = this._bitmapData.clone();
                    }
                    catch(e:ASError)
                    {
                        return null;
                    }
                }
            }
            return bitmap;
        }

        public var visible(get,never):Bool;
function  get_visible():Bool
        {
            return this._isVisible && this._canBeVisible;
        }

        public var offset(get,never):Point;
function  get_offset():Point
        {
            return this._offset;
        }

        public var relativeDepth(get,never):Float;
function  get_relativeDepth():Float
        {
            return (this._relativeDepth + this._extraDepth);
        }

        public var extraDepth(never,set):Float;
function  set_extraDepth(k:Float):Float        {
            return this._extraDepth = k;
        }

        
        public var isHighlighter(get,set):Bool;
function  get_isHighlighter():Bool
        {
            return this._isHighlighter;
        }
function  set_isHighlighter(k:Bool):Bool        {
            return this._isHighlighter = k;
        }

        
        public var color(get,set):UInt;
function  get_color():UInt
        {
            return this._color;
        }
function  set_color(k:UInt):UInt        {
            return this._color = k;
        }

        public var type(get,never):Int;
function  get_type():Int
        {
            return this._type;
        }

        public var leftSide(get,never):IVector3d;
function  get_leftSide():IVector3d
        {
            return this._leftSide;
        }

        public var rightSide(get,never):IVector3d;
function  get_rightSide():IVector3d
        {
            return this._rightSide;
        }

        public var location(get,never):IVector3d;
function  get_location():IVector3d
        {
            return this._location;
        }

        public var normal(get,never):IVector3d;
function  get_normal():IVector3d
        {
            return this._normal;
        }

        
        public var _Str_18448(get,set):Bool;
function  get__Str_18448():Bool
        {
            return this._hasTexture;
        }
function  set__Str_18448(k:Bool):Bool        {
            return this._hasTexture = k;
        }

        public var rasterizer(never,set):IPlaneRasterizer;
function  set_rasterizer(k:IPlaneRasterizer):IPlaneRasterizer        {
            return this._rasterizer = k;
        }

        public var _Str_16279(never,set):PlaneMaskManager;
function  set__Str_16279(k:PlaneMaskManager):PlaneMaskManager        {
            return this._maskManager = k;
        }

        public var id(never,set):String;
function  set_id(k:String):String        {
            if (k != this._id)
            {
                this.resetTextureCache();
                this._id = k;
            }
return k;
        }

        public var uniqueId(get,never):Int;
function  get_uniqueId():Int
        {
            return this._uniqueId;
        }

        public function dispose()
        {
            var k:Int;
            var _local_2:PlaneBitmapData;
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
                    _local_2 = ASCompat.dynamicAs(this._textures.getWithIndex(k) , PlaneBitmapData);
                    if (_local_2 != null)
                    {
                        if (_local_2.bitmap != null)
                        {
                            _local_2.bitmap.dispose();
                        }
                        _local_2.dispose();
                    }
                    k++;
                }
                this._textures.dispose();
                this._textures = null;
            }
            this._activeTexture = null;
            this._location = null;
            this._origin = null;
            this._leftSide = null;
            this._rightSide = null;
            this._normal = null;
            this._rasterizer = null;
            this._cornerA = null;
            this._cornerB = null;
            this._cornerC = null;
            this._cornerD = null;
            this._bitmapMasks = null;
            this._rectangleMasks = null;
            if (this._maskBitmapData != null)
            {
                this._maskBitmapData.dispose();
                this._maskBitmapData = null;
            }
            if (this._maskBufferBitmapData != null)
            {
                this._maskBufferBitmapData.dispose();
                this._maskBufferBitmapData = null;
            }
            this._disposed = true;
        }

        public function copyBitmapData(k:BitmapData):BitmapData
        {
            if (this.visible)
            {
                if (((!(this._bitmapData == null)) && (!(k == null))))
                {
                    if (((this._bitmapData.width == k.width) && (this._bitmapData.height == k.height)))
                    {
                        k.copyPixels(this._bitmapData, this._bitmapData.rect, ZERO_POINT);
                        return k;
                    }
                }
            }
            return null;
        }

        function cacheTexture(k:String, _arg_2:PlaneBitmapData):Bool
        {
            var _local_3= ASCompat.dynamicAs(this._textures.remove(k) , PlaneBitmapData);
            if (_local_3 != null)
            {
                if (((!(_arg_2 == null)) && (!(_arg_2.bitmap == _local_3.bitmap))))
                {
                    _local_3.bitmap.dispose();
                }
                _local_3.dispose();
            }
            this._activeTexture = _arg_2;
            this._textures.add(k, _arg_2);
            return true;
        }

        function resetTextureCache(k:BitmapData=null)
        {
            var _local_2:Int;
            var _local_3:PlaneBitmapData;
            if (this._textures != null)
            {
                _local_2 = 0;
                while ((_local_2 : UInt) < this._textures.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._textures.getWithIndex(_local_2) , PlaneBitmapData);
                    if (_local_3 != null)
                    {
                        if (((!(_local_3.bitmap == null)) && (!(_local_3.bitmap == k))))
                        {
                            _local_3.bitmap.dispose();
                        }
                        _local_3.dispose();
                    }
                    _local_2++;
                }
                this._textures.reset();
            }
            this._activeTexture = null;
        }

        function getTextureIdentifier(k:Float):String
        {
            if (this._rasterizer != null)
            {
                return this._rasterizer.getTextureIdentifier(k, this.normal);
            }
            return Std.string(k);
        }

        function needsNewTexture(k:IRoomGeometry, _arg_2:Int):Bool
        {
            var _local_4:String;
            if (k == null)
            {
                return false;
            }
            var _local_3= this._activeTexture;
            if (_local_3 == null)
            {
                _local_4 = this.getTextureIdentifier(k.scale);
                _local_3 = ASCompat.dynamicAs(this._textures.getValue(_local_4) , PlaneBitmapData);
            }
            this.updateMaskChangeStatus();
            if ((this._canBeVisible && (((_local_3 == null) || ((_local_3.timeStamp >= 0) && (_arg_2 > _local_3.timeStamp))) || this._maskChanged)))
            {
                return true;
            }
            return false;
        }

        function getTexture(k:IRoomGeometry, _arg_2:Int):BitmapData
        {
            var _local_5:Float;
            var _local_6:Float;
            var _local_7:IVector3d;
            var _local_8:BitmapData;
            var _local_9:BitmapData;
            if (k == null)
            {
                return null;
            }
            var _local_3:PlaneBitmapData;
            var _local_4:String;
            if (this.needsNewTexture(k, _arg_2))
            {
                _local_5 = (this._leftSide.length * k.scale);
                _local_6 = (this._rightSide.length * k.scale);
                _local_7 = k.getCoordinatePosition(this._normal);
                _local_4 = this.getTextureIdentifier(k.scale);
                if (this._activeTexture != null)
                {
                    _local_3 = this._activeTexture;
                }
                else
                {
                    _local_3 = ASCompat.dynamicAs(this._textures.getValue(_local_4) , PlaneBitmapData);
                }
                _local_8 = null;
                if (_local_3 != null)
                {
                    _local_8 = _local_3.bitmap;
                }
                if (this._rasterizer != null)
                {
                    _local_3 = this._rasterizer.render(_local_8, this._id, _local_5, _local_6, k.scale, _local_7, this._hasTexture, this._textureOffsetX, this._textureOffsetY, this._textureMaxX, this._textureMaxY, _arg_2);
                    if (_local_3 != null)
                    {
                        if (((!(_local_8 == null)) && (!(_local_3.bitmap == _local_8))))
                        {
                            _local_8.dispose();
                        }
                    }
                }
                else
                {
                    _local_9 = new BitmapData(Std.int(_local_5), Std.int(_local_6), true, (0xFF000000 | this._color));
                    _local_3 = new PlaneBitmapData(_local_9, -1);
                }
                if (_local_3 != null)
                {
                    this.updateMask(_local_3.bitmap, k);
                    this.cacheTexture(_local_4, _local_3);
                }
            }
            else
            {
                if (this._activeTexture != null)
                {
                    _local_3 = this._activeTexture;
                }
                else
                {
                    _local_4 = this.getTextureIdentifier(k.scale);
                    _local_3 = ASCompat.dynamicAs(this._textures.getValue(_local_4) , PlaneBitmapData);
                }
            }
            if (_local_3 != null)
            {
                this._activeTexture = _local_3;
                return _local_3.bitmap;
            }
            return null;
        }

        function _Str_23649(k:IRoomGeometry):PlaneDrawingData
        {
            var _local_7:PlaneMask;
            var _local_8:String;
            var _local_9:IVector3d;
            var _local_10:IGraphicAsset;
            var _local_11:Point;
            if (!this._useMask)
            {
                return null;
            }
            var _local_2:RoomPlaneBitmapMask;
            var _local_3:Int;
            var _local_4:Int;
            var _local_5= new PlaneDrawingData();
            var _local_6 = 0;
            while (_local_6 < this._bitmapMasks.length)
            {
                _local_2 = ASCompat.dynamicAs(this._bitmapMasks[_local_6] , RoomPlaneBitmapMask);
                if (_local_2 != null)
                {
                    _local_7 = this._maskManager.getMask(_local_2.type);
                    if (_local_7 != null)
                    {
                        _local_8 = _local_7.getAliasByName(Std.int(k.scale));
                        if (_local_8 != null)
                        {
                            _local_9 = k.getCoordinatePosition(this._normal);
                            _local_10 = _local_7.getGraphicAsset(k.scale, _local_9);
                            if (_local_10 != null)
                            {
                                _local_3 = Std.int(this._maskBitmapData.width * (1 - (_local_2._Str_5120 / this._leftSide.length)));
                                _local_4 = Std.int(this._maskBitmapData.height * (1 - (_local_2._Str_4659 / this._rightSide.length)));
                                _local_11 = new Point((_local_3 + _local_10.offsetX), (_local_4 + _local_10.offsetY));
                                _local_5.addMask(_local_8, _local_11, _local_10.flipH, _local_10.flipV);
                            }
                        }
                    }
                }
                _local_6++;
            }
            return _local_5;
        }

        function _Str_24802(k:IRoomGeometry):Int
        {
            var _local_2= k.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_3= k.getScreenPoint(new Vector3d(0, 1, 0));
            return Math.round((this._leftSide.length * Math.abs((_local_2.x - _local_3.x))));
        }

        public function getDrawingDatas(geometry:IRoomGeometry):Array<ASAny>
        {
            var maskData:PlaneDrawingData;
            var data:PlaneDrawingData;
            var layers:Array<ASAny>;
            var layer:PlaneVisualizationLayer;
            var i:Int;
            var normal:IVector3d;
            var cm:PlaneMaterialCellMatrix;
            var column:PlaneMaterialCellColumn;
            var assetNames:Array<ASAny>;
            var cell:PlaneMaterialCell;
            var name:String;
            var drawingDatas:Array<ASAny> = [];
            if (this._isVisible)
            {
                maskData = null;
                try
                {
                    maskData = this._Str_23649(geometry);
                    layers = this._rasterizer.getLayers(this._id);
                    i = 0;
                    while (i < layers.length)
                    {
                        layer = ASCompat.dynamicAs(layers[i] , PlaneVisualizationLayer);
                        if (layer != null)
                        {
                            if ((this._hasTexture && (!(layer.material() == null))))
                            {
                                normal = geometry.getCoordinatePosition(this._normal);
                                cm = layer.material().getMaterialCellMatrix(normal);
                                data = new PlaneDrawingData(maskData, blend(this._color, layer.getColor()), cm._Str_14945());
                                Randomizer.setSeed(this._randomSeed);
                                for (_tmp_ in cm._Str_23721(this._Str_24802(geometry)))
                                {
column  = _tmp_;
                                    assetNames = [];
                                    for (_tmp_ in column._Str_22299())
                                    {
cell  = _tmp_;
                                        name = cell.getAliasByName(normal);
                                        if (name != null)
                                        {
                                            assetNames.push(name);
                                        }
                                    }
                                    if (assetNames.length > 0)
                                    {
                                        if (!column._Str_24523())
                                        {
                                            assetNames.push("");
                                        }
                                        data._Str_22862(assetNames);
                                    }
                                }
                                if (data.assetNameColumns.length > 0)
                                {
                                    drawingDatas.push(data);
                                }
                            }
                            else
                            {
                                data = new PlaneDrawingData(maskData, blend(this._color, layer.getColor()));
                                drawingDatas.push(data);
                            }
                        }
                        i = (i + 1);
                    }
                }
                catch(e:ASError)
                {
                    Logger.log(["Error in getting RoomPlane drawing data.", e]);
                }
                if (drawingDatas.length == 0)
                {
                    drawingDatas.push(new PlaneDrawingData(maskData, this._color));
                }
            }
            return drawingDatas;
        }

        function addOutlines(k:PlaneBitmapData)
        {
        }

        public function update(geometry:IRoomGeometry, timeSinceStartMs:Int):Bool
        {
            var cosAngle:Float;
            var i:Int;
            var originPos:IVector3d;
            var originZ:Float;
            var relativeDepth:Float;
            var texture:BitmapData;
            if (((geometry == null) || this._disposed))
            {
                return false;
            }
            var geometryChanged = false;
            if (this.FLOOR_COLOR != geometry.updateId)
            {
                geometryChanged = true;
            }
            if (((!geometryChanged) || (!this._canBeVisible)))
            {
                if (!this.visible)
                {
                    return false;
                }
            }
            if (geometryChanged)
            {
                this._activeTexture = null;
                cosAngle = 0;
                cosAngle = Vector3d.cosAngle(geometry.directionAxis, this.normal);
                if (cosAngle > -0.001)
                {
                    if (this._isVisible)
                    {
                        this._isVisible = false;
                        return true;
                    }
                    return false;
                }
                i = 0;
                while (i < this._secondaryNormals.length)
                {
                    cosAngle = Vector3d.cosAngle(geometry.directionAxis, this._secondaryNormals[i]);
                    if (cosAngle > -0.001)
                    {
                        if (this._isVisible)
                        {
                            this._isVisible = false;
                            return true;
                        }
                        return false;
                    }
                    i = (i + 1);
                }
                this.updateCorners(geometry);
                originPos = geometry.getScreenPosition(this._origin);
                originZ = originPos.z;
                relativeDepth = (Math.max(this._cornerA.z, Math.max(Math.max(this._cornerB.z, this._cornerC.z), this._cornerD.z)) - originZ);
                if (this._type == TYPE_FLOOR)
                {
                    relativeDepth = (relativeDepth - ((this._location.z + Math.min(0, Math.min(this._leftSide.z, this._rightSide.z))) * 8));
                }
                if (this._type == TYPE_LANDSCAPE)
                {
                    relativeDepth = (relativeDepth + 0.02);
                }
                this._relativeDepth = relativeDepth;
                this._isVisible = true;
                this.FLOOR_COLOR = geometry.updateId;
            }
            if ((geometryChanged || this.needsNewTexture(geometry, timeSinceStartMs)))
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
                    try
                    {
                        this._bitmapData = new BitmapData(Std.int(this._width), Std.int(this._height), true, 0xFFFFFF);
                    }
                    catch(e:ASError)
                    {
                        _bitmapData = null;
                        dispose();
                    }
                    if (this._bitmapData == null)
                    {
                        return false;
                    }
                    this._bitmapData.lock();
                }
                else
                {
                    this._bitmapData.lock();
                    this._bitmapData.fillRect(this._bitmapData.rect, 0xFFFFFF);
                }
                Randomizer.setSeed(this._randomSeed);
                texture = this.getTexture(geometry, timeSinceStartMs);
                if (texture != null)
                {
                    this.renderTexture(geometry, texture);
                }
                else
                {
                    this.dispose();
                    return false;
                }
                this._bitmapData.unlock();
                return (texture != null) || geometryChanged;
            }
            return false;
        }

        function updateCorners(k:IRoomGeometry)
        {
            this._cornerA.assign(k.getScreenPosition(this._location));
            this._cornerB.assign(k.getScreenPosition(Vector3d.sum(this._location, this._rightSide)));
            this._cornerC.assign(k.getScreenPosition(Vector3d.sum(Vector3d.sum(this._location, this._leftSide), this._rightSide)));
            this._cornerD.assign(k.getScreenPosition(Vector3d.sum(this._location, this._leftSide)));
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
            if (((this._type == TYPE_WALL) || (this._type == TYPE_LANDSCAPE)))
            {
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
            var _local_3:Int;
            var _local_4:Int;
            var _local_5:Float;
            var _local_6:Int;
            var _local_7:Int;
            if (this._bitmapData != null)
            {
                if (((((((_arg_2.a == 1) && (_arg_2.d == 1)) && (_arg_2.c == 0)) && (!(_arg_2.b == 0))) && (Math.abs(_arg_2.b) <= 1)) && ((this._type == TYPE_WALL) || (this._type == TYPE_LANDSCAPE))))
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

        public function resetBitmapMasks()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._useMask)
            {
                if (this._bitmapMasks.length == 0)
                {
                    return;
                }
                this._maskChanged = true;
                this._bitmapMasks = [];
            }
        }

        public function addBitmapMask(k:String, _arg_2:Float, _arg_3:Float):Bool
        {
            var _local_4:RoomPlaneBitmapMask;
            var _local_5:Int;
            if (this._useMask)
            {
                _local_4 = null;
                _local_5 = 0;
                while (_local_5 < this._bitmapMasks.length)
                {
                    _local_4 = ASCompat.dynamicAs(this._bitmapMasks[_local_5] , RoomPlaneBitmapMask);
                    if (_local_4 != null)
                    {
                        if ((((_local_4.type == k) && (_local_4._Str_5120 == _arg_2)) && (_local_4._Str_4659 == _arg_3)))
                        {
                            return false;
                        }
                    }
                    _local_5++;
                }
                _local_4 = new RoomPlaneBitmapMask(k, _arg_2, _arg_3);
                this._bitmapMasks.push(_local_4);
                this._maskChanged = true;
                return true;
            }
            return false;
        }

        public function resetRectangleMasks()
        {
            if (this._useMask)
            {
                if (this._rectangleMasks.length == 0)
                {
                    return;
                }
                this._maskChanged = true;
                this._rectangleMasks = [];
            }
        }

        public function addRectangleMask(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float):Bool
        {
            var _local_5:RoomPlaneRectangleMask;
            var _local_6:Int;
            if (this._useMask)
            {
                _local_5 = null;
                _local_6 = 0;
                while (_local_6 < this._rectangleMasks.length)
                {
                    _local_5 = ASCompat.dynamicAs(this._rectangleMasks[_local_6] , RoomPlaneRectangleMask);
                    if (_local_5 != null)
                    {
                        if (((((_local_5._Str_5120 == k) && (_local_5._Str_4659 == _arg_2)) && (_local_5._Str_9124 == _arg_3)) && (_local_5._Str_12156 == _arg_4)))
                        {
                            return false;
                        }
                    }
                    _local_6++;
                }
                _local_5 = new RoomPlaneRectangleMask(k, _arg_2, _arg_3, _arg_4);
                this._rectangleMasks.push(_local_5);
                this._maskChanged = true;
                return true;
            }
            return false;
        }

        function updateMaskChangeStatus()
        {
            var _local_6:Bool;
            var _local_7:RoomPlaneBitmapMask;
            if (!this._maskChanged)
            {
                return;
            }
            var k = 0;
            var _local_2 = 0;
            var _local_3= true;
            var _local_4:RoomPlaneBitmapMask;
            var _local_5:RoomPlaneRectangleMask;
            if (this._bitmapMasks.length == this._bitmapMasksOld.length)
            {
                while (k < this._bitmapMasks.length)
                {
                    _local_4 = ASCompat.dynamicAs(this._bitmapMasks[k] , RoomPlaneBitmapMask);
                    if (_local_4 != null)
                    {
                        _local_6 = false;
                        while (_local_2 < this._bitmapMasksOld.length)
                        {
                            _local_7 = ASCompat.dynamicAs(this._bitmapMasksOld[_local_2] , RoomPlaneBitmapMask);
                            if (_local_7 != null)
                            {
                                if ((((_local_7.type == _local_4.type) && (_local_7._Str_5120 == _local_4._Str_5120)) && (_local_7._Str_4659 == _local_4._Str_4659)))
                                {
                                    _local_6 = true;
                                    break;
                                }
                            }
                            _local_2++;
                        }
                        if (!_local_6)
                        {
                            _local_3 = false;
                            break;
                        }
                    }
                    k++;
                }
            }
            else
            {
                _local_3 = false;
            }
            if (this._rectangleMasks.length > this._rectangleMasksOld.length)
            {
                _local_3 = false;
            }
            if (_local_3)
            {
                this._maskChanged = false;
            }
        }

        function updateMask(texture:BitmapData, geometry:IRoomGeometry)
        {
            var normal:IVector3d;
            var posX:Int;
            var posY:Int;
            var type:String;
            var wd:Int;
            var ht:Int;
            if ((((!this._useMask) || (((this._bitmapMasks.length == 0) && (this._rectangleMasks.length == 0)) && (!this._maskChanged))) || (this._maskManager == null)))
            {
                return;
            }
            if (((texture == null) || (geometry == null)))
            {
                return;
            }
            var mask:RoomPlaneBitmapMask;
            var rectMask:RoomPlaneRectangleMask;
            var i:Int;
            var j:Int;
            this.updateMaskChangeStatus();
            var width:Float = texture.width;
            var height:Float = texture.height;
            if ((((this._maskBitmapData == null) || (!(this._maskBitmapData.width == width))) || (!(this._maskBitmapData.height == height))))
            {
                if (this._maskBitmapData != null)
                {
                    this._maskBitmapData.dispose();
                    this._maskBitmapData = null;
                }
                try
                {
                    this._maskBitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0xFFFFFF);
                }
                catch(e:ASError)
                {
                    _maskBitmapData = null;
                    return;
                }
                this._maskChanged = true;
            }
            if (this._maskChanged)
            {
                this._bitmapMasksOld = [];
                this._rectangleMasksOld = [];
                if (this._maskBitmapData != null)
                {
                    this._maskBitmapData.fillRect(this._maskBitmapData.rect, 0xFFFFFF);
                }
                this.resetTextureCache(texture);
                normal = geometry.getCoordinatePosition(this._normal);
                posX = 0;
                posY = 0;
                i = 0;
                while (i < this._bitmapMasks.length)
                {
                    mask = ASCompat.dynamicAs(this._bitmapMasks[i] , RoomPlaneBitmapMask);
                    if (mask != null)
                    {
                        posX = Std.int(this._maskBitmapData.width - ((this._maskBitmapData.width * mask._Str_5120) / this._leftSide.length));
                        posY = Std.int(this._maskBitmapData.height - ((this._maskBitmapData.height * mask._Str_4659) / this._rightSide.length));
                        type = mask.type;
                        this._maskManager.updateMask(this._maskBitmapData, type, geometry.scale, normal, posX, posY);
                        this._bitmapMasksOld.push(new RoomPlaneBitmapMask(type, mask._Str_5120, mask._Str_4659));
                    }
                    i = (i + 1);
                }
                j = 0;
                while (j < this._rectangleMasks.length)
                {
                    rectMask = ASCompat.dynamicAs(this._rectangleMasks[j] , RoomPlaneRectangleMask);
                    if (rectMask != null)
                    {
                        posX = Std.int(this._maskBitmapData.width - ((this._maskBitmapData.width * rectMask._Str_5120) / this._leftSide.length));
                        posY = Std.int(this._maskBitmapData.height - ((this._maskBitmapData.height * rectMask._Str_4659) / this._rightSide.length));
                        wd = Std.int((this._maskBitmapData.width * rectMask._Str_9124) / this._leftSide.length);
                        ht = Std.int((this._maskBitmapData.height * rectMask._Str_12156) / this._rightSide.length);
                        this._maskBitmapData.fillRect(new Rectangle((posX - wd), (posY - ht), wd, ht), 0xFF000000);
                        this._rectangleMasksOld.push(new RoomPlaneRectangleMask(rectMask._Str_9124, rectMask._Str_4659, rectMask._Str_9124, rectMask._Str_12156));
                    }
                    j = (j + 1);
                }
                this._maskChanged = false;
            }
            this._Str_24790(texture, this._maskBitmapData);
        }

        function _Str_24790(texture:BitmapData, mask:BitmapData)
        {
            if (((texture == null) || (mask == null)))
            {
                return;
            }
            if (((!(this._maskBufferBitmapData == null)) && ((!(this._maskBufferBitmapData.width == texture.width)) || (!(this._maskBufferBitmapData.height == texture.height)))))
            {
                this._maskBufferBitmapData.dispose();
                this._maskBufferBitmapData = null;
            }
            if (this._maskBufferBitmapData == null)
            {
                try
                {
                    this._maskBufferBitmapData = new BitmapData(texture.width, texture.height, true, 0xFFFFFFFF);
                }
                catch(e:ASError)
                {
                    if (_maskBufferBitmapData != null)
                    {
                        _maskBufferBitmapData.dispose();
                    }
                    _maskBufferBitmapData = null;
                    return;
                }
            }
            this._maskBufferBitmapData.copyChannel(texture, texture.rect, ZERO_POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
            this._maskBufferBitmapData.draw(mask, null, null, BlendMode.DARKEN);
            texture.copyChannel(this._maskBufferBitmapData, this._maskBufferBitmapData.rect, ZERO_POINT, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
        }
    }

