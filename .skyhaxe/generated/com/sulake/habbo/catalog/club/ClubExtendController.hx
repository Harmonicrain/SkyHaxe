package com.sulake.habbo.catalog.club
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubOfferExtendData;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.catalog.HabboClubExtendOfferMessageEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.IHabboConfigurationManager;

     class ClubExtendController 
    {
        var _catalog:HabboCatalog;
        var _confirmationDialog:ClubExtendConfirmationDialog;
        var _offer:ClubOfferExtendData;
        var _disposed:Bool = false;

        public function new(k:HabboCatalog)
        {
            this._catalog = k;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._Str_4504();
            this._offer = null;
            this._catalog = null;
            this._disposed = true;
        }

        public function _Str_24854(k:HabboClubExtendOfferMessageEvent)
        {
            if (this._disposed)
            {
                return;
            }
            var _local_2= k.getParser();
            this._offer = _local_2.offer();
            this.showConfirmation();
            if (this._catalog.connection != null)
            {
                if (this._offer.vip)
                {
                    this._catalog.connection.send(new EventLogMessageComposer("Catalog", "dialog_show", "vip.membership.extension.purchase"));
                }
                else
                {
                    this._catalog.connection.send(new EventLogMessageComposer("Catalog", "dialog_show", "basic.membership.extension.purchase"));
                }
            }
        }

        public function _Str_4504()
        {
            if (this._confirmationDialog != null)
            {
                this._confirmationDialog.dispose();
                this._confirmationDialog = null;
            }
        }

        public function showConfirmation()
        {
            this._Str_4504();
            this._confirmationDialog = new ClubExtendConfirmationDialog(this, this._offer);
            this._confirmationDialog.showConfirmation();
        }

        public function _Str_11237()
        {
            if ((((!(this._catalog != null)) || (!(this._catalog.connection != null))) || (!(this._offer != null))))
            {
                return;
            }
            if (this._catalog.getPurse().credits < this._offer.priceCredits)
            {
                this._catalog.showNotEnoughCreditsAlert();
                return;
            }
            if (this._offer.vip)
            {
                this._catalog.purchaseVipMembershipExtension(this._offer.offerId);
            }
            else
            {
                this._catalog.purchaseBasicMembershipExtension(this._offer.offerId);
            }
            this._Str_4504();
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

        public var config(get,never):IHabboConfigurationManager;
public function  get_config():IHabboConfigurationManager
        {
            return this._catalog;
        }
    }

