package com.sulake.habbo.navigator
;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IFrameWindow;

     class ClubPromoAlertView extends AlertView 
    {
        var _text:String;
        var _promoText:String;

        public function new(k:IHabboTransitionalNavigator, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            super(k, "nav_promo_alert", _arg_2);
            this._text = _arg_3;
            this._promoText = _arg_4;
        }
@:allow(com.sulake.habbo.navigator) 
        override function setupAlertWindow(k:IFrameWindow)
        {
            var _local_2= k.content;
            _local_2.findChildByName("body_text").caption = this._text;
            _local_2.findChildByName("promo_text").caption = this._promoText;
            var _local_3= _local_2.findChildByName("ok");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_6167);
            }
            var _local_4= _local_2.findChildByName("promo_container");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_24289);
            }
        }

        function _Str_6167(k:WindowMouseEvent)
        {
            dispose();
        }

        function _Str_24289(k:WindowMouseEvent)
        {
            navigator.openCatalogClubPage("ClubPromoAlertView");
            dispose();
        }
    }


