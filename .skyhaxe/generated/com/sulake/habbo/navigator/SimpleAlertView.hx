package com.sulake.habbo.navigator
;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IFrameWindow;

     class SimpleAlertView extends AlertView 
    {
        var _text:String;

        public function new(k:IHabboTransitionalNavigator, _arg_2:String, _arg_3:String)
        {
            super(k, "nav_simple_alert", _arg_2);
            this._text = _arg_3;
        }
@:allow(com.sulake.habbo.navigator) 
        override function setupAlertWindow(k:IFrameWindow)
        {
            var _local_2= k.content;
            cast(_local_2.findChildByName("body_text"), ITextWindow).text = this._text;
            var _local_3= _local_2.findChildByName("ok");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_6167);
            }
            k.tags.push("SimpleAlertView");
        }

        function _Str_6167(k:WindowMouseEvent)
        {
            dispose();
        }
    }


