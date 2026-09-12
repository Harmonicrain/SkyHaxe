package com.sulake.habbo.catalog
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.catalog.club.ClubBenefitsDialog;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import flash.geom.Matrix;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;

     class HabboCatalogUtils implements IDisposable implements  IGetImageListener 
    {
        static inline final CREDIT= "credit";
        static inline final ACTIVITYPOINT= "activityPoint";

        var _Str_11721:String = "HCU_dynamic_badge";
        var _disposed:Bool = false;
        var _habboCatalog:HabboCatalog;
        var _Str_9622:ClubBenefitsDialog;
        var _Str_13008:Array<ASAny>;
        var _Str_16414:Int = 0;
        var _Str_9144:ASDictionary<ASAny,ASAny>;
        var _Str_21405:Bool = false;
        var _Str_19703:Bool = false;
        var _Str_22047:Bool = false;

        public function new(k:HabboCatalog)
        {
            this._Str_13008 = ASCompat.allocArray(0);
            this._Str_9144 = new ASDictionary<ASAny,ASAny>();
            this._habboCatalog = k;
        }

        public static function _Str_21831(k:String):Bool
        {
            return (k.indexOf("builders_club") == 0) || (k.indexOf("loyalty_bc") == 0);
        }

        public static function _Str_14396(k:IBitmapWrapperWindow, _arg_2:BitmapData, _arg_3:Rectangle=null)
        {
            if (k.bitmap == null)
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0);
            }
            else
            {
                k.bitmap.fillRect(k.bitmap.rect, 0);
            }
            var _local_4= k.bitmap;
            var _local_5= ((_arg_3 != null) ? _arg_3 : _arg_2.rect);
            _local_4.copyPixels(_arg_2, _local_5, new Point(((_local_4.width - _local_5.width) / 2), ((_local_4.height - _local_5.height) / 2)), null, null, true);
            k.invalidate();
        }


        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._Str_9622 != null)
                {
                    this._Str_9622.dispose();
                    this._Str_9622 = null;
                }
                this._habboCatalog = null;
                this._Str_9144 = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function createWindow(k:String, _arg_2:UInt=1, _arg_3:Map=null):IWindow
        {
            var _local_7:Array<ASAny> = null;
            var _local_8:IWindow = null;
            var _local_9:IBitmapWrapperWindow = null;
            if (((this._habboCatalog.windowManager == null) || (this._habboCatalog.assets == null)))
            {
                return null;
            }
            var _local_4= Std.downcast(this._habboCatalog.assets.getAssetByName(k) , XmlAsset);
            if (((_local_4 == null) || (_local_4.content == null)))
            {
                return null;
            }
            var _local_5= this._habboCatalog.windowManager.buildFromXML(((_local_4.content : com.sulake.core.utils.xml.XML) ), _arg_2, _arg_3);
            var _local_6= Std.downcast(_local_5 , IWindowContainer);
            if (_local_6 != null)
            {
                _local_7 = [];
                _local_6.groupChildrenWithTag("bitmap", _local_7, -1);
                if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
                {
_local_8  = _tmp_;
                    _local_9 = Std.downcast(_local_8 , IBitmapWrapperWindow);
                    if (_local_9 != null)
                    {
                        _local_9.disposesBitmap = false;
                        this._Str_25276(_local_9, _local_9.bitmapAssetName);
                    }
                }
            }
            return _local_5;
        }

        public function _Str_6455(k:IWindowContainer, _arg_2:IPurchasableOffer, _arg_3:Int=1, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            if (_arg_2 == null)
            {
                return;
            }
            var _local_6= this._Str_25756(_arg_2, _arg_3, _arg_4);
            this._Str_24235(k, _local_6, _arg_4, _arg_5, false);
        }

        function _Str_24235(k:IWindowContainer, _arg_2:Array<ASAny>, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool)
        {
            var _local_6= this._Str_24668(k);
            if (_local_6 == null)
            {
                return;
            }
            var _local_7 = 0;
            while (_local_7 < _arg_2.length)
            {
                this._Str_23443(_local_6, _local_7, _arg_2[_local_7], _arg_3, _arg_4, _arg_5);
                _local_7++;
            }
            var _local_8= (_local_7 * 2);
            while (_local_6.numListItems > _local_8)
            {
                _local_6.removeListItemAt(_local_8);
            }
            k.addChild(_local_6);
        }

        function _Str_23443(k:IItemListWindow, _arg_2:Int, _arg_3:ASObject, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool)
        {
            var _local_7= Std.downcast(k.getListItemByName(("amount_" + Std.string(_arg_2))) , ITextWindow);
            var _local_8= k.getListItemByName(("unit_" + Std.string(_arg_2)));
            _local_7.text = (_arg_6 ? "" : (((_arg_2 > 0) ? "+ " : "") + _arg_3.amount));
            _local_8.style = ActivityPointTypeEnum.getIconStyleFor(ASCompat.toInt(_arg_3.unit), this._habboCatalog, true, _arg_5);
            _local_8.width = ((_arg_4 && _arg_5) ? 53 : 22);
        }

        function _Str_24668(k:IWindowContainer):IItemListWindow
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= Std.downcast(this.createWindow("price_display") , IItemListWindow);
            if (_local_2 == null)
            {
                return null;
            }
            while (k.numChildren > 0)
            {
                k.removeChildAt(0).dispose();
            }
            return _local_2;
        }

        function _Str_25756(k:IPurchasableOffer, _arg_2:Int, _arg_3:Bool):Array<ASAny>
        {
            var _local_5 = 0;
            var _local_4= -1;
            var _local_6:Array<ASAny> = [];
            if (k.priceInCredits > 0)
            {
                _local_5 = this._Str_4488(k.bundlePurchaseAllowed, k.priceInCredits, _arg_2);
                _local_4 = (_arg_3 ? this._habboCatalog.getSeasonalCurrencyActivityPointType() : -1);
                _local_6.push({
                    "amount":_local_5,
                    "unit":_local_4
                });
            }
            if (k.priceInActivityPoints > 0)
            {
                _local_5 = this._Str_4488(k.bundlePurchaseAllowed, k.priceInActivityPoints, _arg_2);
                _local_6.push({
                    "amount":_local_5,
                    "unit":k.activityPointType
                });
            }
            if (_local_6.length == 0)
            {
                _local_6.push({
                    "amount":0,
                    "unit":-1
                });
            }
            return _local_6;
        }

        public function getPriceMap(k:IPurchasableOffer, _arg_2:Int):Map
        {
            var _local_3 = 0;
            var _local_4= new Map();
            if (k.priceInCredits > 0)
            {
                _local_3 = this._Str_4488(k.bundlePurchaseAllowed, k.priceInCredits, _arg_2);
                _local_4.add(CREDIT, {"amount":_local_3});
            }
            if (k.priceInActivityPoints > 0)
            {
                _local_3 = this._Str_4488(k.bundlePurchaseAllowed, k.priceInActivityPoints, _arg_2);
                _local_4.add(ACTIVITYPOINT, {
                    "amount":_local_3,
                    "activityPointType":k.activityPointType
                });
            }
            if (_local_4.length == 0)
            {
                _local_4.add(CREDIT, {"amount":0});
            }
            return _local_4;
        }

        public function _Str_7075(k:IPurchasableOffer, _arg_2:IWindowContainer, _arg_3:IWindow, _arg_4:IWindow, _arg_5:Int, _arg_6:Bool, _arg_7:Int, _arg_8:Bool=false, _arg_9:Bool=false):IWindow
        {
            var _local_11:IWindow = null;
            if (_arg_3 != null)
            {
                _arg_2.removeChild(_arg_3);
                _arg_3.dispose();
            }
            if (this._habboCatalog.catalogType == CatalogType.BUILDER)
            {
                return null;
            }
            _arg_3 = this._habboCatalog.utils.createWindow("priceDisplayWidget");
            _arg_2.addChild(_arg_3);
            var _local_10= Std.downcast(_arg_2.findChildByName("price_box_new") , IWindowContainer);
            if (_local_10 != null)
            {
                this._habboCatalog.utils._Str_6455(_local_10, k, 1, _arg_8, _arg_9);
                _local_11 = _arg_2.findChildByName("room_canvas_container");
                if (_local_11 == null)
                {
                    _local_11 = _arg_4;
                }
                if (_local_11 != null)
                {
                    _arg_3.x = (((_local_11.x + _local_11.width) + _arg_5) - _arg_3.width);
                    if (_arg_6)
                    {
                        _arg_3.y = (_local_11.y + _arg_7);
                    }
                    else
                    {
                        _arg_3.y = ((_local_11.y + _local_11.height) - (_arg_3.height + _arg_7));
                    }
                }
                if (k.priceInActivityPoints == 0)
                {
                    _arg_3.color = 14992765;
                }
                if (k.priceInCredits == 0)
                {
                    switch (k.activityPointType)
                    {
                        case ActivityPointTypeEnum.DUCKET:
                            _arg_3.color = 11257559;
                            
                        default:
                            _arg_3.color = 9032648;
                    }
                }
            }
            return _arg_3;
        }

        public function _Str_22321(k:String, _arg_2:IWindowContainer, _arg_3:Int, _arg_4:Int, _arg_5:Bool=true, _arg_6:Bool=true)
        {
            var _local_7= Std.downcast(_arg_2.findChildByName(this._Str_11721) , IWindowContainer);
            if (_local_7 == null)
            {
                _local_7 = Std.downcast(this.createWindow("badgeDisplayWidget") , IWindowContainer);
                _local_7.name = this._Str_11721;
            }
            cast(_local_7.findChildByName("asset_image"), IStaticBitmapWrapperWindow).assetUri = "catalogue_badge_background";
            var _local_8= Std.downcast(_local_7.findChildByName("badge_image") , IWidgetWindow);
            var _local_9= Std.downcast(_local_8.widget , IBadgeImageWidget);
            _local_8.visible = true;
            _local_9.badgeId = k;
            _arg_2.addChild(_local_7);
            _local_7.x = (_arg_6 ? _arg_3 : ((_arg_2.width - _local_7.width) - _arg_3));
            _local_7.y = (_arg_5 ? _arg_4 : ((_arg_2.height - _local_7.height) - _arg_4));
        }

        public function _Str_23233(k:IWindowContainer)
        {
            var _local_2= Std.downcast(k.findChildByName(this._Str_11721) , IWindowContainer);
            if (_local_2 != null)
            {
                k.removeChild(_local_2);
            }
        }

        public function _Str_24300(k:String, _arg_2:IWindowContainer, _arg_3:Int, _arg_4:Int, _arg_5:Bool=true, _arg_6:Bool=true)
        {
            var _local_7= Std.downcast(_arg_2.findChildByName(this._Str_11721) , IWindowContainer);
            if (_local_7 == null)
            {
                _local_7 = Std.downcast(this.createWindow("badgeDisplayWidget") , IWindowContainer);
                _local_7.name = this._Str_11721;
            }
            _local_7.findChildByName("badge_image").visible = false;
            cast(_local_7.findChildByName("badge_image"), IStaticBitmapWrapperWindow).assetUri = k;
            _arg_2.addChild(_local_7);
            _local_7.x = (_arg_6 ? _arg_3 : ((_arg_2.width - _local_7.width) - _arg_3));
            _local_7.y = (_arg_5 ? _arg_4 : ((_arg_2.height - _local_7.height) - _arg_4));
        }

        public function _Str_25276(k:IBitmapWrapperWindow, _arg_2:String)
        {
            if (k == null)
            {
                return;
            }
            var _local_3= this._habboCatalog.assets.getAssetByName(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= ASCompat.dynamicAs(_local_3.content , BitmapData);
            if (_local_4 == null)
            {
                return;
            }
            if (k.bitmap != null)
            {
                k.bitmap.dispose();
                k.bitmap = null;
            }
            if (k.bitmap == null)
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0);
            }
            var _local_5= Std.int((k.width - _local_4.width) * 0.5);
            var _local_6= Std.int((k.height - _local_4.height) * 0.5);
            k.bitmap.draw(_local_4, new Matrix(1, 0, 0, 1, _local_5, _local_6));
        }

        public function showVipBenefits()
        {
            if (this._habboCatalog.getBoolean("catalog.vip.benefits.enabled"))
            {
                if (((this._Str_9622 == null) || this._Str_9622.disposed))
                {
                    this._Str_9622 = new ClubBenefitsDialog(this._habboCatalog);
                }
            }
            else
            {
                this.openLink(this._habboCatalog.getProperty("link.format.club"));
            }
        }

        public function openLink(k:String)
        {
            if (k != "")
            {
                this._habboCatalog.windowManager.alert("${catalog.alert.external.link.title}", "${catalog.alert.external.link.desc}", 0, this._Str_22522);
                HabboWebTools.openWebPage(k, "habboMain");
            }
        }

        function _Str_22522(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        public function _Str_4488(k:Bool, _arg_2:Int, _arg_3:Int):Int
        {
            if (((this._habboCatalog.discountEnabled && k) && (!(this._habboCatalog.bundleDiscountRuleset == null))))
            {
                return _arg_2 * (_arg_3 - this._Str_20487(_arg_3));
            }
            return _arg_2 * _arg_3;
        }

        public function _Str_20487(k:Int):Int
        {
            var _local_2= this._Str_23707(k);
            _local_2 = (_local_2 + this._Str_25020(k));
            _local_2 = (_local_2 + this._Str_23776(k));
            return _local_2;
        }

        function _Str_23707(k:Int):Int
        {
            var _local_2= this._habboCatalog.bundleDiscountRuleset;
            var _local_3= Std.int(k / _local_2._Str_9227);
            return _local_3 * _local_2._Str_23802;
        }

        function _Str_25020(k:Int):Int
        {
            var _local_5 = 0;
            var _local_2 = 0;
            var _local_3= this._habboCatalog.bundleDiscountRuleset;
            var _local_4= Std.int(k / _local_3._Str_9227);
            if (_local_4 >= _local_3._Str_21500)
            {
                _local_5 = (k % _local_3._Str_9227);
                if (_local_5 == (_local_3._Str_9227 - 1))
                {
                    _local_2++;
                }
                _local_2 = (_local_2 + (_local_4 - _local_3._Str_21500));
            }
            return _local_2;
        }

        function _Str_23776(k:Int):Int
        {
            var _local_4 = 0;
            var _local_2 = 0;
            var _local_3= this._habboCatalog.bundleDiscountRuleset;
            final _iter_ = _local_3._Str_25155; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toInt(_tmp_);
                if (k >= _local_4)
                {
                    _local_2++;
                }
            }
            return _local_2;
        }

        public var _Str_20096(get,never):Array<ASAny>;
