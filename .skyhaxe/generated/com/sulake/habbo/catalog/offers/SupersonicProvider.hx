package com.sulake.habbo.catalog.offers
;
    import flash.external.ExternalInterface;

     class SupersonicProvider implements IOfferProvider 
    {
        static inline final SUPERSONICADSONCAMPAIGNSREADY= "supersonicAdsOnCampaignsReady";
        static inline final SUPERSONICADSONCAMPAIGNCOMPLETED= "supersonicAdsOnCampaignCompleted";
        static inline final SUPERSONICADSONCAMPAIGNOPEN= "supersonicAdsOnCampaignOpen";
        static inline final SUPERSONICADSONCAMPAIGNCLOSE= "supersonicAdsOnCampaignClose";
        static inline final SUPERSONICADSLOADCAMPAIGNS= "supersonicAdsLoadCampaigns";
        static inline final SUPERSONICADSCAMAPAIGNENGAGE= "supersonicAdsCamapaignEngage";

        var _disposed:Bool = false;
        var _offerCenter:OfferCenter;
        var _offerCount:Int = 0;
        var _showingPopup:Bool = false;
        var _loaded:Bool = false;

        public function new(k:OfferCenter)
        {
            this._offerCenter = k;
            if (this.enabled)
            {
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNSREADY, this._Str_18543);
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNCOMPLETED, this._Str_24285);
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNOPEN, this._Str_18305);
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNCLOSE, this._Str_18245);
            }
        }

        function _Str_18543(k:String)
        {
            this._offerCount = ASCompat.toInt(k);
            this._Str_4988();
        }

        function _Str_18305()
        {
            this._showingPopup = true;
            this._Str_4988();
        }

        function _Str_18245()
        {
            this._showingPopup = false;
            this._Str_4988();
        }

        function _Str_24285()
        {
        }

        public function load()
        {
            if ((this.enabled && (!this._loaded)))
            {
                try
                {
                    ExternalInterface.call(SUPERSONICADSLOADCAMPAIGNS);
                    this._loaded = true;
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([((("External interface not working. Could not call " + SUPERSONICADSLOADCAMPAIGNS) + ": ") + e)]);
                }
 }            }
        }

        public function showVideo()
        {
            if ((this.enabled && (this._offerCount > 0)))
            {
                try
                {
                    ExternalInterface.call(SUPERSONICADSCAMAPAIGNENGAGE);
                    this._offerCount--;
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([((("External interface not working. Could not call " + SUPERSONICADSCAMAPAIGNENGAGE) + ": ") + e)]);
                }
 }            }
        }

        public var _Str_15510(get,never):Bool;
public function  get__Str_15510():Bool
        {
            return this._offerCount > 0;
        }

        public var _Str_16897(get,never):Bool;
public function  get__Str_16897():Bool
        {
            return this._showingPopup;
        }

        function _Str_4988()
        {
            if (this._offerCenter != null)
            {
                this._offerCenter._Str_4988();
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNSREADY, null);
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNCOMPLETED, null);
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNOPEN, null);
                ExternalInterface.addCallback(SUPERSONICADSONCAMPAIGNCLOSE, null);
            }
            this._offerCenter = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._offerCenter.configuration.getBoolean("offers.supersonic.enabled") && ExternalInterface.available;
        }
    }

