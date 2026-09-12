package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.IWindow;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.sulake.core.assets.BitmapDataAsset;

     class SeperatorWidget implements _Str_16365 
    {
        public static inline final SEPARATOR= "separator";
        static final _Str_15525:String = (SEPARATOR + ":vertical");
        static final _Str_15640:PropertyStruct = new PropertyStruct(_Str_15525, false, PropertyStruct.BOOLEAN);
        static inline final ILLUMINA_LIGHT_SEPARATOR_HORIZONTAL= "illumina_light_separator_horizontal";
        static inline final ILLUMINA_LIGHT_SEPARATOR_VERTICAL= "illumina_light_separator_vertical";

        var _disposed:Bool = false;
        var _Str_2326:IWidgetWindow;
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _Str_1868:IBitmapWrapperWindow;
        var _Str_2903:BitmapData;
        var _children:IWindowContainer;
        var _vertical:Bool = false;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._vertical = ASCompat.toBool(_Str_15640.value);
            this._Str_2326 = k;
            this._habboWindowManagerComponent = _arg_2;
            this._root = Std.downcast(this._habboWindowManagerComponent.buildFromXML(((this._habboWindowManagerComponent.assets.getAssetByName("separator_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._Str_1868 = Std.downcast(this._root.getChildByName("canvas") , IBitmapWrapperWindow);
            this._children = Std.downcast(this._root.getChildByName("children") , IWindowContainer);
            this._Str_1868.addEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
            this._Str_1868.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_ADDED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_REMOVED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this._Str_2832);
            this._Str_2326.rootWindow = this._root;
            this._root.width = this._Str_2326.width;
            this._root.height = this._Str_2326.height;
        }

        function _Str_2832(k:WindowEvent)
        {
            this.refresh();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._Str_2903 != null)
                {
                    this._Str_2903.dispose();
                    this._Str_2903 = null;
                }
                if (this._Str_1868 != null)
                {
                    this._Str_1868.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
                    this._Str_1868.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
                    this._Str_1868 = null;
                }
                if (this._children != null)
                {
                    this._children.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_ADDED, this._Str_2832);
                    this._children.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_REMOVED, this._Str_2832);
                    this._children.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this._Str_2832);
                    this._children.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this._Str_2832);
                    this._children = null;
                }
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._Str_2326 != null)
                {
                    this._Str_2326.rootWindow = null;
                    this._Str_2326 = null;
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

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return this._children.iterator;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_15640.withValue(this._vertical));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (this._disposed)
            {
                return k;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case _Str_15525:
                        this.vertical = ASCompat.toBool(_local_2.value);
                        
                }
            }
return k;
        }

        
        public var vertical(get,set):Bool;
public function  get_vertical():Bool
        {
            return this._vertical;
        }
public function  set_vertical(k:Bool):Bool        {
            this._vertical = k;
            this.refresh();
return k;
        }

        function refresh()
        {
            var _local_2:IWindow = null;
            var _local_3:BitmapData = null;
            var _local_4:Point = null;
            if (this._disposed)
            {
                return;
            }
            if ((((this._Str_2903 == null) || (!(this._Str_2903.width == this._Str_1868.width))) || (!(this._Str_2903.height == this._Str_1868.height))))
            {
                if (this._Str_2903 != null)
                {
                    this._Str_2903.dispose();
                }
                this._Str_2903 = new BitmapData(Std.int(Math.max(1, this._Str_1868.width)), Std.int(Math.max(1, this._Str_1868.height)), true, 0);
                this._Str_1868.bitmap = this._Str_2903;
            }
            this._Str_2903.lock();
            this._Str_2903.fillRect(new Rectangle(0, 0, this._Str_1868.width, this._Str_1868.height), 0);
            var k= Std.downcast(this._habboWindowManagerComponent.assets.getAssetByName((this._vertical ? ILLUMINA_LIGHT_SEPARATOR_VERTICAL : ILLUMINA_LIGHT_SEPARATOR_HORIZONTAL)) , BitmapDataAsset);
            if (k != null)
            {
                _local_3 = ASCompat.dynamicAs(k.content , BitmapData);
                if (this._vertical)
                {
                    _local_4 = new Point(((this._Str_1868.width / 2) - 1), 0);
                    while (_local_4.y < this._Str_1868.height)
                    {
                        this._Str_2903.copyPixels(_local_3, k.rectangle, _local_4);
                        _local_4.y = (_local_4.y + k.rectangle.height);
                    }
                }
                else
                {
                    _local_4 = new Point(0, ((this._Str_1868.height / 2) - 1));
                    while (_local_4.x < this._Str_1868.width)
                    {
                        this._Str_2903.copyPixels(_local_3, k.rectangle, _local_4);
                        _local_4.x = (_local_4.x + k.rectangle.width);
                    }
                }
            }
            final _iter_ = this._children.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
            {
_local_2  = _tmp_;
                if (_local_2.visible)
                {
                    this._Str_2903.fillRect(_local_2.rectangle, 0);
                }
            }
            this._Str_2903.unlock();
            this._Str_1868.invalidate();
        }
    }




