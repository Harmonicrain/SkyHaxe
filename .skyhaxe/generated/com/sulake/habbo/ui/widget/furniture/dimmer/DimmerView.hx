package com.sulake.habbo.ui.widget.furniture.dimmer
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.geom.Point;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.assets.XmlAsset;

     class DimmerView 
    {
        static inline final _Str_4126:Float = 100;
        static inline final _Str_4162:Float = 100;

        var _window:IWindowContainer;
        var _tabContext:ITabContextWindow;
        var _windowXML:com.sulake.core.utils.xml.XML;
        var _widget:DimmerFurniWidget;
        var _colorGrid:DimmerViewColorGrid;
        var _alphaSlider:DimmerViewAlphaSlider;
        var _selectedBrightness:Int = 0;
        var _selectedColorIndex:Int = 0;
        var _selectedType:Int = 0;

        public function new(k:DimmerFurniWidget)
        {
            this._widget = k;
        }

        
        public var _Str_7404(get,set):Int;
public function  get__Str_7404():Int
        {
            return this._selectedBrightness;
        }

        
        public var _Str_4246(get,set):Int;
public function  get__Str_4246():Int
        {
            return this._selectedColorIndex;
        }

        
        public var _Str_7660(get,set):Int;
public function  get__Str_7660():Int
        {
            return this._selectedType;
        }

        public function dispose()
        {
            this._Str_2718();
            this._widget = null;
        }

        public function showInterface()
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            this._Str_19341(this._widget._Str_13894);
            this.update();
        }

        public function update()
        {
            var _local_3:String = null;
            if (((this._window == null) || (this._widget == null)))
            {
                return;
            }
            var k:ASAny = (this._widget._Str_22519 == 1);
            var _local_2= this._window.findChildByName("on_off_button");
            if (_local_2 != null)
            {
                _local_3 = (k ? "${widget.dimmer.button.off}" : "${widget.dimmer.button.on}");
                _local_2.caption = _local_3;
            }
            _local_2 = this._window.findChildByName("tabbedview");
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
            _local_2 = this._window.findChildByName("apply_button");
            if (_local_2 != null)
            {
                if (k)
                {
                    _local_2.enable();
                }
                else
                {
                    _local_2.disable();
                }
            }
            _local_2 = this._window.findChildByName("off_border");
            if (_local_2 != null)
            {
                _local_2.visible = (!k);
            }
        }

        public function _Str_2718()
        {
            if (this._widget != null)
            {
                this._widget._Str_23566();
            }
            if (this._colorGrid != null)
            {
                this._colorGrid.dispose();
                this._colorGrid = null;
            }
            if (this._alphaSlider != null)
            {
                this._alphaSlider.dispose();
                this._alphaSlider = null;
            }
            this._tabContext = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function createWindow()
        {
            var k:IWindow = null;
            var _local_5:IWindow = null;
            var _local_6:ITabButtonWindow = null;
            var _local_7:BitmapData = null;
            if ((((this._widget == null) || (this._widget.windowManager == null)) || (this._Str_21491 == null)))
            {
                return;
            }
            this._window = Std.downcast(this._widget.windowManager.createWindow("dimmerui_container", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(_Str_4126, _Str_4162, 2, 2), null, 0) , IWindowContainer);
            this._window.buildFromXML(this._Str_21491);
            k = this._window.findChildByTag("close");
            if (k != null)
            {
                k.procedure = this.onWindowClose;
            }
            k = this._window.findChildByName("color_grid_container");
            if (k != null)
            {
                _local_5 = Std.downcast(k , IWindowContainer).findChildByName("color_grid");
                if (_local_5 != null)
                {
                    this._colorGrid = new DimmerViewColorGrid(this, Std.downcast(_local_5 , IItemGridWindow), this._widget.windowManager, this._widget.assets);
                }
            }
            k = this._window.findChildByName("brightness_container");
            if (k != null)
            {
                this._alphaSlider = new DimmerViewAlphaSlider(this, Std.downcast(k , IWindowContainer), this._widget.assets);
            }
            this._tabContext = cast(this._window.findChildByName("tab_context"), ITabContextWindow);
            this.selectTab(this._widget._Str_13894);
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._tabContext.numTabs)
            {
                _local_6 = this._tabContext.getTabButtonAt(_local_2);
                _local_6.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
                _local_6.procedure = this._Str_16089;
                _local_2++;
            }
            k = this._window.findChildByName("type_checkbox");
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            k = this._window.findChildByName("apply_button");
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            k = this._window.findChildByName("on_off_button");
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            var _local_3= Std.downcast(this._window.findChildByName("off_image") , IBitmapWrapperWindow);
            var _local_4= Std.downcast(this._widget.assets.getAssetByName("dimmer_info") , BitmapDataAsset);
            if (((!(_local_3 == null)) && (!(_local_4 == null))))
            {
                _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height);
                _local_7 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                if (_local_7 != null)
                {
                    _local_3.bitmap.copyPixels(_local_7, _local_7.rect, new Point(0, 0));
                }
            }
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            var _local_4:ICheckBoxWindow = null;
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "type_checkbox":
                    _local_4 = Std.downcast(k.target , ICheckBoxWindow);
                    if (_local_4 == null)
                    {
                        return;
                    }
                    if (_local_4.Selected)
                    {
                        this._Str_7660 = 2;
                    }
                    else
                    {
                        this._Str_7660 = 1;
                    }
                    this._widget._Str_12547();
                    return;
                case "apply_button":
                    this._widget._Str_19799(true);
                    return;
                case "cancel"
                   | "close":
                    this._Str_2718();
                    return;
                case "on_off_button":
                    this._widget._Str_22483();
                    return;
            }
        }

        function _Str_16089(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowEvent.WINDOW_EVENT_SELECTED)
            {
                return;
            }
            this._widget._Str_19799(false);
            var _local_3= _arg_2.id;
            this._Str_19341(_local_3);
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_2718();
        }

        function _Str_19341(k:Int)
        {
            if (((((this._widget == null) || (this._widget._Str_8447 == null)) || (k < 0)) || (k >= this._widget._Str_8447.length)))
            {
                return;
            }
            this._widget._Str_13894 = k;
            var _local_2:DimmerFurniWidgetPresetItem = this._widget._Str_8447[k];
            if (_local_2 == null)
            {
                return;
            }
            this.selectTab(k);
            this._selectedBrightness = ASCompat.toInt(_local_2.brightness);
            if (this._alphaSlider != null)
            {
                this._alphaSlider.setValue(this._selectedBrightness);
            }
            this._selectedColorIndex = this.colors.indexOf(_local_2.color);
            if (this._colorGrid != null)
            {
                this._colorGrid._Str_6965(this._selectedColorIndex);
            }
            this._Str_7660 = _local_2.type;
            this._widget._Str_12547();
        }

        function selectTab(k:Int)
        {
            if (this._tabContext == null)
            {
                return;
            }
            var _local_2:IWindow = this._tabContext.getTabButtonAt(k);
            if (_local_2 != null)
            {
                this._tabContext.selector.setSelected(Std.downcast(_local_2 , ISelectableWindow));
            }
        }

        function _Str_26376():Int
        {
            if (this._tabContext == null)
            {
                return -1;
            }
            var k= this._tabContext.selector.getSelected();
            return this._tabContext.selector.getSelectableIndex(k);
        }

        var _Str_21491(get,never):com.sulake.core.utils.xml.XML;
