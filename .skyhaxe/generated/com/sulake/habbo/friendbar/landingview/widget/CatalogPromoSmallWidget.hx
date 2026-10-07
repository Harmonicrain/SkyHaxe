package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;

     class CatalogPromoSmallWidget extends CatalogPromoWidget 
    {
        public function new(k:HabboLandingView)
        {
            super(k);
        }

        override function  get_xmlAssetName():String
        {
            return "catalog_promo_small";
        }
    }

