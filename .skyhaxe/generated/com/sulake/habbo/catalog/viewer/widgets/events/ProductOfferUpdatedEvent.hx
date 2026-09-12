package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;
    import com.sulake.habbo.catalog.IPurchasableOffer;

     class ProductOfferUpdatedEvent extends Event 
    {
        var _offer:IPurchasableOffer;

        public function new(k:IPurchasableOffer, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CatalogWidgetEvent.PRODUCT_OFFER_UPDATED, _arg_2, _arg_3);
            this._offer = k;
        }

        public var offer(get,never):IPurchasableOffer;
public function  get_offer():IPurchasableOffer
        {
            return this._offer;
        }
    }

