package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class CatalogButtonElementHandler extends AbstractButtonElementHandler 
    {
        var _pageName:String;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._pageName = _arg_3[2];
        }

        override function onClick()
        {
            if (ASCompat.stringAsBool(this._pageName))
            {
                landingView.catalog.openCatalogPage(this._pageName);
            }
            else
            {
                landingView.catalog.openCatalog();
            }
            landingView.tracking.trackGoogle("landingView", "click_genericcatalog");
        }
public function new(){	super();
}
    }

