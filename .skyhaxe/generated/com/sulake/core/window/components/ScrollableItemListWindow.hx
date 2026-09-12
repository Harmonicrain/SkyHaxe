package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class ScrollableItemListWindow extends WindowController implements IScrollableListWindow 
    {
        var _cachedItemList:IItemListWindow;
        var _cachedScrollBar:IScrollbarWindow;
        var _autoHideScrollBar:Bool = true;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            this._scrollBar.scrollable = this._itemList;
            if ((this._scrollBar.testStateFlag(WindowState.DISABLED) && this._autoHideScrollBar))
            {
                this.hideScrollBar();
            }
        }

        override public function dispose()
        {
            if (this._cachedScrollBar != null)
            {
                this._cachedScrollBar.removeEventListener(WindowEvent.WINDOW_EVENT_ENABLED, this.scrollBarEventProc);
                this._cachedScrollBar.removeEventListener(WindowEvent.WINDOW_EVENT_DISABLED, this.scrollBarEventProc);
                this._cachedScrollBar = null;
            }
            if (this._cachedItemList != null)
            {
                this._cachedItemList = null;
            }
            super.dispose();
        }

        var _itemList(get,never):IItemListWindow;
function  get__itemList():IItemListWindow
        {
            if (this._cachedItemList == null)
            {
                this._cachedItemList = Std.downcast(findChildByTag("_ITEMLIST") , IItemListWindow);
            }
            return this._cachedItemList;
        }

        public function scrollWithWheel(k:Float, _arg_2:Bool):Bool
        {
            return this._itemList.scrollWithWheel(k, _arg_2);
        }

        public var scrollableWindow(get,never):IWindow;
public function  get_scrollableWindow():IWindow
        {
            return this._itemList;
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

        function scrollBarEventProc(k:WindowEvent)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_ENABLED)
            {
                this.showScrollBar();
            }
            else
            {
                if (((k.type == WindowEvent.WINDOW_EVENT_DISABLED) && this._autoHideScrollBar))
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
                this._itemList.width = _w;
            }
        }

        function showScrollBar()
        {
            if (!this._scrollBar.visible)
            {
                this._scrollBar.visible = true;
                this._itemList.width = (_w - this._scrollBar.width);
            }
        }

        function updateScrollBarVisibility(k:Bool=false)
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
                if ((k || this._scrollBar.visible))
                {
                    this.showScrollBar();
                }
            }
        }

        function isConstructionReady():Bool
        {
            return (this._itemList != null) && (this._scrollBar != null);
        }

        
        public var autoHideScrollBar(get,set):Bool;
public function  set_autoHideScrollBar(k:Bool):Bool        {
            this._autoHideScrollBar = k;
            this.updateScrollBarVisibility(true);
return k;
        }
public function  get_autoHideScrollBar():Bool
        {
            return this._autoHideScrollBar;
        }

        public var isScrollBarVisible(get,never):Bool;
public function  get_isScrollBarVisible():Bool
        {
            return (this._scrollBar != null) && this._scrollBar.visible;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return this.isConstructionReady() ? this._itemList.iterator : null;
        }

        
        public var scrollH(get,set):Float;
public function  get_scrollH():Float
        {
            return this._itemList.scrollH;
        }

        
        public var scrollV(get,set):Float;
public function  get_scrollV():Float
        {
            return this._itemList.scrollV;
        }
public function  set_scrollH(k:Float):Float        {
            return this._itemList.scrollH = k;
        }
public function  set_scrollV(k:Float):Float        {
            return this._itemList.scrollV = k;
        }

        public var maxScrollH(get,never):Int;
public function  get_maxScrollH():Int
        {
            return this._itemList.maxScrollH;
        }

        public var maxScrollV(get,never):Int;
public function  get_maxScrollV():Int
        {
            return this._itemList.maxScrollV;
        }

        public var visibleRegion(get,never):Rectangle;
public function  get_visibleRegion():Rectangle
        {
            return this._itemList.visibleRegion;
        }

        public var scrollableRegion(get,never):Rectangle;
public function  get_scrollableRegion():Rectangle
        {
            return this._itemList.scrollableRegion;
        }

        
        public var scrollStepH(get,set):Float;
