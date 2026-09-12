package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.window.utils.LimitedItemOverlayNumberBitmapGenerator;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;

     class RarityItemOverlayGridWidget implements _Str_3083 
    {
        public static inline final RARITY_ITEM_OVERLAY_GRID= "rarity_item_overlay_grid";

        var _Str_2326:IWidgetWindow;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _disposed:Bool = false;
        var _root:IWindowContainer;
        var _rarityLevel:Int = 0;
        var _Str_26422:IStaticBitmapWrapperWindow;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._Str_2326 = k;
            this._habboWindowManagerComponent = _arg_2;
            this._root = cast(this._habboWindowManagerComponent.buildFromXML(new com.sulake.core.utils.xml.XML(this._habboWindowManagerComponent.assets.getAssetByName("rarity_item_overlay_griditem_xml").content)), IWindowContainer);
            this._Str_2326.rootWindow = this._root;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var rarityLevel(get,set):Int;
public function  set_rarityLevel(k:Int):Int        {
            this._rarityLevel = k;
            var _local_2= cast(this._root.findChildByName("rarity_item_overlay_plaque_number_bitmap"), IBitmapWrapperWindow);
            _local_2.bitmap = LimitedItemOverlayNumberBitmapGenerator._Str_14181(this._habboWindowManagerComponent.assets, this.rarityLevel, _local_2.width, _local_2.height);
return k;
        }
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return [];
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
return k;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
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

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }
    }



