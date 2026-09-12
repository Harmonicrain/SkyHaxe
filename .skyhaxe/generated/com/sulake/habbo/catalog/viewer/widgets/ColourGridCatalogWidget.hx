package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.IItemGridWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetColoursEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetMultiColoursEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.geom.Rectangle;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetColourIndexEvent;

     class ColourGridCatalogWidget extends CatalogWidget
    {
        var _colours:Array<ASAny>;
        var _colourGrid:IItemGridWindow;
        var _colourChooserLayout:com.sulake.core.utils.xml.XML;
        var _colourChooserBackground:BitmapData;
        var _colourChooserColour:BitmapData;
        var _colourChosen:BitmapData;
        var _selectedGridItem:IWindowContainer;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            if (!this._colourGrid.disposed)
            {
                this._colourGrid.destroyGridItems();
                this._colourGrid.dispose();
            }
            this._colourGrid = null;
            this._colourChooserLayout = null;
            this._selectedGridItem = null;
            events.removeEventListener(CatalogWidgetEvent.COLOUR_ARRAY, this._Str_20989);
            events.removeEventListener(CatalogWidgetEvent.MULTI_COLOUR_ARRAY, this._Str_22045);
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.COLOUR_GRID);
            var k:ASAny = (_window.tags.indexOf("FIXED") > -1);
            if (!k)
            {
                _window.getChildAt(0).width = _window.width;
                _window.getChildAt(0).height = _window.height;
            }
            this._colourGrid = Std.downcast(_window.findChildByName("colourGrid") , IItemGridWindow);
            this._colourGrid.width = window.width;
            this._colourGrid.height = window.height;
            var _local_2= Std.downcast(page.viewer.catalog.assets.getAssetByName("color_chooser_cell") , XmlAsset);
            this._colourChooserLayout = ((_local_2.content : com.sulake.core.utils.xml.XML) );
            events.addEventListener(CatalogWidgetEvent.COLOUR_ARRAY, this._Str_20989);
            events.addEventListener(CatalogWidgetEvent.MULTI_COLOUR_ARRAY, this._Str_22045);
            return true;
        }

        function _Str_20989(k:CatalogWidgetColoursEvent)
        {
            var _local_2 = 0;
            var _local_3:BitmapDataAsset = null;
            var _local_4:BitmapDataAsset = null;
            var _local_5:BitmapDataAsset = null;
            this._colours = [];
            final _iter_ = k.colours; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                this._colours.push(([_local_2] : Array<Dynamic>));
            }
            _local_3 = Std.downcast(page.viewer.catalog.assets.getAssetByName(k._Str_17113) , BitmapDataAsset);
            this._colourChooserBackground = ASCompat.dynamicAs(_local_3.content , BitmapData);
            _local_4 = Std.downcast(page.viewer.catalog.assets.getAssetByName(k._Str_17801) , BitmapDataAsset);
            this._colourChooserColour = ASCompat.dynamicAs(_local_4.content , BitmapData);
            _local_5 = Std.downcast(page.viewer.catalog.assets.getAssetByName(k._Str_17175) , BitmapDataAsset);
            this._colourChosen = ASCompat.dynamicAs(_local_5.content , BitmapData);
            this._Str_14728();
            this.select(Std.downcast(this._colourGrid.getGridItemAt(k.index) , IWindowContainer));
        }

        function _Str_22045(k:CatalogWidgetMultiColoursEvent)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:BitmapDataAsset = null;
            var _local_4:BitmapDataAsset = null;
            var _local_5:BitmapDataAsset = null;
            this._colours = [];
            final _iter_ = k.colours; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._colours.push(_local_2.slice(0));
            }
            _local_3 = Std.downcast(page.viewer.catalog.assets.getAssetByName(k._Str_17113) , BitmapDataAsset);
            this._colourChooserBackground = ASCompat.dynamicAs(_local_3.content , BitmapData);
            _local_4 = Std.downcast(page.viewer.catalog.assets.getAssetByName(k._Str_17801) , BitmapDataAsset);
            this._colourChooserColour = ASCompat.dynamicAs(_local_4.content , BitmapData);
            _local_5 = Std.downcast(page.viewer.catalog.assets.getAssetByName(k._Str_17175) , BitmapDataAsset);
            this._colourChosen = ASCompat.dynamicAs(_local_5.content , BitmapData);
            this._Str_14728();
            this.select(Std.downcast(this._colourGrid.getGridItemAt(0) , IWindowContainer));
        }

        function select(k:IWindowContainer)
        {
            var _local_2:IWindow = null;
            Logger.log([("[ColourGridCatalogWidget] Select: " + k)]);
            if (this._selectedGridItem != null)
            {
                _local_2 = this._selectedGridItem.getChildByName("chosen");
                if (_local_2 != null)
                {
                    _local_2.visible = false;
                }
            }
            this._selectedGridItem = k;
            if (this._selectedGridItem != null)
            {
                _local_2 = this._selectedGridItem.getChildByName("chosen");
            }
            if (_local_2 != null)
            {
                _local_2.visible = true;
            }
        }

        function _Str_14728()
        {
            var k:Array<ASAny> = null;
            var _local_2:IWindowContainer = null;
            var _local_3:IBitmapWrapperWindow = null;
            var _local_4:IBitmapWrapperWindow = null;
            var _local_5:IBitmapWrapperWindow = null;
            var _local_6:UInt = 0;
            var _local_7:UInt = 0;
            var _local_8:UInt = 0;
            var _local_9:BitmapData = null;
            var _local_10:BitmapData = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            Logger.log([("[ColourGridCatalogWidget] Display colors: " + ASCompat.toString([this._colours.length, this._colourGrid.numGridItems]))]);
            this._colourGrid.destroyGridItems();
            this._selectedGridItem = null;
            final _iter_ = this._colours; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.length > 0)
                {
                    _local_2 = Std.downcast(page.viewer.catalog.windowManager.buildFromXML(this._colourChooserLayout) , IWindowContainer);
                    _local_2.addEventListener(WindowMouseEvent.CLICK, this.onClick);
                    _local_2.background = true;
                    _local_2.color = 0xFFFFFFFF;
                    _local_2.width = this._colourChooserBackground.width;
                    _local_2.height = this._colourChooserBackground.height;
                    this._colourGrid.addGridItem(_local_2);
                    _local_3 = Std.downcast(_local_2.findChildByTag("BG_BORDER") , IBitmapWrapperWindow);
                    if (_local_3 != null)
                    {
                        _local_3.bitmap = new BitmapData(this._colourChooserBackground.width, this._colourChooserBackground.height, true, 0);
                        _local_3.bitmap.copyPixels(this._colourChooserBackground, this._colourChooserBackground.rect, new Point(0, 0));
                    }
                    _local_4 = Std.downcast(_local_2.findChildByTag("COLOR_IMAGE") , IBitmapWrapperWindow);
                    if (_local_4 != null)
                    {
                        _local_4.bitmap = new BitmapData(this._colourChooserColour.width, this._colourChooserColour.height, true, 0);
                        _local_6 = 0xFF;
                        _local_7 = 0xFF;
                        _local_8 = 0xFF;
                        _local_9 = null;
                        _local_10 = null;
                        _local_11 = ASCompat.toInt(k[0]);
                        if (_local_11 >= 0)
                        {
                            _local_6 = ((_local_11 >> 16) & 0xFF);
                            _local_7 = ((_local_11 >> 8) & 0xFF);
                            _local_8 = ((_local_11 >> 0) & 0xFF);
                        }
                        _local_9 = this._colourChooserColour.clone();
                        _local_9.colorTransform(_local_9.rect, new ColorTransform((_local_6 / 0xFF), (_local_7 / 0xFF), (_local_8 / 0xFF)));
                        if (k.length > 1)
                        {
                            _local_12 = ASCompat.toInt(k[1]);
                            if (_local_12 >= 0)
                            {
                                _local_6 = ((_local_12 >> 16) & 0xFF);
                                _local_7 = ((_local_12 >> 8) & 0xFF);
                                _local_8 = ((_local_12 >> 0) & 0xFF);
                            }
                            _local_10 = this._colourChooserColour.clone();
                            _local_10.colorTransform(_local_10.rect, new ColorTransform((_local_6 / 0xFF), (_local_7 / 0xFF), (_local_8 / 0xFF)));
                        }
                        _local_4.bitmap.copyPixels(_local_9, _local_9.rect, new Point(0, 0));
                        _local_9.dispose();
                        if (_local_10 != null)
                        {
                            _local_13 = Std.int(_local_10.width / 2);
                            _local_4.bitmap.copyPixels(_local_10, new Rectangle(_local_13, 0, (_local_10.width - _local_13), _local_10.height), new Point((_local_10.width / 2), 0));
                            _local_10.dispose();
                        }
                    }
                    _local_5 = Std.downcast(_local_2.findChildByTag("COLOR_CHOSEN") , IBitmapWrapperWindow);
                    if (_local_5 != null)
                    {
                        _local_5.bitmap = new BitmapData(this._colourChosen.width, this._colourChosen.height, true, 0xFFFFFF);
                        _local_5.bitmap.copyPixels(this._colourChosen, this._colourChosen.rect, new Point(0, 0), null, null, true);
                        _local_5.visible = false;
                    }
                }
            }
        }

        function onClick(k:WindowMouseEvent)
        {
            this.select(Std.downcast(k.target , IWindowContainer));
            var _local_2= this._colourGrid.getGridItemIndex(k.target );
            events.dispatchEvent(new CatalogWidgetColourIndexEvent(_local_2));
        }
    }

