package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.IPlaneRasterizer;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.RoomGeometry;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.room.utils.Rasterizer;
    import flash.geom.Point;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;

     class PlaneRasterizer implements IPlaneRasterizer 
    {
        static inline final DEFAULT= "default";

        var _assetCollection:IGraphicAssetCollection = null;
        var _materials:Map = null;
        var _textures:Map = null;
        var _planes:Map = null;
        var _geometries:Map = null;
        var _data:com.sulake.core.utils.xml.XML = null;

        public function new()
        {
            this._textures = new Map();
            this._materials = new Map();
            this._planes = new Map();
            this._geometries = new Map();
        }

        var data(get,never):com.sulake.core.utils.xml.XML;
function  get_data():com.sulake.core.utils.xml.XML
        {
            return this._data;
        }

        var assetCollection(get,never):IGraphicAssetCollection;
function  get_assetCollection():IGraphicAssetCollection
        {
            return this._assetCollection;
        }

        public function initializeDimensions(k:Int, _arg_2:Int):Bool
        {
            return true;
        }

        public function dispose()
        {
            var _local_2:Plane;
            var _local_3:RoomGeometry;
            var k:Int;
            if (this._planes != null)
            {
                k = 0;
                while ((k : UInt) < this._planes.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._planes.getWithIndex(k) , Plane);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._planes.dispose();
                this._planes = null;
            }
            if (this._materials != null)
            {
                this.resetMaterials();
                this._materials.dispose();
                this._materials = null;
            }
            if (this._textures != null)
            {
                this.resetTextures();
                this._textures.dispose();
                this._textures = null;
            }
            if (this._geometries != null)
            {
                k = 0;
                while ((k : UInt) < this._geometries.length)
                {
                    _local_3 = this._geometries.getWithIndex(k);
                    if (_local_3 != null)
                    {
                        _local_3.dispose();
                    }
                    k++;
                }
                this._geometries.dispose();
                this._geometries = null;
            }
            this._data = null;
            this._assetCollection = null;
        }

        public function clearCache()
        {
            var _local_2:Plane;
            var _local_3:PlaneMaterial;
            var k:Int;
            k = 0;
            while ((k : UInt) < this._planes.length)
            {
                _local_2 = ASCompat.dynamicAs(this._planes.getWithIndex(k) , Plane);
                if (_local_2 != null)
                {
                    _local_2.clearCache();
                }
                k++;
            }
            k = 0;
            while ((k : UInt) < this._materials.length)
            {
                _local_3 = ASCompat.dynamicAs(this._materials.getWithIndex(k) , PlaneMaterial);
                if (_local_3 != null)
                {
                    _local_3.clearCache();
                }
                k++;
            }
        }

        public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            this._data = k;
        }

        public function reinitialize()
        {
            this.resetTextures();
            this.resetMaterials();
            this.initializeAll();
        }

        function resetMaterials()
        {
            var _local_2:PlaneMaterial;
            var k = 0;
            while ((k : UInt) < this._materials.length)
            {
                _local_2 = ASCompat.dynamicAs(this._materials.getWithIndex(k) , PlaneMaterial);
                if (_local_2 != null)
                {
                    _local_2.dispose();
                }
                k++;
            }
            this._materials.reset();
        }

        function resetTextures()
        {
            var _local_2:PlaneTexture;
            var k = 0;
            while ((k : UInt) < this._textures.length)
            {
                _local_2 = ASCompat.dynamicAs(this._textures.getWithIndex(k) , PlaneTexture);
                if (_local_2 != null)
                {
                    _local_2.dispose();
                }
                k++;
            }
            this._textures.reset();
        }

        function getTexture(k:String):PlaneTexture
        {
            return ASCompat.dynamicAs(this._textures.getValue(k) , PlaneTexture);
        }

        function material(k:String):PlaneMaterial
        {
            return ASCompat.dynamicAs(this._materials.getValue(k) , PlaneMaterial);
        }

        function getPlane(k:String):Plane
        {
            return this._planes.getValue(k);
        }

        function _Str_3453(k:String, _arg_2:Plane):Bool
        {
            if (_arg_2 == null)
            {
                return false;
            }
            if (this._planes.getValue(k) == null)
            {
                this._planes.add(k, _arg_2);
                return true;
            }
            return false;
        }

        public function initializeAssetCollection(k:IGraphicAssetCollection)
        {
            if (this.data == null)
            {
                return;
            }
            this._assetCollection = k;
            this.initializeAll();
        }

        function initializeAll()
        {
            if (this.data == null)
            {
                return;
            }
            this.initializeTexturesAndMaterials();
            this.initializePlanes();
        }

        function initializeTexturesAndMaterials()
        {
            var k= this.data.child("textures");
            if (k.length() > 0)
            {
                this.parseTextures(k.at(0), this.assetCollection);
            }
            var _local_2= this.data.child("materials");
            if (_local_2.length() > 0)
            {
                this.parsePlaneMaterials(_local_2.at(0));
            }
        }

        function initializePlanes()
        {
        }

        function parseTextures(k:com.sulake.core.utils.xml.XML, _arg_2:IGraphicAssetCollection)
        {
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:String;
            var _local_7:PlaneTexture;
            var _local_8:com.sulake.core.utils.xml.XMLList;
            var _local_9:Int;
            var _local_10:com.sulake.core.utils.xml.XML;
            var _local_11:Float;
            var _local_12:Float;
            var _local_13:Float;
            var _local_14:Float;
            var _local_15:String;
            var _local_16:IGraphicAsset;
            var _local_17:BitmapDataAsset;
            var _local_18:BitmapData;
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            var _local_3= k.child("texture");
            var _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                if (XMLValidator.checkRequiredAttributes(_local_5, ["id"]))
                {
                    _local_6 = _local_5.attribute("id").toString();
                    if (this._textures.getValue(_local_6) == null)
                    {
                        _local_7 = new PlaneTexture();
                        _local_8 = _local_5.child("bitmap");
                        _local_9 = 0;
                        while (_local_9 < _local_8.length())
                        {
                            _local_10 = _local_8.at(_local_9);
                            if (XMLValidator.checkRequiredAttributes(_local_10, ["assetName"]))
                            {
                                _local_11 = PlaneTexture.MIN_NORMAL_COORDINATE_VALUE;
                                _local_12 = PlaneTexture.MAX_NORMAL_COORDINATE_VALUE;
                                _local_13 = PlaneTexture.MIN_NORMAL_COORDINATE_VALUE;
                                _local_14 = PlaneTexture.MAX_NORMAL_COORDINATE_VALUE;
                                if (_local_10.attribute("normalMinX").toString() != "")
                                {
                                    _local_11 = Std.parseFloat(_local_10.attribute("normalMinX").toString());
                                }
                                if (_local_10.attribute("normalMaxX").toString() != "")
                                {
                                    _local_12 = Std.parseFloat(_local_10.attribute("normalMaxX").toString());
                                }
                                if (_local_10.attribute("normalMinY").toString() != "")
                                {
                                    _local_13 = Std.parseFloat(_local_10.attribute("normalMinY").toString());
                                }
                                if (_local_10.attribute("normalMaxY").toString() != "")
                                {
                                    _local_14 = Std.parseFloat(_local_10.attribute("normalMaxY").toString());
                                }
                                _local_15 = _local_10.attribute("assetName").toString();
                                _local_16 = _arg_2.getAsset(_local_15);
                                if (_local_16 != null)
                                {
                                    _local_17 = Std.downcast(_local_16.asset , BitmapDataAsset);
                                    if (_local_17 != null)
                                    {
                                        _local_18 = ASCompat.dynamicAs(_local_17.content , BitmapData);
                                        if (_local_18 != null)
                                        {
                                            if (_local_16.flipH)
                                            {
                                                _local_18 = Rasterizer.getFlipHBitmapData(_local_18);
                                            }
                                            else
                                            {
                                                _local_18 = _local_18.clone();
                                            }
                                            _local_7.addBitmap(_local_18, _local_11, _local_12, _local_13, _local_14, _local_15);
                                        }
                                    }
                                }
                            }
                            _local_9++;
                        }
                        this._textures.add(_local_6, _local_7);
                    }
                }
                _local_4++;
            }
        }

        function parsePlaneMaterials(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:String;
            var _local_6:PlaneMaterial;
            var _local_7:com.sulake.core.utils.xml.XMLList;
            var _local_8:Int;
            var _local_9:com.sulake.core.utils.xml.XML;
            var _local_10:String;
            var _local_11:String;
            var _local_12:Int;
            var _local_13:Int;
            var _local_14:Float;
            var _local_15:Float;
            var _local_16:Float;
            var _local_17:Float;
            var _local_18:com.sulake.core.utils.xml.XMLList;
            var _local_19:PlaneMaterialCellMatrix;
            var _local_20:Int;
            var _local_21:com.sulake.core.utils.xml.XML;
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("material");
            var _local_3 = 0;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2.at(_local_3);
                if (XMLValidator.checkRequiredAttributes(_local_4, ["id"]))
                {
                    _local_5 = _local_4.attribute("id").toString();
                    _local_6 = new PlaneMaterial();
                    _local_7 = _local_4.child("materialCellMatrix");
                    _local_8 = 0;
                    while (_local_8 < _local_7.length())
                    {
                        _local_9 = _local_7.at(_local_8);
                        _local_10 = _local_9.attribute("repeatMode").toString();
                        _local_11 = _local_9.attribute("align").toString();
                        _local_12 = PlaneMaterialCellMatrix.REPEAT_MODE_DEFAULT;
                        switch (_local_10)
                        {
                            case "borders":
                                _local_12 = PlaneMaterialCellMatrix.REPEAT_MODE_BORDERS;
                                
                            case "center":
                                _local_12 = PlaneMaterialCellMatrix.REPEAT_MODE_CENTER;
                                
                            case "first":
                                _local_12 = PlaneMaterialCellMatrix.REPEAT_MODE_FIRST;
                                
                            case "last":
                                _local_12 = PlaneMaterialCellMatrix.REPEAT_MODE_LAST;
                                
                            case "random":
                                _local_12 = PlaneMaterialCellMatrix.REPEAT_MODE_RANDOM;
                                
                        }
                        _local_13 = PlaneMaterialCellMatrix.ALIGN_DEFAULT;
                        switch (_local_11)
                        {
                            case "top":
                                _local_13 = PlaneMaterialCellMatrix.ALIGN_TOP;
                                
                            case "bottom":
                                _local_13 = PlaneMaterialCellMatrix.ALIGN_BOTTOM;
                                
                        }
                        _local_14 = PlaneMaterialCellMatrix.MIN_NORMAL_COORDINATE_VALUE;
                        _local_15 = PlaneMaterialCellMatrix.MAX_NORMAL_COORDINATE_VALUE;
                        _local_16 = PlaneMaterialCellMatrix.MIN_NORMAL_COORDINATE_VALUE;
                        _local_17 = PlaneMaterialCellMatrix.MAX_NORMAL_COORDINATE_VALUE;
                        if (_local_9.attribute("normalMinX").toString() != "")
                        {
                            _local_14 = Std.parseFloat(_local_9.attribute("normalMinX").toString());
                        }
                        if (_local_9.attribute("normalMaxX").toString() != "")
                        {
                            _local_15 = Std.parseFloat(_local_9.attribute("normalMaxX").toString());
                        }
                        if (_local_9.attribute("normalMinY").toString() != "")
                        {
                            _local_16 = Std.parseFloat(_local_9.attribute("normalMinY").toString());
                        }
                        if (_local_9.attribute("normalMaxY").toString() != "")
                        {
                            _local_17 = Std.parseFloat(_local_9.attribute("normalMaxY").toString());
                        }
                        _local_18 = _local_9.child("materialCellColumn");
                        if (_local_18.length() > 0)
                        {
                            _local_19 = null;
                            _local_19 = _local_6.addMaterialCellMatrix(_local_18.length(), _local_12, _local_13, _local_14, _local_15, _local_16, _local_17);
                            _local_20 = 0;
                            while (_local_20 < _local_18.length())
                            {
                                _local_21 = _local_18.at(_local_20);
                                this.parsePlaneMaterialCellColumn(_local_21, _local_19, _local_20);
                                _local_20++;
                            }
                        }
                        this._materials.add(_local_5, _local_6);
                        _local_8++;
                    }
                }
                _local_3++;
            }
        }

        function parsePlaneMaterialCellColumn(k:com.sulake.core.utils.xml.XML, _arg_2:PlaneMaterialCellMatrix, _arg_3:Int)
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            var _local_4= k.attribute("repeatMode").toString();
            var _local_5= ASCompat.parseInt(k.attribute("width").toString());
            var _local_6= PlaneMaterialCellColumn.REPEAT_MODE_ALL;
            switch (_local_4)
            {
                case "borders":
                    _local_6 = PlaneMaterialCellColumn.REPEAT_MODE_BORDERS;
                    
                case "center":
                    _local_6 = PlaneMaterialCellColumn.REPEAT_MODE_CENTER;
                    
                case "first":
                    _local_6 = PlaneMaterialCellColumn.REPEAT_MODE_FIRST;
                    
                case "last":
                    _local_6 = PlaneMaterialCellColumn.REPEAT_MODE_LAST;
                    
                case "none":
                    _local_6 = PlaneMaterialCellColumn.REPEAT_MODE_NONE;
            }
            var _local_7= this.parsePlaneMaterialCells(k);
            _arg_2.createColumn(_arg_3, _local_5, _local_7, _local_6);
        }

        function parsePlaneMaterialCells(k:com.sulake.core.utils.xml.XML):Array<ASAny>
        {
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:String;
            var _local_7:Array<ASAny>;
            var _local_8:Array<ASAny>;
            var _local_9:Array<ASAny>;
            var _local_10:Int;
            var _local_11:com.sulake.core.utils.xml.XMLList;
            var _local_12:PlaneTexture;
            var _local_13:PlaneMaterialCell;
            var _local_14:com.sulake.core.utils.xml.XML;
            var _local_15:com.sulake.core.utils.xml.XMLList;
            var _local_16:com.sulake.core.utils.xml.XMLList;
            var _local_17:com.sulake.core.utils.xml.XML;
            var _local_18:com.sulake.core.utils.xml.XML;
            var _local_19:Int;
            var _local_20:String;
            var _local_21:IGraphicAsset;
            if (k == null)
            {
                return null;
            }
            var _local_2:Array<ASAny> = [];
            var _local_3= k.child("materialCell");
            var _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                _local_6 = _local_5.attribute("textureId").toString();
                _local_7 = null;
                _local_8 = null;
                _local_9 = null;
                _local_10 = 0;
                _local_11 = _local_5.child("extraItemData");
                if (_local_11.length() > 0)
                {
                    _local_14 = _local_11.at(0);
                    _local_15 = _local_14.child("extraItemTypes");
                    _local_16 = _local_14.child("offsets");
                    if (((_local_15.length() > 0) && (_local_16.length() > 0)))
                    {
                        _local_17 = _local_15.at(0);
                        _local_18 = _local_16.at(0);
                        _local_7 = this.parseExtraItemTypes(_local_17);
                        _local_9 = this.parseExtraItemOffsets(_local_18);
                        _local_10 = _local_9.length;
                        if (_local_14.attribute("limitMax").toString() != "")
                        {
                            _local_10 = ASCompat.parseInt(_local_14.attribute("limitMax").toString());
                        }
                    }
                }
                if (_local_7 != null)
                {
                    _local_8 = [];
                    _local_19 = 0;
                    while (_local_19 < _local_7.length)
                    {
                        _local_20 = _local_7[_local_4];
                        _local_21 = this._assetCollection.getAsset(_local_20);
                        if (_local_21 != null)
                        {
                            _local_8.push(_local_21);
                        }
                        _local_19++;
                    }
                }
                _local_12 = this.getTexture(_local_6);
                _local_13 = new PlaneMaterialCell(_local_12, _local_8, _local_9, _local_10);
                _local_2.push(_local_13);
                _local_4++;
            }
            if (_local_2.length == 0)
            {
                _local_2 = null;
            }
            return _local_2;
        }

        function parseExtraItemTypes(k:com.sulake.core.utils.xml.XML):Array<ASAny>
        {
            var _local_4:com.sulake.core.utils.xml.XMLList;
            var _local_5:Int;
            var _local_6:com.sulake.core.utils.xml.XML;
            var _local_7:String;
            var _local_2:Array<ASAny> = [];
            var _local_3:Array<ASAny> = ["assetName"];
            if (k != null)
            {
                _local_4 = k.child("extraItemType");
                _local_5 = 0;
                while (_local_5 < _local_4.length())
                {
                    _local_6 = _local_4.at(_local_5);
                    if (XMLValidator.checkRequiredAttributes(_local_6, _local_3))
                    {
                        _local_7 = _local_6.attribute("assetName").toString();
                        _local_2.push(_local_7);
                    }
                    _local_5++;
                }
            }
            return _local_2;
        }

        function parseExtraItemOffsets(k:com.sulake.core.utils.xml.XML):Array<ASAny>
        {
            var _local_4:com.sulake.core.utils.xml.XMLList;
            var _local_5:Int;
            var _local_6:com.sulake.core.utils.xml.XML;
            var _local_7:Int;
            var _local_8:Int;
            var _local_2:Array<ASAny> = [];
            var _local_3:Array<ASAny> = ["x", "y"];
            if (k != null)
            {
                _local_4 = k.child("offset");
                _local_5 = 0;
                while (_local_5 < _local_4.length())
                {
                    _local_6 = _local_4.at(_local_5);
                    if (XMLValidator.checkRequiredAttributes(_local_6, _local_3))
                    {
                        _local_7 = ASCompat.parseInt(_local_6.attribute("x").toString());
                        _local_8 = ASCompat.parseInt(_local_6.attribute("y").toString());
                        _local_2.push(new Point(_local_7, _local_8));
                    }
                    _local_5++;
                }
            }
            return _local_2;
        }

        function getGeometry(k:Int, _arg_2:Float, _arg_3:Float):IRoomGeometry
        {
            _arg_2 = Math.abs(_arg_2);
            if (_arg_2 > 90)
            {
                _arg_2 = 90;
            }
            _arg_3 = Math.abs(_arg_3);
            if (_arg_3 > 90)
            {
                _arg_3 = 90;
            }
            var _local_4= ((((k + "_") + Math.fround(_arg_2)) + "_") + Math.fround(_arg_3));
            var _local_5:IRoomGeometry = this._geometries.getValue(_local_4);
            if (_local_5 == null)
            {
                _local_5 = new RoomGeometry(k, new Vector3d(_arg_2, _arg_3), new Vector3d(-10, 0, 0));
                this._geometries.add(_local_4, _local_5);
            }
            return _local_5;
        }

        function parseVisualizations(k:Plane, _arg_2:com.sulake.core.utils.xml.XMLList)
        {
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:Int;
            var _local_6:String;
            var _local_7:String;
            var _local_8:Float;
            var _local_9:Float;
            var _local_10:com.sulake.core.utils.xml.XMLList;
            var _local_11:PlaneVisualization;
            var _local_12:Int;
            var _local_13:com.sulake.core.utils.xml.XML;
            var _local_14:PlaneMaterial;
            var _local_15:Int;
            var _local_16:String;
            var _local_17:Int;
            var _local_18:String;
            var _local_19:UInt;
            var _local_20:String;
            var _local_21:String;
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            var _local_3 = 0;
            while (_local_3 < _arg_2.length())
            {
                _local_4 = _arg_2.at(_local_3);
                if (XMLValidator.checkRequiredAttributes(_local_4, ["size"]))
                {
                    _local_5 = ASCompat.parseInt(_local_4.attribute("size").toString());
                    _local_6 = _local_4.attribute("horizontalAngle").toString();
                    _local_7 = _local_4.attribute("verticalAngle").toString();
                    _local_8 = FloorPlane.HORIZONTAL_ANGLE_DEFAULT;
                    if (_local_6 != "")
                    {
                        _local_8 = Std.parseFloat(_local_6);
                    }
                    _local_9 = FloorPlane.VERTICAL_ANGLE_DEFAULT;
                    if (_local_7 != "")
                    {
                        _local_9 = Std.parseFloat(_local_7);
                    }
                    _local_10 = _local_4.child("visualizationLayer");
                    _local_11 = k.createPlaneVisualization(_local_5, _local_10.length(), this.getGeometry(_local_5, _local_8, _local_9));
                    if (_local_11 != null)
                    {
                        _local_12 = 0;
                        while (_local_12 < _local_10.length())
                        {
                            _local_13 = _local_10.at(_local_12);
                            _local_14 = null;
                            _local_15 = PlaneVisualizationLayer.ALIGN_DEFAULT;
                            if (XMLValidator.checkRequiredAttributes(_local_13, ["materialId"]))
                            {
                                _local_21 = _local_13.attribute("materialId").toString();
                                _local_14 = this.material(_local_21);
                            }
                            _local_16 = _local_13.attribute("offset").toString();
                            _local_17 = PlaneVisualizationLayer.DEFAULT_OFFSET;
                            if (_local_16.length > 0)
                            {
                                _local_17 = ASCompat.parseInt(_local_16);
                            }
                            _local_18 = _local_13.attribute("color").toString();
                            _local_19 = FloorPlane.DEFAULT_COLOR;
                            if (_local_18.length > 0)
                            {
                                _local_19 = ASCompat.parseInt(_local_18);
                            }
                            _local_20 = _local_13.attribute("align").toString();
                            if (_local_20 == "bottom")
                            {
                                _local_15 = PlaneVisualizationLayer.ALIGN_BOTTOM;
                            }
                            else
                            {
                                if (_local_20 == "top")
                                {
                                    _local_15 = PlaneVisualizationLayer.ALIGN_TOP;
                                }
                            }
                            _local_11.setLayer(_local_12, _local_14, _local_19, _local_15, _local_17);
                            _local_12++;
                        }
                    }
                }
                _local_3++;
            }
        }

        public function render(k:BitmapData, _arg_2:String, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:IVector3d, _arg_7:Bool, _arg_8:Float=0, _arg_9:Float=0, _arg_10:Float=0, _arg_11:Float=0, _arg_12:Int=0):PlaneBitmapData
        {
            return null;
        }

        public function getTextureIdentifier(k:Float, _arg_2:IVector3d):String
        {
            return Std.string(k);
        }

        public function getLayers(k:String):Array<ASAny>
        {
            var _local_2= this.getPlane(k);
            if (_local_2 == null)
            {
                _local_2 = this.getPlane(DEFAULT);
            }
            return _local_2.getLayers();
        }
    }

