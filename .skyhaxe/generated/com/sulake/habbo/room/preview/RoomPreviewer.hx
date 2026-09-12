package com.sulake.habbo.room.preview
;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.room.utils.RoomId;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.IStuffData;
    import flash.display.DisplayObject;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import flash.display.BitmapData;

     class RoomPreviewer 
    {
        static inline final PREVIEW_CANVAS_ID= 1;
        static inline final PREVIEW_OBJECT_ID= 1;
        static inline final PREVIEW_OBJECT_LOCATION_X= 2;
        static inline final PREVIEW_OBJECT_LOCATION_Y= 2;
        static inline final ALLOWED_IMAGE_CUT= 0.25;
        public static inline final SCALE_NORMAL= 64;
        public static inline final SCALE_SMALL= 32;
        static inline final AUTOMATIC_STATE_CHANGE_INTERVAL= 2500;

        var _roomEngine:IRoomEngine;
        var _previewRoomId:Int = 1;
        var _currentPreviewObjectType:Int = 0;
        var _currentPreviewObjectCategory:Int = 0;
        var _currentPreviewObjectData:String = "";
        var _currentPreviewRectangle:Rectangle = null;
        var _currentPreviewCanvasWidth:Int = 0;
        var _currentPreviewCanvasHeight:Int = 0;
        var _currentPreviewScale:Int = 64;
        var _currentPreviewNeedsZoomOut:Bool = false;
        var _automaticStateChange:Bool = false;
        var _previousAutomaticStateChangeTime:Int = 0;
        var _addViewOffset:Point;
        var _disableUpdate:Bool = false;

        public function new(k:IRoomEngine, _arg_2:Int=1)
        {
            this._addViewOffset = new Point(0, 0);
            this._roomEngine = k;
            this._previewRoomId = RoomId.makeRoomPreviewerId(_arg_2);
            if (this.isRoomEngineReady)
            {
                this._roomEngine.events.addEventListener(RoomEngineObjectEvent.ADDED, this.onRoomObjectAdded);
                this._roomEngine.events.addEventListener(RoomEngineObjectEvent.CONTENT_UPDATED, this.onRoomObjectAdded);
                this._roomEngine.events.addEventListener(RoomEngineEvent.INITIALIZED, this.onRoomInitialized);
            }
            this.createRoomForPreviews();
        }

        public function dispose()
        {
            this.reset(true);
            if ((this.isRoomEngineReady && (!(this._roomEngine.events == null))))
            {
                // NOTE: never disposeRoom() here. A RoomPreviewer shares the live RoomEngine,
                // and disposing a room dispatches RoomEngineEvent.DISPOSED, which RoomUI turns
                // into disposeDesktop()+_isInRoom=false -> blacks out the real room. Every other
                // consumer (catalog, clothing/figure editor) leaves the preview room in place
                // and reuses a fixed id, so re-init overwrites it instead of leaking.
                this._roomEngine.events.removeEventListener(RoomEngineObjectEvent.ADDED, this.onRoomObjectAdded);
                this._roomEngine.events.removeEventListener(RoomEngineObjectEvent.CONTENT_UPDATED, this.onRoomObjectAdded);
                this._roomEngine.events.removeEventListener(RoomEngineEvent.INITIALIZED, this.onRoomInitialized);
            }
        }

        function createRoomForPreviews()
        {
            var k = 0;
            var _local_2:RoomPlaneParser = null;
            var _local_3 = 0;
            var _local_4 = 0;
            if (this.isRoomEngineReady)
            {
                k = 7;
                _local_2 = new RoomPlaneParser();
                _local_2.initializeTileMap((k + 2), (k + 2));
                _local_3 = 1;
                while (_local_3 < (1 + k))
                {
                    _local_4 = 1;
                    while (_local_4 < (1 + k))
                    {
                        _local_2._Str_3982(_local_4, _local_3, 0);
                        _local_4++;
                    }
                    _local_3++;
                }
                _local_2.initializeFromTileData();
                this._roomEngine.initializeRoom(this._previewRoomId, _local_2.getXML());
                _local_2.dispose();
            }
        }

        public function reset(k:Bool)
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.disposeObjectFurniture(this._previewRoomId, PREVIEW_OBJECT_ID);
                this._roomEngine.disposeObjectWallItem(this._previewRoomId, PREVIEW_OBJECT_ID);
                this._roomEngine.disposeObjectUser(this._previewRoomId, PREVIEW_OBJECT_ID);
                if (!k)
                {
                    this.updatePreviewRoomView();
                }
            }
            this._currentPreviewObjectCategory = RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN;
        }

        public function addFurnitureIntoRoom(k:Int, _arg_2:IVector3d, _arg_3:IStuffData=null, _arg_4:String=null):Int
        {
            var _local_6:IRoomObject = null;
            var _local_5= -1;
            if (_arg_3 == null)
            {
                _arg_3 = new LegacyStuffData();
            }
            if (this.isRoomEngineReady)
            {
                if (((this._currentPreviewObjectCategory == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) && (this._currentPreviewObjectType == k)))
                {
                    return PREVIEW_OBJECT_ID;
                }
                this.reset(false);
                this._currentPreviewObjectType = k;
                this._currentPreviewObjectCategory = RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
                this._currentPreviewObjectData = "";
                if (this._roomEngine.addObjectFurniture(this._previewRoomId, PREVIEW_OBJECT_ID, k, new Vector3d(PREVIEW_OBJECT_LOCATION_X, PREVIEW_OBJECT_LOCATION_Y, 0), _arg_2, 0, _arg_3, Math.NaN, -1, 0, 0, "", true, false))
                {
                    this._previousAutomaticStateChangeTime = flash.Lib.getTimer();
                    this._automaticStateChange = true;
                    _local_5 = PREVIEW_OBJECT_ID;
                    _local_6 = this._roomEngine.getRoomObject(this._previewRoomId, PREVIEW_OBJECT_ID, this._currentPreviewObjectCategory);
                    if (_local_6 != null)
                    {
                        if (_arg_4 != null)
                        {
                            Std.downcast(_local_6.getModel() , IRoomObjectModelController).setString(RoomObjectVariableEnum.FURNITURE_EXTRAS, _arg_4);
                        }
                    }
                    this.updatePreviewRoomView();
                }
            }
            return _local_5;
        }

        public function addWallItemIntoRoom(k:Int, _arg_2:IVector3d, _arg_3:String):Int
        {
            var _local_4= -1;
            if (this.isRoomEngineReady)
            {
                if ((((this._currentPreviewObjectCategory == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM) && (this._currentPreviewObjectType == k)) && (this._currentPreviewObjectData == _arg_3)))
                {
                    return PREVIEW_OBJECT_ID;
                }
                this.reset(false);
                this._currentPreviewObjectType = k;
                this._currentPreviewObjectCategory = RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
                this._currentPreviewObjectData = _arg_3;
                if (this._roomEngine.addObjectWallItem(this._previewRoomId, PREVIEW_OBJECT_ID, k, new Vector3d(0.5, 2.3, 1.8), _arg_2, 0, _arg_3, 0, 0, "", -1, false))
                {
                    this._previousAutomaticStateChangeTime = flash.Lib.getTimer();
                    this._automaticStateChange = true;
                    return PREVIEW_OBJECT_ID;
                }
            }
            return _local_4;
        }

        public function addAvatarIntoRoom(k:String, _arg_2:Int):Int
        {
            if (this.isRoomEngineReady)
            {
                this.reset(false);
                this._currentPreviewObjectType = 1;
                this._currentPreviewObjectCategory = RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
                this._currentPreviewObjectData = k;
                if (this._roomEngine.addObjectUser(this._previewRoomId, PREVIEW_OBJECT_ID, new Vector3d(PREVIEW_OBJECT_LOCATION_X, PREVIEW_OBJECT_LOCATION_Y, 0), new Vector3d(90, 0, 0), 135, 1, k))
                {
                    this._previousAutomaticStateChangeTime = flash.Lib.getTimer();
                    this._automaticStateChange = true;
                    this.updateUserGesture(1);
                    this.updateUserEffect(_arg_2);
                    this.updateUserPosture("std");
                }
                this.updatePreviewRoomView();
                return PREVIEW_OBJECT_ID;
            }
            return -1;
        }

        public function updateUserPosture(k:String, _arg_2:String="")
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.updateObjectUserPosture(this._previewRoomId, PREVIEW_OBJECT_ID, k, _arg_2);
            }
        }

        public function updateUserGesture(k:Int)
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.updateObjectUserGesture(this._previewRoomId, PREVIEW_OBJECT_ID, k);
            }
        }

        public function updateUserEffect(k:Int)
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.updateObjectUserEffect(this._previewRoomId, PREVIEW_OBJECT_ID, k);
            }
        }

        public function updateObjectUserFigure(k:String, _arg_2:String=null, _arg_3:String=null, _arg_4:Bool=false):Bool
        {
            if (this.isRoomEngineReady)
            {
                return this._roomEngine.updateObjectUserFigure(this._previewRoomId, PREVIEW_OBJECT_ID, k, _arg_2, _arg_3, _arg_4);
            }
            return false;
        }

        public function updateObjectUserAction(k:String, _arg_2:Int, _arg_3:String=null)
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.updateObjectUserAction(this._previewRoomId, PREVIEW_OBJECT_ID, k, _arg_2, _arg_3);
            }
        }

        public function changeRoomObjectState()
        {
            if (this.isRoomEngineReady)
            {
                this._automaticStateChange = false;
                if (this._currentPreviewObjectCategory != RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                {
                    this._roomEngine.changeObjectState(this._previewRoomId, PREVIEW_OBJECT_ID, this._currentPreviewObjectCategory);
                }
            }
        }

        function checkAutomaticRoomObjectStateChange()
        {
            var k = 0;
            if (this._automaticStateChange)
            {
                k = flash.Lib.getTimer();
                if (k > (this._previousAutomaticStateChangeTime + AUTOMATIC_STATE_CHANGE_INTERVAL))
                {
                    this._previousAutomaticStateChangeTime = k;
                    if (this.isRoomEngineReady)
                    {
                        this._roomEngine.changeObjectState(this._previewRoomId, PREVIEW_OBJECT_ID, this._currentPreviewObjectCategory);
                    }
                }
            }
        }

        public function getRoomCanvas(k:Int, _arg_2:Int):DisplayObject
        {
            var _local_3:DisplayObject = null;
            var _local_4:IRoomGeometry = null;
            if (this.isRoomEngineReady)
            {
                _local_3 = this._roomEngine.createRoomCanvas(this._previewRoomId, PREVIEW_CANVAS_ID, k, _arg_2, this._currentPreviewScale);
                this._roomEngine.setRoomCanvasMask(this._previewRoomId, PREVIEW_CANVAS_ID, true);
                _local_4 = this._roomEngine.getRoomCanvasGeometry(this._previewRoomId, PREVIEW_CANVAS_ID);
                if (_local_4 != null)
                {
                    _local_4.adjustLocation(new Vector3d(PREVIEW_OBJECT_LOCATION_X, PREVIEW_OBJECT_LOCATION_Y, 0), 30);
                }
                this._currentPreviewCanvasWidth = k;
                this._currentPreviewCanvasHeight = _arg_2;
                return _local_3;
            }
            return null;
        }

        public function modifyRoomCanvas(k:Int, _arg_2:Int)
        {
            if (this.isRoomEngineReady)
            {
                this._currentPreviewCanvasWidth = k;
                this._currentPreviewCanvasHeight = _arg_2;
                this._roomEngine.modifyRoomCanvas(this._previewRoomId, PREVIEW_CANVAS_ID, k, _arg_2);
            }
        }

        
        public var addViewOffset(get,set):Point;
public function  set_addViewOffset(k:Point):Point        {
            return this._addViewOffset = k;
        }
public function  get_addViewOffset():Point
        {
            return this._addViewOffset;
        }

        function updatePreviewObjectBoundingRectangle(k:Point)
        {
            var _local_3:Rectangle = null;
            var _local_2= this._roomEngine.getRoomObjectBoundingRectangle(this._previewRoomId, PREVIEW_OBJECT_ID, this._currentPreviewObjectCategory, PREVIEW_CANVAS_ID);
            if (((!(_local_2 == null)) && (!(k == null))))
            {
                _local_2.offset(-(this._currentPreviewCanvasWidth >> 1), -(this._currentPreviewCanvasHeight >> 1));
                _local_2.offset(-k.x, -k.y);
                if (this._currentPreviewRectangle == null)
                {
                    this._currentPreviewRectangle = _local_2;
                }
                else
                {
                    _local_3 = this._currentPreviewRectangle.union(_local_2);
                    if ((((((_local_3.width - this._currentPreviewRectangle.width) > (Std.int(this._currentPreviewCanvasWidth - this._currentPreviewRectangle.width) >> 1)) || ((_local_3.height - this._currentPreviewRectangle.height) > (Std.int(this._currentPreviewCanvasHeight - this._currentPreviewRectangle.height) >> 1))) || (this._currentPreviewRectangle.width < 1)) || (this._currentPreviewRectangle.height < 1)))
                    {
                        this._currentPreviewRectangle = _local_3;
                    }
                }
            }
        }

        function validatePreviewSize(k:Point):Point
        {
            var _local_2:IRoomGeometry = null;
            if (((this._currentPreviewRectangle.width < 1) || (this._currentPreviewRectangle.height < 1)))
            {
                return k;
            }
            if (this.isRoomEngineReady)
            {
                _local_2 = this._roomEngine.getRoomCanvasGeometry(this._previewRoomId, PREVIEW_CANVAS_ID);
                if (((this._currentPreviewRectangle.width > (this._currentPreviewCanvasWidth * (1 + ALLOWED_IMAGE_CUT))) || (this._currentPreviewRectangle.height > (this._currentPreviewCanvasHeight * (1 + ALLOWED_IMAGE_CUT)))))
                {
                    if (ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled"))
                    {
                        if (this._roomEngine.getRoomCanvasScale(this._previewRoomId, PREVIEW_CANVAS_ID) != 0.5)
                        {
                            this._roomEngine.setRoomCanvasScale(this._previewRoomId, PREVIEW_CANVAS_ID, 0.5, null, null, false, false, true);
                            this._currentPreviewScale = SCALE_SMALL;
                            this._currentPreviewNeedsZoomOut = true;
                            k.x = (Std.int(k.x )>> 1);
                            k.y = (Std.int(k.y )>> 1);
                            this._currentPreviewRectangle.left = (Std.int(this._currentPreviewRectangle.left )>> 2);
                            this._currentPreviewRectangle.right = (Std.int(this._currentPreviewRectangle.right )>> 2);
                            this._currentPreviewRectangle.top = (Std.int(this._currentPreviewRectangle.top )>> 2);
                            this._currentPreviewRectangle.bottom = (Std.int(this._currentPreviewRectangle.bottom )>> 2);
                        }
                    }
                    else
                    {
                        if (_local_2.isZoomedIn())
                        {
                            _local_2.performZoomOut();
                            this._currentPreviewScale = SCALE_SMALL;
                            this._currentPreviewNeedsZoomOut = true;
                            k.x = (Std.int(k.x )>> 1);
                            k.y = (Std.int(k.y )>> 1);
                            this._currentPreviewRectangle.left = (Std.int(this._currentPreviewRectangle.left )>> 2);
                            this._currentPreviewRectangle.right = (Std.int(this._currentPreviewRectangle.right )>> 2);
                            this._currentPreviewRectangle.top = (Std.int(this._currentPreviewRectangle.top )>> 2);
                            this._currentPreviewRectangle.bottom = (Std.int(this._currentPreviewRectangle.bottom )>> 2);
                        }
                    }
                }
                else
                {
                    if ((((Std.int(this._currentPreviewRectangle.width )<< 1) < ((this._currentPreviewCanvasWidth * (1 + ALLOWED_IMAGE_CUT)) - 5)) && ((Std.int(this._currentPreviewRectangle.height )<< 1) < ((this._currentPreviewCanvasHeight * (1 + ALLOWED_IMAGE_CUT)) - 5))))
                    {
                        if (ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled"))
                        {
                            if (((!(this._roomEngine.getRoomCanvasScale(this._previewRoomId, PREVIEW_CANVAS_ID) == 1)) && (!this._currentPreviewNeedsZoomOut)))
                            {
                                this._roomEngine.setRoomCanvasScale(this._previewRoomId, PREVIEW_CANVAS_ID, 1, null, null, false, false, true);
                                this._currentPreviewScale = SCALE_NORMAL;
                                k.x = (Std.int(k.x )<< 1);
                                k.y = (Std.int(k.y )<< 1);
                            }
                        }
                        else
                        {
                            if (((!_local_2.isZoomedIn()) && (!this._currentPreviewNeedsZoomOut)))
                            {
                                _local_2.performZoomIn();
                                this._currentPreviewScale = SCALE_NORMAL;
                                k.x = (Std.int(k.x )<< 1);
                                k.y = (Std.int(k.y )<< 1);
                            }
                        }
                    }
                }
            }
            return k;
        }

        public function zoomIn()
        {
            var k:IRoomGeometry = null;
            if (this.isRoomEngineReady)
            {
                if (ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled"))
                {
                    this._roomEngine.setRoomCanvasScale(this._previewRoomId, PREVIEW_CANVAS_ID, 1);
                }
                k = this._roomEngine.getRoomCanvasGeometry(this._previewRoomId, PREVIEW_CANVAS_ID);
                k.performZoomIn();
            }
            this._currentPreviewScale = SCALE_NORMAL;
        }

        public function zoomOut()
        {
            var _local_1:IRoomGeometry = null;
            if (this.isRoomEngineReady)
            {
                if (ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled"))
                {
                    this._roomEngine.setRoomCanvasScale(this._previewRoomId, PREVIEW_CANVAS_ID, 0.5);
                }
                else
                {
                    _local_1 = this._roomEngine.getRoomCanvasGeometry(this._previewRoomId, PREVIEW_CANVAS_ID);
                    _local_1.performZoomOut();
                }
            }
            this._currentPreviewScale = SCALE_SMALL;
        }

        public function updateAvatarDirection(k:Int, _arg_2:Int)
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.updateObjectUser(this._previewRoomId, PREVIEW_OBJECT_ID, new Vector3d(PREVIEW_OBJECT_LOCATION_X, PREVIEW_OBJECT_LOCATION_Y, 0), new Vector3d(PREVIEW_OBJECT_LOCATION_X, PREVIEW_OBJECT_LOCATION_Y, 0), false, 0, new Vector3d((k * 45), 0, 0), (_arg_2 * 45));
            }
        }

        public function updateObjectRoom(k:String=null, _arg_2:String=null, _arg_3:String=null, _arg_4:Bool=false):Bool
        {
            if (this.isRoomEngineReady)
            {
                return this._roomEngine.updateObjectRoom(this._previewRoomId, k, _arg_2, _arg_3, false);
            }
            return false;
        }

        public function updateRoomWallsAndFloorVisibility(k:Bool, _arg_2:Bool=true)
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.updateObjectRoomVisibilities(this._previewRoomId, k, _arg_2);
            }
        }

        function getCanvasOffset(k:Point):Point
        {
            var _local_7 = Math.NaN;
            if (((this._currentPreviewRectangle.width < 1) || (this._currentPreviewRectangle.height < 1)))
            {
                return k;
            }
            var _local_2:ASAny = (Std.int(-(this._currentPreviewRectangle.left + this._currentPreviewRectangle.right) )>> 1);
            var _local_3:ASAny = (Std.int(-(this._currentPreviewRectangle.top + this._currentPreviewRectangle.bottom) )>> 1);
            var _local_4:ASAny = (Std.int(this._currentPreviewCanvasHeight - this._currentPreviewRectangle.height) >> 1);
            if (_local_4 > 10)
            {
                _local_3 = (_local_3 + Math.min(15, ASCompat.toNumber(ASCompat.toNumber(_local_4) - 10)));
            }
            else
            {
                if (this._currentPreviewObjectCategory != RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                {
                    _local_3 = (_local_3 + (5 - Math.max(0, (ASCompat.toNumber(_local_4) / 2))));
                }
                else
                {
                    _local_3 = (ASCompat.toNumber(_local_3) - (5 - Math.min(0, (ASCompat.toNumber(_local_4) / 2))));
                }
            }
            _local_3 = (_local_3 + this._addViewOffset.y);
            _local_2 = (_local_2 + this._addViewOffset.x);
            var _local_5= ASCompat.toInt(ASCompat.toNumber(_local_2) - k.x);
            var _local_6= ASCompat.toInt(ASCompat.toNumber(_local_3) - k.y);
            if (((!(_local_5 == 0)) || (!(_local_6 == 0))))
            {
                _local_7 = Math.sqrt(((_local_5 * _local_5) + (_local_6 * _local_6)));
                if (_local_7 > 10)
                {
                    _local_2 = (k.x + ((_local_5 * 10) / _local_7));
                    _local_3 = (k.y + ((_local_6 * 10) / _local_7));
                }
                return new Point(ASCompat.toNumber(_local_2), ASCompat.toNumber(_local_3));
            }
            return null;
        }

        public function updatePreviewRoomView(k:Bool=false)
        {
            var _local_2:Point = null;
            var _local_3 = 0;
            var _local_4:Point = null;
            if ((this._disableUpdate && (!k)))
            {
                return;
            }
            this.checkAutomaticRoomObjectStateChange();
            if (this.isRoomEngineReady)
            {
                _local_2 = this._roomEngine.getRoomCanvasScreenOffset(this._previewRoomId, PREVIEW_CANVAS_ID);
                if (_local_2 != null)
                {
                    this.updatePreviewObjectBoundingRectangle(_local_2);
                    if (this._currentPreviewRectangle != null)
                    {
                        _local_3 = this._currentPreviewScale;
                        _local_2 = this.validatePreviewSize(_local_2);
                        _local_4 = this.getCanvasOffset(_local_2);
                        if (_local_4 != null)
                        {
                            this._roomEngine.setRoomCanvasScreenOffset(this._previewRoomId, PREVIEW_CANVAS_ID, _local_4);
                        }
                        if (this._currentPreviewScale != _local_3)
                        {
                            this._currentPreviewRectangle = null;
                        }
                    }
                }
            }
        }

        public var disableUpdate(never,set):Bool;
public function  set_disableUpdate(k:Bool):Bool        {
            return this._disableUpdate = k;
        }

        public var disableRoomEngineUpdate(never,set):Bool;
public function  set_disableRoomEngineUpdate(k:Bool):Bool        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.disableUpdate = k;
            }
return k;
        }

        function onRoomInitialized(k:RoomEngineEvent)
        {
            if (k == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineEvent.INITIALIZED:
                    if (k.roomId == this._previewRoomId)
                    {
                        if (this.isRoomEngineReady)
                        {
                            this._roomEngine.updateObjectRoom(this._previewRoomId, "110", "99999");
                        }
                    }
                    return;
            }
        }

        function onRoomObjectAdded(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            if ((((k.roomId == this._previewRoomId) && (k.objectId == PREVIEW_OBJECT_ID)) && (k.category == this._currentPreviewObjectCategory)))
            {
                this._currentPreviewRectangle = null;
                this._currentPreviewNeedsZoomOut = false;
                _local_2 = this._roomEngine.getRoomObject(k.roomId, k.objectId, k.category);
                if ((((!(_local_2 == null)) && (!(_local_2.getModel() == null))) && (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)))
                {
                    _local_3 = _local_2.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Z);
                    _local_4 = _local_2.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_CENTER_Z);
                    if (((!Math.isNaN(_local_3)) && (!Math.isNaN(_local_4))))
                    {
                        this._roomEngine.updateObjectWallItemLocation(k.roomId, k.objectId, new Vector3d(0.5, 2.3, (((3.6 - _local_3) / 2) + _local_4)));
                    }
                }
            }
        }

        public function updateRoomEngine()
        {
            if (this.isRoomEngineReady)
            {
                this._roomEngine.runUpdate();
            }
        }

        public function getGenericRoomObjectImage(k:String, _arg_2:String, _arg_3:IVector3d, _arg_4:Int, _arg_5:IGetImageListener, _arg_6:UInt=0, _arg_7:String=null, _arg_8:IStuffData=null, _arg_9:Int=-1, _arg_10:Int=-1, _arg_11:String=null):ImageResult
        {
            if (this.isRoomEngineReady)
            {
                return this._roomEngine.getGenericRoomObjectImage(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            }
            return null;
        }

        public function getRoomObjectImage(k:Int, _arg_2:IVector3d, _arg_3:Int, _arg_4:IGetImageListener, _arg_5:UInt=0):ImageResult
        {
            if (this.isRoomEngineReady)
            {
                return this._roomEngine.getRoomObjectImage(this._previewRoomId, PREVIEW_OBJECT_ID, k, _arg_2, _arg_3, _arg_4, _arg_5);
            }
            return null;
        }

        public function getRoomObjectCurrentImage():BitmapData
        {
            var k:IRoomObject = null;
            var _local_2:IRoomObjectVisualization = null;
            if (this.isRoomEngineReady)
            {
                k = this._roomEngine.getRoomObject(this._previewRoomId, PREVIEW_OBJECT_ID, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                if (k != null)
                {
                    _local_2 = k.getVisualization();
                    if (_local_2 != null)
                    {
                        return _local_2.getImage(0xFFFFFF, -1);
                    }
                }
            }
            return null;
        }

        public var isRoomEngineReady(get,never):Bool;
public function  get_isRoomEngineReady():Bool
        {
            return (!(this._roomEngine == null)) && this._roomEngine.isInitialized;
        }
    }

