package com.sulake.habbo.ui.widget.furniture.contextmenu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.communication.messages.outgoing.register.UpdateFigureDataMessageComposer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.avatar.CustomizeAvatarWithFurniMessageComposer;

     class PurchasableClothingConfirmationView implements IDisposable 
    {
        static inline final _Str_5091= -1;
        static inline final _Str_10898= 0;
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final SAVE_BUTTON= "save_button";
        static inline final CANCEL_TEXT= "cancel_text";
        static inline final OK_BUTTON= "ok_button";
        static inline final AVATAR_PREVIEW= "avatar_preview";

        var _window:IWindowContainer;
        var _isDisposed:Bool = false;
        var _widget:FurnitureContextMenuWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _requestObjectId:Int = -1;
        var _furnitureData:IFurnitureData;
        var _newFigureString:String;

        public function new(k:FurnitureContextMenuWidget)
        {
            this._widget = k;
            this._windowManager = k.windowManager;
            this._assets = this._widget.assets;
        }

        public function dispose()
        {
            this._isDisposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function open(k:Int)
        {
            var _local_6:Array<ASAny> = null;
            var _local_7:String = null;
            var _local_2= this._widget.handler.roomSession.roomId;
            var _local_3= this._widget.handler.roomEngine.getRoomObject(_local_2, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (_local_3 != null)
            {
                this._furnitureData = this._widget.handler.getFurniData(_local_3);
                this._requestObjectId = _local_3.getId();
            }
            else
            {
                return;
            }
            var _local_4= _Str_5091;
            var _local_5= new Vector<Int>(0);
            switch (this._furnitureData.category)
            {
                case FurniCategory.FIGURE_PURCHASABLE_SET:
                    _local_4 = _Str_10898;
                    _local_6 = (cast this._furnitureData.customParams.split(","));
                    if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                    {
_local_7  = _tmp_;
                        if (this._widget.handler.container.avatarRenderManager.isValidFigureSetForGender(ASCompat.parseInt(_local_7), this._widget.handler.container.sessionDataManager.gender))
                        {
                            _local_5.push(ASCompat.parseInt(_local_7));
                        }
                    }
                    
                default:
                    Logger.log([("[PurchasableClothingConfirmationView.open()] Unsupported furniture category: " + Std.string(this._furnitureData.category))]);
            }
            this._newFigureString = this._widget.handler.container.avatarRenderManager.getFigureStringWithFigureIds(this._widget.handler.container.sessionDataManager.figure, this._widget.handler.container.sessionDataManager.gender, _local_5);
            if (this._widget.handler.container.inventory.hasBoundFigureSetFurniture(this._furnitureData.className))
            {
                this._widget.handler.container.connection.send(new UpdateFigureDataMessageComposer(this._newFigureString, this._widget.handler.container.sessionDataManager.gender));
            }
            else
            {
                this._Str_3248(_local_4);
                this._window.visible = true;
            }
        }

        function _Str_3248(k:Int)
        {
            var _local_4:String = null;
            this._widget.localizations.registerParameter("useproduct.widget.title.bind_clothing", "name", this._furnitureData.localizedName);
            if (this._window == null)
            {
                _local_4 = "use_product_widget_frame_plant_seed_xml";
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName(_local_4).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                this.addClickListener(HEADER_BUTTON_CLOSE);
                this._window.center();
            }
            this._window.caption = "${useproduct.widget.title.bind_clothing}";
            this._widget.localizations.registerParameter("useproduct.widget.text.bind_clothing", "productName", this._furnitureData.localizedName);
            var _local_2= Std.downcast(this._window , IFrameWindow);
            _local_2.content.removeChildAt(0);
            var _local_3= this.createWindow(k);
            _local_2.content.addChild(_local_3);
            switch (k)
            {
                case _Str_10898:
                    this.addClickListener(SAVE_BUTTON);
                    this.addClickListener(CANCEL_TEXT);
                    
                default:
                    throw new ASError(("Invalid type for use product confirmation content apply: " + Std.string(k)));
            }
            this._Str_22999();
            this._window.invalidate();
        }

        function createWindow(k:Int):IWindowContainer
        {
            var _local_2:IAsset = null;
            var _local_3:IWindowContainer = null;
            switch (k)
            {
                case _Str_10898:
                    _local_2 = this._assets.getAssetByName("use_product_controller_purchasable_clothing_xml");
                    
                default:
                    throw new ASError(("Invalid type for view content creation: " + Std.string(k)));
            }
            _local_3 = Std.downcast(this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            return _local_3;
        }

        function _Str_22999()
        {
            var k= cast(this._window.findChildByName(AVATAR_PREVIEW), IWidgetWindow);
            var _local_2= cast(k.widget, IAvatarImageWidget);
            _local_2.figure = this._newFigureString;
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
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_TEXT
                   | OK_BUTTON:
                    this.close();
                    return;
                case SAVE_BUTTON:
                    this._widget.handler.container.connection.send(new CustomizeAvatarWithFurniMessageComposer(this._requestObjectId));
                    this._widget.handler.container.connection.send(new UpdateFigureDataMessageComposer(this._newFigureString, this._widget.handler.container.sessionDataManager.gender));
                    this.close();
                    return;
            }
        }
    }

