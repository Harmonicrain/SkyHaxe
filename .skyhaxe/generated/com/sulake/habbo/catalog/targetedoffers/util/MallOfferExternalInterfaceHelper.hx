package com.sulake.habbo.catalog.targetedoffers.util
;
    import com.sulake.habbo.catalog.targetedoffers.OfferController;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.catalog.targetedoffers.data.HabboMallOffer;

     class MallOfferExternalInterfaceHelper 
    {
        static inline final TARGETEDWEBOFFER_CHECKOFFER= "TargetedWebOffer.checkOffer";
        static inline final TARGETEDWEBOFFERCHECKFAILED= "targetedWebOfferCheckFailed";
        static inline final TARGETEDWEBOFFERCHECKRESPONSE= "targetedWebOfferCheckResponse";

        var _controller:OfferController;

        public function new(k:OfferController)
        {
            this._controller = k;
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(TARGETEDWEBOFFERCHECKRESPONSE, this._Str_23541);
                ExternalInterface.addCallback(TARGETEDWEBOFFERCHECKFAILED, this._Str_23241);
                ExternalInterface.call(TARGETEDWEBOFFER_CHECKOFFER);
            }
            else
            {
                return;
            }
        }

        public function dispose()
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(TARGETEDWEBOFFERCHECKRESPONSE, null);
                ExternalInterface.addCallback(TARGETEDWEBOFFERCHECKFAILED, null);
            }
            this._controller = null;
        }

        public function _Str_23541(k:ASObject)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= new HabboMallOffer(k);
            if (_local_2 == null)
            {
                return;
            }
            this._controller._Str_22982(_local_2);
        }

        public function _Str_23241()
        {
        }
    }

