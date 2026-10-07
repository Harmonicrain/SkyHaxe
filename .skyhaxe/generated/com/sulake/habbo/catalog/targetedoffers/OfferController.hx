package com.sulake.habbo.catalog.targetedoffers
;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog.targetedoffers.util.MallOfferExternalInterfaceHelper;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.communication.messages.incoming.catalog.TargetedOfferEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.TargetedOfferNotFoundEvent;
    import com.sulake.habbo.catalog.purse.PurseUpdateEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetNextTargetedOfferComposer;
    import com.sulake.habbo.catalog.targetedoffers.data.TargetedOffer;
    import com.sulake.habbo.communication._enum.TargetedOfferTrackingStateEnum;
    import com.sulake.habbo.catalog.targetedoffers.data.HabboMallOffer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.ShopTargetedOfferViewedComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.SetTargetedOfferStateComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.PurchaseTargetedOfferComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.catalog.targetedoffers.util.EventLogActions;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.core.window.IWindow;

     class OfferController implements IProductDataListener 
    {
        var _offerDialog:TargetedOfferDialogView;
        var _mallOfferDialog:MallOfferDialogView;
        var _extension:IDisposable;
        var _confirmation:TargetedOfferPurchaseConfirmationView;
        var _externalInterfaceHelper:MallOfferExternalInterfaceHelper;
        var _catalog:HabboCatalog;
        var _disposed:Bool = false;

        public function new(k:HabboCatalog)
        {
            this._catalog = k;
            this._catalog.connection.addMessageEvent(new TargetedOfferEvent(this._Str_25111));
            this._catalog.connection.addMessageEvent(new TargetedOfferNotFoundEvent(this.onTargetedOfferNotFound));
            this._catalog.events.addEventListener(PurseUpdateEvent.CATALOG_PURSE_UPDATE, this.onPurseUpdate);
            this._catalog.sessionDataManager.addProductsReadyEventListener(this);
        }

        public var catalog(get,never):HabboCatalog;
public function  get_catalog():HabboCatalog
        {
            return this._catalog;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this._Str_6602();
            if (this._externalInterfaceHelper != null)
            {
                this._externalInterfaceHelper.dispose();
                this._externalInterfaceHelper = null;
            }
        }

        public function productDataReady()
        {
            this._catalog.connection.send(new GetNextTargetedOfferComposer());
        }

        function _Str_25111(k:TargetedOfferEvent)
        {
            var _local_2= k.getParser();
            var _local_3= new TargetedOffer(_local_2.data);
            if (_local_3._Str_11180 == TargetedOfferTrackingStateEnum.MINIMIZED)
            {
                this.minimizeOffer(_local_3);
            }
            else
            {
                this.maximizeOffer(_local_3);
            }
        }

        function onTargetedOfferNotFound(k:TargetedOfferNotFoundEvent)
        {
            this._externalInterfaceHelper = new MallOfferExternalInterfaceHelper(this);
        }

        public function _Str_22982(k:HabboMallOffer)
        {
            if (k._Str_11180 == TargetedOfferTrackingStateEnum.REJECTED)
            {
                return;
            }
            switch (k._Str_11180)
            {
                case 0
                   | TargetedOfferTrackingStateEnum.PREVIEWED
                   | TargetedOfferTrackingStateEnum.SELECTED:
                    this.maximizeMallOffer(k);
                    return;
                case TargetedOfferTrackingStateEnum.REJECTED:
                    return;
                default:
                    this.minimizeMallOffer(k);
            }
        }

        public function maximizeMallOffer(k:HabboMallOffer)
        {
            if (this._mallOfferDialog != null)
            {
                return;
            }
            this._Str_6602();
            this._mallOfferDialog = new MallOfferDialogView(this, k);
            this._catalog.connection.send(new ShopTargetedOfferViewedComposer(k.targetedOfferId, TargetedOfferTrackingStateEnum.PREVIEWED));
        }

        public function minimizeMallOffer(k:HabboMallOffer, _arg_2:Bool=false)
        {
            this._Str_6602();
            this._extension = new MallOfferMinimizedView(this, k);
        }

        public function onHabboMallOfferOpened(k:HabboMallOffer)
        {
            this._catalog.connection.send(new ShopTargetedOfferViewedComposer(k.targetedOfferId, TargetedOfferTrackingStateEnum.OFFERED));
            this._catalog.openCreditsHabblet();
            this.minimizeMallOffer(k);
        }

        public function onHabboMallOfferClosed(k:HabboMallOffer)
        {
            this._catalog.connection.send(new ShopTargetedOfferViewedComposer(k.targetedOfferId, TargetedOfferTrackingStateEnum.MINIMIZED));
            this.minimizeMallOffer(k);
        }

        public function minimizeOffer(k:TargetedOffer)
        {
            this._Str_6602();
            this._extension = new TargetedOfferMinimizedView(this, k);
            this._catalog.connection.send(new SetTargetedOfferStateComposer(k.id, TargetedOfferTrackingStateEnum.MINIMIZED));
        }

        public function maximizeOffer(k:TargetedOffer)
        {
            var _local_2:String = null;
            if (this._offerDialog != null)
            {
                return;
            }
            this._Str_6602();
            if (!k.isExpired())
            {
                _local_2 = this._Str_24354(k);
                this._offerDialog = new TargetedOfferDialogView(this, k);
                if ((((!(_local_2 == null)) && (_local_2.length > 0)) && this._catalog.assets.hasAsset(_local_2)))
                {
                    this._offerDialog._Str_6297(_local_2);
                }
                else
                {
                    this._offerDialog._Str_6297("targeted_offer_dialog_xml");
                }
                this._catalog.connection.send(new SetTargetedOfferStateComposer(k.id, TargetedOfferTrackingStateEnum.OFFERED));
            }
        }

        public function purchaseTargetedOffer(k:TargetedOffer, _arg_2:Int)
        {
            this._catalog.connection.send(new PurchaseTargetedOfferComposer(k.id, _arg_2));
            k._Str_24338(_arg_2);
            if (k.purchaseLimit > 0)
            {
                this.minimizeOffer(k);
            }
            else
            {
                this._Str_6602();
            }
        }

        public function sendLogEvent(k:String, _arg_2:String="")
        {
            if (((!(this._catalog != null)) || (!(this._catalog.connection != null))))
            {
                return;
            }
            this._catalog.connection.send(new EventLogMessageComposer("TargetedOffers", "FLASH.UNKNOWN", k, _arg_2));
        }

        public function purchaseCredits(k:TargetedOffer)
        {
            this.sendLogEvent(EventLogActions.TARGETED_OFFER_OPEN_CREDITS_PAGE_CLICKED, k.identifier);
            this._catalog.openCreditsHabblet();
        }

        public function attachExtension(k:IWindow)
        {
            this._catalog.toolbar.extensionView.attachExtension(ToolbarDisplayExtensionIds.TARGETED_OFFER, k, ExtensionFixedSlotsEnum._Str_16348);
        }

        public function showConfirmation(k:TargetedOffer, _arg_2:Int)
        {
            if (this._confirmation != null)
            {
                return;
            }
            this._Str_6602();
            this._confirmation = new TargetedOfferPurchaseConfirmationView(this, k, _arg_2);
        }

        function onPurseUpdate(k:PurseUpdateEvent)
        {
            if (this._offerDialog != null)
            {
                this._offerDialog._Str_18148();
            }
        }

        public function _Str_6602()
        {
            if (this._offerDialog != null)
            {
                this._offerDialog.dispose();
                this._offerDialog = null;
            }
            if (this._mallOfferDialog != null)
            {
                this._mallOfferDialog.dispose();
                this._mallOfferDialog = null;
            }
            if (this._extension != null)
            {
                this._catalog.toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.TARGETED_OFFER);
                this._extension.dispose();
                this._extension = null;
            }
            if (this._confirmation != null)
            {
                this._confirmation.dispose();
                this._confirmation = null;
            }
        }

        function _Str_24354(k:TargetedOffer):String
        {
            return this._catalog.getProperty(("targeted.offer.override.layout." + Std.string(k.id)));
        }
    }