function  get__Str_21491():com.sulake.core.utils.xml.XML
        {
            if (this._windowXML != null)
            {
                return this._windowXML;
            }
            if ((((this._widget == null) || (this._widget.assets == null)) || (this._widget.assets.getAssetByName("dimmer_ui") == null)))
            {
                return null;
            }
            var k= cast(this._widget.assets.getAssetByName("dimmer_ui"), XmlAsset);
            this._windowXML = new com.sulake.core.utils.xml.XML(k.content);
            return this._windowXML;
        }

        public var colors(get,never):Array<ASAny>;
public function  get_colors():Array<ASAny>
        {
            if (this._widget == null)
            {
                return null;
            }
            return this._widget.colors;
        }
public function  set__Str_7660(k:Int):Int        {
            if (((!(k == 1)) && (!(k == 2))))
            {
                return k;
            }
            this._selectedType = k;
            var _local_2= Std.downcast(this._window.findChildByName("type_checkbox") , ICheckBoxWindow);
            if (_local_2 != null)
            {
                if (k == 2)
                {
                    _local_2.select();
                }
                else
                {
                    _local_2.unselect();
                }
            }
            if (this._alphaSlider != null)
            {
                this._alphaSlider.min = ASCompat.toNumber(this._widget._Str_23750[(k - 1)]);
            }
return k;
        }
public function  set__Str_4246(k:Int):Int        {
            this._selectedColorIndex = k;
            if (this._colorGrid != null)
            {
                this._colorGrid._Str_6965(k);
            }
            this._widget._Str_12547();
return k;
        }
public function  set__Str_7404(k:Int):Int        {
            this._selectedBrightness = k;
            if (this._alphaSlider != null)
            {
                this._alphaSlider.setValue(k);
            }
            this._widget._Str_12547();
return k;
        }
    }

