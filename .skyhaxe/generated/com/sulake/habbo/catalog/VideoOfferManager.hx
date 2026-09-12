package com.sulake.habbo.catalog
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.catalog._enum.VideoOfferTypeEnum;

     class VideoOfferManager implements IVideoOfferManager implements  IDisposable 
    {
        static inline final CAMPAIGNS_READY= "supersaverAdsOnCampaignsReady";
        static inline final CAMPAIGN_COMPLETED= "supersaverAdsOnCampaignCompleted";
        static inline final CAMPAIGN_OPEN= "supersaverAdsOnCampaignOpen";
        static inline final CAMPAIGN_CLOSE= "supersaverAdsOnCampaignClose";
        static inline final LOAD_CAMPAIGNS= "supersaverAdsLoadCampaigns";
        static inline final CAMPAIGN_ENGAGE= "supersaverAdsCamapaignEngage";

        var _disposed:Bool = false;
        var _catalog:HabboCatalog;
        var _enabled:Bool = false;
        var _offersAvailable:Int = 0;
        var _offersViewed:Int = 0;
        var _offersRequested:Bool = false;
        var _offersReceived:Bool = false;
        var _launchers:Vector<IVideoOfferLauncher>;
        var _callbacksAdded:Bool = false;

        public function new(k:HabboCatalog)
        {
            this._catalog = k;
            this._launchers = new Vector<IVideoOfferLauncher>();
            this._enabled = false;
            this._catalog.connection.addMessageEvent(new UserRightsMessageEvent(this.onUserRights));
            this._Str_21648();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._enabled;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._catalog = null;
            this._launchers = null;
            this._enabled = false;
            if ((this._callbacksAdded && ExternalInterface.available))
            {
                ExternalInterface.addCallback(CAMPAIGNS_READY, null);
                ExternalInterface.addCallback(CAMPAIGN_COMPLETED, null);
                ExternalInterface.addCallback(CAMPAIGN_OPEN, null);
                ExternalInterface.addCallback(CAMPAIGN_CLOSE, null);
                this._callbacksAdded = false;
            }
            this._disposed = true;
        }

        function _Str_21648()
        {
            if (((this._enabled && (!this._callbacksAdded)) && ExternalInterface.available))
            {
                ExternalInterface.addCallback(CAMPAIGNS_READY, this._Str_18543);
                ExternalInterface.addCallback(CAMPAIGN_COMPLETED, this._Str_22666);
                ExternalInterface.addCallback(CAMPAIGN_OPEN, this._Str_18305);
                ExternalInterface.addCallback(CAMPAIGN_CLOSE, this._Str_18245);
                this._callbacksAdded = true;
            }
        }

        function onUserRights(k:UserRightsMessageEvent)
        {
            if (k.securityLevel >= SecurityLevelEnum.CELEBRITY)
            {
                this._enabled = false;
                this._Str_21648();
            }
        }

        public function load(k:IVideoOfferLauncher)
        {
            if (!this._enabled)
            {
                return;
            }
            if ((this._offersRequested && this._offersReceived))
            {
                k.offersAvailable(this._offersAvailable);
            }
            else
            {
                if (((!this._offersRequested) && ExternalInterface.available))
                {
                    ExternalInterface.call(LOAD_CAMPAIGNS);
                    this._offersRequested = true;
                }
                this._launchers.push(k);
            }
        }

        public function launch(k:VideoOfferTypeEnum):Bool
        {
            if (((!this._enabled) || (this._offersAvailable < 1)))
            {
                return false;
            }
            if (ExternalInterface.available)
            {
                this._offersViewed = (this._offersViewed + 1);
                ExternalInterface.call(CAMPAIGN_ENGAGE);
                this._Str_24888();
                if (this._catalog.connection != null)
                {
                    this._catalog.connection.send(new EventLogMessageComposer("SuperSaverAds", "client_action", "supersaverads.video.promo.launched"));
                }
                return this._offersAvailable > this._offersViewed;
            }
            return false;
        }

        function _Str_18543(k:String)
        {
            this._offersReceived = true;
            this._offersAvailable = ASCompat.parseInt(k);
            if (Math.isNaN(this._offersAvailable))
            {
                this._offersAvailable = 0;
            }
            while (this._launchers.length > 0)
            {
                this._launchers.pop().offersAvailable(this._offersAvailable);
            }
        }

        function _Str_18305()
        {
        }

        function _Str_18245()
        {
            this._Str_19586();
            if (this._catalog.connection != null)
            {
                this._catalog.connection.send(new EventLogMessageComposer("SuperSaverAds", "client_action", "supersaverads.video.promo.close"));
            }
        }

        function _Str_22666()
        {
            this._Str_19586();
            if (this._catalog.connection != null)
            {
                this._catalog.connection.send(new EventLogMessageComposer("SuperSaverAds", "client_action", "supersaverads.video.promo.complete"));
            }
        }

        function _Str_24888()
        {
            if (this._catalog.soundManager != null)
            {
                this._catalog.soundManager.mute(true);
            }
        }

        function _Str_19586()
        {
            if (this._catalog.soundManager != null)
            {
                this._catalog.soundManager.mute(false);
            }
        }
    }

