package com.sulake.habbo.window.widgets
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.window.utils.LimitedItemOverlayNumberBitmapGenerator;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import flash.geom.Rectangle;
    import flash.geom.Point;

     class LimitedItemGridOverlayWidget implements ILimitedItemGridOverlayWidget implements  IUpdateReceiver
    {
        public static inline final LIMITED_ITEM_OVERLAY_GRID= "limited_item_overlay_grid";

        static inline final _Str_20449:UInt = 10000;
        static inline final _Str_23542:UInt = 250;

        var _disposed:Bool = false;
        var _Str_2326:IWidgetWindow;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _Str_11590:BitmapData;
        var _Str_5779:IBitmapWrapperWindow;
        var _serialNumber:Int = 0;
        var _Str_7480:UInt = 0;
        var _Str_13683:UInt = 0;
        var _animated:Bool = false;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._Str_7480 = flash.Lib.getTimer();
            this._Str_13683 = this._Str_7480;
            this._Str_2326 = k;
            this._habboWindowManagerComponent = _arg_2;
            this._Str_11590 = cast(this._habboWindowManagerComponent.assets.getAssetByName("unique_item_label_plaque_metal").content, BitmapData).clone();
            this._root = cast(this._habboWindowManagerComponent.buildFromXML(new com.sulake.core.utils.xml.XML(this._habboWindowManagerComponent.assets.getAssetByName("unique_item_overlay_griditem_xml").content)), IWindowContainer);
            this._Str_5779 = cast(this._root.findChildByName("unique_item_overlay_plaque_background_bitmap"), IBitmapWrapperWindow);
            this._Str_5779.bitmap = this._Str_11590;
            this._Str_2326.rootWindow = this._root;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._animated)
                {
                    this._habboWindowManagerComponent.removeUpdateReceiver(this);
                }
                if (this._Str_2326 != null)
                {
                    this._Str_2326.rootWindow = null;
                    this._Str_2326 = null;
                }
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                this._habboWindowManagerComponent = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var serialNumber(get,set):Int;
public function  set_serialNumber(k:Int):Int        {
            this._serialNumber = k;
            var _local_2= cast(this._root.findChildByName("unique_item_overlay_plaque_number_bitmap"), IBitmapWrapperWindow);
            _local_2.bitmap = LimitedItemOverlayNumberBitmapGenerator._Str_14181(this._habboWindowManagerComponent.assets, this.serialNumber, _local_2.width, _local_2.height);
return k;
        }

        
        public var seriesSize(get,set):Int;
public function  set_seriesSize(k:Int):Int        {
return k;
        }
public function  get_serialNumber():Int
        {
            return this._serialNumber;
        }
public function  get_seriesSize():Int
        {
            return 0;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return [];
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
return k;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        
        public var animated(get,set):Bool;
public function  get_animated():Bool
        {
            return this._animated;
        }
public function  set_animated(k:Bool):Bool        {
            this._animated = k;
            if (this._animated)
            {
                this._habboWindowManagerComponent.registerUpdateReceiver(this, 5);
            }
            else
            {
                this._habboWindowManagerComponent.removeUpdateReceiver(this);
            }
return k;
        }

        public function update(k:UInt)
        {
            var _local_2:BitmapData = null;
            var _local_3 = Math.NaN;
            var _local_4 = 0;
            if (!this.disposed)
            {
                this._Str_7480 = (this._Str_7480 + k);
                if ((this._Str_7480 - this._Str_13683) > LimitedItemGridOverlayWidget._Str_20449)
                {
                    _local_2 = new BitmapData(this._Str_5779.width, this._Str_5779.height, false);
                    _local_3 = (((this._Str_7480 - this._Str_13683) - LimitedItemGridOverlayWidget._Str_20449) / LimitedItemGridOverlayWidget._Str_23542);
                    if (_local_3 < 1)
                    {
                        _local_4 = Std.int((this._Str_11590.height - this._Str_5779.height) * _local_3);
                        _local_2.copyPixels(this._Str_11590, new Rectangle(0, _local_4, this._Str_5779.width, this._Str_5779.height), new Point(0, 0));
                        this._Str_5779.bitmap = _local_2;
                    }
                    else
                    {
                        this._Str_5779.bitmap = this._Str_11590;
                        this._Str_13683 = this._Str_7480;
                    }
                }
            }
        }
    }

