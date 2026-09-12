package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import flash.geom.Matrix;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.IWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window._enum.WindowParam;

     class IlluminaBorderWidget implements _Str_16637 
    {
        public static inline final ILLUMINA_BORDER= "illumina_border";
        public static inline final ILLUMINA_LIGHT= "illumina_light";
        public static inline final ILLUMINA_DARK= "illumina_dark";
        public static final _Str_14195:Array<ASAny> = [ILLUMINA_LIGHT, ILLUMINA_DARK];
        public static final _Str_7804:String = (ILLUMINA_BORDER + ":border_style");
        static final _Str_13768:String = (ILLUMINA_BORDER + ":content_child");
        static final _Str_14622:String = (ILLUMINA_BORDER + ":content_padding");
        static final _Str_13118:String = (ILLUMINA_BORDER + ":side_padding");
        static final _Str_13917:String = (ILLUMINA_BORDER + ":child_margin");
        static final _Str_14392:String = (ILLUMINA_BORDER + ":top_left_child");
        static final _Str_14956:String = (ILLUMINA_BORDER + ":top_center_child");
        static final _Str_14239:String = (ILLUMINA_BORDER + ":top_right_child");
        static final _Str_15641:String = (ILLUMINA_BORDER + ":bottom_left_child");
        static final _Str_15636:String = (ILLUMINA_BORDER + ":bottom_center_child");
        static final _Str_13835:String = (ILLUMINA_BORDER + ":bottom_right_child");
        static final _Str_13958:String = (ILLUMINA_BORDER + ":landing_view_mode");
        static final _Str_13216:PropertyStruct = new PropertyStruct(_Str_13768, "", PropertyStruct.STRING);
        static final _Str_13095:PropertyStruct = new PropertyStruct(_Str_14622, 5, PropertyStruct.UINT);
        static final _Str_12566:PropertyStruct = new PropertyStruct(_Str_13118, 15, PropertyStruct.UINT);
        static final _Str_15722:PropertyStruct = new PropertyStruct(_Str_13917, 3, PropertyStruct.UINT);
        static final _Str_14919:PropertyStruct = new PropertyStruct(_Str_14392, "", PropertyStruct.STRING);
        static final _Str_15429:PropertyStruct = new PropertyStruct(_Str_14956, "", PropertyStruct.STRING);
        static final _Str_15053:PropertyStruct = new PropertyStruct(_Str_14239, "", PropertyStruct.STRING);
        static final _Str_15265:PropertyStruct = new PropertyStruct(_Str_15641, "", PropertyStruct.STRING);
        static final _Str_14659:PropertyStruct = new PropertyStruct(_Str_15636, "", PropertyStruct.STRING);
        static final _Str_13511:PropertyStruct = new PropertyStruct(_Str_13835, "", PropertyStruct.STRING);
        static final _Str_15456:PropertyStruct = new PropertyStruct(_Str_13958, false, PropertyStruct.BOOLEAN);
        static final _Str_3559:Matrix = new Matrix();
        static inline final TOP_LEFT= "top_left";
        static inline final TOP= "top_center";
        static inline final TOP_RIGHT= "top_right";
        static inline final RIGHT= "center_right";
        static inline final BOTTOM_RIGHT= "bottom_right";
        static inline final BOTTOM= "bottom_center";
        static inline final BOTTOM_LEFT= "bottom_left";
        static inline final LEFT= "center_left";
        static final _Str_18608:Array<ASAny> = [TOP_LEFT, TOP, TOP_RIGHT, RIGHT, BOTTOM_RIGHT, BOTTOM, BOTTOM_LEFT, LEFT];

        var _borderPieces:ASDictionary<ASAny,ASAny>;
        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _canvas:IBitmapWrapperWindow;
        var _drawBuffer:BitmapData;
        var _children:IWindowContainer;
        var _settingProperties:Bool = false;
        var _resizingWidget:Bool = false;
        var _borderStyle:String;
        var _contentChild:String;
        var _contentPadding:UInt = 0;
        var _sidePadding:UInt = 0;
        var _childMargin:UInt = 0;
        var _topLeftChild:String;
        var _topCenterChild:String;
        var _topRightChild:String;
        var _bottomLeftChild:String;
        var _bottomCenterChild:String;
        var _bottomRightChild:String;
        var _landingViewMode:Bool = false;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._contentChild = ASCompat.toString(_Str_13216.value);
            this._contentPadding = ASCompat.toUInt(_Str_13095.value);
            this._sidePadding = ASCompat.toUInt(_Str_12566.value);
            this._childMargin = ASCompat.toUInt(_Str_15722.value);
            this._topLeftChild = ASCompat.toString(_Str_14919.value);
            this._topCenterChild = ASCompat.toString(_Str_15429.value);
            this._topRightChild = ASCompat.toString(_Str_15053.value);
            this._bottomLeftChild = ASCompat.toString(_Str_15265.value);
            this._bottomCenterChild = ASCompat.toString(_Str_14659.value);
            this._bottomRightChild = ASCompat.toString(_Str_13511.value);
            this._landingViewMode = ASCompat.toBool(_Str_15456.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("illumina_border_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._canvas = Std.downcast(this._root.getChildByName("canvas") , IBitmapWrapperWindow);
            this._children = Std.downcast(this._root.getChildByName("children") , IWindowContainer);
            this._Str_10365 = ASCompat.toString(this._widgetWindow.getDefaultProperty(_Str_7804).value);
            this._widgetWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
            this._widgetWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_ADDED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_REMOVED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this._Str_2832);
            this._children.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this._Str_2832);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
        }

        function _Str_2832(k:WindowEvent)
        {
            this.refresh();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._drawBuffer != null)
                {
                    this._drawBuffer.dispose();
                    this._drawBuffer = null;
                }
                if (this._canvas != null)
                {
                    this._canvas.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZE, this._Str_2832);
                    this._canvas.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_2832);
                    this._canvas = null;
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
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._borderPieces = null;
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
            k.push(this._widgetWindow.createProperty(_Str_7804, this._borderStyle));
            k.push(_Str_13216.withValue(this._contentChild));
            k.push(_Str_13095.withValue(this._contentPadding));
            k.push(_Str_12566.withValue(this._sidePadding));
            k.push(_Str_15722.withValue(this._childMargin));
            k.push(_Str_14919.withValue(this._topLeftChild));
            k.push(_Str_15429.withValue(this._topCenterChild));
            k.push(_Str_15053.withValue(this._topRightChild));
            k.push(_Str_15265.withValue(this._bottomLeftChild));
            k.push(_Str_14659.withValue(this._bottomCenterChild));
            k.push(_Str_13511.withValue(this._bottomRightChild));
            k.push(_Str_15456.withValue(this._landingViewMode));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (this._disposed)
            {
                return k;
            }
            this._settingProperties = true;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case _Str_7804:
                        this._Str_10365 = ASCompat.toString(_local_2.value);
                        
                    case _Str_13768:
                        this._Str_14667 = ASCompat.toString(_local_2.value);
                        
                    case _Str_14622:
                        this._Str_8790 = ASCompat.toUInt(_local_2.value);
                        
                    case _Str_13118:
                        this._Str_12661 = ASCompat.toUInt(_local_2.value);
                        
                    case _Str_13917:
                        this._Str_12578 = ASCompat.toUInt(_local_2.value);
                        
                    case _Str_14392:
                        this._Str_14320 = ASCompat.toString(_local_2.value);
                        
                    case _Str_14956:
                        this._Str_13313 = ASCompat.toString(_local_2.value);
                        
                    case _Str_14239:
                        this._Str_13654 = ASCompat.toString(_local_2.value);
                        
                    case _Str_15641:
                        this._Str_15704 = ASCompat.toString(_local_2.value);
                        
                    case _Str_15636:
                        this._Str_15773 = ASCompat.toString(_local_2.value);
                        
                    case _Str_13835:
                        this._Str_12912 = ASCompat.toString(_local_2.value);
                        
                    case _Str_13958:
                        this._Str_15124 = ASCompat.toBool(_local_2.value);
                        
                }
            }
            this._settingProperties = false;
            this.refresh();
