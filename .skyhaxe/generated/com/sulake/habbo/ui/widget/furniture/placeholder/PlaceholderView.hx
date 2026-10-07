package com.sulake.habbo.ui.widget.furniture.placeholder
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class PlaceholderView 
    {
        var _assetLibrary:IAssetLibrary;
        var _windowManager:IHabboWindowManager;
        var _window:IWindowContainer;

        public function new(k:IAssetLibrary, _arg_2:IHabboWindowManager)
        {
            this._assetLibrary = k;
            this._windowManager = _arg_2;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public function toggleWindow()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this._Str_15155();
            }
            else
            {
                this.showWindow();
            }
        }

        public function showWindow()
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            this._window.visible = true;
            this._window.x = 200;
        }

        function createWindow()
        {
            var k= Std.downcast(this._assetLibrary.getAssetByName("placeholder") , XmlAsset);
            if (((k == null) || (k.content == null)))
            {
                return;
            }
            this._window = Std.downcast(this._windowManager.createWindow("habbohelp_window", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.NULL, (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(-300, 300, 10, 10), null) , IWindowContainer);
            this._window.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ));
            this._window.tags.push("habbo_help_window");
            this._window.background = true;
            this._window.color = 33554431;
            var _local_2= this._window.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.procedure = this.onWindowClose;
            }
        }

        public function _Str_15155()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_15155();
        }
    }

