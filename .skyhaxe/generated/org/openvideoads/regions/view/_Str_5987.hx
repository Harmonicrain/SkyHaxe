package org.openvideoads.regions.view
;
    import org.openvideoads.util.NetworkResource;
    import flash.text.StyleSheet;

     class _Str_5987 extends NetworkResource 
    {
        var _Str_16019:ASFunction;
        var _stylesheet:StyleSheet;

        public function new(k:String=null, _arg_2:ASFunction=null)
        {
            super();
            this._Str_16019 = _arg_2;
            this._stylesheet = new StyleSheet();
            if (k != null)
            {
                url = k;
                call();
            }
        }

        override function loadComplete(k:String)
        {
            this._stylesheet = new StyleSheet();
            this.parseCSS(k);
            if (this._Str_16019 != null)
            {
                this._Str_16019();
            }
        }

        public function parseCSS(k:String)
        {
            this._stylesheet.parseCSS(k);
        }

        public var stylesheet(get,never):StyleSheet;
public function  get_stylesheet():StyleSheet
        {
            return this._stylesheet;
        }
    }

