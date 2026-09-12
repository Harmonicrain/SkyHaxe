package com.sulake.habbo.phonenumber
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;

     class VerificationCodeInputMinimizedView 
    {
        static inline final _Str_3591:UInt = 0xFF78746D;
        static inline final _Str_3385:UInt = 0xFF55534E;

        var _component:HabboPhoneNumber;
        var _window:IWindow;

        public function new(k:HabboPhoneNumber)
        {
            this._component = k;
            this.createWindow();
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.removeEventListener(WindowMouseEvent.CLICK, this._Str_11324);
                this._window.dispose();
                this._window = null;
            }
            this._component = null;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }

        function createWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = this._component.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._component.assets.getAssetByName("phonenumber_verify_minimized_xml").content));
            this._window.addEventListener(WindowMouseEvent.CLICK, this._Str_11324);
            this._window.addEventListener(WindowMouseEvent.OVER, this._Str_7963);
            this._window.addEventListener(WindowMouseEvent.OUT, this._Str_7021);
            cast(this._window, IRegionWindow).findChildByTag("BGCOLOR").color = _Str_3385;
        }

        function _Str_11324(k:WindowMouseEvent)
        {
            this._component._Str_16951(false);
        }

        function _Str_7963(k:WindowMouseEvent)
        {
            cast(this._window, IRegionWindow).findChildByTag("BGCOLOR").color = _Str_3591;
        }

        function _Str_7021(k:WindowMouseEvent)
        {
            cast(this._window, IRegionWindow).findChildByTag("BGCOLOR").color = _Str_3385;
        }
    }


