package com.sulake.habbo.catalog.purchase
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog.HabboCatalogUtils;
    import com.sulake.habbo.catalog.club.ClubBuyOfferData;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Matrix;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog.viewer.ProductImageConfiguration;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.avatar._enum.AvatarAction;
    import com.sulake.habbo.catalog.purchase._Str_11981;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.localization.ILocalization;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.tracking.HabboTracking;
    import flash.ui.Keyboard;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.utils.IIterable;
    import flash.text.TextFormat;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class PurchaseConfirmationDialog implements IAvatarImageListener implements  IGetImageListener 
    {
        static inline final MAX_SUGGESTIONS= 10;
        static inline final COLOR_EVEN:UInt = 0xFFEEEEEE;
        static inline final COLOR_ODD:UInt = 0xFFFFFFFF;
        static inline final COLOR_HIGHLIGHT:UInt = 0xFFCCD1DA;

        var _catalog:HabboCatalog;
        var _roomEngine:IRoomEngine;
        var _localization:IHabboLocalizationManager;
        var _assets:IAssetLibrary;
        var _offerId:Int = 0;
        var _productType:String = "";
        var _pageId:Int = 0;
        var _extraParameter:String;
        var _stuffData:IStuffData = null;
        var _friends:Array<ASAny>;
        var _userName:String;
        var _suggestionContainer:IWindowContainer;
        var _suggestionsListItem:IWindowContainer;
        var _highlightIndex:Int = -1;
        var _quantity:Int = 0;
        var _bundleDiscountEnabled:Bool = false;
        var _receiverName:String = "";
        var _imageId:Int = 0;
        var _defaultStuffType:Int = 0;
        var _stuffTypes:Array<ASAny>;
        var _ribbonTypes:Array<ASAny>;
        var _boxTypes:Array<ASAny>;
        var _ribbonIndex:Int = 0;
        var _boxIndex:Int = 0;
        var _selectedTypeId:Int = 0;
        var _window:IFrameWindow;
        var _disposed:Bool = false;

        public function new(k:IHabboLocalizationManager, _arg_2:IAssetLibrary)
        {
            this._stuffTypes = [];
            this._ribbonTypes = [];
            this._boxTypes = [];
            this._localization = k;
            this._assets = _arg_2;
        }

        static function isValentinesBox(k:Int):Bool
        {
            return k == 8;
        }


        public function _Str_6059(k:IHabboCatalog, _arg_2:IRoomEngine, _arg_3:IPurchasableOffer, _arg_4:Int, _arg_5:String, _arg_6:Int, _arg_7:IStuffData, _arg_8:Array<ASAny>, _arg_9:String, _arg_10:BitmapData)
        {
            this._catalog = Std.downcast(k , HabboCatalog);
            this._roomEngine = _arg_2;
            this._offerId = _arg_3.offerId;
            this._pageId = _arg_4;
            this._extraParameter = _arg_5;
            this._stuffData = _arg_7;
            this._friends = _arg_8;
            this._userName = _arg_9;
            this._quantity = _arg_6;
            this._bundleDiscountEnabled = (this._catalog.discountEnabled ? _arg_3.bundlePurchaseAllowed : false);
            if ((Std.is(_arg_3 , Offer) && (!(_arg_3.product == null))))
            {
                this._productType = _arg_3.product.productType;
            }
            else
            {
                if ((Std.is(_arg_3 , ClubBuyOfferData) || HabboCatalogUtils._Str_21831(_arg_3.localizationId)))
                {
                    this._productType = ProductTypeEnum.HABBO_CLUB;
                }
                else
                {
                    return;
                }
            }
            this.showConfirmationDialog(_arg_3, _arg_10);
            this._catalog.syncPlacedOfferWithPurchase(_arg_3);
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            this._catalog = null;
            this._roomEngine = null;
            this._offerId = -1;
            this._pageId = -1;
            this._extraParameter = "";
            this._friends = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._suggestionContainer = null;
            if (this._suggestionsListItem != null)
            {
                this._suggestionsListItem.dispose();
                this._suggestionsListItem = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var productType(get,never):String;
public function  get_productType():String
        {
            return this._productType;
        }

        public function getIconWrapper():IBitmapWrapperWindow
        {
            return (this._window != null) ? Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow) : null;
        }

        public function isGiftPurchase():Bool
        {
            return (!(this._receiverName == null)) && (!(this._receiverName == ""));
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (k == this._imageId)
            {
                this._imageId = 0;
                this.setImage(_arg_2, true);
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function setImage(k:BitmapData, _arg_2:Bool)
        {
            if ((((this._window == null) || (k == null)) || this.disposed))
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow);
            if (_local_3 == null)
            {
                return;
            }
            if (_local_3.bitmap != null)
            {
                _local_3.bitmap.dispose();
                _local_3.bitmap = null;
            }
            if (_local_3.bitmap == null)
            {
                _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0);
            }
            var _local_4= Std.int((_local_3.width - k.width) * 0.5);
            var _local_5= Std.int((_local_3.height - k.height) * 0.5);
            _local_3.bitmap.draw(k, new Matrix(1, 0, 0, 1, _local_4, _local_5));
            if (_arg_2)
            {
                k.dispose();
            }
        }

        function showConfirmationDialog(k:IPurchasableOffer, _arg_2:BitmapData)
        {
            var _local_7:IProductData = null;
            var _local_8:IItemListWindow = null;
            var _local_9 = false;
            var _local_10:String = null;
            var _local_11:BitmapDataAsset = null;
            var _local_12:IRoomEngine = null;
            var _local_13:ImageResult = null;
            var _local_14:BitmapData = null;
            var _local_15 = 0;
            var _local_16:String = null;
            var _local_17:IProduct = null;
            var _local_18:IAvatarImage = null;
            if (this._catalog == null)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = Std.downcast(this._catalog.utils.createWindow("purchase_confirmation", 2) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this.updateLocalizations(k);
            var _local_3= Std.downcast(this._window.findChildByName("purchase_cost_box") , IWindowContainer);
            this._catalog.utils._Str_6455(_local_3, k, this._quantity);
            this.addClickListener("buy_button", this.onBuyButtonClick);
            this.addClickListener("cancel_button", this.onClose);
            this.addClickListener("header_button_close", this.onClose);
            this._window.center();
            if (this._catalog.getBoolean("disclaimer.credit_spending.enabled"))
            {
                this._window.findChildByName("spending_disclaimer").addEventListener(WindowMouseEvent.CLICK, this.onSpendingDisclaimerClicked);
                this._window.findChildByName("spending_disclaimer").addEventListener(WindowMouseEvent.DOUBLE_CLICK, this.onSpendingDisclaimerClicked);
                this.setDisclaimerAccepted(false);
            }
            else
            {
                this._window.findChildByName("disclaimer").dispose();
                this.setDisclaimerAccepted(true);
            }
            var _local_4= Std.downcast(this._window.findChildByName("product_name") , ITextWindow);
            if (_local_4 != null)
            {
                _local_7 = this._catalog.getProductData(k.localizationId);
                _local_4.text = ((_local_7 == null) ? k.localizationId : _local_7.name);
            }
            var _local_5= Std.downcast(this._window.findChildByName("quantity") , ITextWindow);
            if (_local_5 != null)
            {
                if ((this._catalog.multiplePurchaseEnabled && (this._quantity > 1)))
                {
                    _local_5.text = ("X " + Std.string(this._quantity));
                }
                else
                {
                    _local_8 = cast(this._window.findChildByName("properties_itemlist"), IItemListWindow);
                    if (_local_8 != null)
                    {
                        _local_8.removeListItem(_local_5);
                    }
                }
            }
            var _local_6= Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_9 = false;
                if (ProductImageConfiguration.hasProductImage(k.localizationId))
                {
                    _local_10 = ProductImageConfiguration.PRODUCT_IMAGES[k.localizationId];
                    _local_11 = Std.downcast(this._assets.getAssetByName(_local_10) , BitmapDataAsset);
                    if (_local_11 != null)
                    {
                        this.setImage(ASCompat.dynamicAs(_local_11.content , BitmapData), false);
                        _local_9 = true;
                    }
                }
                if (((!_local_9) && (k.product != null)))
                {
                    _local_12 = this._catalog.roomEngine;
                    _local_15 = 0;
                    _local_16 = "";
                    if (Std.is(k , Offer))
                    {
                        _local_17 = k.product;
                        if (_local_17 != null)
                        {
                            _local_15 = _local_17.productClassId;
                            _local_16 = _local_17.extraParam;
                        }
                    }
                    if (_arg_2 == null)
                    {
                        switch (this.productType)
                        {
                            case ProductTypeEnum.FLOOR:
                                _local_13 = _local_12.getFurnitureImage(_local_15, new Vector3d(90, 0, 0), 64, this, 0, _local_16, -1, -1, this._stuffData);
                                
                            case ProductTypeEnum.WALL:
                                _local_13 = _local_12.getWallItemImage(_local_15, new Vector3d(90, 0, 0), 64, this, 0, _local_16);
                                
                            case ProductTypeEnum.EFFECT:
                                _local_14 = this._catalog.getPixelEffectIcon(_local_15);
                                
                            case ProductTypeEnum.HABBO_CLUB:
                                _local_14 = this._catalog.getSubscriptionProductIcon(_local_15);
                                
                            case ProductTypeEnum.CHAT_STYLE:
                                _local_14 = this._catalog.createChatStylePreview(ASCompat.parseInt(_local_16));
                                
                            case ProductTypeEnum.ROBOT:
                                _local_18 = this._catalog.avatarRenderManager.createAvatarImage(_local_16, AvatarScaleType.LARGE, null, this);
                                _local_18.setDirection(AvatarSetType.FULL, 3);
                                _local_18.appendAction(AvatarAction.EXPRESSION_WAVE);
                                _local_18.appendAction(AvatarAction.GESTURE, [AvatarAction.GESTURE_SMILE]);
                                _local_14 = _local_18.getImage(AvatarSetType.FULL, true);
                                _local_18.dispose();
                                
                        }
                        if (_local_13 != null)
                        {
                            _local_14 = _local_13.data;
                            this._imageId = _local_13.id;
                        }
                    }
                    else
                    {
                        _local_14 = _arg_2;
                    }
                    this.setImage(_local_14, true);
                    _Str_11981._Str_21471(k, Std.downcast(this._window.findChildByName("buy_button") , IButtonWindow));
                }
            }
        }

        function onSpendingDisclaimerClicked(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.target , ICheckBoxWindow);
            if (_local_2 != null)
            {
                this.setDisclaimerAccepted(_local_2.Selected);
            }
        }

        function setDisclaimerAccepted(k:Bool)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.findChildByName("buy_button");
            if (_local_2 == null)
            {
                return;
            }
            if (k)
            {
                _local_2.enable();
            }
            else
            {
                _local_2.disable();
            }
        }

        function updateLocalizations(k:IPurchasableOffer)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= this._catalog.getProductData(k.localizationId);
            var _local_3= ((_local_2 == null) ? "" : _local_2.name);
            this._catalog.windowManager.registerLocalizationParameter("catalog.purchase.confirmation.dialog.costs", "offer_name", _local_3);
        }

        function addClickListener(k:String, _arg_2:ASFunction)
        {
            var _local_3= this._window.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        public function getAvatarFaceBitmap(k:String):BitmapData
        {
            if (((this._catalog == null) || (this._catalog.avatarRenderManager == null)))
            {
                return null;
            }
            var _local_2:BitmapData = null;
            var _local_3= this._catalog.avatarRenderManager.createAvatarImage(k, AvatarScaleType.LARGE, null, this);
            if (_local_3 != null)
            {
_local_2 = _local_3.getCroppedImage(AvatarSetType.HEAD);
                _local_3.dispose();
            }
            return _local_2;
        }

        public function avatarImageReady(k:String)
        {
            if (((((this._catalog == null) || (this._window == null)) || this._window.disposed) || this.disposed))
            {
                return;
            }
            if (k == this._catalog.sessionDataManager.figure)
            {
                this.updateGiftDialogAvatarImage();
            }
            var _local_2= this._catalog.avatarRenderManager.createAvatarImage(k, AvatarScaleType.LARGE, null, this);
            _local_2.setDirection(AvatarSetType.FULL, 3);
            _local_2.appendAction(AvatarAction.EXPRESSION_WAVE);
            _local_2.appendAction(AvatarAction.GESTURE, [AvatarAction.GESTURE_SMILE]);
            var _local_3= _local_2.getImage(AvatarSetType.FULL, true);
            _local_2.dispose();
            this.setImage(_local_3, true);
        }

        function enableGiftDialogAvatarImage(k:Bool)
        {
            var _local_2= Std.downcast(this._window.findChildByName("avatar_image") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                if (k)
                {
                    this.updateGiftDialogAvatarImage();
                }
                else
                {
                    this.updateUnknownSenderAvatarImage();
                }
            }
            var _local_3= Std.downcast(this._window.findChildByName("message_from") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.visible = k;
            }
        }

        function updateGiftDialogAvatarImage()
        {
            var k= this.getAvatarFaceBitmap(this._catalog.sessionDataManager.figure);
            if (k != null)
            {
                this.updateAvatarImage(k);
            }
        }

        function updateUnknownSenderAvatarImage()
        {
            var _local_2:BitmapData = null;
            var k= Std.downcast(this._assets.getAssetByName("gift_incognito") , BitmapDataAsset);
            if (k != null)
            {
                _local_2 = ASCompat.dynamicAs(k.content , BitmapData);
                if (_local_2 != null)
                {
                    this.updateAvatarImage(_local_2.clone());
                }
            }
        }

        function updateAvatarImage(k:BitmapData)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("avatar_image") , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.bitmap = k;
            _local_2.width = k.width;
            _local_2.height = k.height;
        }

        function onShowFaceSelected(k:WindowEvent)
        {
            this.enableGiftDialogAvatarImage(true);
            this.updateGiftDialogAvatarImage();
        }

        function onShowFaceUnselected(k:WindowEvent)
        {
            this.enableGiftDialogAvatarImage(false);
        }

        function isShowPurchaserName():Bool
        {
            var k:ICheckBoxWindow = null;
            if (this.isModerator())
            {
                if (this._window != null)
                {
                    k = Std.downcast(this._window.findChildByName("show_face_checkbox") , ICheckBoxWindow);
                    if (k != null)
                    {
                        return k.Selected;
                    }
                }
                return false;
            }
            return true;
        }

        function updateGiftDialogLabels()
        {
            var _local_9:IWindow = null;
            if (((this._window == null) || this._window.disposed))
            {
                return;
            }
            var k= this.isDefaultBoxSelected();
            var _local_2= "";
            var _local_3= "";
            var _local_4:ILocalization = null;
            var _local_5= Std.downcast(this._window.findChildByName("pick_box_title") , ITextWindow);
            if (_local_5 != null)
            {
                _local_3 = (k ? "catalog.gift_wrapping_new.box.default" : ("catalog.gift_wrapping_new.box." + this._boxTypes[this._boxIndex]));
                _local_4 = this._localization.getLocalizationRaw(_local_3);
                _local_2 = _local_3;
                if (_local_4 != null)
                {
                    _local_2 = _local_4.value;
                }
                _local_5.text = _local_2;
            }
            var _local_6= Std.downcast(this._window.findChildByName("pick_box_price_title") , ITextWindow);
            if (_local_6 != null)
            {
                _local_3 = (k ? "catalog.gift_wrapping_new.freeprice" : "catalog.gift_wrapping_new.price");
                _local_4 = this._localization.getLocalizationRaw(_local_3);
                _local_2 = _local_3;
                if (_local_4 != null)
                {
                    _local_2 = _local_4.value;
                }
                _local_6.text = _local_2;
            }
            var _local_7= Std.downcast(this._window.findChildByName("price_box_container") , IItemListWindow);
            if (_local_7 != null)
            {
                _local_9 = _local_7.getListItemByName("small_coin");
                if (_local_9 != null)
                {
                    _local_9.visible = (!k);
                    _local_7.arrangeListItems();
                }
            }
            var _local_8= Std.downcast(this._window.findChildByName("pick_ribbon_title") , ITextWindow);
            if (_local_8 != null)
            {
                _local_3 = ("catalog.gift_wrapping_new.ribbon." + Std.string(this._ribbonIndex));
                _local_4 = this._localization.getLocalizationRaw(_local_3);
                _local_2 = _local_3;
                if (_local_4 != null)
                {
                    _local_2 = _local_4.value;
                }
                _local_8.text = _local_2;
            }
        }

        public function showGiftDialog()
        {
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11 = Math.NaN;
            if (this._window != null)
            {
                this._window.dispose();
            }
            var k= this._catalog.giftWrappingConfiguration;
            this._window = Std.downcast(this._catalog.utils.createWindow("gift_wrapping") , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.center();
            this.addClickListener("give_gift_button", this.onGiveGiftButtonClick);
            this.addClickListener("cancel_link_region", this.onCancelGift);
            this.addClickListener("header_button_close", this.onCancelGift);
            var _local_2= this._window.findChildByName("name_input");
            if (_local_2 != null)
            {
                if (this._userName != null)
                {
                    this.setReceiverName(this._userName);
                }
                else
                {
                    this.focusNameField();
                }
                this.updateNameHint();
                _local_2.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onNameInputChange);
                _local_2.addEventListener(WindowMouseEvent.DOWN, this.onNameInputMouseDown);
                _local_2.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onNameInputKeyUp);
                _local_2.addEventListener(WindowEvent.WINDOW_EVENT_FOCUSED, this.onNameInputFocus);
                _local_2.addEventListener(WindowEvent.WINDOW_EVENT_UNFOCUSED, this.onNameInputUnfocus);
            }
            var _local_3= Std.downcast(this._window.findChildByName("gift_card") , IStaticBitmapWrapperWindow);
            if (_local_3 != null)
            {
                _local_8 = this._catalog.getProperty("catalog.gift_wrapping_new.gift_card");
                if (_local_8 != "")
                {
                    _local_3.assetUri = (("${image.library.url}Giftcards/" + _local_8) + ".png");
                }
            }
            var _local_4= Std.downcast(this._window.findChildByName("show_face_checkbox") , ICheckBoxWindow);
            if (_local_4 != null)
            {
                if (this.isModerator())
                {
                    _local_4.visible = true;
                    _local_4.select();
                    _local_4.addEventListener(WindowEvent.WINDOW_EVENT_SELECT, this.onShowFaceSelected);
                    _local_4.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECT, this.onShowFaceUnselected);
                }
                else
                {
                    _local_4.visible = false;
                }
            }
            var _local_5= this._window.findChildByName("show_face_checkbox_title");
            if (((!(_local_5 == null)) && (!this.isModerator())))
            {
                _local_5.visible = false;
            }
            this.updateGiftDialogAvatarImage();
            var _local_6= this._window.findChildByName("message_input");
            if (_local_6 != null)
            {
                this.updateMessageHint();
                _local_6.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onMessageInputChange);
                _local_6.addEventListener(WindowEvent.WINDOW_EVENT_FOCUSED, this.onMessageInputFocus);
                _local_6.addEventListener(WindowEvent.WINDOW_EVENT_UNFOCUSED, this.onMessageInputUnfocus);
            }
            var _local_7= this._window.findChildByName("message_from");
            if (_local_7 != null)
            {
                _local_9 = this._catalog.sessionDataManager.userName;
                _local_10 = "catalog.gift_wrapping_new.message_from";
                this._localization.registerParameter(_local_10, "name", _local_9);
                _local_7.caption = this._localization.getLocalization(_local_10, _local_9);
            }
            this.addClickListener("ribbon_prev", this.onPreviousGiftWrap);
            this.addClickListener("ribbon_next", this.onNextGiftWrap);
            this.addClickListener("box_prev", this.onPreviousGiftBox);
            this.addClickListener("box_next", this.onNextGiftBox);
            this._localization.registerParameter("catalog.gift_wrapping_new.price", "price", Std.string(k.price));
            if (k.defaultStuffTypes.length > 0)
            {
                _local_11 = Math.ffloor((Math.random() * k.defaultStuffTypes.length));
                this._defaultStuffType = ASCompat.toInt(k.defaultStuffTypes[Std.int(_local_11)]);
            }
            this._stuffTypes = k.stuffTypes;
            this._boxTypes = this._boxTypes.concat(k.boxTypes);
            this._boxTypes.push(this._defaultStuffType);
            this._ribbonTypes = k.ribbonTypes;
            this._selectedTypeId = ASCompat.toInt(this._stuffTypes[0]);
            this._ribbonIndex = ASCompat.toInt(this._ribbonTypes[0]);
            this._boxIndex = this._catalog.getInteger("catalog.purchase.gift_wrapping.default_box_index", 0);
            if (((this._boxIndex < 0) || (this._boxIndex > (this._boxTypes.length - 1))))
            {
                this._boxIndex = 0;
            }
            this.initColorGrid();
            this.updateColorGrid();
            this.updatePreview();
        }

        function isModerator():Bool
        {
            return this._catalog.sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR);
        }

        function isDefaultBoxSelected():Bool
        {
            return this._boxTypes[this._boxIndex] == this._defaultStuffType;
        }

        function updatePreview()
        {
            if (this._ribbonIndex < 0)
            {
                this._ribbonIndex = (this._ribbonTypes.length - 1);
            }
            if (this._ribbonIndex > (this._ribbonTypes.length - 1))
            {
                this._ribbonIndex = 0;
            }
            if (this._boxIndex < 0)
            {
                this._boxIndex = (this._boxTypes.length - 1);
            }
            if (this._boxIndex > (this._boxTypes.length - 1))
            {
                this._boxIndex = 0;
            }
            var k= ASCompat.toInt(this._boxTypes[this._boxIndex]);
            if (isValentinesBox(k))
            {
                this._ribbonIndex = 10;
                if (this._ribbonIndex > (this._ribbonTypes.length - 1))
                {
                    this._ribbonIndex = 0;
                }
            }
            var _local_2= ASCompat.toInt((k * 1000) + this._ribbonTypes[this._ribbonIndex]);
            if (this._window == null)
            {
                return;
            }
            if (this._roomEngine == null)
            {
                return;
            }
            var _local_3= Std.string(_local_2);
            var _local_4= this._selectedTypeId;
            var _local_5= this.isDefaultBoxSelected();
            if (_local_5)
            {
                this.enableBoxColorAndRibbonSelectors(false);
                _local_4 = this._defaultStuffType;
                _local_3 = "";
            }
            else
            {
                if (isValentinesBox(k))
                {
                    this.enableBoxColorAndRibbonSelectors(false);
                }
                else
                {
                    this.enableBoxColorAndRibbonSelectors(true);
                    if (((k >= 3) && (k <= 6)))
                    {
                        this.enableBoxColorSelectors(false);
                    }
                }
            }
            var _local_6= this._roomEngine.getFurnitureImage(_local_4, new Vector3d(180), 64, this, 0, _local_3);
            if (_local_6 == null)
            {
                return;
            }
            this._imageId = _local_6.id;
            this.setImage(_local_6.data, true);
            this.showSuggestions(false);
            this.updateGiftDialogLabels();
        }

        function initColorGrid()
        {
            var _local_3 = 0;
            var _local_4:IFurnitureData = null;
            var _local_5:IWindowContainer = null;
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("color_grid") , IItemGridWindow);
            k.destroyGridItems();
            var _local_2= Std.downcast(this._catalog.utils.createWindow("gift_palette_item") , IWindowContainer);
            final _iter_ = this._stuffTypes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = ASCompat.toInt(_tmp_);
                _local_4 = this._catalog.getFurnitureData(_local_3, ProductTypeEnum.FLOOR);
                _local_5 = Std.downcast(_local_2.clone() , IWindowContainer);
                if (((!(_local_4 != null)) || (!(_local_5 != null))))
                {
                }
                else
                {
                    _local_5.addEventListener(WindowMouseEvent.CLICK, this.onColorItemClick);
                    _local_5.findChildByName("color").color = ASCompat.toUInt(_local_4.colours[0]);
                    _local_5.id = _local_3;
                    k.addGridItem(_local_5);
                }
            }
        }

        function giveGift()
        {
            var k= this._window.findChildByName("name_input");
            if (k == null)
            {
                return;
            }
            var _local_2= k.caption;
            var _local_3= this._window.findChildByName("message_input");
            var _local_4= ((_local_3 == null) ? "" : _local_3.caption);
            var _local_5= this.isDefaultBoxSelected();
            var _local_6= (_local_5 ? this._defaultStuffType : this._selectedTypeId);
            var _local_7= ASCompat.toInt(_local_5 ? 0 : ASCompat.toInt(this._boxTypes[this._boxIndex]));
            var _local_8= ASCompat.toInt(_local_5 ? 0 : ASCompat.toInt(this._ribbonTypes[this._ribbonIndex]));
            var _local_9= this.isShowPurchaserName();
            this._catalog.purchaseProductAsGift(this._pageId, this._offerId, this._extraParameter, _local_2, _local_4, _local_6, _local_7, _local_8, _local_9);
        }

        function safeDisable(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.disable();
            }
        }

        function safeEnable(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.enable();
            }
        }

        function onBuyButtonClick(k:WindowEvent)
        {
            this.safeDisable("buy_button");
            this.safeDisable("cancel_button");
            this.safeDisable("publish_check");
            this._catalog.purchaseProduct(this._pageId, this._offerId, this._extraParameter, this._quantity);
            var _local_2= this._catalog.currentPage;
            if (_local_2 != null)
            {
                _local_2.dispatchWidgetEvent(new _Str_3308(CatalogWidgetEvent.PURCHASE));
            }
        }

        function onGiftButtonClick(k:WindowEvent)
        {
            this.showGiftDialog();
            HabboTracking.getInstance().trackEventLog("Catalog", "clickConfirm", "client.buy_as_gift.clicked");
        }

        function onClose(k:WindowEvent)
        {
            this._catalog.resetPlacedOfferData();
            this.dispose();
        }

        function onGiveGiftButtonClick(k:WindowEvent)
        {
            this.giveGift();
            this.enableGiftButton(false);
            this._catalog.giftReceiver = null;
            this._catalog.resetPlacedOfferData();
        }

        function onCancelGift(k:WindowEvent)
        {
            this._catalog.resetPlacedOfferData();
            this.dispose();
        }

        function onPreviousGiftWrap(k:WindowEvent)
        {
            this._ribbonIndex--;
            this.updatePreview();
        }

        function onNextGiftWrap(k:WindowEvent)
        {
            this._ribbonIndex++;
            this.updatePreview();
        }

        function onPreviousGiftBox(k:WindowEvent)
        {
            this._boxIndex--;
            this.updatePreview();
        }

        function onNextGiftBox(k:WindowEvent)
        {
            this._boxIndex++;
            this.updatePreview();
        }

        function onNameInputChange(k:WindowEvent)
        {
            var _local_5:String = null;
            var _local_2= k.target;
            if (_local_2 == null)
            {
                return;
            }
            this.updateNameHint();
            if (this._receiverName == _local_2.caption)
            {
                return;
            }
            var _local_3= _local_2.caption.toLowerCase();
            var _local_4:Array<ASAny> = [];
            final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (_local_5.toLowerCase().indexOf(_local_3) != -1)
                {
                    _local_4.push(_local_5);
                }
                if (_local_4.length >= PurchaseConfirmationDialog.MAX_SUGGESTIONS)
                {
                    break;
                }
            }
            this._receiverName = _local_2.caption;
            this.updateSuggestions(_local_4);
        }

        function onNameInputMouseDown(k:WindowEvent)
        {
            var _local_2= k.target;
            if (_local_2 == null)
            {
                return;
            }
            this.showSuggestions(false);
        }

        function onNameInputKeyUp(k:WindowEvent)
        {
            var _local_4 = false;
            var _local_2= Std.downcast(k , WindowKeyboardEvent);
            var _local_3= k.target;
            switch (_local_2.keyCode)
            {
                case Keyboard.UP:
                    this.highlightSuggestion((this._highlightIndex - 1));
                    return;
                case Keyboard.DOWN:
                    this.highlightSuggestion((this._highlightIndex + 1));
                    if (_local_3 != null)
                    {
                        if (_local_3.caption.length == 0)
                        {
                            if (((this._suggestionContainer == null) || (!this._suggestionContainer.visible)))
                            {
                                _local_4 = this.showAllFriendSuggestions();
                                if (_local_4)
                                {
                                    this.highlightSuggestion(0);
                                }
                            }
                        }
                    }
                    return;
                case Keyboard.ENTER:
                    this.selectHighlighted();
                    return;
                case Keyboard.TAB:
                    this.focusMessageField();
                    return;
            }
        }

        function showAllFriendSuggestions():Bool
        {
            var k:Array<ASAny> = null;
            var _local_2:String = null;
            if (((!(this._friends == null)) && (this._friends.length > 0)))
            {
                k = [];
                final _iter_ = this._friends; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    k.push(_local_2);
                    if (k.length >= PurchaseConfirmationDialog.MAX_SUGGESTIONS)
                    {
                        break;
                    }
                }
                this.updateSuggestions(k);
                this.showSuggestions(true);
                return true;
            }
            return false;
        }

        function focusNameField()
        {
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("name_input") , ITextFieldWindow);
            if (k == null)
            {
                return;
            }
            k.visible = true;
            k.focus();
        }

        function focusMessageField()
        {
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("message_input") , ITextFieldWindow);
            if (k == null)
            {
                return;
            }
            k.visible = true;
            k.focus();
        }

        function selectHighlighted()
        {
            if (((this._suggestionContainer == null) || (!this._suggestionContainer.visible)))
            {
                return;
            }
            var k= Std.downcast(this._suggestionContainer.findChildByName("suggestion_list") , IItemListWindow);
            if (k == null)
            {
                return;
            }
            var _local_2= Std.downcast(k.getListItemAt(this._highlightIndex) , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.findChildByName("name_text");
            if (_local_3 == null)
            {
                return;
            }
            this.setReceiverName(_local_3.caption);
            this.showSuggestions(false);
        }

        function showSuggestions(k:Bool)
        {
            if (this._suggestionContainer == null)
            {
                return;
            }
            this._suggestionContainer.visible = k;
            if (!k)
            {
                this.showMessageInput(true);
            }
        }

        function showMessageInput(k:Bool)
        {
            var _local_2= this._window.findChildByName("message_input");
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
        }

        function onMessageInputChange(k:WindowEvent)
        {
            var _local_2= k.target;
            if (_local_2 == null)
            {
                return;
            }
            this.updateMessageHint();
        }

        function onNameInputFocus(k:WindowEvent)
        {
            var _local_2= k.target;
            if (_local_2 == null)
            {
                return;
            }
            this.updateNameHint();
        }

        function onNameInputUnfocus(k:WindowEvent)
        {
            var _local_2= k.target;
            if (_local_2 == null)
            {
                return;
            }
            this.updateNameHint();
        }

        function onMessageInputFocus(k:WindowEvent)
        {
            this.updateMessageHint();
            this.showSuggestions(false);
        }

        function onMessageInputUnfocus(k:WindowEvent)
        {
            this.updateMessageHint();
        }

        function updateNameHint()
        {
            if (this._window == null)
            {
                return;
            }
            var k= this._window.findChildByName("name_input");
            if (k == null)
            {
                return;
            }
            var _local_2= k.caption;
            if (((_local_2 == null) || (_local_2.length == 0)))
            {
                this.enableHint(true, "name_input_hint", "catalog.gift_wrapping_new.name_hint");
            }
            else
            {
                this.enableHint(false, "name_input_hint", "catalog.gift_wrapping_new.name_hint");
            }
        }

        function updateMessageHint()
        {
            if (this._window == null)
            {
                return;
            }
            var k= this._window.findChildByName("message_input");
            if (k == null)
            {
                return;
            }
            var _local_2= k.caption;
            if (((_local_2 == null) || (_local_2.length == 0)))
            {
                this.enableHint(true, "message_input_hint", "catalog.gift_wrapping_new.message_hint");
            }
            else
            {
                this.enableHint(false, "message_input_hint", "catalog.gift_wrapping_new.message_hint");
            }
        }

        function enableHint(k:Bool, _arg_2:String, _arg_3:String)
        {
            var _local_4= Std.downcast(this._window.findChildByName(_arg_2) , ITextWindow);
            if (_local_4 != null)
            {
                _local_4.text = this._localization.getLocalization(_arg_3);
                _local_4.visible = k;
            }
        }

        function enableRibbonSelectors(k:Bool)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.findChildByName("ribbon_prev");
            this.enableWindow(_local_2, k);
            var _local_3= this._window.findChildByName("ribbon_next");
            this.enableWindow(_local_3, k);
            var _local_4= this._window.findChildByName("pick_ribbon_title");
            this.enableWindow(_local_4, k);
        }

        function enableBoxColorAndRibbonSelectors(k:Bool)
        {
            this.enableBoxColorSelectors(k);
            this.enableRibbonSelectors(k);
        }

        function enableBoxColorSelectors(k:Bool)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.findChildByName("box_color_title");
            this.enableWindow(_local_2, k);
            var _local_3= Std.downcast(this._window.findChildByName("color_picker_container") , IWindowContainer);
            if (_local_3 != null)
            {
                this.enableWindow(_local_3, k);
            }
        }

        function enableWindow(k:IWindow, _arg_2:Bool)
        {
            var _local_3:IIterator = null;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:IWindow = null;
            this.enableElement(k, _arg_2);
            if (Std.is(k , IIterable))
            {
                _local_3 = cast(k, IIterable).iterator;
                _local_4 = ASCompat.toInt(_local_3.length);
                if (_local_4 > 0)
                {
                    _local_5 = 0;
                    while (_local_5 < _local_4)
                    {
                        _local_6 = ASCompat.dynamicAs(com.sulake.core.utils.ASProxy.get(_local_3, _local_5), IWindow);
                        if (_local_6 != null)
                        {
                            this.enableElement(_local_6, _arg_2);
                            if (Std.is(_local_6 , IIterable))
                            {
                                this.enableWindow(_local_6, _arg_2);
                            }
                        }
                        _local_5++;
                    }
                }
            }
        }

        function enableElement(k:IWindow, _arg_2:Bool)
        {
            if (_arg_2)
            {
                k.blend = 1;
                k.enable();
            }
            else
            {
                k.blend = 0.5;
                k.disable();
            }
        }

        function updateSuggestions(k:Array<ASAny>)
        {
            var _local_4:String = null;
            var _local_5:IWindowContainer = null;
            var _local_6:ITextWindow = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:TextFormat = null;
            var _local_10 = 0;
            if (this._suggestionContainer == null)
            {
                this._suggestionContainer = Std.downcast(this._window.findChildByName("suggestion_container") , IWindowContainer);
            }
            if (this._suggestionsListItem == null)
            {
                this._suggestionsListItem = Std.downcast(this._catalog.utils.createWindow("suggestion_list_item_new") , IWindowContainer);
            }
            if (((this._suggestionContainer == null) || (this._suggestionsListItem == null)))
            {
                return;
            }
            var _local_2= Std.downcast(this._suggestionContainer.findChildByName("suggestion_list") , IItemListWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.removeListItems();
            if (k.length == 0)
            {
                this.showSuggestions(false);
                return;
            }
            this.showSuggestions(true);
            var _local_3 = 0;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _local_5 = Std.downcast(this._suggestionsListItem.clone() , IWindowContainer);
                if (_local_5 != null)
                {
                    _local_5.addEventListener(WindowMouseEvent.CLICK, this.onSuggestionsClick);
                    _local_5.addEventListener(WindowMouseEvent.OVER, this.onSuggestionsMouseOver);
                    _local_6 = Std.downcast(_local_5.findChildByName("name_text") , ITextWindow);
                    if (_local_6 != null)
                    {
                        _local_6.text = _local_4;
                        if (this._receiverName != null)
                        {
                            _local_7 = this._receiverName.length;
                            if (_local_7 > 0)
                            {
                                _local_8 = _local_4.toLowerCase().indexOf(this._receiverName.toLowerCase());
                                if (_local_8 != -1)
                                {
                                    _local_9 = _local_6.getTextFormat();
                                    _local_9.bold = true;
                                    _local_10 = (_local_8 + _local_7);
                                    if (_local_10 > _local_4.length)
                                    {
                                        _local_10 = _local_4.length;
                                    }
                                    _local_6.setTextFormat(_local_9, _local_8, _local_10);
                                }
                            }
                        }
                        _local_2.addListItem(_local_5);
                    }
                    _local_5.color = this.getColor(_local_3);
                    _local_3++;
                }
            }
            this.showMessageInput((k.length < 2));
            this.highlightSuggestion(0);
        }

        function onSuggestionsClick(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.findChildByName("name_text") , ITextWindow);
            if (_local_3 == null)
            {
                return;
            }
            this.setReceiverName(_local_3.text);
            this.showSuggestions(false);
        }

        function onSuggestionsMouseOver(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._suggestionContainer.findChildByName("suggestion_list") , IItemListWindow);
            if (_local_3 == null)
            {
                return;
            }
            this.highlightSuggestion(_local_3.getListItemIndex(_local_2));
        }

        function highlightSuggestion(k:Int)
        {
            var _local_3:IWindowContainer = null;
            if (this._suggestionContainer == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._suggestionContainer.findChildByName("suggestion_list") , IItemListWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_3 = Std.downcast(_local_2.getListItemAt(this._highlightIndex) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.color = this.getColor(this._highlightIndex);
            }
            this._highlightIndex = k;
            if (this._highlightIndex < 0)
            {
                this._highlightIndex = (_local_2.numListItems - 1);
            }
            if (this._highlightIndex >= _local_2.numListItems)
            {
                this._highlightIndex = 0;
            }
            _local_3 = Std.downcast(_local_2.getListItemAt(this._highlightIndex) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.color = PurchaseConfirmationDialog.COLOR_HIGHLIGHT;
            }
        }

        function getColor(k:Int):UInt
        {
            return ((k % 2) == 0) ? PurchaseConfirmationDialog.COLOR_EVEN : PurchaseConfirmationDialog.COLOR_ODD;
        }

        function setReceiverName(k:String)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.findChildByName("name_input");
            if (_local_2 == null)
            {
                return;
            }
            _local_2.caption = k;
            this.updateNameHint();
            this.focusMessageField();
        }

        function onColorItemClick(k:WindowEvent)
        {
            this._selectedTypeId = k.target.id;
            this.updateColorGrid();
            this.updatePreview();
        }

        function updateColorGrid()
        {
            var _local_2:IWindowContainer = null;
            var _local_3:IWindow = null;
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("color_grid") , IItemGridWindow);
            if (k == null)
            {
                return;
            }
            var _local_4 = 0;
            while ((_local_4 : UInt) < k.numGridItems)
            {
                _local_2 = Std.downcast(k.getGridItemAt(_local_4) , IWindowContainer);
                if (_local_2 == null)
                {
                }
                else
                {
                    _local_3 = _local_2.findChildByName("selection");
                    if (_local_3 == null)
                    {
                    }
                    else
                    {
                        _local_3.visible = (_local_2.id == this._selectedTypeId);
                    }
                }
                _local_4++;
            }
        }

        public function receiverNotFound()
        {
            if (this.disposed)
            {
                return;
            }
            this.enableGiftButton(true);
            if (((!(this._catalog != null)) || (!(this._catalog.windowManager != null))))
            {
                return;
            }
            this._catalog.windowManager.alert(("$" + "{catalog.gift_wrapping.receiver_not_found.title}"), ("$" + "{catalog.gift_wrapping.receiver_not_found.info}"), 0, this.alertHandler);
        }

        function alertHandler(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            this.enableGiftButton(true);
        }

        function enableGiftButton(k:Bool)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("give_gift_button") , IButtonWindow);
            if (_local_2 != null)
            {
                if (k)
                {
                    _local_2.enable();
                }
                else
                {
                    _local_2.disable();
                }
            }
        }

        public function notEnoughCredits()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._window == null)
            {
                return;
            }
            this.enableGiftButton(true);
            this.safeEnable("header_button_close");
            var k= Std.downcast(this._window.findChildByName("use_free_checkbox") , ICheckBoxWindow);
            if (k != null)
            {
                k.select();
            }
        }

        public function turnIntoGifting()
        {
            var k= this._window.findChildByName("buy_button");
            k.removeEventListener(WindowMouseEvent.CLICK, this.onBuyButtonClick);
            k.addEventListener(WindowMouseEvent.CLICK, this.onGiftButtonClick);
            k.caption = "${catalog.purchase_confirmation.gift}";
            this._window.caption = "${catalog.purchase_confirmation.gift.title}";
        }
    }

