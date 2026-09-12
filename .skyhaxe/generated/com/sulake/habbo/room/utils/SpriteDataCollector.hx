package com.sulake.habbo.room.utils
;
    import com.sulake.room.data.RoomObjectSpriteData;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.room.object.visualization.IRoomObjectSpriteVisualization;
    import com.sulake.habbo.room.RoomEngine;
    import flash.geom.Rectangle;
    import com.sulake.room.renderer.IRoomRenderingCanvas;
    import flash.geom.Point;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.habbo.room.object.visualization.room.PlaneDrawingData;
    import com.sulake.room.object.visualization.IPlaneDrawingData;
    import com.sulake.room.object.visualization.IRoomPlane;
    import com.sulake.room.object.visualization.ISortableSprite;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.Stage;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.visualization.IPlaneVisualization;
    import com.sulake.core.Core;

     class SpriteDataCollector 
    {
        static inline final MANNEQUIN_MAGIC_X_OFFSET= 1;
        static inline final MANNEQUIN_MAGIC_Y_OFFSET= -16;
        static inline final AVATAR_WATER_EFFECT_MAGIC_Y_OFFSET= -52;
        static inline final MAX_EXTERNAL_IMAGE_COUNT= 30;

        var maxZ:Float = Math.NaN;
        var spriteCount:Int = 0;
        var externalImageCount:Int = 0;


        static function addMannequinSprites(k:Vector<RoomObjectSpriteData>, _arg_2:RoomEngine):Vector<RoomObjectSpriteData>
        {
            var _local_4:RoomObjectSpriteData = null;
            var _local_5:IRoomObject = null;
            var _local_6:Array<ASAny> = null;
            var _local_7:RoomObjectSpriteData = null;
            var _local_3= new Vector<RoomObjectSpriteData>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                if (((_local_4.objectType == "boutique_mannequin1") && (_local_4.name.indexOf("mannequin_") == 0)))
                {
                    _local_5 = _arg_2.getRoomObject(_arg_2.activeRoomId, _local_4.objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                    if (_local_5 != null)
                    {
                        _local_6 = cast(_local_5.getVisualization(), IRoomObjectSpriteVisualization).getSpriteList();
                        if (_local_6 != null)
                        {
                            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                            {
_local_7  = _tmp_;
                                _local_7.x = Std.int(_local_7.x + ((_local_4.x + (_local_4.width / 2)) + MANNEQUIN_MAGIC_X_OFFSET));
                                _local_7.y = (_local_7.y + ((_local_4.y + _local_4.height) + MANNEQUIN_MAGIC_Y_OFFSET));
                                _local_7.z = (_local_7.z + _local_4.z);
                                _local_3.push(_local_7);
                            }
                        }
                    }
                }
                else
                {
                    _local_3.push(_local_4);
                }
            }
            return _local_3;
        }

        static function sortSpriteDataObjects(k:RoomObjectSpriteData, _arg_2:RoomObjectSpriteData):Float
        {
            if (k.z < _arg_2.z)
            {
                return 1;
            }
            if (k.z > _arg_2.z)
            {
                return -1;
            }
            return -1;
        }

        static function isSpriteInViewPort(k:RoomObjectSpriteData, _arg_2:Rectangle, _arg_3:IRoomRenderingCanvas):Bool
        {
            var _local_4= new Rectangle((k.x + _arg_3.screenOffsetX), (k.y + _arg_3.screenOffsetY), k.width, k.height);
            return _local_4.intersects(_arg_2);
        }

        static function sortQuadPoints(k:Point, _arg_2:Point, _arg_3:Point, _arg_4:Point):Vector<Point>
        {
            var _local_6:Point = null;
            var _local_5= new Vector<Point>(0);
            if (k.x == _arg_2.x)
            {
                ASCompat.ASArray.pushMultiple(_local_5, k, _arg_3, _arg_2, _arg_4);
            }
            else
            {
                if (k.x == _arg_3.x)
                {
                    ASCompat.ASArray.pushMultiple(_local_5, k, _arg_2, _arg_3, _arg_4);
                }
                else
                {
                    if ((((_arg_2.x < k.x) && (_arg_2.y > k.y)) || ((_arg_2.x > k.x) && (_arg_2.y < k.y))))
                    {
                        ASCompat.ASArray.pushMultiple(_local_5, k, _arg_3, _arg_2, _arg_4);
                    }
                    else
                    {
                        ASCompat.ASArray.pushMultiple(_local_5, k, _arg_2, _arg_3, _arg_4);
                    }
                }
            }
            if (_local_5[0].x < _local_5[1].x)
            {
                _local_6 = _local_5[0];
                _local_5[0] = _local_5[1];
                _local_5[1] = _local_6;
                _local_6 = _local_5[2];
                _local_5[2] = _local_5[3];
                _local_5[3] = _local_6;
            }
            if (_local_5[0].y < _local_5[2].y)
            {
                _local_6 = _local_5[0];
                _local_5[0] = _local_5[2];
                _local_5[2] = _local_6;
                _local_6 = _local_5[1];
                _local_5[1] = _local_5[3];
                _local_5[3] = _local_6;
            }
            return _local_5;
        }


        public function getFurniData(k:Rectangle, _arg_2:IRoomRenderingCanvas, _arg_3:RoomEngine, _arg_4:Int):String
        {
            var _local_8:IRoomObject = null;
            var _local_9:RoomObjectSpriteData = null;
            var _local_10:String = null;
            var _local_11:Array<ASAny> = null;
            var _local_12 = Math.NaN;
            var _local_13 = 0;
            var _local_14:RoomObjectSpriteData = null;
            var _local_15:Point = null;
            var _local_16:RoomObjectSpriteData = null;
            var _local_5= new Vector<ASObject>();
            var _local_6= _arg_2.getSortableSpriteList();
            var _local_7= _arg_3.getRoomObjects(_arg_3.activeRoomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
            {
_local_8  = _tmp_;
                if (_local_8.getId() != _arg_4)
                {
                    _local_11 = cast(_local_8.getVisualization(), IRoomObjectSpriteVisualization).getSpriteList();
                    if (_local_11 != null)
                    {
                        _local_12 = 0;
                        _local_13 = 0;
                        if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                        {
_local_14  = _tmp_;
                            if (_local_14.name == ("avatar_" + Std.string(_local_8.getId())))
                            {
                                _local_12 = _local_14.z;
                                _local_13 = Std.int((_local_14.y + _local_14.height) - (_arg_2.geometry.scale / 4));
                                break;
                            }
                        }
                        _local_15 = _arg_3.getRoomObjectScreenLocation(_arg_3.activeRoomId, _local_8.getId(), RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, _arg_2.getId());
                        if (_local_15 != null)
                        {
                            if (_local_13 == 0)
                            {
                                _local_13 = Std.int(_local_15.y);
                            }
                            if (checkNullIteratee(_local_11)) for (_tmp_ in _local_11)
                            {
_local_16  = _tmp_;
                                _local_16.x = Std.int(_local_16.x + (_local_15.x - _arg_2.screenOffsetX));
                                _local_16.y = (_local_16.y + _local_13);
                                _local_16.z = (_local_16.z + _local_12);
                                if (((_local_16.name.indexOf("h_std_fx29_") == 0) || (_local_16.name.indexOf("h_std_fx185_") == 0)))
                                {
                                    _local_16.y = (_local_16.y + AVATAR_WATER_EFFECT_MAGIC_Y_OFFSET);
                                }
                                _local_6.push(_local_16);
                            }
                        }
                    }
                }
            }
            _local_6 = addMannequinSprites(_local_6, _arg_3);
            ASCompat.ASVector.sort(_local_6, sortSpriteDataObjects);
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_9  = _tmp_;
                if ((((((!(_local_9.name == null)) && (_local_9.name.length > 0)) && (!(_local_9.name.indexOf("tile_cursor_") == 0))) && isSpriteInViewPort(_local_9, k, _arg_2)) && ((_arg_4 < 0) || (!(_local_9.objectId == _arg_4)))))
                {
                    _local_5.push(this.getSpriteDataObject(_local_9, k, _arg_2, _arg_3));
                    if (!ASCompat.floatAsBool(this.maxZ))
                    {
                        this.maxZ = _local_9.z;
                    }
                    this.spriteCount++;
                }
            }
            _local_10 = haxe.Json.stringify(_local_5);
            return _local_10;
        }

        public function getRoomRenderingModifiers(k:RoomEngine):String
        {
            var _local_2:ASObject = new ASObject();
            return haxe.Json.stringify(_local_2);
        }

        function getSpriteDataObject(k:RoomObjectSpriteData, _arg_2:Rectangle, _arg_3:IRoomRenderingCanvas, _arg_4:RoomEngine):ASObject
        {
            var _local_7:String = null;
            var _local_9:Array<ASAny> = null;
            var _local_10:IGraphicAssetCollection = null;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12:String = null;
            var _local_13:String = null;
            var _local_5:ASObject = new ASObject();
            var _local_6= k.name;
            if (k.name.indexOf("@") != -1)
            {
                _local_9 = (cast k.name.split("@"));
                _local_6 = _local_9[0];
                _local_7 = _local_9[1];
            }
            if ((ASCompat.stringAsBool(_local_7) && ASCompat.stringAsBool(k.objectType)))
            {
                _local_10 = _arg_4.roomContentLoader.getGraphicAssetCollection(k.objectType);
                if (_local_10 != null)
                {
                    _local_11 = _local_10._Str_17888(_local_7);
                    if (((!(_local_11 == null)) && (!(_local_11.attribute("source") == null))))
                    {
                        _local_5.paletteSourceName = (ASCompat.xmlListToString(_local_11.attribute("source")) + "");
                    }
                }
            }
            var _local_8= _arg_4.configuration.getProperty("image.library.url");
            _local_6 = ASCompat.stringReplace(_local_6, "%image.library.url%", _local_8);
            if (_local_6.indexOf("%group.badge.url%") != -1)
            {
                _local_12 = _arg_4.configuration.getProperty("group.badge.url");
                _local_6 = ASCompat.stringReplace(_local_6, "%group.badge.url%", "");
                _local_13 = ASCompat.stringReplace(_local_12, "%imagerdata%", _local_6);
                _local_6 = _local_13;
            }
            _local_5.name = _local_6;
            _local_5.x = (k.x - _arg_2.x);
            _local_5.y = (k.y - _arg_2.y);
            _local_5.x = (_local_5.x + _arg_3.screenOffsetX);
            _local_5.y = (_local_5.y + _arg_3.screenOffsetY);
            _local_5.z = k.z;
            if ((ASCompat.floatAsBool(k.alpha) && (!(Std.string(k.alpha) == "255"))))
            {
                _local_5.alpha = k.alpha;
            }
            if (k.flipH)
            {
                _local_5.flipH = k.flipH;
            }
            if (ASCompat.floatAsBool(k.skew))
            {
                _local_5.skew = k.skew;
            }
            if (k.frame)
            {
                _local_5.frame = k.frame;
            }
            if ((ASCompat.stringAsBool(k.color) && (k.color.length > 0)))
            {
                _local_5.color = ASCompat.toInt(k.color);
            }
            if ((ASCompat.stringAsBool(k.blendMode) && (!(k.blendMode == "normal"))))
            {
                _local_5.blendMode = k.blendMode;
            }
            if (_local_6.indexOf("http") == 0)
            {
                _local_5.width = k.width;
                _local_5.height = k.height;
                this.externalImageCount++;
                if (this.externalImageCount > MAX_EXTERNAL_IMAGE_COUNT)
                {
                    _local_5.name = "box";
                }
            }
            if (ASCompat.stringAsBool(k.posture))
            {
                _local_5.posture = k.posture;
            }
            return _local_5;
        }

        function makeBackgroundPlane(viewport:Rectangle, color:UInt, planes:Array<ASAny>):IPlaneDrawingData
        {
            var z = Math.NaN;
            var topleft= new Point(0, 0);
            var bottomleft= new Point(viewport.width, 0);
            var topright= new Point(0, viewport.height);
            var bottomright= new Point(viewport.width, viewport.height);
            var cornerPoints= sortQuadPoints(topleft, bottomleft, topright, bottomright);
            if (planes.length > 0)
            {
                z = ASCompat.toNumber(planes[0].z);
                if (ASCompat.floatAsBool(this.maxZ))
                {
                    z = Math.max(this.maxZ, z);
                }
            }
            else
            {
                z = (ASCompat.floatAsBool(this.maxZ) ? this.maxZ : 0);
            }
            z = (z + ((this.spriteCount * 1.776104) + (planes.length * 2.31743)));
            var backgroundPlane:IPlaneDrawingData = new PlaneDrawingData(null, color);
            backgroundPlane.cornerPoints = cornerPoints;
            backgroundPlane.z = z;
            return backgroundPlane;
        }

        function sortRoomPlanes(k:Vector<IRoomPlane>, _arg_2:IRoomRenderingCanvas, _arg_3:RoomEngine):Array<ASAny>
        {
            var _local_6:IRoomPlane = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:ISortableSprite = null;
            var _local_10:ASObject = null;
            var _local_11:IRoomObjectSprite = null;
            var _local_4= new Map();
            var _local_5:Float = 1;
            if (ASCompat.floatAsBool(this.maxZ))
            {
                _local_5 = (_local_5 + this.maxZ);
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_6  = _tmp_;
                _local_10 = {};
                _local_10.plane = _local_6;
                _local_10.z = _local_5;
                _local_4.add(_local_6.uniqueId, _local_10);
            }
            _local_7 = _arg_2.getPlaneSortableSprites();
            ASCompat.ASArray.sortOn(_local_7, "z", ASCompat.ASArray.NUMERIC);
            (_local_7 : ASAny).reverse();
            _local_8 = [];
            if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
            {
_local_9  = _tmp_;
                _local_11 = _local_9.sprite;
                if (_local_11 != null)
                {
                    _local_10 = _local_4.remove(_local_11.planeId);
                    if (_local_10 != null)
                    {
                        _local_10.z = _local_9.z;
                        _local_8.push(_local_10);
                    }
                }
            }
            _local_8 = _local_8.concat(_local_4.getValues());
            return _local_8;
        }

        public function getRoomPlanes(viewport:Rectangle, _arg_2:IRoomRenderingCanvas, _arg_3:RoomEngine, color:UInt):Array<ASAny>
        {
            var _local_8:IRoomGeometry = null;
            var _local_9:Array<ASAny> = null;
            var _local_10:Stage = null;
            var _local_11:ASObject = null;
            var _local_12:IRoomPlane = null;
            var _local_13:Vector<Point> = null;
            var _local_14:Vector3d = null;
            var _local_15:Point = null;
            var _local_16:Point = null;
            var _local_17:Point = null;
            var _local_18:Point = null;
            var _local_19 = 0;
            var _local_20 = 0;
            var _local_21:Point = null;
            var _local_22:Vector<Point> = null;
            var _local_23:IPlaneDrawingData = null;
            var planes:Array<ASAny> = [];
            var _local_6= _arg_3.getRoomObject(_arg_3.activeRoomId, RoomEngine.OBJECT_ID_ROOM, RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM);
            var _local_7= ASCompat.reinterpretAs(_local_6.getVisualization() , IPlaneVisualization);
            if (_local_7 != null)
            {
                _local_8 = _arg_2.geometry;
                _local_9 = this.sortRoomPlanes(_local_7._Str_19113, _arg_2, _arg_3);
                _local_10 = Core.instance.displayObjectContainer.stage;
                if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
                {
_local_11  = _tmp_;
                    _local_12 = _local_11.plane;
                    _local_13 = new Vector<Point>(0);
                    _local_14 = Vector3d.sum(_local_12.location, _local_12.leftSide);
                    _local_15 = _local_8.getScreenPoint(_local_12.location);
                    _local_16 = _local_8.getScreenPoint(_local_14);
                    _local_17 = _local_8.getScreenPoint(Vector3d.sum(_local_12.location, _local_12.rightSide));
                    _local_18 = _local_8.getScreenPoint(Vector3d.sum(_local_14, _local_12.rightSide));
                    ASCompat.ASArray.pushMultiple(_local_13, _local_15, _local_16, _local_17, _local_18);
                    _local_19 = 0;
                    _local_20 = 0;
                    if (checkNullIteratee(_local_13)) for (_tmp_ in _local_13)
                    {
_local_21  = _tmp_;
                        _local_21.offset((_local_10.stageWidth / 2), (_local_10.stageHeight / 2));
                        _local_21.offset(_arg_2.screenOffsetX, _arg_2.screenOffsetY);
                        _local_21.offset(-viewport.x, -viewport.y);
                        if (_local_21.x < 0)
                        {
                            _local_19--;
                        }
                        else
                        {
                            if (_local_21.x >= viewport.width)
                            {
                                _local_19++;
                            }
                        }
                        if (_local_21.y < 0)
                        {
                            _local_20--;
                        }
                        else
                        {
                            if (_local_21.y >= viewport.height)
                            {
                                _local_20++;
                            }
                        }
                    }
                    if (((Math.abs(_local_19) == 4) || (Math.abs(_local_20) == 4)))
                    {
                    }
                    else
                    {
                        _local_22 = sortQuadPoints(_local_15, _local_16, _local_17, _local_18);
                        final _iter_ = _local_12.getDrawingDatas(_local_8); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_23  = _tmp_;
                            _local_23.cornerPoints = _local_22;
                            _local_23.z = ASCompat.toNumber(_local_11.z);
                            planes.push(_local_23);
                        }
                    }
                }
                planes.unshift(this.makeBackgroundPlane(viewport, color, planes));
            }
            return planes;
        }
public function new(){}
    }

