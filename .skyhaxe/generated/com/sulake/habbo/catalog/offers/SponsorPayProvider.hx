package com.sulake.habbo.catalog.offers
;
    import flash.utils.Timer;
    import flash.external.ExternalInterface;
    import flash.events.TimerEvent;

     class SponsorPayProvider implements IOfferProvider 
    {
        static inline final SPONSORPAYLOADED= "sponsorPayLoaded";
        static inline final SPONSORPAYONSTART= "sponsorPayOnStart";
        static inline final SPONSORPAYNOOFFERS= "sponsorPayNoOffers";
        static inline final SPONSORPAYONCLOSE= "sponsorPayOnClose";
        static inline final SPONSORPAYONCONVERSION= "sponsorPayOnConversion";
        static inline final SPONSORPAY_LOADINTEGRATION= "SponsorPay.loadIntegration";
        static inline final SPONSORPAY_SHOWVIDEO= "SponsorPay.showVideo";
        static inline final SPONSORPAY_BACKGROUNDLOAD= "SponsorPay.backgroundLoad";
        static inline final _Str_17517= 150000;

        var _disposed:Bool = false;
        var _offerCenter:OfferCenter;
        var _loaded:Bool = false;
        var _available:Bool = false;
        var _showingPopup:Bool = false;
        var _resetTimer:Timer;

        public function new(k:OfferCenter)        {
            this._offerCenter = k;
            if (!this.enabled)
            {
                return;
            }
            ExternalInterface.addCallback(SPONSORPAYLOADED, this.sponsorPayLoaded);
            ExternalInterface.addCallback(SPONSORPAYONSTART, this.sponsorPayOnStart);
            ExternalInterface.addCallback(SPONSORPAYNOOFFERS, this.sponsorPayNoOffers);
            ExternalInterface.addCallback(SPONSORPAYONCLOSE, this.sponsorPayOnClose);
            ExternalInterface.addCallback(SPONSORPAYONCONVERSION, this.sponsorPayOnConversion);
            this._resetTimer = new Timer(_Str_17517, 1);
            this._resetTimer.addEventListener(TimerEvent.TIMER, (this._Str_22037 : ASAny));
        }

        function _Str_22037(k:TimerEvent)
        {
            this.sponsorPayOnClose();
        }

        public function load()
        {
            if (this._loaded)
            {
                this.sponsorPayLoaded();
                return;
            }
            if (this.enabled)
            {
                try
                {
                    ExternalInterface.call(SPONSORPAY_LOADINTEGRATION, [this._Str_19717]);
                    this._loaded = true;
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([((("External interface not working. Could not call " + SPONSORPAY_LOADINTEGRATION) + ": ") + e)]);
                }
 }            }
        }

        var _Str_19717(get,never):String;
function  get__Str_19717():String
        {
            return this._offerCenter.configuration.getProperty("offers.sponsorpay.appid");
        }

        public function showVideo()
        {
            if ((this._loaded && this.enabled))
            {
                try
                {
                    ExternalInterface.call(SPONSORPAY_SHOWVIDEO);
                    this._showingPopup = true;
                    this._resetTimer.reset();
                    this._resetTimer.start();
                    this._Str_4988();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([((("External interface not working. Could not call " + SPONSORPAY_SHOWVIDEO) + ": ") + e)]);
                }
 }            }
        }

        function sponsorPayLoaded()
        {
            if (this._showingPopup)
            {
                return;
            }
            this._available = false;
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call(SPONSORPAY_BACKGROUNDLOAD);
                }
                else
                {
                    Logger.log([(("External interface not available. Could not call " + SPONSORPAY_BACKGROUNDLOAD) + ".")]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([((("External interface not working. Could not call " + SPONSORPAY_BACKGROUNDLOAD) + ": ") + e)]);
            }
 }        }

        function sponsorPayOnStart(k:String)
        {
            this._available = true;
            this._Str_4988();
        }

        function sponsorPayNoOffers()
        {
            this._available = false;
            this._Str_4988();
        }

        function sponsorPayOnClose()
        {
            this._showingPopup = false;
            if (this._resetTimer != null)
            {
                this._resetTimer.stop();
            }
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call(SPONSORPAY_BACKGROUNDLOAD);
                }
                else
                {
                    Logger.log([(("External interface not available. Could not call " + SPONSORPAY_BACKGROUNDLOAD) + ".")]);
                }
            }
            catch(e:ASError)
            {
                Logger.log([((("External interface not working. Could not call " + SPONSORPAY_BACKGROUNDLOAD) + ": ") + e)]);
            }
            catch (_m2_finally_error:ASAny)
            {
                this._Str_4988();

                throw _m2_finally_error;
            }
                this._Str_4988();

        }

        function sponsorPayOnConversion()
        {
            if (this._offerCenter != null)
            {
                this._offerCenter._Str_24469();
            }
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
                ExternalInterface.addCallback(SPONSORPAYLOADED, null);
                ExternalInterface.addCallback(SPONSORPAYONSTART, null);
                ExternalInterface.addCallback(SPONSORPAYNOOFFERS, null);
                ExternalInterface.addCallback(SPONSORPAYONCLOSE, null);
                ExternalInterface.addCallback(SPONSORPAYONCONVERSION, null);
            }
            if (this._resetTimer != null)
            {
                this._resetTimer.removeEventListener(TimerEvent.TIMER, (this._Str_22037 : ASAny));
                this._resetTimer.stop();
                this._resetTimer = null;
            }
            this._offerCenter = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_15510(get,never):Bool;
public function  get__Str_15510():Bool
        {
            return this._available;
        }

        public var _Str_16897(get,never):Bool;
public function  get__Str_16897():Bool
        {
            return this._showingPopup;
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return (!(this._Str_19717 == "")) && ExternalInterface.available;
        }
    }

