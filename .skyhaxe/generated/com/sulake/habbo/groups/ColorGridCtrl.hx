package com.sulake.habbo.groups
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.users.GuildColorData;
    import com.sulake.core.window.components.IItemGridWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.ColorTransform;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class ColorGridCtrl 
    {
        var _manager:HabboGroupsManager;
        var _parentWindow:IWindowContainer;
        var _parentCallback:ASFunction;
        var _colorData:Vector<GuildColorData>;
        var _colorGrid:IItemGridWindow;
        var _selectedColorIndex:Int = -1;
        var _selectedColorBitmap:BitmapData;
        var _backgroundBitmap:BitmapData;
        var _foregroundBitmap:BitmapData;
        var _disposed:Bool = false;

        public function new(k:HabboGroupsManager, _arg_2:ASFunction)
        {
            this._manager = k;
            this._parentCallback = _arg_2;
        }

        public var _Str_4246(get,never):Int;
public function  get__Str_4246():Int
        {
            return this._selectedColorIndex;
        }

        public var isInitialized(get,never):Bool;
public function  get_isInitialized():Bool
        {
            return (!(this._colorData == null)) && (!(this._colorGrid == null));
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._colorGrid != null)
                {
                    this._colorGrid.destroyGridItems();
                    this._colorGrid = null;
                }
                if (this._backgroundBitmap != null)
                {
                    this._backgroundBitmap.dispose();
                    this._backgroundBitmap = null;
                }
                if (this._foregroundBitmap != null)
                {
                    this._foregroundBitmap.dispose();
                    this._foregroundBitmap = null;
                }
                if (this._backgroundBitmap != null)
                {
                    this._backgroundBitmap.dispose();
                    this._backgroundBitmap = null;
                }
                if (this._selectedColorBitmap != null)
                {
                    this._selectedColorBitmap.dispose();
                    this._selectedColorBitmap = null;
                }
                this._manager = null;
                this._parentWindow = null;
                this._disposed = true;
            }
        }

        public function _Str_16890(k:IWindowContainer, _arg_2:String, _arg_3:Vector<GuildColorData>)
        {
            var _local_4:GuildColorData = null;
            var _local_5:IWindowContainer = null;
            if (((((!(this._colorGrid == null)) || (k == null)) || (_arg_2 == null)) || (_arg_3 == null)))
            {
                return;
            }
            this._parentWindow = k;
            this._colorData = _arg_3;
            this._colorGrid = Std.downcast(this._parentWindow.findChildByName(_arg_2) , IItemGridWindow);
            this._backgroundBitmap = this.getBitmap("color_chooser_bg");
            this._foregroundBitmap = this.getBitmap("color_chooser_fg");
            this._selectedColorBitmap = this.getBitmap("color_chooser_selected");
            final _iter_ = this._colorData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_5 = Std.downcast(this._manager.getXmlWindow("badge_color_item") , IWindowContainer);
                _local_5.procedure = this.onClick;
                _local_5.background = true;
                _local_5.color = 0xFFBEBBA5;
                _local_5.width = this._backgroundBitmap.width;
                _local_5.height = this._backgroundBitmap.height;
                this._Str_18553(_local_5, "background", this._backgroundBitmap, true, null);
                this._Str_18553(_local_5, "foreground", this._foregroundBitmap, true, _local_4);
                this._Str_18553(_local_5, "selected", this._selectedColorBitmap, false, null);
                this._colorGrid.addGridItem(_local_5);
            }
        }

        function _Str_18553(k:IWindowContainer, _arg_2:String, _arg_3:BitmapData, _arg_4:Bool, _arg_5:GuildColorData=null)
        {
            var _local_7:BitmapData = null;
            var _local_6= Std.downcast(k.findChildByName(_arg_2) , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_7 = _arg_3.clone();
                if (_arg_5 != null)
                {
                    _local_7.colorTransform(_local_7.rect, new ColorTransform((_arg_5.red / 0xFF), (_arg_5.green / 0xFF), (_arg_5.blue / 0xFF)));
                }
                _local_6.bitmap = _local_7;
                _local_6.visible = _arg_4;
            }
        }

        public function _Str_6965(k:Int, _arg_2:Bool=true)
        {
            if (k < 0)
            {
                k = 0;
            }
            if (((!(this._selectedColorIndex == k)) && ((k : UInt) < this._colorGrid.numGridItems)))
            {
                this._Str_20185(this._selectedColorIndex, false);
                this._selectedColorIndex = k;
                this._Str_20185(this._selectedColorIndex, true);
            }
            if ((_arg_2 && (!(this._parentCallback == null))))
            {
                this._parentCallback(this);
            }
        }

        public function _Str_6434(k:Int)
        {
            if (!this.isInitialized)
            {
                return;
            }
            var _local_2 = 0;
            while (_local_2 < this._colorData.length)
            {
                if (this._colorData[_local_2].id == k)
                {
                    this._Str_6965(_local_2);
                    return;
                }
                _local_2++;
            }
            this._Str_6965(0);
        }

        public function _Str_15044():Int
        {
            var k= this._Str_10058();
            if (k != null)
            {
                return k.id;
            }
            return 0;
        }

        public function _Str_10058():GuildColorData
        {
            if ((((!(this._colorData == null)) && (this._selectedColorIndex >= 0)) && (this._selectedColorIndex < this._colorData.length)))
            {
                return this._colorData[this._selectedColorIndex];
            }
            return null;
        }

        function getBitmap(k:String):BitmapData
        {
            var _local_3:BitmapData = null;
            var _local_2= Std.downcast(this._manager.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_2 != null)
            {
                _local_3 = ASCompat.dynamicAs(_local_2.content , BitmapData);
                if (_local_3 != null)
                {
                    return _local_3;
                }
            }
            throw new Exception((("Failed to load bitmap asset " + k) + " in ColorGridWidget"));
        }

        function _Str_20185(k:Int, _arg_2:Bool)
        {
            var _local_4:IWindow = null;
            if (((k < 0) || ((k : UInt) >= this._colorGrid.numGridItems)))
            {
                return;
            }
            var _local_3= Std.downcast(this._colorGrid.getGridItemAt(k) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_4 = _local_3.findChildByName("selected") ;
                if (_local_4 != null)
                {
                    _local_4.visible = _arg_2;
                }
            }
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_6965(this._colorGrid.getGridItemIndex(_arg_2));
        }
    }