return k;
        }

        
        public var _Str_10365(get,set):String;
public function  get__Str_10365():String
        {
            return this._borderStyle;
        }
public function  set__Str_10365(k:String):String        {
            var _local_2:String = null;
            this._borderStyle = k;
            this._borderPieces = new ASDictionary<ASAny,ASAny>();
            final _iter_ = _Str_18608; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._borderPieces[_local_2] = this._windowManager.assets.getAssetByName(((this._borderStyle + "_border_") + _local_2));
            }
            this.refresh();
return k;
        }

        
        public var _Str_14667(get,set):String;
public function  get__Str_14667():String
        {
            return this._contentChild;
        }
public function  set__Str_14667(k:String):String        {
            this._contentChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_8790(get,set):UInt;
public function  get__Str_8790():UInt
        {
            return this._contentPadding;
        }
public function  set__Str_8790(k:UInt):UInt        {
            this._contentPadding = k;
            this.refresh();
return k;
        }

        
        public var _Str_12661(get,set):UInt;
public function  get__Str_12661():UInt
        {
            return this._sidePadding;
        }
public function  set__Str_12661(k:UInt):UInt        {
            this._sidePadding = k;
            this.refresh();
return k;
        }

        
        public var _Str_12578(get,set):UInt;
public function  get__Str_12578():UInt
        {
            return this._childMargin;
        }
public function  set__Str_12578(k:UInt):UInt        {
            this._childMargin = k;
            this.refresh();
return k;
        }

        
        public var _Str_14320(get,set):String;
public function  get__Str_14320():String
        {
            return this._topLeftChild;
        }
public function  set__Str_14320(k:String):String        {
            this._topLeftChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_13313(get,set):String;
public function  get__Str_13313():String
        {
            return this._topCenterChild;
        }
public function  set__Str_13313(k:String):String        {
            this._topCenterChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_13654(get,set):String;
public function  get__Str_13654():String
        {
            return this._topRightChild;
        }
public function  set__Str_13654(k:String):String        {
            this._topRightChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_15704(get,set):String;
public function  get__Str_15704():String
        {
            return this._bottomLeftChild;
        }
public function  set__Str_15704(k:String):String        {
            this._bottomLeftChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_15773(get,set):String;
public function  get__Str_15773():String
        {
            return this._bottomCenterChild;
        }
public function  set__Str_15773(k:String):String        {
            this._bottomCenterChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_12912(get,set):String;
public function  get__Str_12912():String
        {
            return this._bottomRightChild;
        }
public function  set__Str_12912(k:String):String        {
            this._bottomRightChild = ((k != null) ? k : "");
            this.refresh();
return k;
        }

        
        public var _Str_15124(get,set):Bool;
public function  get__Str_15124():Bool
        {
            return this._landingViewMode;
        }
public function  set__Str_15124(k:Bool):Bool        {
            this._landingViewMode = k;
            this.refresh();
return k;
        }

        function _Str_4388(k:String):BitmapDataAsset
        {
            return this._borderPieces[k];
        }

        function _Str_8501(k:String):Int
        {
            var _local_2= this._children.getChildByName(k);
            return (((!(k == null)) && (k.length > 0)) && (!(_local_2 == null))) ? _local_2.height : 0;
        }

        var _Str_13539(get,never):Int;
function  get__Str_13539():Int
        {
            return Std.int(Math.max(this._Str_8501(this._topCenterChild), Math.max(this._Str_8501(this._topLeftChild), this._Str_8501(this._topRightChild))) / 2);
        }

        var _Str_19026(get,never):Int;
function  get__Str_19026():Int
        {
            return Std.int(Math.max(this._Str_8501(this._bottomCenterChild), Math.max(this._Str_8501(this._bottomLeftChild), this._Str_8501(this._bottomRightChild))) / 2);
        }

        function refresh()
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_4:Array<ASAny> = null;
            var _local_5:IWindow = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:BitmapDataAsset = null;
            var _local_9:BitmapData = null;
            var _local_10:Rectangle = null;
            var _local_11:Rectangle = null;
            var _local_12 = 0;
            var _local_13 = 0;
            if (((this._settingProperties || this._resizingWidget) || this.disposed))
            {
                return;
            }
            this._root.limits.setEmpty();
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
            var k= this._children.getChildByName(this._contentChild);
            if (k != null)
            {
                _local_6 = Std.int(Math.max(1, (k.width + (2 * this._contentPadding))));
                _local_7 = Std.int(Math.max(1, (((k.height + (2 * this._contentPadding)) + this._Str_13539) + this._Str_19026)));
                this._resizingWidget = true;
                if (this._widgetWindow.testParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN))
                {
                    this._root.limits.minWidth = _local_6;
                    this._root.limits.minHeight = _local_7;
                }
                if (this._widgetWindow.testParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN))
                {
                    this._root.limits.minWidth = _local_6;
                    this._root.limits.minHeight = _local_7;
                    this._root.limits.maxWidth = _local_6;
                    this._root.limits.maxHeight = _local_7;
                }
                this._resizingWidget = false;
            }
            if ((((this._drawBuffer == null) || (!(this._drawBuffer.width == this._root.width))) || (!(this._drawBuffer.height == this._root.height))))
            {
                this._canvas.width = this._root.width;
                this._canvas.height = this._root.height;
                this._children.width = this._root.width;
                this._children.height = this._root.height;
                if (this._drawBuffer != null)
                {
                    this._drawBuffer.dispose();
                }
                this._drawBuffer = new BitmapData(this._canvas.width, this._canvas.height, true, 0);
                this._canvas.bitmap = this._drawBuffer;
            }
            var _local_2= this._canvas.rectangle;
            _local_2.y = (_local_2.y + this._Str_13539);
            _local_2.height = (_local_2.height - (this._Str_13539 + this._Str_19026));
            this._drawBuffer.lock();
            this._drawBuffer.fillRect(new Rectangle(0, 0, this._canvas.width, this._canvas.height), 0);

            final _iter_ = this._borderPieces; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_3 = _tmp_;
                _local_8 = this._Str_4388(_local_3);
                if (((_local_8 == null) || (this._landingViewMode && (((_local_3 == TOP_LEFT) || (_local_3 == LEFT)) || (_local_3 == BOTTOM_LEFT)))))
                {
                }
                else
                {
                    _local_9 = ASCompat.dynamicAs(_local_8.content , BitmapData);
                    _local_10 = _local_8.rectangle;
                    _local_11 = new Rectangle(_local_2.x, _local_2.y, _local_10.width, _local_10.height);
                    switch (_local_3)
                    {
                        case TOP_LEFT:
                            
                        case TOP:
                            _local_11.x = (_local_11.x + this._Str_4388(TOP_LEFT).rectangle.width);
                            _local_11.width = ((_local_2.width - this._Str_4388(TOP_LEFT).rectangle.width) - this._Str_4388(TOP_RIGHT).rectangle.width);
                            
                        case TOP_RIGHT:
                            _local_11.x = (_local_11.x + (_local_2.width - _local_10.width));
                            
                        case RIGHT:
                            _local_11.x = (_local_11.x + (_local_2.width - _local_10.width));
                            _local_11.y = (_local_11.y + this._Str_4388(TOP_RIGHT).rectangle.height);
                            _local_11.height = ((_local_2.height - this._Str_4388(TOP_RIGHT).rectangle.height) - this._Str_4388(BOTTOM_RIGHT).rectangle.height);
                            
                        case BOTTOM_RIGHT:
                            _local_11.x = (_local_11.x + (_local_2.width - _local_10.width));
                            _local_11.y = (_local_11.y + (_local_2.height - _local_10.height));
                            
                        case BOTTOM:
                            _local_11.x = (_local_11.x + this._Str_4388(BOTTOM_LEFT).rectangle.width);
                            _local_11.y = (_local_11.y + (_local_2.height - _local_10.height));
                            _local_11.width = ((_local_2.width - this._Str_4388(BOTTOM_LEFT).rectangle.width) - this._Str_4388(BOTTOM_RIGHT).rectangle.width);
                            if (this._landingViewMode)
                            {
                                _local_12 = Std.int(_local_11.width / 2);
                                _local_11.x = (_local_11.x + _local_12);
                                _local_11.width = (_local_11.width - _local_12);
                            }
                            
                        case BOTTOM_LEFT:
                            _local_11.y = (_local_11.y + (_local_2.height - _local_10.height));
                            
                        case LEFT:
                            _local_11.y = (_local_11.y + this._Str_4388(TOP_LEFT).rectangle.height);
                            _local_11.height = ((_local_2.height - this._Str_4388(TOP_LEFT).rectangle.height) - this._Str_4388(BOTTOM_LEFT).rectangle.height);
                            
                        default:
                            continue;
                    }
                    _Str_3559.a = (_local_11.width / _local_10.width);
                    _Str_3559.d = (_local_11.height / _local_10.height);
                    _Str_3559.tx = (_local_11.x - (_local_10.x * _Str_3559.a));
                    _Str_3559.ty = (_local_11.y - (_local_10.y * _Str_3559.d));
                    this._drawBuffer.draw(_local_9, _Str_3559, null, null, _local_11, false);
                }
            }
            _local_4 = [this._topLeftChild, this._topCenterChild, this._topRightChild, this._bottomLeftChild, this._bottomCenterChild, this._bottomRightChild];
            final _iter_ = this._children.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
            {
_local_5  = _tmp_;
                if (((!(_local_5.name == null)) && (_local_5.name.length > 0)))
                {
                    _local_13 = _local_4.indexOf(_local_5.name);
                    if (_local_13 < 0)
                    {
                        if (_local_5.name == this._contentChild)
                        {
                            _local_5.x = Std.int(_local_2.x + this._Str_8790);
                            _local_5.y = Std.int(_local_2.y + this._Str_8790);
                            _local_5.visible = true;
                        }
                        else
                        {
                            _local_5.visible = false;
                        }
                    }
                    else
                    {
                        switch ((_local_13 % 3))
                        {
                            case 0:
                                _local_5.x = Std.int(Math.min(this._sidePadding, (this._canvas.width - _local_5.width)));
                                
                            case 1:
                                _local_5.x = Std.int(Math.max((this._canvas.width - _local_5.width), 0) / 2);
                                
                            case 2:
                                _local_5.x = Std.int(Math.max(((this._canvas.width - _local_5.width) - this._sidePadding), 0));
                                
                        }
                        if (_local_13 < 3)
                        {
                            _local_5.y = Std.int(this._Str_13539 - (_local_5.height / 2));
                        }
                        else
                        {
                            _local_5.y = Std.int(this._canvas.height - (this._Str_19026 + (_local_5.height / 2)));
                        }
                        _local_5.visible = true;
                        this._drawBuffer.fillRect(new Rectangle((_local_5.x - this._childMargin), _local_5.y, (_local_5.width + (this._childMargin * 2)), _local_5.height), 0);
                    }
                }
                else
                {
                    _local_5.visible = false;
                }
            }
            this._drawBuffer.unlock();
            this._canvas.invalidate();
        }
    }

