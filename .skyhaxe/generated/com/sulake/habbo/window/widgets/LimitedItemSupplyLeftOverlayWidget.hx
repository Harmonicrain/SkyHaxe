package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;

     class LimitedItemSupplyLeftOverlayWidget implements ILimitedItemSupplyLeftOverlayWidget
    {
        public static inline final LIMITED_ITEM_OVERLAY_SUPPLY= "limited_item_overlay_supply";

        var _Str_2326:IWidgetWindow;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _Str_19162:Int = 0;
        var _Str_11520:Int = 0;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._Str_2326 = k;
            this._habboWindowManagerComponent = _arg_2;
            this._root = cast(this._habboWindowManagerComponent.buildFromXML(new com.sulake.core.utils.xml.XML(this._habboWindowManagerComponent.assets.getAssetByName("unique_item_overlay_supply_xml").content)), IWindowContainer);
            this._Str_2326.rootWindow = this._root;
        }

        
        public var supplyLeft(get,set):Int;
public function  set_supplyLeft(k:Int):Int        {
            this._Str_19162 = k;
            var _local_2= Std.downcast(this._root.findChildByName("items_left_count") , ITextWindow);
            _local_2.text = Std.string(k);
            var _local_3 = false;
            this._root.findChildByName("unique_item_sold_out_bitmap").visible = _local_3;
return k;
        }
public function  get_supplyLeft():Int
        {
            return this._Str_19162;
        }

        
        public var serialNumber(get,set):Int;
public function  set_serialNumber(k:Int):Int        {
return k;
        }

        
        public var seriesSize(get,set):Int;
public function  set_seriesSize(k:Int):Int        {
            this._Str_11520 = k;
            var _local_2= Std.downcast(this._root.findChildByName("items_total_count") , ITextWindow);
            _local_2.text = Std.string(k);
return k;
        }
public function  get_serialNumber():Int
        {
            return 0;
        }
public function  get_seriesSize():Int
        {
            return this._Str_11520;
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
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._root == null;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }
    }



