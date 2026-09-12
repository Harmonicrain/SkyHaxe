package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class FurnitureCuboidVisualization extends RoomObjectSpriteVisualization 
    {
        var _assetLibrary:AssetLibrary = null;
        var _planes:Array<ASAny>;
        var _planesInitialized:Bool = false;
        var _assetUpdateCounter:Int = 0;

        public function new()
        {
            this._planes = [];
            super();
        }

        override public function dispose()
        {
            var k = 0;
            var _local_2:FurniturePlane = null;
            super.dispose();
            if (this._assetLibrary != null)
            {
                this._assetLibrary.dispose();
                this._assetLibrary = null;
            }
            if (this._planes != null)
            {
                k = 0;
                while (k < this._planes.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._planes[k] , FurniturePlane);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._planes = null;
            }
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            reset();
            return true;
        }

        function _Str_18024()
        {
            var k= 1;
            createSprites(k);
        }

        function initializePlanes()
        {
            var _local_9:IVector3d = null;
            var _local_10:FurniturePlane = null;
            if (this._planesInitialized)
            {
                return;
            }
            var k= object;
            if (k == null)
            {
                return;
            }
            var _local_2= 1;
            var _local_3= k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_X);
            var _local_4= k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Y);
            var _local_5= k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Z);
            if (((Math.isNaN(_local_3) || Math.isNaN(_local_4)) || Math.isNaN(_local_5)))
            {
                return;
            }
            var _local_6= new Vector3d(_local_3, 0, 0);
            var _local_7= new Vector3d(0, _local_4, 0);
            var _local_8= new Vector3d(-0.5, -0.5, 0);
            if ((((!(_local_8 == null)) && (!(_local_6 == null))) && (!(_local_7 == null))))
            {
                _local_9 = Vector3d.crossProduct(_local_6, _local_7);
                _local_10 = new FurniturePlane(_local_8, _local_6, _local_7);
                _local_10.color = 0xFFFF00;
                this._planes.push(_local_10);
            }
            else
            {
                return;
            }
            this._planesInitialized = true;
            this._Str_18024();
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            var _local_5= object;
            if (_local_5 == null)
            {
                return;
            }
            if (this._assetLibrary == null)
            {
                this._assetLibrary = new AssetLibrary(("furniture cuboid visualization - " + Std.string(_local_5.getInstanceId())));
            }
            if (k == null)
            {
                return;
            }
            this.initializePlanes();
            this._Str_16913(k, _arg_2);
        }

        function _Str_16913(k:IRoomGeometry, _arg_2:Int)
        {
            var _local_6 = false;
            var _local_7:String = null;
            var _local_8:BitmapDataAsset = null;
            var _local_9:FurniturePlane = null;
            var _local_10:IRoomObjectSprite = null;
            var _local_11 = 0;
            var _local_12:BitmapData = null;
            var _local_13:BitmapData = null;
            var _local_14:Point = null;
            var _local_3= object;
            if (_local_3 == null)
            {
                return;
            }
            if (((k == null) || (this._assetLibrary == null)))
            {
                return;
            }
            this._assetUpdateCounter++;
            var _local_4= _arg_2;
            var _local_5 = 0;
            while (_local_5 < this._planes.length)
            {
                _local_6 = false;
                _local_7 = ((("plane " + Std.string(_local_5)) + " ") + Std.string(k.scale));
                _local_8 = Std.downcast(this._assetLibrary.getAssetByName(_local_7) , BitmapDataAsset);
                if (_local_8 == null)
                {
                    _local_8 = new BitmapDataAsset(this._assetLibrary.getAssetTypeDeclarationByClass(BitmapDataAsset));
                    this._assetLibrary.setAsset(_local_7, _local_8);
                }
                _local_9 = ASCompat.dynamicAs(this._planes[_local_5] , FurniturePlane);
                if (_local_9 != null)
                {
                    _local_11 = Std.int(_local_3.getDirection().x);
                    if ((((_local_11 / 45) == 2) || ((_local_11 / 45) == 6)))
                    {
                        _local_9.setRotation(true);
                    }
                    else
                    {
                        _local_9.setRotation(false);
                    }
                    if (_local_9.update(k, _local_4))
                    {
                        _local_12 = _local_9.bitmapData;
                        _local_13 = ASCompat.dynamicAs(_local_8.content , BitmapData);
                        if (_local_12 == null)
                        {
                            _local_8 = null;
                        }
                        else
                        {
                            if (_local_13 != _local_12)
                            {
                                if (_local_13 != null)
                                {
                                    _local_13.dispose();
                                }
                                _local_8.setUnknownContent(_local_12);
                            }
                        }
                        _local_6 = true;
                    }
                }
                else
                {
                    _local_8 = null;
                }
                _local_10 = getSprite(_local_5);
                if (_local_10 != null)
                {
                    if (_local_9 != null)
                    {
                        _local_14 = _local_9.offset;
                        _local_10.offsetX = Std.int(-_local_14.x);
                        _local_10.offsetY = Std.int(-_local_14.y);
                        _local_10.color = ASCompat.toInt(_local_9.color);
                        _local_10.visible = _local_9.visible;
                    }
                    else
                    {
                        _local_10.visible = false;
                    }
                    if (_local_8 != null)
                    {
                        _local_10.asset = ASCompat.dynamicAs(_local_8.content , BitmapData);
                    }
                    else
                    {
                        _local_10.asset = null;
                    }
                    if (_local_6)
                    {
                        _local_10.assetName = ((((_local_7 + "_") + Std.string(_local_3.getInstanceId())) + "_") + Std.string(this._assetUpdateCounter));
                    }
                    _local_10.relativeDepth = _local_9.relativeDepth;
                }
                _local_5++;
            }
        }
    }

