package com.sulake.habbo.ui.widget.furniture.dimmer
;
    import com.sulake.core.window.components.IItemGridWindow;
	import com.sulake.habbo.ui.widget.furniture.dimmer.DimmerView;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.assets.BitmapDataAsset;

     class DimmerViewColorGrid 
    {
        var _gridWindow:IItemGridWindow;
        var _view:DimmerView;
        var _colorCellXML:com.sulake.core.utils.xml.XML;
        var _colorCellFrame:BitmapData;
        var _colorCellButton:BitmapData;
        var _colorCellSelected:BitmapData;
        var _selectedGridItem:IWindowContainer;

        public function new(k:DimmerView, _arg_2:IItemGridWindow, _arg_3:IHabboWindowManager, _arg_4:IAssetLibrary)
        {
            this._view = k;
            this._gridWindow = _arg_2;
            this._Str_6048(_arg_4);
            this.populate(_arg_3);
        }

        public function dispose()
        {
            this._view = null;
            this._gridWindow = null;
            this._colorCellXML = null;
            this._colorCellFrame = null;
            this._colorCellButton = null;
            this._colorCellSelected = null;
        }

        public function _Str_6965(k:Int)
        {
            if (this._gridWindow == null)
            {
                return;
            }
            if (((k < 0) || ((k : UInt) >= this._gridWindow.numGridItems)))
            {
                return;
            }
            this.select(Std.downcast(this._gridWindow.getGridItemAt(k) , IWindowContainer));
        }

        function populate(k:IHabboWindowManager)
        {
            if (((this._view == null) || (this._gridWindow == null)))
            {
                return;
            }
            this._Str_14728(k);
        }

        function select(k:IWindowContainer)
        {
            var _local_2:IWindow = null;
            if (this._selectedGridItem != null)
            {
                _local_2 = this._selectedGridItem.getChildByName("chosen");
                if (_local_2 != null)
                {
                    _local_2.visible = false;
                }
            }
            this._selectedGridItem = k;
            _local_2 = this._selectedGridItem.getChildByName("chosen");
            if (_local_2 != null)
            {
                _local_2.visible = true;
            }
        }

        function _Str_14728(k:IHabboWindowManager)
        {
            var _local_2:UInt = 0;
            var _local_3:IWindowContainer = null;
            var _local_4:IBitmapWrapperWindow = null;
            var _local_5:IBitmapWrapperWindow = null;
            var _local_6:IBitmapWrapperWindow = null;
            var _local_7:UInt = 0;
            var _local_8:UInt = 0;
            var _local_9:UInt = 0;
            var _local_10 = Math.NaN;
            var _local_11 = Math.NaN;
            var _local_12 = Math.NaN;
            var _local_13:ColorTransform = null;
            var _local_14:BitmapData = null;
            this._gridWindow.destroyGridItems();
            this._selectedGridItem = null;
            final _iter_ = this.colors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toUInt(_tmp_);
                _local_3 = Std.downcast(k.buildFromXML(this._colorCellXML) , IWindowContainer);
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onClick);
                _local_3.background = true;
                _local_3.color = 0xFFFFFFFF;
                _local_3.width = this._colorCellFrame.width;
                _local_3.height = this._colorCellFrame.height;
                this._gridWindow.addGridItem(_local_3);
                _local_4 = Std.downcast(_local_3.findChildByTag("BG_BORDER") , IBitmapWrapperWindow);
                if (_local_4 != null)
                {
                    _local_4.bitmap = new BitmapData(this._colorCellFrame.width, this._colorCellFrame.height, true, 0);
                    _local_4.bitmap.copyPixels(this._colorCellFrame, this._colorCellFrame.rect, new Point(0, 0));
                }
                _local_5 = Std.downcast(_local_3.findChildByTag("COLOR_IMAGE") , IBitmapWrapperWindow);
                if (_local_5 != null)
                {
                    _local_5.bitmap = new BitmapData(this._colorCellButton.width, this._colorCellButton.height, true, 0);
                    _local_7 = ((ASCompat.toInt(_local_2 )>> 16) & 0xFF);
                    _local_8 = ((ASCompat.toInt(_local_2 )>> 8) & 0xFF);
                    _local_9 = ((ASCompat.toInt(_local_2 )>> 0) & 0xFF);
                    _local_10 = ((_local_7 / 0xFF) * 1);
                    _local_11 = ((_local_8 / 0xFF) * 1);
                    _local_12 = ((_local_9 / 0xFF) * 1);
                    _local_13 = new ColorTransform(_local_10, _local_11, _local_12);
                    _local_14 = this._colorCellButton.clone();
                    _local_14.colorTransform(_local_14.rect, _local_13);
                    _local_5.bitmap.copyPixels(_local_14, _local_14.rect, new Point(0, 0));
                }
                _local_6 = Std.downcast(_local_3.findChildByTag("COLOR_CHOSEN") , IBitmapWrapperWindow);
                if (_local_6 != null)
                {
                    _local_6.bitmap = new BitmapData(this._colorCellSelected.width, this._colorCellSelected.height, true, 0xFFFFFF);
                    _local_6.bitmap.copyPixels(this._colorCellSelected, this._colorCellSelected.rect, new Point(0, 0), null, null, true);
                    _local_6.visible = false;
                }
            }
        }

        function onClick(k:WindowMouseEvent)
        {
            var _local_2= this._gridWindow.getGridItemIndex(k.target );
            this._Str_6965(_local_2);
            this._view._Str_4246 = _local_2;
        }

        function _Str_6048(k:IAssetLibrary)
        {
            var _local_2:XmlAsset = null;
            var _local_3:BitmapDataAsset = null;
            if (k == null)
            {
                return;
            }
            _local_2 = cast(k.getAssetByName("dimmer_color_chooser_cell"), XmlAsset);
            this._colorCellXML = new com.sulake.core.utils.xml.XML(_local_2.content);
            _local_3 = cast(k.getAssetByName("dimmer_color_frame"), BitmapDataAsset);
            this._colorCellFrame = cast(_local_3.content, BitmapData);
            _local_3 = cast(k.getAssetByName("dimmer_color_button"), BitmapDataAsset);
            this._colorCellButton = cast(_local_3.content, BitmapData);
            _local_3 = cast(k.getAssetByName("dimmer_color_selected"), BitmapDataAsset);
            this._colorCellSelected = cast(_local_3.content, BitmapData);
        }

        var colors(get,never):Array<ASAny>;
function  get_colors():Array<ASAny>
        {
            if (this._view == null)
            {
                return [];
            }
            return this._view.colors;
        }
    }