public function  get_scrollStepH():Float
        {
            return this._itemList.scrollStepH;
        }

        
        public var scrollStepV(get,set):Float;
public function  get_scrollStepV():Float
        {
            return this._itemList.scrollStepV;
        }
public function  set_scrollStepH(k:Float):Float        {
            return this._itemList.scrollStepH = k;
        }
public function  set_scrollStepV(k:Float):Float        {
            return this._itemList.scrollStepV = k;
        }

        
        public var spacing(get,set):Int;
public function  get_spacing():Int
        {
            return this._itemList.spacing;
        }
public function  set_spacing(k:Int):Int        {
            return this._itemList.spacing = k;
        }

        
        public var scaleToFitItems(get,set):Bool;
public function  get_scaleToFitItems():Bool
        {
            return this._itemList.scaleToFitItems;
        }
public function  set_scaleToFitItems(k:Bool):Bool        {
            return this._itemList.scaleToFitItems = k;
        }

        
        public var autoArrangeItems(get,set):Bool;
public function  get_autoArrangeItems():Bool
        {
            return this._itemList.autoArrangeItems;
        }
public function  set_autoArrangeItems(k:Bool):Bool        {
            return this._itemList.autoArrangeItems = k;
        }

        
        public var resizeOnItemUpdate(get,set):Bool;
public function  set_resizeOnItemUpdate(k:Bool):Bool        {
            return this._itemList.resizeOnItemUpdate = k;
        }
public function  get_resizeOnItemUpdate():Bool
        {
            return this._itemList.resizeOnItemUpdate;
        }

        public var numListItems(get,never):Int;
public function  get_numListItems():Int
        {
            return this._itemList.numListItems;
        }

        public function addListItem(k:IWindow):IWindow
        {
            return this._itemList.addListItem(k);
        }

        public function addListItemAt(k:IWindow, _arg_2:UInt):IWindow
        {
            return this._itemList.addListItemAt(k, _arg_2);
        }

        public function getListItemAt(k:UInt):IWindow
        {
            return this._itemList.getListItemAt(k);
        }

        public function getListItemByID(k:UInt):IWindow
        {
            return this._itemList.getListItemByID(k);
        }

        public function getListItemByName(k:String):IWindow
        {
            return this._itemList.getListItemByName(k);
        }

        public function getListItemByTag(k:String):IWindow
        {
            return this._itemList.getListItemByTag(k);
        }

        public function getListItemIndex(k:IWindow):Int
        {
            return this._itemList.getListItemIndex(k);
        }

        public function removeListItem(k:IWindow):IWindow
        {
            return this._itemList.removeListItem(k);
        }

        public function removeListItemAt(k:Int):IWindow
        {
            return this._itemList.removeListItemAt(k);
        }

        public function setListItemIndex(k:IWindow, _arg_2:Int)
        {
            this._itemList.setListItemIndex(k, _arg_2);
        }

        public function swapListItems(k:IWindow, _arg_2:IWindow)
        {
            this._itemList.swapListItems(k, _arg_2);
        }

        public function swapListItemsAt(k:Int, _arg_2:Int)
        {
            this._itemList.swapListItemsAt(k, _arg_2);
        }

        public function groupListItemsWithID(k:UInt, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            return this._itemList.groupListItemsWithID(k, _arg_2, _arg_3);
        }

        public function groupListItemsWithTag(k:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            return this._itemList.groupListItemsWithTag(k, _arg_2, _arg_3);
        }

        public function removeListItems()
        {
            this._itemList.removeListItems();
        }

        public function destroyListItems()
        {
            this._itemList.destroyListItems();
        }

        public function arrangeListItems()
        {
            this._itemList.arrangeListItems();
        }

        public function stopDragging()
        {
            this._itemList.stopDragging();
        }

        public var disableAutodrag(never,set):Bool;
public function  set_disableAutodrag(k:Bool):Bool        {
            return this._itemList.disableAutodrag = k;
        }

        
        public var isPartOfGridWindow(get,set):Bool;
public function  get_isPartOfGridWindow():Bool
        {
            return this._itemList.isPartOfGridWindow;
        }
public function  set_isPartOfGridWindow(k:Bool):Bool        {
            return this._itemList.disableAutodrag = k;
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
    }

