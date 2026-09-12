package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class TitleElementHandler implements IElementHandler implements  IFloatingElement 
    {
        var _floatingEnabled:Bool = false;


        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            var _local_5= cast(_arg_2, IWindowContainer);
            var _local_6:String = _arg_3[1];
            this._floatingEnabled = ((_arg_3.length > 2) ? (_arg_3[2] == "true") : false);
            _local_5.findChildByName("title_txt").caption = (("${" + _local_6) + "}");
            HabboLandingView._Str_9079(_local_5, "title_txt", "hdr_line");
        }

        public function _Str_7806(k:Bool):Bool
        {
            return k || this._floatingEnabled;
        }

        public function refresh()
        {
        }
public function new(){}
    }

