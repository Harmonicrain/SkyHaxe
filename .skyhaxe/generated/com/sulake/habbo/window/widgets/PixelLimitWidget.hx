package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.theme.PropertyKeys;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class PixelLimitWidget implements _Str_17266 
    {
        public static inline final PIXEL_LIMIT= "pixel_limit";
        static final limitPropertyKey:String = (PIXEL_LIMIT + ":limit");
        static final _Str_12653:PropertyStruct = new PropertyStruct(limitPropertyKey, 0, PropertyStruct.STRING, false, null);

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _refreshing:Bool = false;
        var _root:IWindowContainer;
        var _bitmap:IStaticBitmapWrapperWindow;
        var _region:IRegionWindow;
        var _limit:Int = 0;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._limit = ASCompat.toInt(_Str_12653.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("badge_image_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._bitmap = Std.downcast(this._root.findChildByName("bitmap") , IStaticBitmapWrapperWindow);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
        }

        
        public var limit(get,set):Int;
public function  get_limit():Int
        {
            return this._limit;
        }
public function  set_limit(k:Int):Int        {
            this._limit = Std.int(Math.max(0, Math.min(100, k)));
            this.refresh();
return k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._region != null)
                {
                    this._region.removeEventListener(WindowMouseEvent.CLICK, this.onClick);
                    this._region.dispose();
                    this._region = null;
                }
                this._bitmap = null;
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
            var _local_2:PropertyStruct = null;
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_12653.withValue(this._limit));
            final _iter_ = this._bitmap.properties; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.key != PropertyKeys.ASSET_URI)
                {
                    k.push(_local_2.withNameSpace(PIXEL_LIMIT));
                }
            }
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_3:PropertyStruct = null;
            this._refreshing = true;
            var _local_2:Array<ASAny> = [];
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                switch (_local_3.key)
                {
                    case limitPropertyKey:
                        this.limit = ASCompat.toInt(_local_3.value);
                        
                }
                if (_local_3.key != ((PIXEL_LIMIT + ":") + PropertyKeys.ASSET_URI))
                {
                    _local_2.push(_local_3.withoutNameSpace());
                }
            }
            this._bitmap.properties = _local_2;
            this._refreshing = false;
            this.refresh();
return k;
        }

        function refresh()
        {
            if (this._refreshing)
            {
                return;
            }
            this._bitmap.assetUri = this.assetUri;
            this._bitmap.invalidate();
        }

        var assetUri(get,never):String;
function  get_assetUri():String
        {
            var k:String = null;
            var _local_2= Std.int(Math.ffloor((this._limit / 20)) * 20);
            _local_2 = Std.int(Math.max(_local_2, 20));
            k = "${image.library.url}reception/challenge_meter_%amount%.png";
            k = ASCompat.stringReplace(k, "%amount%", Std.string(_local_2));
            return k;
        }

        function onClick(k:WindowMouseEvent)
        {
        }

        public var bitmapData(get,never):BitmapData;
public function  get_bitmapData():BitmapData
        {
            return this._bitmap.bitmapData;
        }

        
        public var pivotPoint(get,set):UInt;
public function  get_pivotPoint():UInt
        {
            return this._bitmap.pivotPoint;
        }
public function  set_pivotPoint(k:UInt):UInt        {
            this._bitmap.pivotPoint = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var stretchedX(get,set):Bool;
public function  get_stretchedX():Bool
        {
            return this._bitmap.stretchedX;
        }
public function  set_stretchedX(k:Bool):Bool        {
            this._bitmap.stretchedX = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var stretchedY(get,set):Bool;
public function  get_stretchedY():Bool
        {
            return this._bitmap.stretchedY;
        }
public function  set_stretchedY(k:Bool):Bool        {
            this._bitmap.stretchedY = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var zoomX(get,set):Float;
public function  get_zoomX():Float
        {
            return this._bitmap.zoomX;
        }
public function  set_zoomX(k:Float):Float        {
            this._bitmap.zoomX = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var zoomY(get,set):Float;
public function  get_zoomY():Float
        {
            return this._bitmap.zoomY;
        }
public function  set_zoomY(k:Float):Float        {
            this._bitmap.zoomY = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var greyscale(get,set):Bool;
public function  get_greyscale():Bool
        {
            return this._bitmap.greyscale;
        }
public function  set_greyscale(k:Bool):Bool        {
            this._bitmap.greyscale = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var etchingColor(get,set):UInt;
public function  get_etchingColor():UInt
        {
            return this._bitmap.etchingColor;
        }
public function  set_etchingColor(k:UInt):UInt        {
            this._bitmap.etchingColor = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var fitSizeToContents(get,set):Bool;
public function  get_fitSizeToContents():Bool
        {
            return this._bitmap.fitSizeToContents;
        }
public function  set_fitSizeToContents(k:Bool):Bool        {
            this._bitmap.fitSizeToContents = k;
            this._bitmap.invalidate();
return k;
        }

        public var etchingPoint(get,never):Point;
public function  get_etchingPoint():Point
        {
            return new Point(0, 1);
        }

        
        public var wrapX(get,set):Bool;
public function  get_wrapX():Bool
        {
            return false;
        }
public function  set_wrapX(k:Bool):Bool        {
return k;
        }

        
        public var wrapY(get,set):Bool;
public function  get_wrapY():Bool
        {
            return false;
        }
public function  set_wrapY(k:Bool):Bool        {
return k;
        }
    }