public function  get__Str_20096():Array<ASAny>
        {
            return this._Str_13008;
        }

        public var _Str_23617(get,never):Int;
public function  get__Str_23617():Int
        {
            return this._Str_16414;
        }

        public function _Str_24024()
        {
            var _local_2 = 0;
            var _local_3 = 0;
            this._Str_13008 = new Array<ASAny>();
            this._Str_16414 = 0;
            var k = 0;
            while (k < 99)
            {
                _local_2 = this._Str_4488(true, 1, k);
                _local_3 = this._Str_4488(true, 1, (k + 1));
                if (_local_2 == _local_3)
                {
                    this._Str_13008.push(k);
                    this._Str_16414 = k;
                }
                k++;
            }
        }

        public function _Str_25512()
        {
            if (!this._Str_21405)
            {
                HabboTracking.getInstance().trackEventLog("Catalog", "spinnerValueChanged", "client.bundle.discounts");
                this._Str_21405 = true;
            }
        }

        public function _Str_22409()
        {
            if (!this._Str_19703)
            {
                HabboTracking.getInstance().trackEventLog("Catalog", "bundlesInfoOpened", "client.bundle.discounts");
                this._Str_19703 = true;
            }
        }

        public function _Str_25517()
        {
            if (!this._Str_22047)
            {
                HabboTracking.getInstance().trackEventLog("Catalog", "discountItemShown", "client.bundle.discounts");
                this._Str_22047 = true;
            }
        }

        public function displayProductIcon(k:String, _arg_2:Int, _arg_3:IBitmapWrapperWindow)
        {
            var _local_4:ImageResult = null;
            var _local_5:Vector<IBitmapWrapperWindow> = null;
            if (this._habboCatalog == null)
            {
                return;
            }
            switch (k)
            {
                case ProductTypeEnum.FLOOR:
                    _local_4 = this._habboCatalog.roomEngine.getFurnitureIcon(_arg_2, this);
                    
                case ProductTypeEnum.WALL:
                    _local_4 = this._habboCatalog.roomEngine.getWallItemIcon(_arg_2, this);
                    
                case ProductTypeEnum.EFFECT:
                    _arg_3.bitmap = this._habboCatalog.getPixelEffectIcon(_arg_2);
                    
                case ProductTypeEnum.HABBO_CLUB:
                    _arg_3.bitmap = this._habboCatalog.getSubscriptionProductIcon(_arg_2);
                    
            }
            if (_local_4 != null)
            {
                _arg_3.bitmap = _local_4.data;
                if (_local_4.id != 0)
                {
                    _local_5 = this._Str_9144[_local_4.id];
                    if (_local_5 == null)
                    {
                        _local_5 = new Vector<IBitmapWrapperWindow>(0);
                        this._Str_9144[_local_4.id] = _local_5;
                    }
                    _local_5.push(_arg_3);
                }
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_4:IBitmapWrapperWindow = null;
            var _local_3:Vector<IBitmapWrapperWindow> = this._Str_9144[k];
            if (_local_3 == null)
            {
                return;
            }
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                _local_4.bitmap = _arg_2;
            }
            this._Str_9144.remove(k);
        }

        public function imageFailed(k:Int)
        {
        }
    }

