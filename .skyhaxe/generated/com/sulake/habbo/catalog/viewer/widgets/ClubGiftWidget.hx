package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.club.ClubGiftController;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubGiftData;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.viewer.Product;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Rectangle;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.assets.XmlAsset;

     class ClubGiftWidget extends CatalogWidget
    {
        static inline final _Str_6060= 31;

        var _controller:ClubGiftController;
        var _offers:Map;
        var _preview:IWindowContainer;
        var _catalog:HabboCatalog;

        public function new(k:IWindowContainer, _arg_2:ClubGiftController, _arg_3:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_3;
            this._controller = _arg_2;
            this._offers = new Map();
        }

        override public function dispose()
        {
            super.dispose();
            this._controller = null;
            this._catalog = null;
            if (this._preview != null)
            {
                this._preview.dispose();
                this._preview = null;
            }
        }

        override public function init():Bool
        {
            if (window == null)
            {
                return false;
            }
            if (!super.init())
            {
                return false;
            }
            this._controller.widget = this;
            _Str_2819(CatalogWidgetEnum.CLUB_GIFT);
            _window.findChildByName("info_text").caption = "";
            _window.findChildByName("past_club_days").caption = "";
            _window.findChildByName("past_vip_days").caption = "";
            this.update();
            return true;
        }

        public function update()
        {
            this._Str_11602();
            this._Str_11855();
        }

        function _Str_11602()
        {
            var _local_2:String = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_7 = 0;
            if (((!(this._controller != null)) || (!(window != null))))
            {
                return;
            }
            var k= window.findChildByName("info_text");
            if (k == null)
            {
                return;
            }
            if (this._controller._Str_7574 > 0)
            {
                _local_2 = "catalog.club_gift.available";
                this._controller.localization.registerParameter(_local_2, "amount", Std.string(this._controller._Str_7574));
            }
            else
            {
                if (this._controller._Str_12860 > 0)
                {
                    _local_2 = "catalog.club_gift.days_until_next";
                    this._controller.localization.registerParameter(_local_2, "days", Std.string(this._controller._Str_12860));
                }
                else
                {
                    if (this._controller._Str_6454)
                    {
                        _local_2 = "catalog.club_gift.not_available";
                    }
                    else
                    {
                        _local_2 = "catalog.club_gift.no_club";
                    }
                }
            }
            k.caption = this._controller.localization.getLocalization(_local_2);
            if (this._controller.purse == null)
            {
                return;
            }
            var _local_5= window.findChildByName("past_club_days");
            if (_local_5 != null)
            {
                _local_7 = (this._controller.purse.pastClubDays + this._controller.purse.pastVipDays);
                _local_2 = ((_local_7 >= ClubGiftWidget._Str_6060) ? "catalog.club_gift.past_club.long" : "catalog.club_gift.past_club");
                _local_3 = (_local_7 % ClubGiftWidget._Str_6060);
                _local_4 = Std.int(_local_7 / ClubGiftWidget._Str_6060);
                this._controller.localization.registerParameter(_local_2, "days", Std.string(_local_3));
                this._controller.localization.registerParameter(_local_2, "months", Std.string(_local_4));
                _local_5.caption = this._controller.localization.getLocalization(_local_2);
            }
            var _local_6= window.findChildByName("past_vip_days");
            if (_local_6 != null)
            {
                _local_2 = ((this._controller.purse.pastVipDays >= ClubGiftWidget._Str_6060) ? "catalog.club_gift.past_vip.long" : "catalog.club_gift.past_vip");
                _local_3 = (this._controller.purse.pastVipDays % ClubGiftWidget._Str_6060);
                _local_4 = Std.int(this._controller.purse.pastVipDays / ClubGiftWidget._Str_6060);
                this._controller.localization.registerParameter(_local_2, "days", Std.string(_local_3));
                this._controller.localization.registerParameter(_local_2, "months", Std.string(_local_4));
                _local_6.caption = this._controller.localization.getLocalization(_local_2);
            }
        }

        function _Str_11855()
        {
            var k:IPurchasableOffer = null;
            var _local_2:Array<ASAny> = null;
            var _local_5:IWindow = null;
            var _local_6:CatalogPageMessageOfferData = null;
            var _local_7:Vector<IProduct> = null;
            var _local_8:IProductData = null;
            var _local_9:CatalogPageMessageProductData = null;
            var _local_10:ClubGiftData = null;
            var _local_11:IFurnitureData = null;
            var _local_12:Product = null;
            if ((((!(this._controller != null)) || (!(window != null))) || (!(page != null))))
            {
                return;
            }
            final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._offers.reset();
            _local_2 = this._controller._Str_16489();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._controller._Str_23509();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.downcast(window.findChildByName("gift_list") , IItemListWindow);
            if (_local_4 == null)
            {
                return;
            }
            _local_4.destroyListItems();
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_6  = _tmp_;
                _local_7 = new Vector<IProduct>(0);
                _local_8 = this._controller.catalog.getProductData(_local_6.localizationId);
                final _iter_ = _local_6.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_9  = _tmp_;
                    _local_11 = this._controller.catalog.getFurnitureData(_local_9.furniClassId, _local_9.productType);
                    _local_12 = new Product(_local_9.productType, _local_9.furniClassId, _local_9.extraParam, _local_9.productCount, _local_8, _local_11, this._catalog);
                    _local_7.push(_local_12);
                }
                k = new Offer(_local_6.offerId, _local_6.localizationId, _local_6.isRent, _local_6.priceInCredits, _local_6.priceInActivityPoints, _local_6.activityPointType, _local_6.giftable, _local_6.clubLevel, _local_7, _local_6.bundlePurchaseAllowed, this._catalog);
                k.page = page;
                _local_10 = ASCompat.dynamicAs(_local_3.getValue(k.offerId) , ClubGiftData);
                _local_5 = this._Str_6850(k, _local_10);
                if (_local_5 == null)
                {
                }
                else
                {
                    _local_4.addListItem(_local_5);
                    this._offers.add(k.offerId, k);
                }
            }
        }

        function _Str_6850(k:IPurchasableOffer, _arg_2:ClubGiftData):IWindow
        {
            var _local_6 = 0;
            var _local_7:String = null;
            var _local_12 = 0;
            var _local_13 = 0;
            if ((((!(k != null)) || (!(k.product != null))) || (!(_arg_2 != null))))
            {
                return null;
            }
            var _local_3= Std.downcast(this.createWindow("club_gift_list_item") , IWindowContainer);
            if (_local_3 == null)
            {
                return null;
            }
            _local_3.procedure = this.clickHandler;
            var _local_4= k.product;
            if (_local_4 == null)
            {
                return null;
            }
            var _local_5= _local_4.productData;
            if (_local_5 == null)
            {
                return null;
            }
            this.setText(_local_3.findChildByName("gift_name"), _local_5.name);
            this.setText(_local_3.findChildByName("gift_desc"), _local_5.description);
            if (_arg_2._Str_12313)
            {
                _local_6 = (_arg_2._Str_21146 - this._controller.purse.pastVipDays);
            }
            else
            {
                _local_6 = (_arg_2._Str_21146 - (this._controller.purse.pastClubDays + this._controller.purse.pastVipDays));
            }
            if (((!_arg_2.isSelectable) && (_local_6 > 0)))
            {
                if (_arg_2._Str_12313)
                {
                    _local_7 = "catalog.club_gift.vip_missing";
                }
                else
                {
                    _local_7 = "catalog.club_gift.club_missing";
                }
                if (_local_6 >= ClubGiftWidget._Str_6060)
                {
                    _local_7 = (_local_7 + ".long");
                }
                _local_12 = (_local_6 % ClubGiftWidget._Str_6060);
                _local_13 = Std.int(_local_6 / ClubGiftWidget._Str_6060);
                this._controller.localization.registerParameter(_local_7, "days", Std.string(_local_12));
                this._controller.localization.registerParameter(_local_7, "months", Std.string(_local_13));
            }
            else
            {
                if (this._controller._Str_7574 > 0)
                {
                    _local_7 = "catalog.club_gift.selectable";
                }
                else
                {
                    _local_7 = "";
                }
            }
            this.setText(_local_3.findChildByName("months_required"), ((_local_7.length > 0) ? this._controller.localization.getLocalization(_local_7) : ""));
            var _local_8= Std.downcast(_local_3.findChildByName("vip_icon") , IIconWindow);
            if (_local_8 != null)
            {
                _local_8.visible = _arg_2._Str_12313;
            }
            var _local_9= Std.downcast(_local_3.findChildByName("select_button") , IButtonWindow);
            if (_local_9 != null)
            {
                if ((_arg_2.isSelectable && (this._controller._Str_7574 > 0)))
                {
                    _local_9.enable();
                }
                else
                {
                    _local_9.disable();
                }
                _local_9.id = k.offerId;
            }
            var _local_10= k.productContainer;
            if (_local_10 == null)
            {
                return null;
            }
            if ((((!(page != null)) || (!(page.viewer != null))) || (!(page.viewer.roomEngine != null))))
            {
                return null;
            }
            var _local_11= Std.downcast(_local_3.findChildByName("image_container") , IWindowContainer);
            if (_local_11 != null)
            {
                _local_10.view = _local_11;
                _local_10.initProductIcon(page.viewer.roomEngine);
                _local_11.procedure = this._Str_24976;
                _local_11.id = k.offerId;
            }
            return _local_3;
        }

        function setText(k:IWindow, _arg_2:String)
        {
            k.caption = _arg_2;
        }

        function clickHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (((((!(k != null)) || (!(_arg_2 != null))) || (!(this._offers != null))) || (!(this._controller != null))))
            {
                return;
            }
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (_arg_2.name != "select_button")
            {
                return;
            }
            var _local_3:IPurchasableOffer = this._offers.getValue(_arg_2.id);
            if (_local_3 == null)
            {
                return;
            }
            this._controller._Str_24080(_local_3);
        }

        function _Str_24976(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:Rectangle = null;
            if ((((!(k != null)) || (!(_arg_2 != null))) || (!(this._offers != null))))
            {
                return;
            }
            if (_arg_2.name != "image_container")
            {
                return;
            }
            var _local_3:IPurchasableOffer = this._offers.getValue(_arg_2.id);
            if (_local_3 == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                _local_4 = new Rectangle();
                _arg_2.getGlobalRectangle(_local_4);
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                this._Str_23606();
            }
        }

        function showPreview(k:Offer, _arg_2:Rectangle)
        {
            var _local_5:ImageResult = null;
            if (((!(k != null)) || (!(k.productContainer != null))))
            {
                return;
            }
            if ((((!(page != null)) || (!(page.viewer != null))) || (!(page.viewer.roomEngine != null))))
            {
                return;
            }
            var _local_3= k.product;
            if (_local_3 == null)
            {
                return;
            }
            if (this._preview == null)
            {
                this._preview = Std.downcast(this.createWindow("club_gift_preview") , IWindowContainer);
            }
            if (this._preview == null)
            {
                return;
            }
            var _local_4= Std.downcast(this._preview.findChildByName("image") , IBitmapWrapperWindow);
            if (_local_4 == null)
            {
                return;
            }
            switch (_local_3.productType)
            {
                case ProductTypeEnum.FLOOR:
                    _local_5 = page.viewer.roomEngine.getFurnitureImage(_local_3.productClassId, new Vector3d(90), 64, null, 0, _local_3.extraParam);
                    
                case ProductTypeEnum.WALL:
                    _local_5 = page.viewer.roomEngine.getWallItemImage(_local_3.productClassId, new Vector3d(90), 64, null, 0, _local_3.extraParam);
                    
                default:
                    return;
            }
            if (((!(_local_5 != null)) || (!(_local_5.data != null))))
            {
                return;
            }
            _local_4.width = _local_5.data.width;
            _local_4.height = _local_5.data.height;
            if (_local_4.bitmap != null)
            {
                _local_4.bitmap.dispose();
            }
            _local_4.bitmap = new BitmapData(_local_4.width, _local_4.height);
            _local_4.bitmap.draw(_local_5.data);
            _local_5.data.dispose();
            var _local_6= Point.interpolate(_arg_2.topLeft, _arg_2.bottomRight, 0.5);
            this._preview.setGlobalPosition(_local_6.subtract(new Point((this._preview.width / 2), (this._preview.height / 2))));
            this._preview.visible = true;
            this._preview.activate();
        }

        function _Str_23606()
        {
            if (this._preview != null)
            {
                this._preview.visible = false;
            }
        }

        function createWindow(k:String):IWindow
        {
            if ((((!(this._controller != null)) || (!(this._controller.assets != null))) || (!(this._controller.windowManager != null))))
            {
                return null;
            }
            var _local_2= Std.downcast(this._controller.assets.getAssetByName(k) , XmlAsset);
            if (((!(_local_2 != null)) || (!_local_2.content)))
            {
                return null;
            }
            var _local_3= ((_local_2.content : com.sulake.core.utils.xml.XML) );
            if (_local_3 == null)
            {
                return null;
            }
            return this._controller.windowManager.buildFromXML(_local_3);
        }
    }

