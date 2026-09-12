package com.sulake.habbo.ui.widget.uihelpbubbles
;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextFieldWindow;

     class _Str_4171 
    {
        var _window:IWindowContainer;
        var _widget:UiHelpBubblesWidget;
        var _id:String;
        var _Str_6304:Point;
        var _Str_19278:String;
        var _Str_13653:Bool = false;
        var _Str_3495:IBubbleWindow;
        var _Str_12172:IButtonWindow;
        var _Str_2757:IWindowContainer;
        var _Str_20666:Bool = false;
        var _Str_12235:IBitmapWrapperWindow;
        var _Str_15322:IWindow;
        var _Str_21983:IWindow;
        var _Str_4383:ASFunction;

        public function new(k:UiHelpBubblesWidget, _arg_2:_Str_5419, _arg_3:Bool)
        {
            this._widget = k;
            this._id = _arg_2.name;
            this._Str_19278 = _arg_2.text;
            this._Str_13653 = _arg_3;
            this._Str_20666 = _arg_2._Str_16803;
            this.createWindow();
        }

        public function dispose()
        {
            this._widget = null;
            if (((!(this._Str_15322 == null)) && (!(this._Str_4383 == null))))
            {
                this._Str_15322.removeEventListener(WindowMouseEvent.CLICK, this._Str_4383);
            }
            if (this._Str_2757 != null)
            {
                this._Str_2757.dispose();
                this._Str_2757 = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function addMouseClickListener(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }

        function createWindow()
        {
            var _local_3:XmlAsset = null;
            var _local_4 = 0;
            if ((((!(this._widget != null)) || (!(this._widget.assets != null))) || (!(this._widget.windowManager != null))))
            {
                return;
            }
            if (this._Str_20666)
            {
                _local_3 = Std.downcast(this._widget.assets.getAssetByName("ui_help_modal") , XmlAsset);
                this._Str_2757 = Std.downcast(this._widget.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) ), 3) , IWindowContainer);
            }
            if (this._Str_2757 != null)
            {
                this._Str_2757.width = this._Str_2757.desktop.width;
                this._Str_2757.height = this._Str_2757.desktop.height;
                this._Str_12235 = Std.downcast(this._Str_2757.findChildByName("bitmap") , IBitmapWrapperWindow);
                this.addMouseClickListener(this._Str_12235, this._Str_25803);
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("ui_help_bubble") , XmlAsset);
            if (k == null)
            {
                return;
            }
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), 3) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._Str_12172 = Std.downcast(this._window.findChildByName("help_bubble_btn_ok") , IButtonWindow);
            this._Str_3495 = Std.downcast(this._window.findChildByName("bubble") , IBubbleWindow);
            var _local_2= Std.downcast(this._window.findChildByName("help_bubble_text") , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.text = this._Str_19278;
                _local_4 = Std.int(_local_2.textHeight);
                this._window.height = (_local_4 + 90);
                this._Str_12172.y = (_local_4 + 30);
            }
            if (!this._Str_13653)
            {
                this._Str_12172.caption = this._widget.localizations.getLocalization("alert.close.button", "alert.close.button");
                this.addMouseClickListener(this._Str_12172, this._Str_16126);
            }
            else
            {
                this.addMouseClickListener(this._Str_12172, this._Str_17704);
            }
            this._window.visible = true;
        }

        public function show()
        {
            if (this._window != null)
            {
                this._window.visible = true;
                this._window.activate();
            }
        }

        function _Str_25803(k:WindowMouseEvent)
        {
            this._Str_2757.deactivate();
            this._window.activate();
        }

        function _Str_17704(k:WindowMouseEvent)
        {
            if (this._widget == null)
            {
                return;
            }
            if (this._Str_2757 != null)
            {
                this._Str_2757.visible = false;
            }
            this._widget._Str_14683(this._id);
        }

        function _Str_16126(k:WindowMouseEvent)
        {
            if (this._widget == null)
            {
                return;
            }
            this._widget._Str_25030();
            if (this._Str_2757 != null)
            {
                this._Str_2757.visible = false;
            }
            this._widget._Str_14683(this._id);
        }

        public function _Str_21122(k:Rectangle)
        {
            if (this._Str_12235 == null)
            {
                return;
            }
            var _local_2= new BitmapData(this._Str_2757.width, this._Str_2757.height, true, 0xFFE00000);
            var _local_3= new BitmapData(Std.int(k.width), Std.int(k.height), true, 0xFFFFFF);
            _local_2.copyPixels(_local_3, _local_3.rect, new Point(k.x, k.y));
            this._Str_12235.bitmap = _local_2;
            this._Str_12235.invalidate();
        }

        public function _Str_19842(k:Point)
        {
            this._Str_6304 = k;
            this._window.y = Std.int(this._Str_6304.y);
            this._window.x = Std.int(this._Str_6304.x - (this._window.width / 2));
        }

        public function _Str_11739(k:String, _arg_2:Int)
        {
            this._Str_3495.direction = k;
            this._Str_3495._Str_8006 = (_arg_2 - 8);
        }

        public function _Str_16079(k:IWindow)
        {
            if (this._Str_4383 != null)
            {
                return;
            }
            this._Str_15322 = k;
            if (!this._Str_13653)
            {
                this._Str_4383 = this._Str_16126;
            }
            else
            {
                this._Str_4383 = this._Str_17704;
            }
            this._Str_15322.addEventListener(WindowMouseEvent.CLICK, this._Str_4383);
        }

        public function _Str_22662(k:ITextFieldWindow)
        {
            if (this._Str_4383 != null)
            {
                return;
            }
            this._Str_21983 = k;
            if (!this._Str_13653)
            {
                this._Str_4383 = this._Str_16126;
            }
            else
            {
                this._Str_4383 = this._Str_17704;
            }
            this._Str_21983.addEventListener(WindowMouseEvent.CLICK, this._Str_4383);
        }

        public function _Str_5493():IWindowContainer
        {
            return this._window;
        }

        public function getName():String
        {
            return this._id;
        }
    }

