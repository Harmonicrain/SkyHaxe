package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.habbo.window.utils.ChestItemOverlayNumberBitmapGenerator;

    /** July chest contents-count plaque used by inventory thumbnails. */
     class ChestItemGridOverlayWidget
        implements IChestItemGridOverlayWidget
    {
        public static inline final TYPE= "chest_overlay_grid";
        public static inline final COLOR_SILVER= "silver";
        public static inline final COLOR_GOLD= "gold";
        public static inline final COLOR_BROWN= "brown";

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _contentsCount:Int = 0;
        var _color:String;

        public function new(window:IWidgetWindow,
            windowManager:HabboWindowManagerComponent)
        {
            this._widgetWindow = window;
            this._windowManager = windowManager;
            this._root = cast(windowManager.buildFromXML(
                new com.sulake.core.utils.xml.XML(windowManager.assets.getAssetByName(
                    "chest_overlay_griditem_xml").content)), IWindowContainer);
            this._widgetWindow.rootWindow = this._root;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._widgetWindow != null)
            {
                this._widgetWindow.rootWindow = null;
                this._widgetWindow = null;
            }
            if (this._root != null)
            {
                this._root.dispose();
                this._root = null;
            }
            this._windowManager = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return [];
        }
public function  set_properties(value:Array<ASAny>):Array<ASAny>        {
return value;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        
        public var contentsCount(get,set):Int;
public function  set_contentsCount(value:Int):Int        {
            this._contentsCount = value;
            var number= cast(
                this._root.findChildByName(
                    "chest_plaque_number_bitmap"), IBitmapWrapperWindow);
            number.bitmap = ChestItemOverlayNumberBitmapGenerator.createBitmap(
                this._windowManager.assets, value, number.width, number.height);
return value;
        }
public function  get_contentsCount():Int
        {
            return this._contentsCount;
        }

        
        public var color(get,set):String;
public function  set_color(value:String):String        {
            this._color = value;
            cast(this._root.findChildByName(
                "chest_plaque_bitmap"), IStaticBitmapWrapperWindow).assetUri =
                "chest_overlay_" + value + "_plaque";
return value;
        }
public function  get_color():String
        {
            return this._color;
        }
    }

