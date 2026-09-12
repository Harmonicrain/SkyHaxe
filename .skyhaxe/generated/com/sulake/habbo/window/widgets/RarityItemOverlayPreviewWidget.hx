package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;

     class RarityItemOverlayPreviewWidget implements _Str_4520 
    {
        public static inline final RARITY_ITEM_OVERLAY_PREVIEW= "rarity_item_overlay_preview";
        static final levelPropertyKey:String = (RARITY_ITEM_OVERLAY_PREVIEW + ":level");
        static final _Str_18738:PropertyStruct = new PropertyStruct(levelPropertyKey, 0, PropertyStruct.INT);

        var _Str_2326:IWidgetWindow;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _rarityLevel:Int = 0;
        var _disposed:Bool = false;
        var _Str_19285:ITextWindow;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._Str_2326 = k;
            this._habboWindowManagerComponent = _arg_2;
            this._root = cast(this._habboWindowManagerComponent.buildFromXML(new com.sulake.core.utils.xml.XML(this._habboWindowManagerComponent.assets.getAssetByName("rarity_item_overlay_preview_xml").content)), IWindowContainer);
            this._Str_19285 = Std.downcast(this._root.findChildByName("level") , ITextWindow);
            this._Str_2326.rootWindow = this._root;
        }

        
        public var rarityLevel(get,set):Int;
public function  set_rarityLevel(k:Int):Int        {
            this._rarityLevel = k;
            this._Str_19285.caption = Std.string(k);
return k;
        }
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_18738.withValue(this.rarityLevel));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case levelPropertyKey:
                        this.rarityLevel = ASCompat.toInt(_local_2.value);
                        
                }
            }
return k;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }
    }


