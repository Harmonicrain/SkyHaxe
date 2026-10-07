package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowEvent;

     class ScrollableItemGridWindow extends WindowController implements IScrollableGridWindow 
    {
        var _cachedGridList:IItemGridWindow;
        var _cachedScrollBar:IScrollbarWindow;
        var _autoHideScrollBar:Bool = true;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            this._scrollBar.scrollable = this._itemGrid;
            if (this._scrollBar.testStateFlag(WindowState.DISABLED))
            {
                this.hideScrollBar();
            }
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.SPACING, this.spacing));
            k.push(createProperty(PropertyKeys.AUTO_ARRANGE_ITEMS, this.autoArrangeItems));
            k.push(createProperty(PropertyKeys.SCALE_TO_FIT_ITEMS, this.scaleToFitItems));
            k.push(createProperty(PropertyKeys.RESIZE_ON_ITEM_UPDATE, this.resizeOnItemUpdate));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.SPACING:
                        this.spacing = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.SCALE_TO_FIT_ITEMS:
                        this.scaleToFitItems = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.RESIZE_ON_ITEM_UPDATE:
                        this.resizeOnItemUpdate = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.AUTO_ARRANGE_ITEMS:
                        this.autoArrangeItems = ASCompat.asBoolean(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }

        
        public var autoHideScrollBar(get,set):Bool;
public function  get_autoHideScrollBar():Bool
        {
            return this._autoHideScrollBar;
        }
public function  set_autoHideScrollBar(k:Bool):Bool        {
            this._autoHideScrollBar = k;
            this.updateScrollBarVisibility();
return k;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return this.isConstructionReady() ? this._itemGrid.iterator : null;
        }

        
        public var scrollH(get,set):Float;
public function  get_scrollH():Float
        {
            return this._itemGrid.scrollH;
        }
public function  set_scrollH(k:Float):Float        {
            return this._itemGrid.scrollH = k;
        }

        
        public var scrollV(get,set):Float;
public function  get_scrollV():Float
        {
            return this._itemGrid.scrollV;
        }
public function  set_scrollV(k:Float):Float        {
            return this._itemGrid.scrollV = k;
        }

        public var maxScrollH(get,never):Int;
public function  get_maxScrollH():Int
        {
            return this._itemGrid.maxScrollH;
        }

        public var maxScrollV(get,never):Int;
public function  get_maxScrollV():Int
        {
            return this._itemGrid.maxScrollV;
        }

        public var visibleRegion(get,never):Rectangle;
public function  get_visibleRegion():Rectangle
        {
            return this._itemGrid.visibleRegion;
        }

        public var scrollableRegion(get,never):Rectangle;
public function  get_scrollableRegion():Rectangle
        {
            return this._itemGrid.scrollableRegion;
        }

        
        public var scrollStepH(get,set):Float;
public function  get_scrollStepH():Float
        {
            return this._itemGrid.scrollStepH;
        }
public function  set_scrollStepH(k:Float):Float        {
            return this._itemGrid.scrollStepH = k;
        }

        
        public var scrollStepV(get,set):Float;
public function  get_scrollStepV():Float
        {
            return this._itemGrid.scrollStepV;
        }
public function  set_scrollStepV(k:Float):Float        {
            return this._itemGrid.scrollStepV = k;
        }

        
        public var autoArrangeItems(get,set):Bool;
public function  get_autoArrangeItems():Bool
        {
            return this._itemGrid.autoArrangeItems;
        }
public function  set_autoArrangeItems(k:Bool):Bool        {
            return this._itemGrid.autoArrangeItems = k;
        }

        public var numColumns(get,never):UInt;
public function  get_numColumns():UInt
        {
            return this._itemGrid.numColumns;
        }

        public var numRows(get,never):UInt;
public function  get_numRows():UInt
        {
            return this._itemGrid.numRows;
        }

        public var numGridItems(get,never):UInt;
public function  get_numGridItems():UInt
        {
            return this._itemGrid.numGridItems;
        }

        
        public var shouldRebuildGridOnResize(get,set):Bool;
public function  get_shouldRebuildGridOnResize():Bool
        {
            return this._itemGrid.shouldRebuildGridOnResize;
        }
public function  set_shouldRebuildGridOnResize(k:Bool):Bool        {
            return this._itemGrid.shouldRebuildGridOnResize = k;
        }

        
        public var spacing(get,set):Int;
public function  get_spacing():Int
        {
            return this._itemGrid.spacing;
        }
public function  set_spacing(k:Int):Int        {
            return this._itemGrid.spacing = k;
        }

        public var verticalSpacing(never,set):Int;
public function  set_verticalSpacing(k:Int):Int        {
            return this._itemGrid.verticalSpacing = k;
        }

        
        public var scaleToFitItems(get,set):Bool;
public function  get_scaleToFitItems():Bool
        {
            return this._itemGrid.scaleToFitItems;
        }
public function  set_scaleToFitItems(k:Bool):Bool        {
            return this._itemGrid.scaleToFitItems = k;
        }

        
        public var resizeOnItemUpdate(get,set):Bool;
