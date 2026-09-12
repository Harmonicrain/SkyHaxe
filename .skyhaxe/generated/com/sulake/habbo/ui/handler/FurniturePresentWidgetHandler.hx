package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPresentOpenMessage;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPresentDataUpdateEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.display.BitmapData;
    import com.sulake.habbo.session.events.RoomSessionPresentEvent;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import flash.events.Event;

     class FurniturePresentWidgetHandler implements IRoomWidgetHandler implements  IGetImageListener 
    {
        static inline final FLOOR= "floor";
        static inline final WALLPAPER= "wallpaper";
        static inline final LANDSCAPE= "landscape";
        static inline final POSTER= "poster";

        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _objectId:Int = -1;
        var _name:String = "";


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FURNI_PRESENT_WIDGET;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_PRESENT, RoomWidgetPresentOpenMessage.RWPOM_OPEN_PRESENT];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFurniToWidgetMessage = null;
            var _local_3:IRoomObject = null;
            var _local_4:RoomWidgetPresentOpenMessage = null;
            var _local_5:IRoomObjectModel = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9 = 0;
            var _local_10:String = null;
            var _local_11 = 0;
            var _local_12:ImageResult = null;
            var _local_13:RoomWidgetPresentDataUpdateEvent = null;
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_PRESENT:
                    _local_2 = Std.downcast(k , RoomWidgetFurniToWidgetMessage);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.id, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_5 = _local_3.getModel();
                        if (_local_5 != null)
                        {
                            this._objectId = _local_2.id;
                            _local_6 = _local_5.getString(RoomObjectVariableEnum.FURNITURE_DATA);
                            if (_local_6 == null)
                            {
                                _local_6 = "";
                            }
                            _local_7 = _local_5.getString(RoomObjectVariableEnum.FURNITURE_PURCHASER_NAME);
                            _local_8 = _local_5.getString(RoomObjectVariableEnum.FURNITURE_PURCHASER_FIGURE);
                            _local_9 = Std.int(_local_5.getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                            _local_10 = _local_5.getString(RoomObjectVariableEnum.FURNITURE_EXTRAS);
                            _local_11 = 32;
                            _local_12 = this._container.roomEngine.getFurnitureImage(_local_9, new Vector3d(180), _local_11, null, 0, _local_10);
                            _local_13 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_PACKAGEINFO, _local_2.id, _local_6, this._container.isOwnerOfFurniture(_local_3), _local_12.data, _local_7, _local_8);
                            this._container.events.dispatchEvent(_local_13);
                        }
                    }
                    
                case RoomWidgetPresentOpenMessage.RWPOM_OPEN_PRESENT:
                    _local_4 = Std.downcast(k , RoomWidgetPresentOpenMessage);
                    if (_local_4.objectId != this._objectId)
                    {
                        return null;
                    }
                    if (this._container != null)
                    {
                        if (this._container.roomSession != null)
                        {
                            this._container.roomSession.sendPresentOpenMessage(_local_4.objectId);
                        }
                        if (this._container.roomEngine != null)
                        {
                            this._container.roomEngine.changeObjectModelData(this._container.roomEngine.activeRoomId, _local_4.objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, RoomObjectVariableEnum.FURNITURE_DISABLE_PICKING_ANIMATION, 1);
                        }
                    }
                    
            }
            return null;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if ((this.disposed || (this._container == null)))
            {
                return;
            }
            var _local_3= new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS_IMAGE, 0, this._name, false, _arg_2);
            this._container.events.dispatchEvent(_local_3);
        }

        public function imageFailed(k:Int)
        {
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomSessionPresentEvent.RSPE_PRESENT_OPENED];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionPresentEvent = null;
            var _local_3:IFurnitureData = null;
            var _local_4:ImageResult = null;
            var _local_5:RoomWidgetPresentDataUpdateEvent = null;
            var _local_6 = false;
            var _local_7:IProductData = null;
            var _local_8:IRoomObject = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11 = 0;
            var _local_12:String = null;
            var _local_13:PetFigureData = null;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16:ImageResult = null;
            if (k == null)
            {
                return;
            }
            if ((((!(this._container == null)) && (!(this._container.events == null))) && (!(k == null))))
            {
                switch (k.type)
                {
                    case RoomSessionPresentEvent.RSPE_PRESENT_OPENED:
                        _local_2 = Std.downcast(k , RoomSessionPresentEvent);
                        if (_local_2 != null)
                        {
                            this._name = "";
                            _local_4 = null;
                            if (_local_2.itemType == ProductTypeEnum.FLOOR)
                            {
                                _local_3 = this._container.sessionDataManager.getFloorItemData(_local_2.classId);
                            }
                            else
                            {
                                if (_local_2.itemType == ProductTypeEnum.WALL)
                                {
                                    _local_3 = this._container.sessionDataManager.getWallItemData(_local_2.classId);
                                }
                            }
                            _local_6 = false;
                            if (_local_2.isPlacedInRoom)
                            {
                                _local_8 = this._container.roomEngine.getRoomObject(this._container.roomSession.roomId, _local_2.placedItemId, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                                if (_local_8 != null)
                                {
                                    _local_6 = this._container.isOwnerOfFurniture(_local_8);
                                }
                            }
                            switch (_local_2.itemType)
                            {
                                case ProductTypeEnum.WALL:
                                    if (_local_3 != null)
                                    {
                                        switch (_local_3.className)
                                        {
                                            case FLOOR:
                                                _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS_FLOOR, 0, this._container.localization.getLocalization("inventory.furni.item.floor.name"), _local_6, null);
                                                
                                            case LANDSCAPE:
                                                _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS_LANDSCAPE, 0, this._container.localization.getLocalization("inventory.furni.item.landscape.name"), _local_6, null);
                                                
                                            case WALLPAPER:
                                                _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS_WALLPAPER, 0, this._container.localization.getLocalization("inventory.furni.item.wallpaper.name"), _local_6, null);
                                                
                                            case POSTER:
                                                _local_9 = _local_2.productCode;
                                                _local_10 = null;
                                                if (_local_9.indexOf("poster") == 0)
                                                {
                                                    _local_11 = ASCompat.toInt(ASCompat.stringReplace(_local_9, "poster", ""));
                                                    _local_10 = Std.string(_local_11);
                                                }
                                                _local_4 = this._container.roomEngine.getWallItemIcon(_local_2.classId, this, _local_10);
                                                _local_7 = this._container.sessionDataManager.getProductData(_local_9);
                                                if (_local_7 != null)
                                                {
                                                    this._name = _local_7.name;
                                                }
                                                else
                                                {
                                                    if (_local_3 != null)
                                                    {
                                                        this._name = _local_3.localizedName;
                                                    }
                                                }
                                                if (_local_4 != null)
                                                {
                                                    _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS, 0, this._name, _local_6, _local_4.data);
                                                }
                                                
                                            default:
                                                _local_4 = this._container.roomEngine.getWallItemIcon(_local_2.classId, this);
                                                if (_local_3 != null)
                                                {
                                                    this._name = _local_3.localizedName;
                                                }
                                                if (_local_4 != null)
                                                {
                                                    _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS, 0, this._name, _local_6, _local_4.data);
                                                }
                                        }
                                    }
                                    
                                case ProductTypeEnum.HABBO_CLUB:
                                    _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS_CLUB, 0, this._container.localization.getLocalization("widget.furni.present.hc"), false, null);
                                    
                                default:
                                    if (_local_2.placedItemType == ProductTypeEnum.PET)
                                    {
                                        _local_12 = _local_2.petFigureString;
                                        if (((!(_local_12 == null)) && (_local_12.length > 0)))
                                        {
                                            _local_13 = new PetFigureData(_local_12);
                                            _local_14 = 2;
                                            _local_15 = 64;
                                            if (_local_13.typeId == PetTypeEnum.HORSE)
                                            {
                                                _local_15 = 32;
                                            }
                                            _local_16 = this._container.roomEngine.getPetImage(_local_13.typeId, _local_13.paletteId, _local_13.color, new Vector3d((_local_14 * 45)), _local_15, this, true, 0, _local_13._Str_3542);
                                            if (_local_16 != null)
                                            {
                                                _local_4 = _local_16;
                                            }
                                        }
                                    }
                                    if (_local_4 == null)
                                    {
                                        _local_4 = this._container.roomEngine.getFurnitureImage(_local_2.classId, new Vector3d(90), 64, this);
                                    }
                                    _local_7 = this._container.sessionDataManager.getProductData(_local_2.productCode);
                                    if (_local_7 != null)
                                    {
                                        this._name = _local_7.name;
                                    }
                                    else
                                    {
                                        if (_local_3 != null)
                                        {
                                            this._name = _local_3.localizedName;
                                        }
                                    }
                                    if (_local_4 != null)
                                    {
                                        _local_5 = new RoomWidgetPresentDataUpdateEvent(RoomWidgetPresentDataUpdateEvent.RWPDUE_CONTENTS, 0, this._name, _local_6, _local_4.data);
                                    }
                            }
                            if (_local_5 != null)
                            {
                                _local_5.classId = _local_2.classId;
                                _local_5.itemType = _local_2.itemType;
                                _local_5.placedItemId = _local_2.placedItemId;
                                 _local_5.isPlacedInRoom = _local_2.isPlacedInRoom;
                                _local_5.placedItemType = _local_2.placedItemType;
                                this._container.events.dispatchEvent(_local_5);
                            }
                        }
                }
            }
        }

        public function update()
        {
        }
public function new(){}
    }

