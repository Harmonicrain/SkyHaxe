package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class TextElementHandler implements IElementHandler 
    {
        var _window:ITextWindow;


        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._window = Std.downcast(_arg_2 , ITextWindow);
            var _local_5:String = _arg_3[1];
            this._window.caption = (("${" + _local_5) + "}");
            if (_arg_3.length > 2)
            {
                this._window.width = ASCompat.parseInt(_arg_3[2]);
            }
            if (((_arg_3.length > 3) && (_arg_3[3] == "true")))
            {
                this._window.border = true;
            }
        }

        public function refresh()
        {
        }

        public var _Str_14499(never,set):String;
public function  set__Str_14499(k:String):String        {
            this._window.caption = (("${" + k) + "}");
return k;
        }
public function new(){}
    }

