package com.sulake.habbo.ui.widget.furniture.contextmenu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUseProductMessage;

     class MonsterPlantSeedConfirmationView implements IDisposable implements  IGetImageListener 
    {
        static inline final _Str_5091= -1;
        static inline final _Str_9984= 0;
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final SAVE_BUTTON= "save_button";
        static inline final CANCEL_TEXT= "cancel_text";
        static inline final OK_BUTTON= "ok_button";

        var _window:IWindowContainer;
        var _isDisposed:Bool = false;
        var _widget:FurnitureContextMenuWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _requestObjectId:Int = -1;
        var _previewCallbackId:Int = 0;
        var _furnitureData:IFurnitureData;

        public function new(k:FurnitureContextMenuWidget)
        {
            this._widget = k;
            this._windowManager = k.windowManager;
            this._assets = this._widget.assets;
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
            this._isDisposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._furnitureData = null;
        }

        public function open(k:Int)
        {
            var _local_2= this._widget.handler.roomSession.roomId;
            var _local_3= this._widget.handler.roomEngine.getRoomObject(_local_2, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (_local_3 != null)
            {
                this._furnitureData = this._widget.handler.getFurniData(_local_3);
                this._requestObjectId = _local_3.getId();
            }
            var _local_4= _Str_5091;
            switch (this._furnitureData.category)
            {
                case FurniCategory.MONSTERPLANT_SEED:
                    _local_4 = _Str_9984;
                    
                default:
                    Logger.log([("[PlantSeedConfirmationView.open()] Unsupported furniture category: " + Std.string(this._furnitureData.category))]);
            }
            this._Str_3248(_local_4);
            this._window.visible = true;
        }

        function _Str_3248(k:Int)
        {
            var _local_5:String = null;
            var _local_2= new BitmapData(10, 10);
            this._widget.localizations.registerParameter("useproduct.widget.title.plant_seed", "name", this._furnitureData.localizedName);
            if (this._window == null)
            {
                _local_5 = "use_product_widget_frame_plant_seed_xml";
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName(_local_5).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                this.addClickListener(HEADER_BUTTON_CLOSE);
                this._window.center();
            }
            this._widget.localizations.registerParameter("useproduct.widget.text.plant_seed", "productName", this._furnitureData.localizedName);
            var _local_3= Std.downcast(this._window , IFrameWindow);
            _local_3.content.removeChildAt(0);
            var _local_4= this.createWindow(k);
            _local_3.content.addChild(_local_4);
            switch (k)
            {
                case _Str_9984:
                    this.addClickListener(SAVE_BUTTON);
                    this.addClickListener(CANCEL_TEXT);
                    _local_2 = this._Str_3993(this._furnitureData);
                    
                default:
                    throw new ASError(("Invalid type for use product confirmation content apply: " + Std.string(k)));
            }
            this._Str_3060(_local_2);
            this._window.invalidate();
        }

        function createWindow(k:Int):IWindowContainer
        {
            var _local_2:IAsset = null;
            var _local_3:IWindowContainer = null;
            switch (k)
            {
                case _Str_9984:
                    _local_2 = this._assets.getAssetByName("use_product_controller_plant_seed_xml");
                    
                default:
                    throw new ASError(("Invalid type for view content creation: " + Std.string(k)));
            }
            _local_3 = Std.downcast(this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            return _local_3;
        }

        function _Str_3993(k:IFurnitureData):BitmapData
        {
            var _local_3:ImageResult = null;
            var _local_4:BitmapData = null;
            if (k == null)
            {
                return null;
            }
            var _local_2:Array<ASAny> = (cast k.customParams.split(" "));
            switch (k.category)
            {
                case FurniCategory.MONSTERPLANT_SEED:
                    _local_3 = this._widget.handler.roomEngine.getFurnitureImage(this._furnitureData.id, new Vector3d(90, 0, 0), 64, this, 0, "", -1, -1, null);
                    
                default:
                    Logger.log([("[PlantSeedConfirmationView] Unsupported furniture category: " + Std.string(k.category))]);
            }
            if (_local_3 != null)
            {
                this._previewCallbackId = _local_3.id;
                _local_4 = _local_3.data;
            }
            return _local_4;
        }

        function _Str_3060(k:BitmapData)
        {
            if (((!(this._window != null)) || (!(k != null))))
            {
                return;
            }
            this._Str_3234("preview_image_bg");
            this._Str_3234("preview_image");
        }

        function _Str_3234(k:String)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName(k) , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._assets.getAssetByName(_local_2.bitmapAssetName) , BitmapDataAsset);
            if (_local_3 == null)
            {
                return;
            }
            _local_2.disposesBitmap = false;
            _local_2.bitmap = ASCompat.dynamicAs(_local_3.content , BitmapData);
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function addClickListener(k:String)
        {
            this._window.findChildByName(k).addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            var _local_2:RoomWidgetMessage = null;
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_TEXT
                   | OK_BUTTON:
                    this.close();
                    
                case SAVE_BUTTON:
                    _local_2 = new RoomWidgetUseProductMessage(RoomWidgetUseProductMessage.MONSTERPLANT_SEED, this._requestObjectId);
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
    }

