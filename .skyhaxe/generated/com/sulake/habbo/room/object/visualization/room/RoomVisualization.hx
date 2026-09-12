package com.sulake.habbo.room.object.visualization.room
;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.room.object.visualization.IPlaneVisualization;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import flash.geom.Rectangle;
    import com.sulake.habbo.room.object.RoomPlaneBitmapMaskParser;
    import com.sulake.core.assets.IAsset;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object._enum.AlphaTolerance;
    import com.sulake.room.object._enum.RoomObjectSpriteType;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.object.RoomPlaneData;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.RoomPlaneBitmapMaskData;
    import com.sulake.room.object.visualization.IRoomPlane;

     class RoomVisualization extends RoomObjectSpriteVisualization implements IPlaneVisualization 
    {
        public static inline final FLOOR_COLOR= 0xFFFFFF;
        public static inline final FLOOR_COLOR_LEFT= 0xDDDDDD;
        public static inline final FLOOR_COLOR_RIGHT= 0xBBBBBB;
        static inline final WALL_COLOR_TOP= 0xFFFFFF;
        static inline final WALL_COLOR_SIDE= 0xCCCCCC;
        static inline final WALL_COLOR_BOTTOM= 0x999999;
        static inline final WALL_COLOR_BORDER= 0x999999;
        public static inline final LANDSCAPE_COLOR_TOP= 0xFFFFFF;
        public static inline final LANDSCAPE_COLOR_SIDE= 0xCCCCCC;
        public static inline final LANDSCAPE_COLOR_BOTTOM= 0x999999;
        static inline final ROOM_DEPTH_OFFSET:Float = 1000;

        static inline final _Str_9654= 250;

        var _data:RoomVisualizationData = null;
        var _assetLibrary:AssetLibrary = null;
        var _roomPlaneParser:RoomPlaneParser = null;
        var _planes:Array<ASAny>;
        var _planesInitialized:Bool = false;
        var _visiblePlanes:Array<ASAny>;
        var _visiblePlaneSpriteNumbers:Array<ASAny>;
        var _boundingRectangle:Rectangle = null;
        var _roomPlaneBitmapMaskParser:RoomPlaneBitmapMaskParser = null;
        var _wallType:String = null;
        var _floorType:String = null;
        var _landscapeType:String = null;
        var _floorThicknessMultiplier:Float = Math.NaN;
        var _wallThicknessMultiplier:Float = Math.NaN;
        var _floorHoleUpdateTime:Float = Math.NaN;
        var _planeMaskData:String = null;
        var _backgroundColor:UInt = 0xFFFFFF;
        var _backgroundRed:Int = 0xFF;
        var _backgroundGreen:Int = 0xFF;
        var _backgroundBlue:Int = 0xFF;
        var _colorizeBgOnly:Bool = true;
        var _assetUpdateCounter:Int = 0;
        var _geometryUpdateId:Int = -1000;
        var _roomGeometryUpdateId:Int = -1;
        var _highlightAreaX:Int = 0;
        var _highlightAreaY:Int = 0;
        var _highlightAreaWidth:Int = 0;
        var _highlightAreaHeight:Int = 0;
        var _highlightFilter:Array<ASAny>;
        var _geometryDirX:Float = 0;
        var _geometryDirY:Float = 0;
        var _geometryDirZ:Float = 0;
        var _geometryScale:Float = 0;
        var _planeTypeVisibilities:Array<ASAny>;

        public function new()
        {
            this._planes = [];
            this._visiblePlanes = [];
            this._visiblePlaneSpriteNumbers = [];
            this._planeTypeVisibilities = [];
            super();
            this._assetLibrary = new AssetLibrary("room visualization");
            this._roomPlaneParser = new RoomPlaneParser();
            this._roomPlaneBitmapMaskParser = new RoomPlaneBitmapMaskParser();
            this._planeTypeVisibilities[RoomPlane.TYPE_UNDEFINED] = false;
            this._planeTypeVisibilities[RoomPlane.TYPE_FLOOR] = true;
            this._planeTypeVisibilities[RoomPlane.TYPE_WALL] = true;
            this._planeTypeVisibilities[RoomPlane.TYPE_LANDSCAPE] = true;
        }

        public var floorRelativeDepth(get,never):Float;
public function  get_floorRelativeDepth():Float
        {
            return ROOM_DEPTH_OFFSET + 0.1;
        }

        public var wallRelativeDepth(get,never):Float;
public function  get_wallRelativeDepth():Float
        {
            return ROOM_DEPTH_OFFSET + 0.5;
        }

        public var wallAdRelativeDepth(get,never):Float;
public function  get_wallAdRelativeDepth():Float
        {
            return ROOM_DEPTH_OFFSET + 0.49;
        }

        public var _Str_3828(get,never):Int;
public function  get__Str_3828():Int
        {
            return this._planes.length;
        }

        override public function dispose()
        {
            var k = 0;
            var _local_2:IAsset = null;
            super.dispose();
            if (this._assetLibrary != null)
            {
                k = 0;
                while ((k : UInt) < this._assetLibrary.numAssets)
                {
                    _local_2 = this._assetLibrary.getAssetByIndex(k);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._assetLibrary.dispose();
                this._assetLibrary = null;
            }
            this.resetRoomPlanes();
            this._planes = null;
            this._visiblePlanes = null;
            this._visiblePlaneSpriteNumbers = null;
            if (this._roomPlaneParser != null)
            {
                this._roomPlaneParser.dispose();
                this._roomPlaneParser = null;
            }
            if (this._roomPlaneBitmapMaskParser != null)
            {
                this._roomPlaneBitmapMaskParser.dispose();
                this._roomPlaneBitmapMaskParser = null;
            }
            if (this._data != null)
            {
                this._data.clearCache();
                this._data = null;
            }
        }

        function resetRoomPlanes()
        {
            var k = 0;
            var _local_2:RoomPlane = null;
            if (this._planes != null)
            {
                k = 0;
                while (k < this._planes.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._planes[k] , RoomPlane);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._planes = [];
            }
            this._planesInitialized = false;
            this._assetUpdateCounter = (this._assetUpdateCounter + 1);
            this.reset();
        }

        override function reset()
        {
            super.reset();
            this._wallType = null;
            this._floorType = null;
            this._landscapeType = null;
            this._planeMaskData = null;
            this._roomGeometryUpdateId = -1;
            this._geometryScale = 0;
        }

        override public function  get_boundingRectangle():Rectangle
        {
            if (this._boundingRectangle == null)
            {
                this._boundingRectangle = super.boundingRectangle;
            }
            return new Rectangle(this._boundingRectangle.x, this._boundingRectangle.y, this._boundingRectangle.width, this._boundingRectangle.height);
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            this.reset();
            if (((k == null) || (!Std.is(k , RoomVisualizationData))))
            {
                return false;
            }
            this._data = Std.downcast(k , RoomVisualizationData);
            this._data.initializeAssetCollection(assetCollection);
            return true;
        }

        function _Str_18024()
        {
            var _local_3:RoomPlane = null;
            var _local_4:IRoomObjectSprite = null;
            var k= this._planes.length;
            createSprites(k);
            var _local_2 = 0;
            while (_local_2 < k)
            {
                _local_3 = ASCompat.dynamicAs(this._planes[_local_2] , RoomPlane);
                _local_4 = getSprite(_local_2);
                if (((((!(_local_4 == null)) && (!(_local_3 == null))) && (!(_local_3.leftSide == null))) && (!(_local_3.rightSide == null))))
                {
                    if (((_local_3.type == RoomPlane.TYPE_WALL) && ((_local_3.leftSide.length < 1) || (_local_3.rightSide.length < 1))))
                    {
                        _local_4.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
                    }
                    else
                    {
                        _local_4.alphaTolerance = AlphaTolerance.MATCH_OPAQUE_PIXELS;
                    }
                    if (_local_3.type == RoomPlane.TYPE_WALL)
                    {
                        _local_4.tag = ("plane.wall@" + Std.string(_local_2 + 1));
                    }
                    else
                    {
                        if (_local_3.type == RoomPlane.TYPE_FLOOR)
                        {
                            _local_4.tag = ("plane.floor@" + Std.string(_local_2 + 1));
                        }
                        else
                        {
                            _local_4.tag = ("plane@" + Std.string(_local_2 + 1));
                        }
                    }
                    _local_4.spriteType = RoomObjectSpriteType.ROOM_PLANE;
                    if (this._roomPlaneParser.isPlaneTemporaryHighlighter(_local_2))
                    {
                        _local_4.filters = this._highlightFilter;
                        _local_4.skipMouseHandling = true;
                        _local_3.extraDepth = -100;
                        _local_3.isHighlighter = true;
                    }
                    else
                    {
                        _local_4.filters = [];
                        _local_4.skipMouseHandling = false;
                        _local_3.extraDepth = 0;
                        _local_3.isHighlighter = false;
                    }
                }
                _local_2++;
            }
        }

        public function initializeHighlightArea(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Array<ASAny>)
        {
            this._highlightAreaX = k;
            this._highlightAreaY = _arg_2;
            this._highlightAreaWidth = _arg_3;
            this._highlightAreaHeight = _arg_4;
            this._highlightFilter = _arg_5;
            this.resetRoomPlanes();
        }

        public function clearHighlightArea()
        {
            this._highlightAreaX = 0;
            this._highlightAreaY = 0;
            this._highlightAreaWidth = 0;
            this._highlightAreaHeight = 0;
            this._highlightFilter = null;
            this.resetRoomPlanes();
        }

        function _Str_25732()
        {
            var _local_8:IVector3d = null;
            var _local_9:IVector3d = null;
            var _local_10:IVector3d = null;
            var _local_11:Array<ASAny> = null;
            var _local_12 = 0;
            var _local_13:RoomPlane = null;
            var _local_14:IVector3d = null;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            var _local_17 = Math.NaN;
            var _local_18 = Math.NaN;
            var _local_19 = 0;
            var _local_20 = Math.NaN;
            var _local_21 = Math.NaN;
            var _local_22 = Math.NaN;
            var _local_23 = Math.NaN;
            if (this._planesInitialized)
            {
                return;
            }
            var k= object;
            if (k == null)
            {
                return;
            }
            if (!Math.isNaN(this._floorThicknessMultiplier))
            {
                this._roomPlaneParser.floorThicknessMultiplier = this._floorThicknessMultiplier;
            }
            if (!Math.isNaN(this._wallThicknessMultiplier))
            {
                this._roomPlaneParser.wallThicknessMultiplier = this._wallThicknessMultiplier;
            }
            var _local_2= k.getModel().getString(RoomObjectVariableEnum.ROOM_PLANE_XML);
            if (!this._roomPlaneParser.initializeFromXML(new com.sulake.core.utils.xml.XML(_local_2)))
            {
                return;
            }
            // Wired 2.0 area selection: re-apply the highlight rectangle on every
            // plane (re)build so the highlighted floor renders as its own planes.
            if ((this._highlightAreaWidth > 0) && (this._highlightAreaHeight > 0))
            {
                this._roomPlaneParser.initializeHighlightArea(this._highlightAreaX, this._highlightAreaY, this._highlightAreaWidth, this._highlightAreaHeight);
            }
            var _local_3= this.getLandscapeWidth();
            var _local_4= this.getLandscapeHeight();
            var _local_5:Float = 0;
            var _local_6= Std.int(k.getModel().getNumber(RoomObjectVariableEnum.ROOM_RANDOM_SEED));
            var _local_7 = 0;
            while (_local_7 < this._roomPlaneParser._Str_3828)
            {
                _local_8 = this._roomPlaneParser.getPlaneLocation(_local_7);
                _local_9 = this._roomPlaneParser.getPlaneLeftSide(_local_7);
                _local_10 = this._roomPlaneParser.getPlaneRightSide(_local_7);
                _local_11 = this._roomPlaneParser.getPlaneSecondaryNormals(_local_7);
                _local_12 = this._roomPlaneParser.getPlaneType(_local_7);
                _local_13 = null;
                if ((((!(_local_8 == null)) && (!(_local_9 == null))) && (!(_local_10 == null))))
                {
                    _local_14 = Vector3d.crossProduct(_local_9, _local_10);
                    _local_6 = ((_local_6 * 7613) + 517);
                    _local_13 = null;
                    if (_local_12 == RoomPlaneData.PLANE_FLOOR)
                    {
                        _local_15 = ((_local_8.x + _local_9.x) + 0.5);
                        _local_16 = ((_local_8.y + _local_10.y) + 0.5);
                        _local_17 = (Std.int(_local_15) - _local_15);
                        _local_18 = (Std.int(_local_16) - _local_16);
                        _local_13 = new RoomPlane(k.getLocation(), _local_8, _local_9, _local_10, RoomPlane.TYPE_FLOOR, true, _local_11, _local_6, -_local_17, -_local_18);
                        if (_local_14.z != 0)
                        {
                            _local_13.color = FLOOR_COLOR;
                        }
                        else
                        {
                            _local_13.color = ((_local_14.x != 0) ? FLOOR_COLOR_RIGHT : FLOOR_COLOR_LEFT);
                        }
                        if (this._data != null)
                        {
                            _local_13.rasterizer = this._data.floorRasterizer;
                        }
                    }
                    else
                    {
                        if (_local_12 == RoomPlaneData.PLANE_WALL)
                        {
                            _local_13 = new RoomPlane(k.getLocation(), _local_8, _local_9, _local_10, RoomPlane.TYPE_WALL, true, _local_11, _local_6);
                            if (((_local_9.length < 1) || (_local_10.length < 1)))
                            {
                                _local_13._Str_18448 = false;
                            }
                            if (((_local_14.x == 0) && (_local_14.y == 0)))
                            {
                                _local_13.color = WALL_COLOR_BORDER;
                            }
                            else
                            {
                                if (_local_14.y > 0)
                                {
                                    _local_13.color = WALL_COLOR_TOP;
                                }
                                else
                                {
                                    if (_local_14.y == 0)
                                    {
                                        _local_13.color = WALL_COLOR_SIDE;
                                    }
                                    else
                                    {
                                        _local_13.color = WALL_COLOR_BOTTOM;
                                    }
                                }
                            }
                            if (this._data != null)
                            {
                                _local_13.rasterizer = this._data.wallRasterizer;
                            }
                        }
                        else
                        {
                            if (_local_12 == RoomPlaneData.PLANE_LANDSCAPE)
                            {
                                _local_13 = new RoomPlane(k.getLocation(), _local_8, _local_9, _local_10, RoomPlane.TYPE_LANDSCAPE, true, _local_11, _local_6, _local_5, 0, _local_3, _local_4);
                                if (_local_14.y > 0)
                                {
                                    _local_13.color = LANDSCAPE_COLOR_TOP;
                                }
                                else
                                {
                                    if (_local_14.y == 0)
                                    {
                                        _local_13.color = LANDSCAPE_COLOR_SIDE;
                                    }
                                    else
                                    {
                                        _local_13.color = LANDSCAPE_COLOR_BOTTOM;
                                    }
                                }
                                if (this._data != null)
                                {
                                    _local_13.rasterizer = this._data.landscapeRasterizer;
                                }
                                _local_5 = (_local_5 + _local_9.length);
                            }
                            else
                            {
                                if (_local_12 == RoomPlaneData.PLANE_BILLBOARD)
                                {
                                    _local_13 = new RoomPlane(k.getLocation(), _local_8, _local_9, _local_10, RoomPlane.TYPE_WALL, true, _local_11, _local_6);
                                    if (((_local_9.length < 1) || (_local_10.length < 1)))
                                    {
                                        _local_13._Str_18448 = false;
                                    }
                                    if (((_local_14.x == 0) && (_local_14.y == 0)))
                                    {
                                        _local_13.color = WALL_COLOR_BORDER;
                                    }
                                    else
                                    {
                                        if (_local_14.y > 0)
                                        {
                                            _local_13.color = WALL_COLOR_TOP;
                                        }
                                        else
                                        {
                                            if (_local_14.y == 0)
                                            {
                                                _local_13.color = WALL_COLOR_SIDE;
                                            }
                                            else
                                            {
                                                _local_13.color = WALL_COLOR_BOTTOM;
                                            }
                                        }
                                    }
                                    if (this._data != null)
                                    {
                                        _local_13.rasterizer = this._data.wallAdRasterizr;
                                    }
                                }
                            }
                        }
                    }
                    if (_local_13 != null)
                    {
                        _local_13._Str_16279 = this._data._Str_16279;
                        _local_19 = 0;
                        while (_local_19 < this._roomPlaneParser.getPlaneMaskCount(_local_7))
                        {
                            _local_20 = this._roomPlaneParser.getPlaneMaskLeftSideLoc(_local_7, _local_19);
                            _local_21 = this._roomPlaneParser.getPlaneMaskRightSideLoc(_local_7, _local_19);
                            _local_22 = this._roomPlaneParser.getPlaneMaskLeftSideLength(_local_7, _local_19);
                            _local_23 = this._roomPlaneParser.getPlaneMaskRightSideLength(_local_7, _local_19);
                            _local_13.addRectangleMask(_local_20, _local_21, _local_22, _local_23);
                            _local_19++;
                        }
                        this._planes.push(_local_13);
                    }
                }
                else
                {
                    return;
                }
                _local_7++;
            }
            this._planesInitialized = true;
            this._Str_18024();
        }

        function getLandscapeWidth():Float
        {
            var _local_3 = 0;
            var _local_4:IVector3d = null;
            var k:Float = 0;
            var _local_2 = 0;
            while (_local_2 < this._roomPlaneParser._Str_3828)
            {
                _local_3 = this._roomPlaneParser.getPlaneType(_local_2);
                if (_local_3 == RoomPlaneData.PLANE_LANDSCAPE)
                {
                    _local_4 = this._roomPlaneParser.getPlaneLeftSide(_local_2);
                    k = (k + _local_4.length);
                }
                _local_2++;
            }
            return k;
        }

        function getLandscapeHeight():Float
        {
            var _local_3 = 0;
            var _local_4:IVector3d = null;
            var k:Float = 0;
            var _local_2 = 0;
            while (_local_2 < this._roomPlaneParser._Str_3828)
            {
                _local_3 = this._roomPlaneParser.getPlaneType(_local_2);
                if (_local_3 == RoomPlaneData.PLANE_LANDSCAPE)
                {
                    _local_4 = this._roomPlaneParser.getPlaneRightSide(_local_2);
                    if (_local_4.length > k)
                    {
                        k = _local_4.length;
                    }
                }
                _local_2++;
            }
            if (k > 5)
            {
                k = 5;
            }
            return k;
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12:IRoomObjectSprite = null;
            var _local_13:RoomPlane = null;
            var _local_14:UInt = 0;
            var _local_15:UInt = 0;
            var _local_16:UInt = 0;
            var _local_17:UInt = 0;
            var _local_18:UInt = 0;
            var _local_5= object;
            if (_local_5 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            var _local_6= this.updateGeometry(k);
            var _local_7= _local_5.getModel();
            var _local_8 = false;
            if (this.updatePlaneThicknesses(_local_7))
            {
                _local_8 = true;
            }
            if (this._Str_18134(_local_7))
            {
                _local_8 = true;
            }
            this._Str_25732();
            _local_8 = this.updateMasksAndColors(_local_7);
            var _local_9= _arg_2;
            if ((((_local_9 < (this._geometryUpdateId + RoomVisualization._Str_9654)) && (!_local_6)) && (!_local_8)))
            {
                return;
            }
            if (this.updatePlaneTexturesAndVisibilities(_local_7))
            {
                _local_8 = true;
            }
            if (this._Str_16913(k, _local_6, _arg_2))
            {
                _local_8 = true;
            }
            if (_local_8)
            {
                _local_10 = 0;
                while (_local_10 < this._visiblePlanes.length)
                {
                    _local_11 = ASCompat.toInt(this._visiblePlaneSpriteNumbers[_local_10]);
                    _local_12 = getSprite(_local_11);
                    _local_13 = ASCompat.dynamicAs(this._visiblePlanes[_local_10] , RoomPlane);
                    if ((((!(_local_12 == null)) && (!(_local_13 == null))) && (!(_local_13.type == RoomPlane.TYPE_LANDSCAPE))))
                    {
                        if (this._colorizeBgOnly)
                        {
                            _local_14 = _local_13.color;
                            _local_15 = Std.int(((ASCompat.toInt(_local_14 )& 0xFF) * this._backgroundBlue) / 0xFF);
                            _local_16 = Std.int((((ASCompat.toInt(_local_14 )>> 8) & 0xFF) * this._backgroundGreen) / 0xFF);
                            _local_17 = Std.int((((ASCompat.toInt(_local_14 )>> 16) & 0xFF) * this._backgroundRed) / 0xFF);
                            _local_18 = (ASCompat.toInt(_local_14 )>> 24);
                            _local_14 = ((((ASCompat.toInt(_local_18 )<< 24) + (ASCompat.toInt(_local_17 )<< 16)) + (ASCompat.toInt(_local_16 )<< 8)) + _local_15);
                            _local_12.color = ASCompat.toInt(_local_14);
                        }
                        else
                        {
                            _local_12.color = ASCompat.toInt(_local_13.color);
                        }
                    }
                    _local_10++;
                }
                increaseUpdateId();
            }
            _modelUpdateID = _local_7.getUpdateID();
            this._geometryUpdateId = _local_9;
        }

        function updateGeometry(k:IRoomGeometry):Bool
        {
            var _local_3:IVector3d = null;
            var _local_2 = false;
            if (k.updateId != this._roomGeometryUpdateId)
            {
                this._roomGeometryUpdateId = k.updateId;
                this._boundingRectangle = null;
                _local_3 = k.direction;
                if (((!(_local_3 == null)) && ((((!(_local_3.x == this._geometryDirX)) || (!(_local_3.y == this._geometryDirY))) || (!(_local_3.z == this._geometryDirZ))) || (!(k.scale == this._geometryScale)))))
                {
                    this._geometryDirX = _local_3.x;
                    this._geometryDirY = _local_3.y;
                    this._geometryDirZ = _local_3.z;
                    this._geometryScale = k.scale;
                    _local_2 = true;
                }
            }
            return _local_2;
        }

        function updateMasksAndColors(k:IRoomObjectModel):Bool
        {
            var _local_3:String = null;
            var _local_4:UInt = 0;
            var _local_5 = false;
            var _local_2 = false;
            if (_modelUpdateID != k.getUpdateID())
            {
                _local_3 = k.getString(RoomObjectVariableEnum.ROOM_PLANE_MASK_XML);
                if (_local_3 != this._planeMaskData)
                {
                    this._Str_15935(_local_3);
                    this._planeMaskData = _local_3;
                    _local_2 = true;
                }
                _local_4 = Std.int(k.getNumber(RoomObjectVariableEnum.ROOM_BACKGROUND_COLOR));
                if (_local_4 != this._backgroundColor)
                {
                    this._backgroundColor = _local_4;
                    this._backgroundBlue = (ASCompat.toInt(this._backgroundColor )& 0xFF);
                    this._backgroundGreen = ((ASCompat.toInt(this._backgroundColor )>> 8) & 0xFF);
                    this._backgroundRed = ((ASCompat.toInt(this._backgroundColor )>> 16) & 0xFF);
                    _local_2 = true;
                }
                _local_5 = ASCompat.toBool(k.getNumber(RoomObjectVariableEnum.ROOM_COLORIZE_BG_ONLY));
                if (_local_5 != this._colorizeBgOnly)
                {
                    this._colorizeBgOnly = _local_5;
                    _local_2 = true;
                }
            }
            return _local_2;
        }

        function updatePlaneTexturesAndVisibilities(k:IRoomObjectModel):Bool
        {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5 = false;
            var _local_6 = false;
            var _local_7 = false;
            if (_modelUpdateID != k.getUpdateID())
            {
                _local_2 = k.getString(RoomObjectVariableEnum.ROOM_WALL_TYPE);
                _local_3 = k.getString(RoomObjectVariableEnum.ROOM_FLOOR_TYPE);
                _local_4 = k.getString(RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE);
                this.updatePlaneTextureTypes(_local_3, _local_2, _local_4);
                _local_5 = ASCompat.toBool(k.getNumber(RoomObjectVariableEnum.ROOM_FLOOR_VISIBILITY));
                _local_6 = ASCompat.toBool(k.getNumber(RoomObjectVariableEnum.ROOM_WALL_VISIBILITY));
                _local_7 = ASCompat.toBool(k.getNumber(RoomObjectVariableEnum.ROOM_LANDSCAPE_VISIBILITY));
                this.updatePlaneTypeVisibilities(_local_5, _local_6, _local_7);
                return true;
            }
            return false;
        }

        function updatePlaneThicknesses(k:IRoomObjectModel):Bool
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            if (_modelUpdateID != k.getUpdateID())
            {
                _local_2 = k.getNumber(RoomObjectVariableEnum.ROOM_FLOOR_THICKNESS);
                _local_3 = k.getNumber(RoomObjectVariableEnum.ROOM_WALL_THICKNESS);
                if ((((!Math.isNaN(_local_2)) && (!Math.isNaN(_local_3))) && ((!(_local_2 == this._floorThicknessMultiplier)) || (!(_local_3 == this._wallThicknessMultiplier)))))
                {
                    this._floorThicknessMultiplier = _local_2;
                    this._wallThicknessMultiplier = _local_3;
                    this.resetRoomPlanes();
                    return true;
                }
            }
            return false;
        }

        function _Str_18134(k:IRoomObjectModel):Bool
        {
            var _local_2 = Math.NaN;
            if (_modelUpdateID != k.getUpdateID())
            {
                _local_2 = k.getNumber(RoomObjectVariableEnum.ROOM_FLOOR_HOLE_UPDATE_TIME);
                if (((!Math.isNaN(_local_2)) && (!(_local_2 == this._floorHoleUpdateTime))))
                {
                    this._floorHoleUpdateTime = _local_2;
                    this.resetRoomPlanes();
                    return true;
                }
            }
            return false;
        }

        function updatePlaneTextureTypes(k:String, _arg_2:String, _arg_3:String):Bool
        {
            var _local_5:RoomPlane = null;
            if (k != this._floorType)
            {
                this._floorType = k;
            }
            else
            {
                k = null;
            }
            if (_arg_2 != this._wallType)
            {
                this._wallType = _arg_2;
            }
            else
            {
                _arg_2 = null;
            }
            if (_arg_3 != this._landscapeType)
            {
                this._landscapeType = _arg_3;
            }
            else
            {
                _arg_3 = null;
            }
            if ((((k == null) && (_arg_2 == null)) && (_arg_3 == null)))
            {
                return false;
            }
            var _local_4 = 0;
            while (_local_4 < this._planes.length)
            {
                _local_5 = ASCompat.dynamicAs(this._planes[_local_4] , RoomPlane);
                if (_local_5 != null)
                {
                    if (((_local_5.type == RoomPlane.TYPE_FLOOR) && (!(k == null))))
                    {
                        _local_5.id = k;
                    }
                    else
                    {
                        if (((_local_5.type == RoomPlane.TYPE_WALL) && (!(_arg_2 == null))))
                        {
                            _local_5.id = _arg_2;
                        }
                        else
                        {
                            if (((_local_5.type == RoomPlane.TYPE_LANDSCAPE) && (!(_arg_3 == null))))
                            {
                                _local_5.id = _arg_3;
                            }
                        }
                    }
                }
                _local_4++;
            }
            return true;
        }

        function updatePlaneTypeVisibilities(k:Bool, _arg_2:Bool, _arg_3:Bool)
        {
            if ((((!(k == this._planeTypeVisibilities[RoomPlane.TYPE_FLOOR])) || (!(_arg_2 == this._planeTypeVisibilities[RoomPlane.TYPE_WALL]))) || (!(_arg_3 == this._planeTypeVisibilities[RoomPlane.TYPE_LANDSCAPE]))))
            {
                this._planeTypeVisibilities[RoomPlane.TYPE_FLOOR] = k;
                this._planeTypeVisibilities[RoomPlane.TYPE_WALL] = _arg_2;
                this._planeTypeVisibilities[RoomPlane.TYPE_LANDSCAPE] = _arg_3;
                this._visiblePlanes = [];
                this._visiblePlaneSpriteNumbers = [];
            }
        }

        function _Str_16913(k:IRoomGeometry, _arg_2:Bool, _arg_3:Int):Bool
        {
            var _local_10 = 0;
            var _local_11:IRoomObjectSprite = null;
            var _local_12:RoomPlane = null;
            var _local_13 = Math.NaN;
            var _local_14:String = null;
            var _local_4= object;
            if (_local_4 == null)
            {
                return false;
            }
            if (k == null)
            {
                return false;
            }
            this._assetUpdateCounter++;
            if (_arg_2)
            {
                this._visiblePlanes = [];
                this._visiblePlaneSpriteNumbers = [];
            }
            var _local_5= _arg_3;
            var _local_6= this._visiblePlanes;
            if (this._visiblePlanes.length == 0)
            {
                _local_6 = this._planes;
            }
            var _local_7 = false;
            var _local_8:ASAny = (this._visiblePlanes.length > 0);
            var _local_9 = 0;
            while (_local_9 < _local_6.length)
            {
                _local_10 = _local_9;
                if (_local_8)
                {
                    _local_10 = ASCompat.toInt(this._visiblePlaneSpriteNumbers[_local_9]);
                }
                _local_11 = getSprite(_local_10);
                if (_local_11 != null)
                {
                    _local_12 = ASCompat.dynamicAs(_local_6[_local_9] , RoomPlane);
                    if (_local_12 != null)
                    {
                        _local_11.planeId = _local_12.uniqueId;
                        if (_local_12.update(k, _local_5))
                        {
                            if (_local_12.visible)
                            {
                                _local_13 = ((_local_12.relativeDepth + this.floorRelativeDepth) + (_local_10 / 1000));
                                if (_local_12.type != RoomPlane.TYPE_FLOOR)
                                {
                                    _local_13 = ((_local_12.relativeDepth + this.wallRelativeDepth) + (_local_10 / 1000));
                                    if (((_local_12.leftSide.length < 1) || (_local_12.rightSide.length < 1)))
                                    {
                                        _local_13 = (_local_13 + (ROOM_DEPTH_OFFSET * 0.5));
                                    }
                                }
                                _local_14 = ((("plane " + Std.string(_local_10)) + " ") + Std.string(k.scale));
                                this.updateSprite(_local_11, _local_12, _local_14, _local_13);
                            }
                            _local_7 = true;
                        }
                        if (_local_11.visible != (_local_12.visible && this._planeTypeVisibilities[_local_12.type]))
                        {
                            _local_11.visible = (!_local_11.visible);
                            _local_7 = true;
                        }
                        if (_local_11.visible)
                        {
                            if (!_local_8)
                            {
                                this._visiblePlanes.push(_local_12);
                                this._visiblePlaneSpriteNumbers.push(_local_9);
                            }
                        }
                    }
                    else
                    {
                        _local_11.planeId = 0;
                        if (_local_11.visible)
                        {
                            _local_11.visible = false;
                            _local_7 = true;
                        }
                    }
                }
                _local_9++;
            }
            return _local_7;
        }

        function updateSprite(k:IRoomObjectSprite, _arg_2:RoomPlane, _arg_3:String, _arg_4:Float)
        {
            var _local_5= _arg_2.offset;
            k.offsetX = Std.int(-_local_5.x);
            k.offsetY = Std.int(-_local_5.y);
            k.relativeDepth = _arg_4;
            k.color = ASCompat.toInt(_arg_2.color);
            k.asset = this.getPlaneBitmap(_arg_2, _arg_3);
            k.assetName = ((_arg_3 + "_") + Std.string(this._assetUpdateCounter));
        }

        function getPlaneBitmap(k:RoomPlane, _arg_2:String):BitmapData
        {
            var _local_3= Std.downcast(this._assetLibrary.getAssetByName(_arg_2) , BitmapDataAsset);
            if (_local_3 == null)
            {
                _local_3 = new BitmapDataAsset(this._assetLibrary.getAssetTypeDeclarationByClass(BitmapDataAsset));
                this._assetLibrary.setAsset(_arg_2, _local_3);
            }
            var _local_4= ASCompat.dynamicAs(_local_3.content , BitmapData);
            var _local_5= k.copyBitmapData(_local_4);
            if (_local_5 == null)
            {
                _local_5 = k.bitmapData;
                if (_local_5 != null)
                {
                    if (_local_4 != _local_5)
                    {
                        if (_local_4 != null)
                        {
                            _local_4.dispose();
                        }
                        _local_3.setUnknownContent(_local_5);
                    }
                }
            }
            return _local_5;
        }

        function _Str_15935(k:String)
        {
            var _local_10:String = null;
            var _local_11:IVector3d = null;
            var _local_12:String = null;
            var _local_13 = 0;
            var _local_14:IVector3d = null;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            var _local_17 = Math.NaN;
            var _local_18 = 0;
            if (k == null)
            {
                return;
            }
            var _local_2= new com.sulake.core.utils.xml.XML(k);
            this._roomPlaneBitmapMaskParser.initialize(_local_2);
            var _local_3:RoomPlane = null;
            var _local_4:Array<ASAny> = [];
            var _local_5:Array<ASAny> = [];
            var _local_6 = false;
            var _local_7 = 0;
            while (_local_7 < this._planes.length)
            {
                _local_3 = ASCompat.dynamicAs(this._planes[_local_7] , RoomPlane);
                if (_local_3 != null)
                {
                    _local_3.resetBitmapMasks();
                    if (_local_3.type == RoomPlane.TYPE_LANDSCAPE)
                    {
                        _local_4.push(_local_7);
                    }
                }
                _local_7++;
            }
            var _local_8 = 0;
            while (_local_8 < this._roomPlaneBitmapMaskParser.maskCount)
            {
                _local_10 = this._roomPlaneBitmapMaskParser.getMaskType(_local_8);
                _local_11 = this._roomPlaneBitmapMaskParser.getMaskLocation(_local_8);
                _local_12 = this._roomPlaneBitmapMaskParser.getMaskCategory(_local_8);
                if (_local_11 != null)
                {
                    _local_13 = 0;
                    while (_local_13 < this._planes.length)
                    {
                        _local_3 = ASCompat.dynamicAs(this._planes[_local_13] , RoomPlane);
                        if (((_local_3.type == RoomPlane.TYPE_WALL) || (_local_3.type == RoomPlane.TYPE_LANDSCAPE)))
                        {
                            if ((((!(_local_3 == null)) && (!(_local_3.location == null))) && (!(_local_3.normal == null))))
                            {
                                _local_14 = Vector3d.dif(_local_11, _local_3.location);
                                _local_15 = Math.abs(Vector3d.scalarProjection(_local_14, _local_3.normal));
                                if (_local_15 < 0.01)
                                {
                                    if (((!(_local_3.leftSide == null)) && (!(_local_3.rightSide == null))))
                                    {
                                        _local_16 = Vector3d.scalarProjection(_local_14, _local_3.leftSide);
                                        _local_17 = Vector3d.scalarProjection(_local_14, _local_3.rightSide);
                                        if (((_local_3.type == RoomPlane.TYPE_WALL) || ((_local_3.type == RoomPlane.TYPE_LANDSCAPE) && (_local_12 == RoomPlaneBitmapMaskData.HOLE))))
                                        {
                                            _local_3.addBitmapMask(_local_10, _local_16, _local_17);
                                        }
                                        else
                                        {
                                            if (_local_3.type == RoomPlane.TYPE_LANDSCAPE)
                                            {
                                                if (!_local_3._Str_14801)
                                                {
                                                    _local_6 = true;
                                                }
                                                _local_3._Str_14801 = true;
                                                _local_5.push(_local_13);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        _local_13++;
                    }
                }
                _local_8++;
            }
            var _local_9 = 0;
            while (_local_9 < _local_4.length)
            {
                _local_18 = ASCompat.toInt(_local_4[_local_9]);
                if (_local_5.indexOf(_local_18) < 0)
                {
                    _local_3 = ASCompat.dynamicAs(this._planes[_local_18] , RoomPlane);
                    _local_3._Str_14801 = false;
                    _local_6 = true;
                }
                _local_9++;
            }
            if (_local_6)
            {
                this._visiblePlanes = [];
                this._visiblePlaneSpriteNumbers = [];
            }
        }

        public var _Str_19113(get,never):Vector<IRoomPlane>;
public function  get__Str_19113():Vector<IRoomPlane>
        {
            var _local_2:RoomPlane = null;
            var k= new Vector<IRoomPlane>(0);
            final _iter_ = this._visiblePlanes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push(_local_2);
            }
            return k;
        }
    }