public function  get_resizeOnItemUpdate():Bool
        {
            return this._itemGrid.resizeOnItemUpdate;
        }
public function  set_resizeOnItemUpdate(k:Bool):Bool        {
            return this._itemGrid.resizeOnItemUpdate = k;
        }

        
        public var containerResizeToColumns(get,set):Bool;
public function  set_containerResizeToColumns(k:Bool):Bool        {
return k;
        }
public function  get_containerResizeToColumns():Bool
        {
            return false;
        }

        var _itemGrid(get,never):IItemGridWindow;
function  get__itemGrid():IItemGridWindow
        {
            if (this._cachedGridList == null)
            {
                this._cachedGridList = Std.downcast(findChildByTag("_ITEMGRID") , IItemGridWindow);
            }
            return this._cachedGridList;
        }

        var _scrollBar(get,never):IScrollbarWindow;
function  get__scrollBar():IScrollbarWindow
        {
            if (this._cachedScrollBar == null)
            {
                this._cachedScrollBar = Std.downcast(findChildByTag("_SCROLLBAR") , IScrollbarWindow);
                if (this._cachedScrollBar != null)
                {
                    this._cachedScrollBar.addEventListener(WindowEvent.WINDOW_EVENT_ENABLED, this.scrollBarEventProc);
                    this._cachedScrollBar.addEventListener(WindowEvent.WINDOW_EVENT_DISABLED, this.scrollBarEventProc);
                }
            }
            return this._cachedScrollBar;
        }

        override public function dispose()
        {
            if (this._cachedScrollBar != null)
            {
                this._cachedScrollBar.removeEventListener(WindowEvent.WINDOW_EVENT_ENABLED, this.scrollBarEventProc);
                this._cachedScrollBar.removeEventListener(WindowEvent.WINDOW_EVENT_DISABLED, this.scrollBarEventProc);
                this._cachedScrollBar = null;
            }
            if (this._cachedGridList != null)
            {
                this._cachedGridList = null;
            }
            super.dispose();
        }

        public function addGridItem(k:IWindow):IWindow
        {
            return this._itemGrid.addGridItem(k);
        }

        public function addGridItemAt(k:IWindow, _arg_2:UInt):IWindow
        {
            return this._itemGrid.addGridItemAt(k, _arg_2);
        }

        public function getGridItemAt(k:UInt):IWindow
        {
            return this._itemGrid.getGridItemAt(k);
        }

        public function getGridItemByID(k:UInt):IWindow
        {
            return this._itemGrid.getGridItemByID(k);
        }

        public function getGridItemByName(k:String):IWindow
        {
            return this._itemGrid.getGridItemByName(k);
        }

        public function getGridItemByTag(k:String):IWindow
        {
            return this._itemGrid.getGridItemByTag(k);
        }

        public function getGridItemIndex(k:IWindow):Int
        {
            return this._itemGrid.getGridItemIndex(k);
        }

        public function removeGridItem(k:IWindow):IWindow
        {
            return this._itemGrid.removeGridItem(k);
        }

        public function removeGridItemAt(k:Int):IWindow
        {
            return this._itemGrid.removeGridItemAt(k);
        }

        public function setGridItemIndex(k:IWindow, _arg_2:Int)
        {
            this._itemGrid.setGridItemIndex(k, _arg_2);
        }

        public function swapGridItems(k:IWindow, _arg_2:IWindow)
        {
            this._itemGrid.swapGridItems(k, _arg_2);
        }

        public function swapGridItemsAt(k:Int, _arg_2:Int)
        {
            this._itemGrid.swapGridItemsAt(k, _arg_2);
        }

        public function removeGridItems()
        {
            this._itemGrid.removeGridItems();
        }

        public function destroyGridItems()
        {
            this._itemGrid.destroyGridItems();
        }

        public function rebuildGridStructure()
        {
            this._itemGrid.rebuildGridStructure();
        }

        function isConstructionReady():Bool
        {
            return (this._itemGrid != null) && (this._scrollBar != null);
        }

        function scrollBarEventProc(k:WindowEvent)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_ENABLED)
            {
                this.showScrollBar();
            }
            else
            {
                if (k.type == WindowEvent.WINDOW_EVENT_DISABLED)
                {
                    this.hideScrollBar();
                }
            }
        }

        function hideScrollBar()
        {
            if (this._scrollBar.visible)
            {
                this._scrollBar.visible = false;
            }
        }

        function showScrollBar()
        {
            if (!this._scrollBar.visible)
            {
                this._scrollBar.visible = true;
            }
        }

        function updateScrollBarVisibility()
        {
            if (this._autoHideScrollBar)
            {
                if (this._scrollBar.testStateFlag(WindowState.DISABLED))
                {
                    if (this._scrollBar.visible)
                    {
                        this.hideScrollBar();
                    }
                }
            }
            else
            {
                if (this._scrollBar.visible)
                {
                    this.showScrollBar();
                }
            }
        }
    }

