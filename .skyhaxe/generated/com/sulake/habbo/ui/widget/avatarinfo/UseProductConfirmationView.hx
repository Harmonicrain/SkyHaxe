package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.avatar.pets.PetCustomPart;
    import com.sulake.habbo.room.PetColorResult;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUseProductMessage;

     class UseProductConfirmationView implements IDisposable implements  IGetImageListener 
    {
        static inline final _Str_5091= -1;
        static inline final _Str_11906= 0;
        static inline final _Str_11214= 1;
        static inline final _Str_11733= 2;
        static inline final _Str_11369= 3;
        static inline final _Str_8759= 4;
        static inline final _Str_8432= 5;
        static inline final _Str_9653= 6;
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final SAVE_BUTTON= "save_button";
        static inline final CANCEL_TEXT= "cancel_text";
        static inline final OK_BUTTON= "ok_button";
        static inline final PREVIEW_IMAGE_REGION= "preview_image_region";

        var _window:IWindowContainer;
        var _isDisposed:Bool = false;
        var _widget:AvatarInfoWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _requestObjectId:Int = -1;
        var _targetRoomObjectId:Int = -1;
        var _previewCallbackId:Int = 0;
        var _furnitureData:IFurnitureData;
        var _petData:RoomUserData;

        public function new(k:AvatarInfoWidget)
        {
            this._widget = k;
            this._windowManager = k.windowManager;
            this._assets = this._widget.assets;
        }

        public var _Str_20466(get,never):Int;
public function  get__Str_20466():Int
        {
            return this._requestObjectId;
        }

        public var _Str_5563(get,never):Int;
public function  get__Str_5563():Int
        {
            return this._targetRoomObjectId;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._isDisposed = true;
            this._furnitureData = null;
            this._petData = null;
        }

        public function open(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_4= this._widget.handler.roomSession.roomId;
            var _local_5= this._widget.handler.roomEngine.getRoomObject(_local_4, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (_local_5 != null)
            {
                this._furnitureData = this._widget.handler.getFurniData(_local_5);
                this._requestObjectId = _local_5.getId();
            }
            else
            {
                this._furnitureData = this._widget.handler.container.sessionDataManager.getFloorItemData(k);
                this._requestObjectId = _arg_3;
            }
            this._targetRoomObjectId = _arg_2;
            this._petData = this._widget.handler.roomSession.userDataManager.getUserDataByIndex(_arg_2);
            var _local_6= _Str_5091;
            switch (this._furnitureData.category)
            {
                case FurniCategory.PET_SHAMPOO:
                    _local_6 = _Str_11906;
                    
                case FurniCategory.PET_CUSTOM_PART:
                    _local_6 = _Str_11214;
                    
                case FurniCategory.PET_CUSTOM_PART_SHAMPOO:
                    _local_6 = _Str_11733;
                    
                case FurniCategory.PET_SADDLE:
                    _local_6 = _Str_11369;
                    
                case FurniCategory.MONSTERPLANT_REVIVAL:
                    _local_6 = _Str_8759;
                    
                case FurniCategory.MONSTERPLANT_REBREED:
                    _local_6 = _Str_8432;
                    
                case FurniCategory.MONSTERPLANT_FERTILIZE:
                    _local_6 = _Str_9653;
                    
                default:
                    Logger.log([("[UseProductConfirmationView.open()] Unsupported furniture category: " + Std.string(this._furnitureData.category))]);
            }
            this._Str_3248(_local_6);
            this._window.center();
            this._window.visible = true;
        }

        function _Str_3248(k:Int)
        {
            var _local_4:String = null;
            var _local_2= new BitmapData(10, 10);
            this._widget.localizations.registerParameter("useproduct.widget.title", "name", this._petData.name);
            this._widget.localizations.registerParameter("useproduct.widget.title.monsterplant", "name", this._petData.name);
            this._widget.localizations.registerParameter("useproduct.widget.title.monsterplant_rebreed", "name", this._petData.name);
            this._widget.localizations.registerParameter("useproduct.widget.title.monsterplant_fertilize", "name", this._petData.name);
            this._widget.localizations.registerParameter("useproduct.widget.title.monsterplant_rebreed", "name", this._petData.name);
            this._widget.localizations.registerParameter("useproduct.widget.monsterplant.plant.name", "name", this._petData.name);
            this._widget.localizations.registerParameter("useproduct.widget.monsterplant.plant.raritylevel", "level", Std.string(this._petData.rarityLevel));
            this._widget.localizations.registerParameter("useproduct.widget.monsterplant.plant.description", "name", this._petData.ownerName);
            if (this._window == null)
            {
                _local_4 = "use_product_widget_frame_xml";
                switch (k)
                {
                    case _Str_8759:
                        _local_4 = "use_product_widget_frame_monsterplant_xml";
                        
                    case _Str_8432:
                        _local_4 = "use_product_widget_frame_monsterplant_rebreed_xml";
                        
                    case _Str_9653:
                        _local_4 = "use_product_widget_frame_monsterplant_fertilize_xml";
                        
                    default:
                        _local_4 = "use_product_widget_frame_xml";
                }
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName(_local_4).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                this.addClickListener(HEADER_BUTTON_CLOSE);
            }
            this._widget.localizations.registerParameter("useproduct.widget.text.saddle", "productName", this._furnitureData.localizedName);
            this._widget.localizations.registerParameter("useproduct.widget.text.custompart", "productName", this._furnitureData.localizedName);
            this._widget.localizations.registerParameter("useproduct.widget.text.custompartshampoo", "productName", this._furnitureData.localizedName);
            this._widget.localizations.registerParameter("useproduct.widget.text.shampoo", "productName", this._furnitureData.localizedName);
            this._widget.localizations.registerParameter("useproduct.widget.text.revive_monsterplant", "productName", this._furnitureData.localizedName);
            Std.downcast(this._window , IFrameWindow).content.removeChildAt(0);
            var _local_3= this.createWindow(k);
            Std.downcast(this._window , IFrameWindow).content.addChild(_local_3);
            Std.downcast(this._window , IFrameWindow)._Str_5665();
            switch (k)
            {
                case _Str_11906
                   | _Str_11214
                   | _Str_11733
                   | _Str_11369
                   | _Str_8759
                   | _Str_8432
                   | _Str_9653:
                    this.addClickListener(PREVIEW_IMAGE_REGION);
                    this.addClickListener(SAVE_BUTTON);
                    this.addClickListener(CANCEL_TEXT);
                    _local_2 = this._Str_3993(this._furnitureData);
                    
                default:
                    throw new ASError(("Invalid type for use product confirmation content apply: " + Std.string(k)));
            }
            this._Str_3060(_local_2);
            this._window.invalidate();
        }

        function createWindow(k:Int):IWindow
        {
            var _local_2:IAsset = null;
            var _local_3:IWindow = null;
            switch (k)
            {
                case _Str_11906:
                    _local_2 = this._assets.getAssetByName("use_product_controller_shampoo_xml");
                    
                case _Str_11214:
                    _local_2 = this._assets.getAssetByName("use_product_controller_custom_part_xml");
                    
                case _Str_11733:
                    _local_2 = this._assets.getAssetByName("use_product_controller_custom_part_shampoo_xml");
                    
                case _Str_11369:
                    _local_2 = this._assets.getAssetByName("use_product_controller_saddle_xml");
                    
                case _Str_8759:
                    _local_2 = this._assets.getAssetByName("use_product_controller_revive_monsterplant_xml");
                    
                case _Str_8432:
                    _local_2 = this._assets.getAssetByName("use_product_controller_rebreed_monsterplant_xml");
                    
                case _Str_9653:
                    _local_2 = this._assets.getAssetByName("use_product_controller_fertilize_monsterplant_xml");
                    
                default:
                    throw new ASError(("Invalid type for Use Product View content creation: " + Std.string(k)));
            }
            _local_3 = this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) ;
            return _local_3;
        }

        function _Str_3993(k:IFurnitureData):BitmapData
        {
            var _local_2:PetFigureData = null;
            var _local_3:Array<ASAny> = null;
            var _local_4:ImageResult = null;
            var _local_5 = 0;
            var _local_6:Array<ASAny> = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:Array<ASAny> = null;
            var _local_10 = 0;
            var _local_11:BitmapData = null;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15:PetCustomPart = null;
            var _local_16:String = null;
            var _local_17:Array<ASAny> = null;
            var _local_18:PetColorResult = null;
            var _local_19:String = null;
            var _local_20:PetColorResult = null;
            var _local_21:PetCustomPart = null;
            var _local_22:IRoomObject = null;
            var _local_23 = 0;
            if (k == null)
            {
                return null;
            }
            _local_2 = new PetFigureData(this._petData.figure);
            _local_3 = (cast k.customParams.split(" "));
            _local_5 = ASCompat.toInt(_local_3[0]);
            var _local_9:Array<ASAny> = [];
            switch (k.category)
            {
                case FurniCategory.PET_SHAMPOO:
                    if (_local_3.length < 2)
                    {
                        Logger.log([("[UseProductConfirmationView] Invalid custom params: " + ASCompat.toString(_local_3))]);
                    }
 else {                    _local_16 = _local_3[1];
                    _local_17 = this._widget.handler.roomEngine.getPetColorsByTag(_local_5, _local_16);
                    _local_18 = this._widget.handler.roomEngine.getPetColor(_local_5, _local_2.paletteId);
                    if (checkNullIteratee(_local_17)) for (_tmp_ in _local_17)
                    {
_local_20  = _tmp_;
                        if (_local_20.breed == _local_18.breed)
                        {
                            _local_12 = ASCompat.toInt(_local_20.id);
                            break;
                        }
                    }
                    _local_4 = this._widget.handler.roomEngine.getPetImage(_local_2.typeId, _local_12, _local_2.color, new Vector3d(90), 64, this, true, 0, _local_2._Str_3542);
                    
}                case FurniCategory.PET_CUSTOM_PART:
                    if (_local_3.length < 4)
                    {
                        Logger.log([("[UseProductConfirmationView] Invalid custom params: " + ASCompat.toString(_local_3))]);
                    }
 else {                    _local_6 = (cast ASCompat.asString(_local_3[1] ).split(","));
                    _local_7 = (cast ASCompat.asString(_local_3[2] ).split(","));
                    _local_8 = (cast ASCompat.asString(_local_3[3] ).split(","));
                    _local_10 = 0;
                    while (_local_10 < _local_6.length)
                    {
                        _local_13 = ASCompat.toInt(_local_6[_local_10]);
                        _local_15 = _local_2.getCustomPart(_local_13);
                        _local_12 = ASCompat.toInt(_local_8[_local_10]);
                        if (_local_15 != null)
                        {
                            _local_12 = _local_15.paletteId;
                        }
                        _local_9.push(new PetCustomPart(_local_13, ASCompat.toInt(_local_7[_local_10]), _local_12));
                        _local_10++;
                    }
                    _local_4 = this._widget.handler.roomEngine.getPetImage(_local_2.typeId, _local_2.paletteId, _local_2.color, new Vector3d(90), 64, this, true, 0, _local_9);
                    
}                case FurniCategory.PET_CUSTOM_PART_SHAMPOO:
                    if (_local_3.length < 3)
                    {
                        Logger.log([("[UseProductConfirmationView] Invalid custom params: " + ASCompat.toString(_local_3))]);
                    }
 else {                    _local_6 = (cast ASCompat.asString(_local_3[1] ).split(","));
                    _local_8 = (cast ASCompat.asString(_local_3[2] ).split(","));
                    _local_10 = 0;
                    while (_local_10 < _local_6.length)
                    {
                        _local_13 = ASCompat.toInt(_local_6[_local_10]);
                        _local_15 = _local_2.getCustomPart(_local_13);
                        _local_14 = -1;
                        if (_local_15 != null)
                        {
                            _local_14 = _local_15.partId;
                        }
                        _local_9.push(new PetCustomPart(ASCompat.toInt(_local_6[_local_10]), _local_14, ASCompat.toInt(_local_8[_local_10])));
                        _local_10++;
                    }
                    _local_4 = this._widget.handler.roomEngine.getPetImage(_local_2.typeId, _local_2.paletteId, _local_2.color, new Vector3d(90), 64, this, true, 0, _local_9);
                    
}                case FurniCategory.PET_SADDLE:
                    if (_local_3.length < 4)
                    {
                        Logger.log([("[UseProductConfirmationView] Invalid custom params: " + ASCompat.toString(_local_3))]);
                    }
 else {                    _local_6 = (cast ASCompat.asString(_local_3[1] ).split(","));
                    _local_7 = (cast ASCompat.asString(_local_3[2] ).split(","));
                    _local_8 = (cast ASCompat.asString(_local_3[3] ).split(","));
                    _local_10 = 0;
                    while (_local_10 < _local_6.length)
                    {
                        _local_9.push(new PetCustomPart(ASCompat.toInt(_local_6[_local_10]), ASCompat.toInt(_local_7[_local_10]), ASCompat.toInt(_local_8[_local_10])));
                        _local_10++;
                    }
                    final _iter_ = _local_2._Str_3542; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_21  = _tmp_;
                        if (_local_6.indexOf(_local_21._Str_11008) == -1)
                        {
                            _local_9.push(_local_21);
                        }
                    }
                    _local_4 = this._widget.handler.roomEngine.getPetImage(_local_2.typeId, _local_2.paletteId, _local_2.color, new Vector3d(90), 64, this, true, 0, _local_9);
                    
}                case FurniCategory.MONSTERPLANT_REBREED
                   | FurniCategory.MONSTERPLANT_REVIVAL
                   | FurniCategory.MONSTERPLANT_FERTILIZE:
                    _local_19 = null;
                    if (this._petData != null)
                    {
                        _local_19 = "rip";
                        _local_22 = this._Str_13861(this._petData.roomObjectId);
                        if (_local_22 != null)
                        {
                            _local_19 = _local_22.getModel().getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                            if (_local_19 == "rip")
                            {
                                _local_23 = this._petData.petLevel;
                                if (_local_23 < 7)
                                {
                                    _local_19 = ("grw" + Std.string(_local_23));
                                }
                                else
                                {
                                    _local_19 = "std";
                                }
                            }
                        }
                    }
                    _local_4 = this._widget.handler.roomEngine.getPetImage(_local_2.typeId, _local_2.paletteId, _local_2.color, new Vector3d(90), 64, this, true, 0, _local_2._Str_3542, _local_19);
                    
                default:
                    Logger.log([("[UseProductConfirmationView] Unsupported furniture category: " + Std.string(k.category))]);
            }
            if (_local_4 != null)
            {
                this._previewCallbackId = _local_4.id;
                _local_11 = _local_4.data;
            }
            return _local_11;
        }

        function _Str_13861(k:Int):IRoomObject
        {
            return this._widget.handler.roomEngine.getRoomObject(this._widget.handler.roomEngine.activeRoomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
        }

        function _Str_3060(k:BitmapData)
        {
            var _local_5:BitmapData = null;
            if (((!(this._window != null)) || (!(k != null))))
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("preview_image") , IBitmapWrapperWindow);
            if (_local_2.bitmap == null)
            {
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height);
            }
            var _local_3= this._assets.getAssetByName("use_product_preview_bg_png") ;
            if (_local_3 != null)
            {
                _local_5 = ASCompat.dynamicAs(_local_3.content , BitmapData);
                _local_2.bitmap.copyPixels(_local_5, _local_5.rect, new Point(0, 0));
            }
            var _local_4= new Point(((_local_2.width - k.width) / 2), ((_local_2.height - k.height) / 2));
            _local_2.bitmap.copyPixels(k, k.rect, _local_4, null, null, true);
        }

        function close()
        {
            this._window.visible = false;
        }

        function addClickListener(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            }
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            var _local_2:RoomWidgetMessage = null;
            switch (k.target.name)
            {
                case PREVIEW_IMAGE_REGION:
                    if (this._petData != null)
                    {
                        this._Str_22884(this._petData.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                    }
                    
                case HEADER_BUTTON_CLOSE
                   | CANCEL_TEXT
                   | OK_BUTTON:
                    this.close();
                    
                case SAVE_BUTTON:
                    _local_2 = new RoomWidgetUseProductMessage(RoomWidgetUseProductMessage.RWUPM_PET_PRODUCT, this._requestObjectId, this._petData.id);
                    this.close();
                    
            }
            if (_local_2 != null)
            {
                this._widget.messageListener.processWidgetMessage(_local_2);
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this.disposed)
            {
                return;
            }
            if (this._previewCallbackId == k)
            {
                this._Str_3060(_arg_2);
                this._previewCallbackId = 0;
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_22884(k:Int, _arg_2:Int):Bool
        {
            var _local_4 = 0;
            var _local_3= this._Str_8946(k, _arg_2);
            if (_local_3 != null)
            {
                _local_4 = this._widget.handler.container.roomSession.roomId;
                this._widget.handler.container.roomEngine.selectRoomObject(_local_4, _local_3.getId(), _arg_2);
                return true;
            }
            return false;
        }

        function _Str_8946(k:Int, _arg_2:Int):IRoomObject
        {
            var _local_3= this._widget.handler.container.roomSession.roomId;
            var _local_4= this._widget.handler.container.roomEngine.getRoomObject(_local_3, k, _arg_2);
            return _local_4;
        }
    }

