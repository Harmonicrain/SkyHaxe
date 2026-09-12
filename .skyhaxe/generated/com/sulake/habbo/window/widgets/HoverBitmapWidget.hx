package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.theme.PropertyKeys;

     class HoverBitmapWidget implements _Str_14236 
    {
        public static inline final HOVER_BITMAP= "hover_bitmap";
        static final hoverAssetPropertyKey:String = (HOVER_BITMAP + ":hover_asset");
        static final normalAssetPropertyKey:String = (HOVER_BITMAP + ":normal_asset");
        static final _Str_16062:PropertyStruct = new PropertyStruct(hoverAssetPropertyKey, null, PropertyStruct.STRING);
        static final _Str_16371:PropertyStruct = new PropertyStruct(normalAssetPropertyKey, null, PropertyStruct.STRING);

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _bitmap:IStaticBitmapWrapperWindow;
        var _normalAsset:String;
        var _hoverAsset:String;
        var _isMouseOver:Bool = false;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._bitmap = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("hover_bitmap_xml").content : com.sulake.core.utils.xml.XML) )) , IStaticBitmapWrapperWindow);
            this._bitmap.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
            this._bitmap.addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
            this._widgetWindow.rootWindow = this._bitmap;
            this._bitmap.width = this._widgetWindow.width;
            this._bitmap.height = this._widgetWindow.height;
            this._bitmap.invalidate();
        }

        function onMouseOver(k:WindowMouseEvent)
        {
            this._isMouseOver = true;
            this._bitmap.assetUri = this._hoverAsset;
        }

        function onMouseOut(k:WindowMouseEvent)
        {
            this._isMouseOver = false;
            this._bitmap.assetUri = this._normalAsset;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._bitmap != null)
                {
                    this._bitmap.dispose();
                    this._bitmap = null;
                }
                this._widgetWindow.rootWindow = null;
                this._widgetWindow = null;
                this._windowManager = null;
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
            var _local_2:PropertyStruct = null;
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_16371.withValue(this._normalAsset));
            k.push(_Str_16062.withValue(this._hoverAsset));
            if (this._bitmap != null)
            {
                final _iter_ = this._bitmap.properties; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.key != PropertyKeys.ASSET_URI)
                    {
                        k.push(_local_2);
                    }
                }
            }
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
                    case normalAssetPropertyKey:
                        this._Str_13459 = ASCompat.toString(_local_2.value);
                        
                    case hoverAssetPropertyKey:
                        this._Str_15575 = ASCompat.toString(_local_2.value);
                        
                }
            }
            if (this._bitmap != null)
            {
                this._bitmap.properties = k;
                this._bitmap.invalidate();
            }
return k;
        }

        
        public var _Str_13459(get,set):String;
public function  get__Str_13459():String
        {
            return this._normalAsset;
        }
public function  set__Str_13459(k:String):String        {
            this._normalAsset = k;
            if (!this._isMouseOver)
            {
                this._bitmap.assetUri = this._normalAsset;
            }
return k;
        }

        
        public var _Str_15575(get,set):String;
public function  get__Str_15575():String
        {
            return this._hoverAsset;
        }
public function  set__Str_15575(k:String):String        {
            this._hoverAsset = k;
            if (this._isMouseOver)
            {
                this._bitmap.assetUri = this._hoverAsset;
            }
return k;
        }

        public var _Str_24603(get,never):IStaticBitmapWrapperWindow;
public function  get__Str_24603():IStaticBitmapWrapperWindow
        {
            return this._bitmap;
        }
    }


