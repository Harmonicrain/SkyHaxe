package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.window._enum._Str_10992;
    import com.sulake.habbo.window._enum._Str_7639;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.display.BitmapData;

     class ProgressIndicatorWidget implements _Str_4466 
    {
        public static inline final PROGRESS_INDICATOR= "progress_indicator";
        static final stylePropertyKey:String = (PROGRESS_INDICATOR + ":style");
        static final sizePropertyKey:String = (PROGRESS_INDICATOR + ":size");
        static final positionPropertyKey:String = (PROGRESS_INDICATOR + ":position");
        static final modePropertyKey:String = (PROGRESS_INDICATOR + ":mode");
        static final _Str_13010:PropertyStruct = new PropertyStruct(stylePropertyKey, _Str_10992.FLAT, PropertyStruct.STRING, false, _Str_10992.ALL);
        static final _Str_19001:PropertyStruct = new PropertyStruct(sizePropertyKey, 1, PropertyStruct.UINT);
        static final _Str_13575:PropertyStruct = new PropertyStruct(positionPropertyKey, 0, PropertyStruct.UINT);
        static final _Str_12527:PropertyStruct = new PropertyStruct(modePropertyKey, _Str_7639.POSITION, PropertyStruct.STRING, false, _Str_7639.ALL);
        static inline final _Str_18224:UInt = 1000;

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IItemListWindow;
        var _position:UInt = 0;
        var _style:String;
        var _mode:String;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._position = ASCompat.toUInt(_Str_13575.value);
            this._style = ASCompat.toString(_Str_13010.value);
            this._mode = ASCompat.toString(_Str_12527.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("progress_indicator_xml").content : com.sulake.core.utils.xml.XML) )) , IItemListWindow);
            this._widgetWindow.setParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN);
            this._widgetWindow.rootWindow = this._root;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._windowManager = null;
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
            return EmptyIterator.INSTANCE;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_13010.withValue(this._style));
            k.push(_Str_19001.withValue(this.size));
            k.push(_Str_13575.withValue(this._position));
            k.push(_Str_12527.withValue(this._mode));
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
                    case stylePropertyKey:
                        this.style = ASCompat.toString(_local_2.value);
                        
                    case sizePropertyKey:
                        this.size = ASCompat.toUInt(_local_2.value);
                        
                    case positionPropertyKey:
                        this.position = ASCompat.toUInt(_local_2.value);
                        
                    case modePropertyKey:
                        this.mode = ASCompat.toString(_local_2.value);
                        
                }
            }
return k;
        }

        
        public var style(get,set):String;
public function  get_style():String
        {
            return this._style;
        }
public function  set_style(k:String):String        {
            this._style = k;
            this.refresh();
return k;
        }

        
        public var size(get,set):UInt;
public function  get_size():UInt
        {
            return this._root.numListItems;
        }
public function  set_size(k:UInt):UInt        {
            k = Std.int(Math.min(Math.max(k, 1), _Str_18224));
            if (k != this.size)
            {
                while (k < this.size)
                {
                    this._root.removeListItemAt(ASCompat.toInt(this.size - 1));
                }
                while (k > this.size)
                {
                    this._root.addListItem(this._root.getListItemAt(0).clone());
                }
                this.refresh();
            }
return k;
        }

        
        public var position(get,set):UInt;
public function  get_position():UInt
        {
            return this._position;
        }
public function  set_position(k:UInt):UInt        {
            this._position = k;
            this.refresh();
return k;
        }

        
        public var mode(get,set):String;
public function  get_mode():String
        {
            return this._mode;
        }
public function  set_mode(k:String):String        {
            this._mode = k;
            this.refresh();
return k;
        }

        function refresh()
        {
            var _local_2:IStaticBitmapWrapperWindow = null;
            var _local_3 = false;
            var _local_4:BitmapData = null;
            var k = 0;
            while ((k : UInt) < this.size)
            {
                _local_2 = Std.downcast(this._root.getListItemAt(k) , IStaticBitmapWrapperWindow);
                switch (this._mode)
                {
                    case _Str_7639.POSITION:
                        _local_3 = (((k + 1) : UInt) == this.position);
                        
                    case _Str_7639.PROGRESS:
                        _local_3 = ((k : UInt) < this.position);
                        
                }
                _local_2.assetUri = (("progress_disk_" + this._style) + (_local_3 ? "_on" : "_off"));
                _local_4 = _local_2.bitmapData;
                _local_2.width = _local_4.width;
                _local_2.height = _local_4.height;
                this._root.height = _local_4.height;
                k++;
            }
        }
    }

