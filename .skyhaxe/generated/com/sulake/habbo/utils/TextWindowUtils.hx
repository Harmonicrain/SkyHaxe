package com.sulake.habbo.utils
;
    import flash.text.StyleSheet;
    import com.sulake.core.window.components.ITextWindow;

     class TextWindowUtils 
    {


        public static function _Str_20340(k:ITextWindow, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:Bool=true)
        {
            if (k == null)
            {
                return;
            }
            var _local_6= new StyleSheet();
            var _local_7:ASObject = new ASObject();
            _local_7.color = _Str_5520(_arg_2);
            var _local_8:ASObject = new ASObject();
            if (_arg_5)
            {
                _local_8.textDecoration = "underline";
            }
            _local_8.color = _Str_5520(_arg_3);
            var _local_9:ASObject = new ASObject();
            _local_9.color = _Str_5520(_arg_4);
            var _local_10:ASObject = new ASObject();
            _local_10.textDecoration = "underline";
            _local_6.setStyle("a:link", _local_8);
            _local_6.setStyle("a:hover", _local_7);
            _local_6.setStyle("a:active", _local_9);
            _local_6.setStyle(".visited", _local_10);
            k.styleSheet = _local_6;
        }

        public static function _Str_5520(k:UInt):String
        {
            var _local_2= ASCompat.toRadix(k, 16);
            while (_local_2.length < 6)
            {
                _local_2 = ("0" + _local_2);
            }
            return "#" + _local_2;
        }

	public function new() {}
    }

