package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

     class FormattedTextController extends TextController 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function  set_text(k:String):String        {
            if (k == null)
            {
                return k;
            }
            if (_localized)
            {
                context.removeLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                _localized = false;
            }
            _caption = k;
            if ((((!_displayRaw) && (_caption.charAt(0) == "$")) && (_caption.charAt(1) == "{")))
            {
                _localized = true;
                context.registerLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
            }
            else
            {
                if (_field != null)
                {
                    _field.htmlText = _caption;
                    refreshTextImage();
                }
            }
return k;
        }

        override public function  set_localization(k:String):String        {
            if (((!(k == null)) && (!(_field == null))))
            {
                _field.htmlText = limitStringLength(k);
                refreshTextImage();
            }
return k;
        }
    }

