package com.sulake.habbo.catalog.club
;
    import com.sulake.habbo.catalog.viewer.widgets.IVipBuyCatalogWidget;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubOfferData;
    import com.sulake.habbo.communication.messages.parser.catalog.HabboClubOffersMessageParser;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.catalog.purse.IPurse;

     class ClubOfferHandler 
    {
        var _visualization:IVipBuyCatalogWidget;
        var _habboCatalog:HabboCatalog;
        var _Str_2397:Array<ASAny>;
        var _Str_2635:ClubBuyConfirmationDialog;
        var _connection:IConnection;
        var _disposed:Bool = false;

        public function new(k:HabboCatalog, _arg_2:IConnection)
        {
            this._habboCatalog = k;
            this._connection = _arg_2;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._visualization != null)
            {
                this._visualization.dispose();
                this._visualization = null;
            }
            this.reset();
            this._Str_4504();
            this._habboCatalog = null;
            this._disposed = true;
        }

        public var catalog(get,never):HabboCatalog;
public function  get_catalog():HabboCatalog
        {
            return this._habboCatalog;
        }

        public function reset()
        {
            var k:ClubBuyOfferData = null;
            final _iter_ = this._Str_2397; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._Str_2397 = [];
        }

        public function onOffers(k:HabboClubOffersMessageParser)
        {
            var _local_3:ClubBuyOfferData = null;
            var _local_4:ClubOfferData = null;
            var _local_5:ClubBuyOfferData = null;
            var _local_6 = false;
            var _local_7:Array<ASAny> = null;
            var _local_8:ClubBuyOfferData = null;
            var _local_9 = 0;
            if (this._disposed)
            {
                return;
            }
            this.reset();
            var _local_2 = 0;
            final _iter_ = k.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_5 = new ClubBuyOfferData(_local_4.offerId, _local_4.productCode, _local_4.priceCredits, _local_4.priceActivityPoints, _local_4._Str_23501, _local_4.vip, _local_4.months, _local_4._Str_15178, _local_4._Str_11224, _local_4.year, _local_4.month, _local_4.day, _local_4._Str_18028);
                this._Str_2397.push(_local_5);
                if (_local_4.vip)
                {
                    _local_2++;
                    _local_3 = _local_5;
                }
            }
            if (_local_2 == 1)
            {
                _local_3._Str_10047 = true;
            }
            ASCompat.ASArray.sort(this._Str_2397, this.orderByPrecedence);
            if (this._visualization != null)
            {
                this._visualization.reset();
                this._visualization._Str_15013(this._Str_25808());
                _local_6 = this._visualization.isGift;
                _local_7 = this._Str_23878(_local_6);
                final _iter_ = this._Str_2397; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_8  = _tmp_;
                    if (_local_8.months > 0)
                    {
                        if (_local_7.length > 0)
                        {
                            _local_9 = _local_8.months;
                            if (_local_7.indexOf(_local_9) == -1)
                            {
                                continue;
                            }
                        }
                        this._visualization._Str_6059(_local_8);
                    }
                }
            }
        }

        function _Str_23878(k:Bool):Array<ASAny>
        {
            var _local_4:String = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            var _local_7 = Math.NaN;
            var _local_2= new Array<ASAny>();
            var _local_3= (k ? "catalog.vip.gift.promo" : "catalog.vip.buy.promo");
            if (this._habboCatalog.propertyExists(_local_3))
            {
                _local_4 = this._habboCatalog.getProperty(_local_3, null);
                if (((!(_local_4 == null)) && (_local_4.length > 0)))
                {
                    _local_5 = (cast _local_4.split(","));
                    if (_local_5.length > 0)
                    {
                        if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                        {
_local_6  = _tmp_;
                            _local_7 = ASCompat.parseInt(_local_6);
                            if (((!Math.isNaN(_local_7)) && (_local_7 > 0)))
                            {
                                _local_2.push(_local_7);
                            }
                        }
                    }
                }
            }
            return _local_2;
        }

        public function _Str_18073(k:IVipBuyCatalogWidget)
        {
            if (this._visualization == k)
            {
                this._visualization = null;
            }
        }

        public function registerVisualization(k:IVipBuyCatalogWidget)
        {
            this._visualization = k;
        }

        public function requestOffers(k:Int)
        {
            this._habboCatalog.getHabboClubOffers(k);
        }

        public function showConfirmation(k:ClubBuyOfferData, _arg_2:Int)
        {
            this._Str_4504();
            this._Str_2635 = new ClubBuyConfirmationDialog(this, k, _arg_2);
        }

        public function _Str_11237(k:ClubBuyOfferData, _arg_2:Int)
        {
            if (((!(this._habboCatalog != null)) || (!(this._habboCatalog.connection != null))))
            {
                return;
            }
            this._habboCatalog.purchaseProduct(_arg_2, k.offerId);
            this._Str_4504();
        }

        public function _Str_4504()
        {
            if (this._Str_2635 != null)
            {
                this._Str_2635.dispose();
                this._Str_2635 = null;
            }
        }

        public function _Str_25808():Int
        {
            var k= HabboClubLevelEnum.NO_CLUB;
            if (this._habboCatalog.getPurse().hasClubLeft)
            {
                k = (this._habboCatalog.getPurse().isVIP ? HabboClubLevelEnum.VIP : HabboClubLevelEnum.CLUB);
            }
            return k;
        }

        public var _Str_6454(get,never):Bool;
public function  get__Str_6454():Bool
        {
            if (((!(this._habboCatalog != null)) || (!(this._habboCatalog.getPurse() != null))))
            {
                return false;
            }
            return this._habboCatalog.getPurse().clubDays > 0;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            if (this._habboCatalog == null)
            {
                return null;
            }
            return this._habboCatalog.windowManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            if (this._habboCatalog == null)
            {
                return null;
            }
            return this._habboCatalog.localization;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            if (this._habboCatalog == null)
            {
                return null;
            }
            return this._habboCatalog.assets;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            if (this._habboCatalog == null)
            {
                return null;
            }
            return this._habboCatalog.roomEngine;
        }

        public function getProductData(k:String):IProductData
        {
            if (this._habboCatalog == null)
            {
                return null;
            }
            return this._habboCatalog.getProductData(k);
        }

        public function getPurse():IPurse
        {
            if (this._habboCatalog == null)
            {
                return null;
            }
            return this._habboCatalog.getPurse();
        }

        function orderByPrecedence(k:ClubBuyOfferData, _arg_2:ClubBuyOfferData):Float
        {
            var _local_3:Float = k.months;
            var _local_4:Float = _arg_2.months;
            if (_local_3 < _local_4)
            {
                return -1;
            }
            if (_local_3 > _local_4)
            {
                return 1;
            }
            return 0;
        }
    }

