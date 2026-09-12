package com.sulake.habbo.catalog.club
;
    import com.sulake.habbo.catalog.viewer.widgets.ClubGiftWidget;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetClubGiftInfo;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.SelectClubGiftComposer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.catalog.purse.IPurse;

     class ClubGiftController 
    {
        var _widget:ClubGiftWidget;
        var _daysUntilNextGift:Int = 0;
        var _giftsAvailable:Int = 0;
        var _offers:Array<ASAny>;
        var _giftData:Map;
        var _catalog:HabboCatalog;
        var _confirmationDialog:ClubGiftConfirmationDialog;

        public function new(k:HabboCatalog)
        {
            this._catalog = k;
        }

        public function dispose()
        {
            this._catalog = null;
            if (this._confirmationDialog != null)
            {
                this._confirmationDialog.dispose();
                this._confirmationDialog = null;
            }
        }

        public var widget(never,set):ClubGiftWidget;
public function  set_widget(k:ClubGiftWidget):ClubGiftWidget        {
            this._widget = k;
            this._catalog.connection.send(new GetClubGiftInfo());
return k;
        }

        public var _Str_12860(get,never):Int;
public function  get__Str_12860():Int
        {
            return this._daysUntilNextGift;
        }

        public var _Str_7574(get,never):Int;
public function  get__Str_7574():Int
        {
            return this._giftsAvailable;
        }

        public function _Str_24745(k:Int, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Map)
        {
            this._daysUntilNextGift = k;
            this._giftsAvailable = _arg_2;
            this._offers = _arg_3;
            this._giftData = _arg_4;
            if (this._widget != null)
            {
                this._widget.update();
            }
        }

        public function _Str_24080(k:IPurchasableOffer)
        {
            this._Str_4504();
            this._confirmationDialog = new ClubGiftConfirmationDialog(this, k);
        }

        public function _Str_11237(k:String)
        {
            if ((((!ASCompat.stringAsBool(k)) || (!(this._catalog != null))) || (!(this._catalog.connection != null))))
            {
                return;
            }
            this._catalog.connection.send(new SelectClubGiftComposer(k));
            this._giftsAvailable--;
            this._widget.update();
            this._Str_4504();
        }

        public function _Str_4504()
        {
            if (this._confirmationDialog != null)
            {
                this._confirmationDialog.dispose();
                this._confirmationDialog = null;
            }
        }

        public function _Str_16489():Array<ASAny>
        {
            return this._offers;
        }

        public function _Str_23509():Map
        {
            return this._giftData;
        }

        public var _Str_6454(get,never):Bool;
public function  get__Str_6454():Bool
        {
            if (((!(this._catalog != null)) || (!(this._catalog.getPurse() != null))))
            {
                return false;
            }
            return this._catalog.getPurse().clubDays > 0;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            if (this._catalog == null)
            {
                return null;
            }
            return this._catalog.windowManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            if (this._catalog == null)
            {
                return null;
            }
            return this._catalog.localization;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            if (this._catalog == null)
            {
                return null;
            }
            return this._catalog.assets;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            if (this._catalog == null)
            {
                return null;
            }
            return this._catalog.roomEngine;
        }

        public function getProductData(k:String):IProductData
        {
            if (this._catalog == null)
            {
                return null;
            }
            return this._catalog.getProductData(k);
        }

        public var purse(get,never):IPurse;
public function  get_purse():IPurse
        {
            if (this._catalog == null)
            {
                return null;
            }
            return this._catalog.getPurse();
        }

        public var catalog(get,never):HabboCatalog;
public function  get_catalog():HabboCatalog
        {
            return this._catalog;
        }
    }

