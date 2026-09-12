package com.sulake.core.window
;
    import com.sulake.core.window.graphics.IGraphicContextHost;
    import com.sulake.core.window.utils.IChildWindowHost;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowEventDispatcher;
    import com.sulake.core.window.graphics.IGraphicContext;
    import com.sulake.core.window.utils.WindowRectLimits;
    import com.sulake.core.window.dynamicstyle.DynamicStyle;
    import com.sulake.core.window.theme.IPropertyMap;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.graphics.WindowRedrawFlag;
    import com.sulake.core.window.utils.IRectLimiter;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.graphics.GraphicContext;
    import com.sulake.core.window.events.WindowDisposeEvent;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.runtime.IDisposable;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import com.sulake.core.utils.Map;
    import flash.display.IBitmapDrawable;
    import com.sulake.core.window.services.IMouseListenerService;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window._enum.MouseListenerType;
    import com.sulake.core.window.dynamicstyle.DynamicStyleManager;
    import flash.display.BitmapData;
    import com.sulake.core.window.utils.PropertyStruct;
    import flash.events.MouseEvent;
    import flash.events.Event;

     class WindowController extends WindowModel implements IWindow implements  IGraphicContextHost implements  IChildWindowHost 
    {
        static var _uidCounter:UInt = 0;
        static final _RECT:Rectangle = new Rectangle();
        public static inline final TAG_EXCLUDE= "_EXCLUDE";
        public static inline final TAG_INTERNAL= "_INTERNAL";
        public static inline final _COLORIZE= "_COLORIZE";
        public static inline final _IGNORE_INHERITED_STYLE= "_IGNORE_INHERITED_STYLE";
        static final _POINT_ZERO:Point = new Point();

        var _events:WindowEventDispatcher;
        var _graphics:IGraphicContext;
        var _procedure:ASFunction;
        var _drawable:Bool = true;
        var _parent:WindowController;
        var _children:Vector<IWindow>;
        var _debug:Bool = false;
        var _limits:WindowRectLimits;
        var _immediateClickMode:Bool = false;
        var _currentDynamicStyle:DynamicStyle;
        var _forceGraphicContexts:Bool = false;
        var _lastParentRect:Rectangle;
        var _uid:UInt = 0;
        var _propertyDefaults:IPropertyMap;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0, _arg_12:String="")
        {
            var _local_15:UInt = 0;
            this._uid = _uidCounter++;
            var _local_13= _arg_5.getWindowFactory()._Str_19128(_arg_2, _arg_3);
            if (_arg_6 == null)
            {
                _arg_6 = new Rectangle(0, 0, ((_local_13 != null) ? ASCompat.toInt(ASCompat.xmlListToString(_local_13.attribute("width"))) : 10), ((_local_13 != null) ? ASCompat.toInt(ASCompat.xmlListToString(_local_13.attribute("height"))) : 10));
            }
            this._propertyDefaults = _arg_5.getWindowFactory().getThemeManager().getPropertyDefaults(_arg_3);
            super(_arg_11, k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_10, _arg_12);
            if (this._graphics == null)
            {
                this._graphics = this.getGraphicContext((!testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
            }
            this._lastParentRect = new Rectangle();
            if (_local_13 != null)
            {
                _initialRect = new Rectangle(0, 0, ASCompat.toInt(ASCompat.xmlListToString(_local_13.attribute("width"))), ASCompat.toInt(ASCompat.xmlListToString(_local_13.attribute("height"))));
                _previousRect = _initialRect.clone();
                _x = Std.int(_initialRect.x);
                _y = Std.int(_initialRect.y);
                _w = Std.int(_initialRect.width);
                _h = Std.int(_initialRect.height);
                _arg_5.getWindowParser().parseAndConstruct(_local_13, this, null);
                _local_15 = _param;
                _param = (ASCompat.toInt(_param )& (~ASCompat.toInt(WindowParam.WINDOW_PARAM_REFLECT_RESIZE_TO_PARENT)));
                this.setRectangle(Std.int(_arg_6.x), Std.int(_arg_6.y), Std.int(_arg_6.width), Std.int(_arg_6.height));
                _param = _local_15;
                _previousRect.x = _arg_6.x;
                _previousRect.y = _arg_6.y;
                _previousRect.width = _arg_6.width;
                _previousRect.height = _arg_6.height;
            }
            var _local_14= _arg_5.getWindowFactory()._Str_20294(_arg_2, _arg_3);
            if (_local_14 != null)
            {
                _blend = _local_14.blend;
                _mouseThreshold = _local_14.threshold;
                if (_background != _local_14.background)
                {
                    this.background = _local_14.background;
                }
                if (_fillColor != _local_14.color)
                {
                    this.color = _local_14.color;
                }
                if (_local_14._Str_24281())
                {
                    cast(this.limits, WindowRectLimits).assign(_local_14.width_min, _local_14.width_max, _local_14.height_min, _local_14.height_max);
                }
            }
            if (_arg_9 != null)
            {
                this.properties = _arg_9;
            }
            this._procedure = _arg_8;
            if (_arg_7 != null)
            {
                this._parent = Std.downcast(_arg_7 , WindowController);
                cast(_arg_7, WindowController).addChild(this);
                if (this._graphics != null)
                {
                    _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
                }
            }
        }

        static function calculateMouseRegion(k:WindowController, _arg_2:Rectangle)
        {
            var _local_3= new Rectangle();
            k.getGlobalRectangle(_local_3);
            var _local_4= k.numChildren;
            var _local_5= Std.int(_local_3.x);
            var _local_6= Std.int(_local_3.y);
            _arg_2.left = ((_local_5 < _arg_2.left) ? _local_5 : _arg_2.left);
            _arg_2.top = ((_local_6 < _arg_2.top) ? _local_6 : _arg_2.top);
            _arg_2.right = ((_local_3.right > _arg_2.right) ? _local_3.right : _arg_2.right);
            _arg_2.bottom = ((_local_3.bottom > _arg_2.bottom) ? _local_3.bottom : _arg_2.bottom);
            var _local_7 = 0;
            while (_local_7 < _local_4)
            {
                WindowController.calculateMouseRegion(Std.downcast(k.getChildAt(_local_7) , WindowController), _arg_2);
                _local_7++;
            }
        }

        public static function expandToAccommodateChild(k:WindowController, _arg_2:IWindow)
        {
            var _local_8:UInt = 0;
            var _local_9:UInt = 0;
            var _local_10:UInt = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5= k.width;
            var _local_6= k.height;
            var _local_7 = false;
            if (_arg_2.x < 0)
            {
                _local_3 = _arg_2.x;
                _local_5 = (_local_5 - _local_3);
                _arg_2.x = 0;
                _local_7 = true;
            }
            if (_arg_2.right > _local_5)
            {
                _local_5 = (_arg_2.x + _arg_2.width);
                _local_7 = true;
            }
            if (_arg_2.y < 0)
            {
                _local_4 = _arg_2.y;
                _local_6 = (_local_6 - _local_4);
                _arg_2.y = 0;
                _local_7 = true;
            }
            if (_arg_2.bottom > _local_6)
            {
                _local_6 = (_arg_2.y + _arg_2.height);
                _local_7 = true;
            }
            if (_local_7)
            {
                _local_8 = (ASCompat.toInt(k.param )& (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN)));
                if (_local_8 != 0)
                {
                    k.setParamFlag(_local_8, false);
                }
                k.setRectangle((k.x + _local_3), (k.y + _local_4), _local_5, _local_6);
                if (((!(_local_4 == 0)) || (!(_local_3 == 0))))
                {
                    _local_10 = k.numChildren;
                    _local_9 = 0;
                    while (_local_9 < _local_10)
                    {
                        k.getChildAt(ASCompat.toInt(_local_9)).offset(-_local_3, -_local_4);
                        _local_9++;
                    }
                }
                if (_local_8 != 0)
                {
                    k.setParamFlag(_local_8, true);
                }
            }
        }

        public static function resizeToAccommodateChildren(k:WindowController)
        {
            var _local_2:UInt = 0;
            var _local_7:IWindow = null;
            var _local_10:UInt = 0;
            var _local_11 = false;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5= ASCompat.MIN_INT;
            var _local_6= ASCompat.MIN_INT;
            var _local_8 = false;
            var _local_9:UInt = k.numChildren;
            _local_2 = 0;
            while (_local_2 < _local_9)
            {
                _local_7 = k.getChildAt(ASCompat.toInt(_local_2));
                if ((_local_7.x + _local_7.width) > _local_5)
                {
                    _local_5 = (_local_7.x + _local_7.width);
                    _local_8 = true;
                }
                if ((_local_7.y + _local_7.height) > _local_6)
                {
                    _local_6 = (_local_7.y + _local_7.height);
                    _local_8 = true;
                }
                _local_2++;
            }
            if (_local_8)
            {
                _local_10 = (ASCompat.toInt(k.param )& (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN)));
                if (_local_10 != 0)
                {
                    k.setParamFlag(_local_10, false);
                }
                if (((!(_local_3 == 0)) || (!(_local_4 == 0))))
                {
                    _local_2 = 0;
                    while (_local_2 < _local_9)
                    {
                        _local_7 = k.getChildAt(ASCompat.toInt(_local_2));
                        _local_11 = _local_7.testParamFlag(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT);
                        if (_local_11)
                        {
                            _local_7.setParamFlag(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT, false);
                        }
                        _local_7.offset(-_local_3, -_local_4);
                        if (_local_11)
                        {
                            _local_7.setParamFlag(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT, true);
                        }
                        _local_2++;
                    }
                }
                k.width = _local_5;
                k.height = _local_6;
                if (_local_10 != 0)
                {
                    k.setParamFlag(_local_10, true);
                }
            }
        }


        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            return [];
        }

        
        public var procedure(get,set):ASFunction;
public function  get_procedure():ASFunction
        {
            return (this._procedure != null) ? this._procedure : ((this._parent != null) ? this._parent.procedure : this.nullEventProc);
        }

        
        public var filters(get,set):Array<ASAny>;
public function  get_filters():Array<ASAny>
        {
            return this.hasGraphicsContext() ? (cast this.getGraphicContext(true).filters) : [];
        }

        
        public var parent(get,set):IWindow;
public function  get_parent():IWindow
        {
            return this._parent;
        }

        
        public var debug(get,set):Bool;
public function  get_debug():Bool
        {
            return this._debug;
        }

        public var limits(get,never):IRectLimiter;
public function  get_limits():IRectLimiter
        {
            return (this._limits != null) ? this._limits : (this._limits = new WindowRectLimits(this));
        }

        
        public var immediateClickMode(get,set):Bool;
public function  get_immediateClickMode():Bool
        {
            return this._immediateClickMode;
        }

        public override function  set_x(k:Int):Int        {
            if (k != _x)
            {
                this.setRectangle(k, _y, _w, _h);
            }
return k;
        }

        public override function  set_y(k:Int):Int        {
            if (k != _y)
            {
                this.setRectangle(_x, k, _w, _h);
            }
return k;
        }

        public override function  set_id(k:Int):Int        {
            _id = k;
return k;
        }

        public override function  set_name(k:String):String        {
            return _name = k;
        }

        public override function  set_width(k:Int):Int        {
            if (k != _w)
            {
                this.setRectangle(_x, _y, k, _h);
            }
return k;
        }

        public override function  set_height(k:Int):Int        {
            if (k != _h)
            {
                this.setRectangle(_x, _y, _w, k);
            }
return k;
        }

        public override function  set_position(k:Point):Point        {
            this.setRectangle(Std.int(k.x), Std.int(k.y), _w, _h);
return k;
        }

        public override function  set_rectangle(k:Rectangle):Rectangle        {
            this.setRectangle(Std.int(k.x), Std.int(k.y), Std.int(k.width), Std.int(k.height));
return k;
        }

        public override function  set_background(k:Bool):Bool        {
            _background = k;
            _fillColor = (_background ? (ASCompat.toInt(_fillColor )| ASCompat.toInt(_alphaColor)) : (ASCompat.toInt(_fillColor )& 0xFFFFFF));
            this._drawable = (this._drawable || k);
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
return k;
        }

        public override function  set_color(k:UInt):UInt        {
            _alphaColor = (ASCompat.toInt(k )& ASCompat.toInt(0xFF000000));
            _fillColor = ASCompat.toUInt(_background ? k : (ASCompat.toInt(k )& 0xFFFFFF));
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
return k;
        }

        public override function  set_alpha(k:UInt):UInt        {
            _alphaColor = (ASCompat.toInt(k )<< 24);
            _fillColor = (_background ? (ASCompat.toInt(_alphaColor )| ASCompat.toInt(_fillColor)) : (0xFFFFFF & ASCompat.toInt(_fillColor)));
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
return k;
        }

        public override function  set_blend(k:Float):Float        {
            k = ((k > 1) ? 1 : ((k < 0) ? 0 : k));
            if (k != _blend)
            {
                _blend = k;
                _context.invalidate(this, null, WindowRedrawFlag.BLEND);
            }
return k;
        }

        public override function  set_visible(k:Bool):Bool        {
            var _local_2:WindowEvent = null;
            if (k != _visible)
            {
                _visible = k;
                if (((this._graphics != null) && (!k)))
                {
                    this._graphics.visible = false;
                }
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
                _local_2 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY, this, this);
                this.update(this, _local_2);
                _local_2.recycle();
            }
return k;
        }

        public override function  set_type(k:UInt):UInt        {
            if (k != _type)
            {
                _type = k;
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            }
return k;
        }

        public override function  set_caption(k:String):String        {
            k = (ASCompat.stringAsBool(k) ? k : "");
            if (k != caption)
            {
                _caption = k;
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            }
return k;
        }

        public override function  set_tags(k:Array<ASAny>):Array<ASAny>        {
            if (k != null)
            {
                _tags = k;
            }
return k;
        }

        public override function  set_mouseThreshold(k:UInt):UInt        {
            _mouseThreshold = ASCompat.toUInt((k > 0xFF) ? 0xFF : k);
return k;
        }
public function  set_procedure(k:ASFunction):ASFunction        {
            return this._procedure = k;
        }
public function  set_filters(k:Array<ASAny>):Array<ASAny>        {
            if (this.hasGraphicsContext())
            {
                this.getGraphicContext(true).filters = (cast k);
            }
return k;
        }
public function  set_debug(k:Bool):Bool        {
            return this._debug = k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
return k;
        }

        public var offsetX(never,set):Int;
public function  set_offsetX(k:Int):Int        {
            return _offsetX = k;
        }

        public var offsetY(never,set):Int;
public function  set_offsetY(k:Int):Int        {
            return _offsetY = k;
        }

        public var etching(never,set):Array<ASAny>;
public function  set_etching(k:Array<ASAny>):Array<ASAny>        {
return k;
        }

        public override function  set_state(k:UInt):UInt        {
            if (k != _state)
            {
                _state = k;
                _context.invalidate(this, null, WindowRedrawFlag.STATE);
            }
return k;
        }

        
        public var dynamicStyleColor(get,set):ColorTransform;
public function  set_dynamicStyleColor(k:ColorTransform):ColorTransform        {
            return _dynamicStyleColorTransform = k;
        }
public function  get_dynamicStyleColor():ColorTransform
        {
            return _dynamicStyleColorTransform;
        }

        public override function  set_style(k:UInt):UInt        {
            var _local_2:Array<ASAny> = null;
            var _local_3:UInt = 0;
            var _local_4:WindowController = null;
            if (k != _style)
            {
                _style = k;
                _local_2 = new Array<ASAny>();
                this.groupChildrenWithTag(WindowController.TAG_INTERNAL, _local_2);
                _local_3 = _local_2.length;
                while (--_local_3 > -1)
                {
                    _local_4 = ASCompat.dynamicAs(_local_2[ASCompat.toInt(_local_3)] , WindowController);
                    if (_local_4.tags.indexOf(_IGNORE_INHERITED_STYLE) == -1)
                    {
                        _local_4.style = _style;
                    }
                }
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
                this._propertyDefaults = _context.getWindowFactory().getThemeManager().getPropertyDefaults(_style);
            }
return k;
        }

        public override function  set_dynamicStyle(k:String):String        {
            _dynamicStyle = k;
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
return k;
        }

        public override function  set_clipping(k:Bool):Bool        {
            if (k != _clipping)
            {
                _clipping = k;
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            }
return k;
        }

        public var host(get,never):IWindow;
public function  get_host():IWindow
        {
            return ((this._parent : ASAny) == (this.desktop : ASAny)) ? this : this._parent.host;
        }

        public var desktop(get,never):IDesktopWindow;
public function  get_desktop():IDesktopWindow
        {
            return _context.getDesktopWindow();
        }
public function  set_parent(k:IWindow):IWindow        {
            var _local_3:WindowController = null;
            var _local_4:WindowEvent = null;
            if ((k : ASAny) == (this : ASAny))
            {
                throw new ASError("Attempted to assign self as parent!");
            }
            if (((!(k == null)) && (!((k.context : ASAny) == (_context : ASAny)))))
            {
                _context = cast(k.context, WindowContext);
                if (this._children != null)
                {
                    final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_3  = cast(_tmp_, WindowController);
                        _local_3.parent = this;
                    }
                }
            }
            var _local_2:IWindow = this._parent;
            if ((this._parent : ASAny) != (k : ASAny))
            {
                if (this._parent != null)
                {
                    this._parent.removeChild(this);
                }
                this._parent = cast(k, WindowController);
                if (this._parent != null)
                {
                    this._lastParentRect = this._parent.rectangle;
                    _previousRect.x = _x;
                    _previousRect.y = _y;
                    _previousRect.width = _w;
                    _previousRect.height = _h;
                    _local_4 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_PARENT_ADDED, this, this._parent);
                    this.update(this, _local_4);
                }
                else
                {
                    this._lastParentRect.x = 0;
                    this._lastParentRect.y = 0;
                    this._lastParentRect.width = 0;
                    this._lastParentRect.height = 0;
                    _local_4 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_PARENT_REMOVED, this, _local_2);
                    this.update(this, _local_4);
                }
                _local_4.recycle();
            }
return k;
        }

        public function hasGraphicsContext():Bool
        {
            return (!(this._graphics == null)) || (!testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT));
        }

        public function getGraphicContext(k:Bool):IGraphicContext
        {
            if ((k && (!(this._graphics != null))))
            {
                this._graphics = new GraphicContext((("GC {" + _name) + "}"), GraphicContext.GC_TYPE_BITMAP, new Rectangle(_x, _y, _w, _h));
                this._graphics.visible = _visible;
            }
            return this._graphics;
        }

        public function setupGraphicsContext():IGraphicContext
        {
            var k = 0;
            var _local_2:WindowController = null;
            this._graphics = this.getGraphicContext(true);
            if (this._parent != null)
            {
                this._parent.setupGraphicsContext();
            }
            if (((this._children != null) && (this._children.length > 0)))
            {
                if (this._graphics._Str_13711 != this.numChildren)
                {
                    k = 0;
                    final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_2  = cast(_tmp_, WindowController);
                        this._graphics._Str_16175(_local_2.getGraphicContext(true), k++);
                    }
                }
            }
            this._forceGraphicContexts = true;
            return this._graphics;
        }

        public function releaseGraphicsContext()
        {
            this._forceGraphicContexts = false;
            if (this._graphics != null)
            {
            }
        }

        public function clone():IWindow
        {
            var k= Type.getClass(this);
            var _local_2= ASCompat.dynamicAs(Type.createInstance(k, [_name, _type, _style, _param, _context, new Rectangle(_x, _y, _w, _h), null, this._procedure, this.properties, ((_tags != null) ? _tags.copy() : null), _id]) , WindowController);
            _local_2.dynamicStyle = _dynamicStyle;
            _local_2._mouseThreshold = _mouseThreshold;
            _local_2._drawable = this._drawable;
            _local_2._debug = this._debug;
            _local_2._lastParentRect = this._lastParentRect.clone();
            _local_2._x = _x;
            _local_2._y = _y;
            _local_2._w = _w;
            _local_2._h = _h;
            _local_2._initialRect = _initialRect.clone();
            _local_2._previousRect = _previousRect.clone();
            _local_2._minimizedRect = ((_minimizedRect != null) ? _minimizedRect.clone() : null);
            _local_2._maximizedRect = ((_maximizedRect != null) ? _maximizedRect.clone() : null);
            _local_2._limits = ((this._limits != null) ? this._limits.clone(_local_2) : null);
            _local_2._context = _context;
            _local_2._fillColor = _fillColor;
            _local_2._alphaColor = _alphaColor;
            _local_2.clipping = _clipping;
            _local_2._visible = _visible;
            _local_2._blend = _blend;
            _local_2._param = _param;
            _local_2._state = _state;
            _local_2._name = _name;
            _local_2._id = _id;
            _local_2.caption = _caption;
            _local_2.background = _background;
            this.cloneChildWindows(_local_2);
            return _local_2;
        }

        function cloneChildWindows(k:WindowController)
        {
            var _local_2:WindowController = null;
            if (this._children != null)
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    if (_local_2.tags.indexOf(WindowController.TAG_EXCLUDE) == -1)
                    {
                        k.addChild(_local_2.clone());
                    }
                }
            }
        }

        override public function dispose()
        {
            var k:WindowDisposeEvent = null;
            if (!_disposed)
            {
                this.immediateClickMode = false;
                this._procedure = null;
                if (!_context.disposed)
                {
                    if (!this.isChildWindow())
                    {
                        if (this.getStateFlag(WindowState.ACTIVE))
                        {
                            this.deactivate();
                        }
                    }
                }
                if (this._children != null)
                {
                    while (this._children.length > 0)
                    {
                        this._children.pop().dispose();
                    }
                }
                this._children = null;
                if (this.parent != null)
                {
                    this.parent = null;
                }
                if (this._events != null)
                {
                    k = WindowDisposeEvent.allocate(this);
                    this._events.dispatchEvent(k);
                    k.recycle();
                    if (Std.is(this._events , IDisposable))
                    {
                        this._events.dispose();
                        this._events = null;
                    }
                }
                if (this._graphics != null)
                {
                    this._graphics.dispose();
                    this._graphics = null;
                }
                super.dispose();
            }
        }

        public function toString():String
        {
            return (((((("[" + "Window ") + getQualifiedClassName(this)) + " ") + _name) + " ") + Std.string(this._uid)) + "]";
        }

        override public function invalidate(k:Rectangle=null)
        {
            _context.invalidate(this, k, WindowRedrawFlag.REDRAW);
        }

        public function resolve():UInt
        {
            return 0;
        }

        public function center()
        {
            if (this._parent != null)
            {
                this.x = Std.int((this._parent.width / 2) - (_w / 2));
                this.y = Std.int((this._parent.height / 2) - (_h / 2));
            }
        }

        public function setRectangle(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            var _local_7:UInt = 0;
            var _local_8:WindowEvent = null;
            if (this._limits != null)
            {
                _arg_4 = Std.int(Math.max(this._limits.minHeight, _arg_4));
                _arg_4 = Std.int(Math.min(this._limits.maxHeight, _arg_4));
                _arg_3 = Std.int(Math.max(this._limits.minWidth, _arg_3));
                _arg_3 = Std.int(Math.min(this._limits.maxWidth, _arg_3));
            }
            var _local_5= ((!(k == _x)) || (!(_arg_2 == _y)));
            var _local_6= ((!(_arg_3 == _w)) || (!(_arg_4 == _h)));
            if ((_local_6 && (!_local_5)))
            {
                _local_7 = (ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_HORIZONTAL));
                if (_local_7 == WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_CENTER)
                {
                    k = Std.int(k - ((_arg_3 - _w) / 2));
                    _local_5 = true;
                }
                else
                {
                    if (_local_7 == WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_RIGHT)
                    {
                        k = (k - (_arg_3 - _w));
                        _local_5 = true;
                    }
                }
                _local_7 = (ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_VERTICAL));
                if (_local_7 == WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_MIDDLE)
                {
                    _arg_2 = Std.int(_arg_2 - ((_arg_4 - _h) / 2));
                    _local_5 = true;
                }
                else
                {
                    if (_local_7 == WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_BOTTOM)
                    {
                        _arg_2 = (_arg_2 - (_arg_4 - _h));
                        _local_5 = true;
                    }
                }
            }
            if (testParamFlag(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT))
            {
                if (this._parent != null)
                {
                    k = ((k < 0) ? 0 : k);
                    _arg_2 = ((_arg_2 < 0) ? 0 : _arg_2);
                    if (_local_5)
                    {
                        k = (k - (((k + _arg_3) > this._parent.width) ? ((k + _arg_3) - this._parent.width) : 0));
                        _arg_2 = (_arg_2 - (((_arg_2 + _arg_4) > this._parent.height) ? ((_arg_2 + _arg_4) - this._parent.height) : 0));
                        _local_5 = ((!(k == _x)) || (!(_arg_2 == _y)));
                    }
                    else
                    {
                        _arg_3 = (_arg_3 - (((k + _arg_3) > this._parent.width) ? ((k + _arg_3) - this._parent.width) : 0));
                        _arg_4 = (_arg_4 - (((_arg_2 + _arg_4) > this._parent.height) ? ((_arg_2 + _arg_4) - this._parent.height) : 0));
                        _local_6 = ((!(_arg_3 == _w)) || (!(_arg_4 == _h)));
                    }
                }
            }
            if ((_local_5 || _local_6))
            {
                if (_local_5)
                {
                    _local_8 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RELOCATE, this, null, true);
                    this.update(this, _local_8);
                    if (_local_8.isWindowOperationPrevented())
                    {
                        _local_5 = false;
                    }
                    _local_8.recycle();
                }
                if (_local_6)
                {
                    _local_8 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESIZE, this, null, true);
                    this.update(this, _local_8);
                    if (_local_8.isWindowOperationPrevented())
                    {
                        _local_6 = false;
                    }
                    _local_8.recycle();
                }
                if (_local_5)
                {
                    _previousRect.x = _x;
                    _previousRect.y = _y;
                    _previousRect.width = _w;
                    _previousRect.height = _h;
                    _x = k;
                    _y = _arg_2;
                }
                if (_local_6)
                {
                    _previousRect.width = _w;
                    _previousRect.height = _h;
                    _w = _arg_3;
                    _h = _arg_4;
                }
                if (_local_5)
                {
                    _local_8 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RELOCATED, this, null);
                    this.update(this, _local_8);
                    _local_8.recycle();
                }
                if (_local_6)
                {
                    _local_8 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESIZED, this, null);
                    this.update(this, _local_8);
                    _local_8.recycle();
                }
            }
        }

        public function getRegionProperties(k:Rectangle=null, _arg_2:Rectangle=null, _arg_3:Rectangle=null, _arg_4:Rectangle=null)
        {
            if (k != null)
            {
                k.x = _x;
                k.y = _y;
                k.width = _w;
                k.height = _h;
            }
            if (_arg_2 != null)
            {
                _arg_2.x = _previousRect.x;
                _arg_2.y = _previousRect.y;
                _arg_2.width = _previousRect.width;
                _arg_2.height = _previousRect.height;
            }
            if (((!(_arg_3 == null)) && (!(_minimizedRect == null))))
            {
                _arg_3.x = _minimizedRect.x;
                _arg_3.y = _minimizedRect.y;
                _arg_3.width = _minimizedRect.width;
                _arg_3.height = _minimizedRect.height;
            }
            if (((!(_arg_4 == null)) && (!(_maximizedRect == null))))
            {
                _arg_4.x = _maximizedRect.x;
                _arg_4.y = _maximizedRect.y;
                _arg_4.width = _maximizedRect.width;
                _arg_4.height = _maximizedRect.height;
            }
        }

        public function setRegionProperties(k:Rectangle=null, _arg_2:Rectangle=null, _arg_3:Rectangle=null)
        {
            if (_arg_3 != null)
            {
                if (((_arg_3.width < 0) || (_arg_3.height < 0)))
                {
                    throw new ASError("Invalid rectangle; maximized size can't be less than zero!");
                }
                if (_maximizedRect == null)
                {
                    _maximizedRect = new Rectangle();
                }
                _maximizedRect.x = _arg_3.x;
                _maximizedRect.y = _arg_3.y;
                _maximizedRect.width = _arg_3.width;
                _maximizedRect.height = _arg_3.height;
            }
            if (_arg_2 != null)
            {
                if (((_arg_2.width < 0) || (_arg_2.height < 0)))
                {
                    throw new ASError("Invalid rectangle; minimized size can't be less than zero!");
                }
                if (_minimizedRect == null)
                {
                    _minimizedRect = new Rectangle();
                }
                _minimizedRect.x = _arg_2.x;
                _minimizedRect.y = _arg_2.y;
                _minimizedRect.width = _arg_2.width;
                _minimizedRect.height = _arg_2.height;
            }
            if (((_arg_3.width < _arg_2.width) || (_arg_3.height < _arg_2.height)))
            {
                _arg_3.width = _arg_2.width;
                _arg_3.height = _arg_2.height;
                throw new ASError("Maximized rectangle can't be smaller than minimized rectangle!");
            }
            if (k != null)
            {
                this.setRectangle(Std.int(k.x), Std.int(k.y), Std.int(k.width), Std.int(k.height));
            }
        }

        public function buildFromXML(k:com.sulake.core.utils.xml.XML, _arg_2:Map=null):Bool
        {
            return !(_context.getWindowParser().parseAndConstruct(k, this, _arg_2) == null);
        }

        public function fetchDrawBuffer():IBitmapDrawable
        {
            return testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT) ? ((this._parent != null) ? this._parent.fetchDrawBuffer() : null) : this.getGraphicContext(true).fetchDrawBuffer();
        }

        public function getDrawRegion(k:Rectangle)
        {
            if (!testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
            {
                k.x = 0;
                k.y = 0;
                k.width = _w;
                k.height = _h;
            }
            else
            {
                if (this._parent != null)
                {
                    this._parent.getDrawRegion(k);
                    k.x = (k.x + _x);
                    k.y = (k.y + _y);
                    k.width = _w;
                    k.height = _h;
                }
                else
                {
                    k.x = 0;
                    k.y = 0;
                    k.width = 0;
                    k.height = 0;
                }
            }
        }

        public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3:IWindow = null;
            var _local_4:IMouseListenerService = null;
            var _local_5:WindowEvent = null;
            var _local_6:UInt = 0;
            if (!testParamFlag(WindowParam.WINDOW_PARAM_INTERNAL_EVENT_HANDLING))
            {
                this.procedure(_arg_2, this);
                if (_disposed)
                {
                    return true;
                }
                if (!_arg_2.isWindowOperationPrevented())
                {
                    if (this.hasEventListener(_arg_2.type))
                    {
                        this._events.dispatchEvent(_arg_2);
                        if (_disposed)
                        {
                            return true;
                        }
                    }
                }
                if (_arg_2.cancelable)
                {
                    if (_arg_2.isWindowOperationPrevented())
                    {
                        return true;
                    }
                }
            }
            if (Std.is(_arg_2 , WindowMouseEvent))
            {
                switch (_arg_2.type)
                {
                    case WindowMouseEvent.DOWN:
                        if (this.activate())
                        {
                            if (_arg_2.cancelable)
                            {
                                _arg_2.preventDefault();
                            }
                        }
                        if (disposed)
                        {
                            return true;
                        }
                        this.setStateFlag(WindowState.PRESSED, true);
                        _local_4 = _context.getWindowServices().getMouseListenerService();
                        _local_4.begin(this);
                        _local_4.eventTypes.push(WindowMouseEvent.UP);
                        _local_4._Str_14321 = MouseListenerType.EVENTS_OUTSIDE_WINDOW;
                        if (testParamFlag(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TRIGGER))
                        {
                            _local_3 = this;
                            while (_local_3 != null)
                            {
                                if (_local_3.testParamFlag(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TARGET))
                                {
                                    _context.getWindowServices().getMouseDraggingService().begin(_local_3);
                                    break;
                                }
                                _local_3 = _local_3.parent;
                            }
                        }
                        if ((ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TRIGGER)) > 0)
                        {
                            _local_3 = this;
                            while (_local_3 != null)
                            {
                                if (_local_3.testParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TARGET))
                                {
                                    _context.getWindowServices().getMouseScalingService().begin(_local_3, (ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TRIGGER)));
                                    break;
                                }
                                _local_3 = _local_3.parent;
                            }
                        }
                        
                    case WindowMouseEvent.UP:
                        if (testStateFlag(WindowState.PRESSED))
                        {
                            this.setStateFlag(WindowState.PRESSED, false);
                        }
                        _context.getWindowServices().getMouseListenerService().end(this);
                        if (testParamFlag(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TARGET))
                        {
                            _context.getWindowServices().getMouseDraggingService().end(this);
                        }
                        if (testParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TARGET))
                        {
                            _context.getWindowServices().getMouseScalingService().end(this);
                        }
                        
                    case WindowMouseEvent.OUT:
                        if (testStateFlag(WindowState.HOVERING))
                        {
                            this.setStateFlag(WindowState.HOVERING, false);
                        }
                        if (testStateFlag(WindowState.PRESSED))
                        {
                            this.setStateFlag(WindowState.PRESSED, false);
                        }
                        
                    case WindowMouseEvent.OVER:
                        if (!testStateFlag(WindowState.HOVERING))
                        {
                            this.setStateFlag(WindowState.HOVERING, true);
                        }
                        
                    case WindowMouseEvent.WHEEL:
                        return false;
                }
            }
            else
            {
                if (Std.is(_arg_2 , WindowEvent))
                {
                    switch (_arg_2.type)
                    {
                        case WindowEvent.WINDOW_EVENT_RESIZED:
                            if (k == this)
                            {
                                _RECT.x = ((_x < _previousRect.x) ? _x : _previousRect.x);
                                _RECT.y = ((_y < _previousRect.y) ? _y : _previousRect.y);
                                _RECT.right = (((_x + _w) > _previousRect.right) ? (_x + _w) : _previousRect.right);
                                _RECT.bottom = (((_y + _h) > _previousRect.bottom) ? (_y + _h) : _previousRect.bottom);
                                _RECT.offset(-_x, -_y);
                                _context.invalidate(this, _RECT, WindowRedrawFlag.RESIZE);
                                _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this, null);
                                this.notifyChildren(_local_5);
                                _local_5.recycle();
                                if (testParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER, WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER))
                                {
                                    this.updateScaleRelativeToParent();
                                }
                                else
                                {
                                    if (testParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER, WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER))
                                    {
                                        this.updateScaleRelativeToParent();
                                    }
                                }
                                if (this._parent != null)
                                {
                                    _local_6 = _param;
                                    _param = (ASCompat.toInt(_param )& (~(ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER))));
                                    if (testParamFlag(WindowParam.WINDOW_PARAM_REFLECT_HORIZONTAL_RESIZE_TO_PARENT))
                                    {
                                        this._parent.width = Std.int(this._parent.width + (_w - _previousRect.width));
                                    }
                                    if (testParamFlag(WindowParam.WINDOW_PARAM_REFLECT_VERTICAL_RESIZE_TO_PARENT))
                                    {
                                        this._parent.height = Std.int(this._parent.height + (_h - _previousRect.height));
                                    }
                                    _param = _local_6;
                                    _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this._parent, this);
                                    this._parent.update(this, _local_5);
                                    _local_5.recycle();
                                }
                            }
                            
                        case WindowEvent.WINDOW_EVENT_RELOCATED:
                            if (k == this)
                            {
                                _RECT.x = ((_x < _previousRect.x) ? _x : _previousRect.x);
                                _RECT.y = ((_y < _previousRect.y) ? _y : _previousRect.y);
                                _RECT.right = (((_x + _w) > _previousRect.right) ? (_x + _w) : _previousRect.right);
                                _RECT.bottom = (((_y + _h) > _previousRect.bottom) ? (_y + _h) : _previousRect.bottom);
                                _RECT.offset(-_x, -_y);
                                _context.invalidate(this, _RECT, WindowRedrawFlag.RELOCATE);
                                _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_PARENT_RELOCATED, this, null);
                                this.notifyChildren(_local_5);
                                _local_5.recycle();
                                if (this._parent != null)
                                {
                                    _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this._parent, this);
                                    this._parent.update(this, _local_5);
                                    _local_5.recycle();
                                }
                            }
                            
                        case WindowEvent.WINDOW_EVENT_ACTIVATED:
                            if (k == this)
                            {
                                _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_PARENT_ACTIVATED, this, null);
                                this.notifyChildren(_local_5);
                                _local_5.recycle();
                                if (this._parent != null)
                                {
                                    _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_ACTIVATED, this._parent, this);
                                    this._parent.update(this, _local_5);
                                    _local_5.recycle();
                                }
                            }
                            
                        case WindowEvent.WINDOW_EVENT_PARENT_ADDED:
                            if (testParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER, WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER))
                            {
                                this.updateScaleRelativeToParent();
                            }
                            else
                            {
                                if (testParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER, WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER))
                                {
                                    this.updateScaleRelativeToParent();
                                }
                            }
                            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
                            
                        case WindowEvent.WINDOW_EVENT_PARENT_RESIZED:
                            this._parent.getRegionProperties(null, this._lastParentRect);
                            this.updateScaleRelativeToParent();
                            
                        case WindowEvent.WINDOW_EVENT_CHILD_ADDED:
                            if (testParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN))
                            {
                                this.scaleToAccommodateChildren();
                            }
                            else
                            {
                                if (testParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN))
                                {
                                    expandToAccommodateChild(this, _arg_2.related);
                                }
                            }
                            this.renderDynamicStyle();
                            
                        case WindowEvent.WINDOW_EVENT_CHILD_REMOVED:
                            if (testParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN))
                            {
                                this.scaleToAccommodateChildren();
                            }
                            
                        case WindowEvent.WINDOW_EVENT_CHILD_ACTIVATED:
                            this.activate();
                            
                        case WindowEvent.WINDOW_EVENT_CHILD_RESIZED:
                            if (testParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN))
                            {
                                this.scaleToAccommodateChildren();
                            }
                            else
                            {
                                if (testParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN))
                                {
                                    expandToAccommodateChild(this, _arg_2.related);
                                }
                            }
                            
                        case WindowEvent.WINDOW_EVENT_CHILD_RELOCATED:
                            if (testParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN))
                            {
                                this.scaleToAccommodateChildren();
                            }
                            else
                            {
                                if (testParamFlag(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN))
                                {
                                    expandToAccommodateChild(this, _arg_2.related);
                                }
                            }
                            
                        case WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY:
                            if (k == this)
                            {
                                if (this._parent != null)
                                {
                                    _local_5 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY, this._parent, this);
                                    this._parent.update(this, _local_5);
                                    _local_5.recycle();
                                }
                            }
                            
                    }
                }
            }
            return true;
        }

        function renderDynamicStyle()
        {
            var k:UInt = 0;
            if (_dynamicStyle == "")
            {
                return;
            }
            if (((!(this._currentDynamicStyle != null)) || (!(this._currentDynamicStyle.name == _dynamicStyle))))
            {
                this._currentDynamicStyle = DynamicStyleManager.getStyle(_dynamicStyle);
            }
            if (this.getStateFlag(WindowState.DISABLED))
            {
                k = WindowState.DISABLED;
            }
            else
            {
                if (this.getStateFlag(WindowState.PRESSED))
                {
                    k = WindowState.PRESSED;
                }
                else
                {
                    if (this.getStateFlag(WindowState.HOVERING))
                    {
                        k = WindowState.HOVERING;
                    }
                    else
                    {
                        k = WindowState.DEFAULT;
                    }
                }
            }
            this.applyDynamicStyleByState(this, this._currentDynamicStyle, k);
            if (this._children != null)
            {
                this.recursivelyUpdateChildrensDynamicStyles(this._children, k);
            }
        }

        function applyDynamicStyleByState(k:WindowController, _arg_2:DynamicStyle, _arg_3:UInt)
        {
            var _local_5:Array<ASAny> = null;
            var _local_4:ASObject = _arg_2.getStyleByWindowState(_arg_3);
            k.offsetX = ASCompat.toInt(_local_4.offsetX ? ASCompat.toInt(_local_4.offsetX ): 0);
            k.offsetY = ASCompat.toInt(_local_4.offsetY ? ASCompat.toInt(_local_4.offsetY ): 0);
            if (k.hasGraphicsContext())
            {
                k._graphics.getDisplayObject().transform.colorTransform = _arg_2.getColorTransform(_arg_3);
            }
            else
            {
                k._dynamicStyleColorTransform = _arg_2.getColorTransform(_arg_3);
                k.invalidate();
            }
            if (_local_4.etchingPoint)
            {
                _local_5 = [_local_4.etchingColor, _local_4.etchingPoint[0], _local_4.etchingPoint[1]];
                k.etching = _local_5;
                k.invalidate();
            }
            else
            {
                k.etching = [0, 0, 1];
                k.invalidate();
            }
        }

        function recursivelyUpdateChildrensDynamicStyles(k:Vector<IWindow>, _arg_2:UInt)
        {
            var _local_3:WindowController = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = cast(_tmp_, WindowController);
                if (this._currentDynamicStyle.getChildStyle(_local_3) != null)
                {
                    this.applyDynamicStyleByState(_local_3, this._currentDynamicStyle.getChildStyle(_local_3), _arg_2);
                }
                if (_local_3._children != null)
                {
                    this.recursivelyUpdateChildrensDynamicStyles(_local_3._children, _arg_2);
                }
            }
        }

        function notifyEventListeners(k:WindowEvent)
        {
            this.procedure(k, this);
            if (!k.isWindowOperationPrevented())
            {
                if (this.hasEventListener(k.type))
                {
                    this._events.dispatchEvent(k);
                }
            }
        }

        function nullEventProc(k:WindowEvent, _arg_2:IWindow)
        {
        }

        function notifyChildren(k:WindowEvent)
        {
            var _local_2:WindowController = null;
            if (this._children != null)
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    _local_2.update(this, k);
                }
            }
        }

        public function convertPointFromGlobalToLocalSpace(k:Point)
        {
            var _local_2= k.x;
            var _local_3= k.y;
            if (this._parent == null)
            {
                k.x = _x;
                k.y = _y;
            }
            else
            {
                this._parent.getGlobalPosition(k);
                k.x = (k.x + _x);
                k.y = (k.y + _y);
            }
            k.x = (_local_2 - k.x);
            k.y = (_local_3 - k.y);
        }

        public function convertPointFromLocalToGlobalSpace(k:Point)
        {
            var _local_2= k.x;
            var _local_3= k.y;
            if (this._parent == null)
            {
                k.x = _x;
                k.y = _y;
            }
            else
            {
                this._parent.getGlobalPosition(k);
                k.x = (k.x + _x);
                k.y = (k.y + _y);
            }
            k.x = (k.x + _local_2);
            k.y = (k.y + _local_3);
        }

        public function getRelativeMousePosition(k:Point)
        {
            this.getGlobalPosition(k);
            k.x = (_context.getDesktopWindow().mouseX - k.x);
            k.y = (_context.getDesktopWindow().mouseY - k.y);
        }

        public function getAbsoluteMousePosition(k:Point)
        {
            k.x = _context.getDesktopWindow().mouseX;
            k.y = _context.getDesktopWindow().mouseY;
        }

        public function getLocalPosition(k:Point)
        {
            k.x = _x;
            k.y = _y;
        }

        public function getLocalRectangle(k:Rectangle)
        {
            k.x = _x;
            k.y = _y;
            k.width = _w;
            k.height = _h;
        }

        public function hitTestLocalPoint(k:Point):Bool
        {
            return (((k.x >= _x) && (k.x < (_x + _w))) && (k.y >= _y)) && (k.y < (_y + _h));
        }

        public function hitTestLocalRectangle(k:Rectangle):Bool
        {
            return rectangle.intersects(k);
        }

        public function validateLocalPointIntersection(k:Point, _arg_2:BitmapData):Bool
        {
            return this.testLocalPointHitAgainstAlpha(k, _arg_2, _mouseThreshold);
        }

        public function getGlobalPosition(k:Point)
        {
            if (this._parent != null)
            {
                this._parent.getGlobalPosition(k);
                k.x = (k.x + _x);
                k.y = (k.y + _y);
            }
            else
            {
                k.x = _x;
                k.y = _y;
            }
        }

        public function setGlobalPosition(k:Point)
        {
            var _local_2= new Point();
            if (this._parent != null)
            {
                this._parent.getGlobalPosition(_local_2);
                _local_2.x = (_local_2.x + _x);
                _local_2.y = (_local_2.y + _y);
            }
            else
            {
                _local_2.x = _x;
                _local_2.y = _y;
            }
            this.x = Std.int(x + (k.x - _local_2.x));
            this.y = Std.int(y + (k.y - _local_2.y));
        }

        public function getGlobalRectangle(k:Rectangle)
        {
            if (this._parent != null)
            {
                this._parent.getGlobalRectangle(k);
                k.x = (k.x + _x);
                k.y = (k.y + _y);
            }
            else
            {
                k.x = _x;
                k.y = _y;
            }
            k.width = _w;
            k.height = _h;
        }

        public function setGlobalRectangle(k:Rectangle)
        {
            var _local_2= new Point();
            if (this._parent != null)
            {
                this._parent.getGlobalPosition(_local_2);
                _local_2.x = (_local_2.x + _x);
                _local_2.y = (_local_2.y + _y);
            }
            else
            {
                _local_2.x = _x;
                _local_2.y = _y;
            }
            this.setRectangle(Std.int(x + (k.x - _local_2.x)), Std.int(y + (k.y - _local_2.y)), Std.int(k.width), Std.int(k.height));
        }

        public function hitTestGlobalPoint(k:Point):Bool
        {
            var _local_2= new Rectangle();
            this.getGlobalRectangle(_local_2);
            return _local_2.containsPoint(k);
        }

        public function hitTestGlobalRectangle(k:Rectangle):Bool
        {
            var _local_2= new Rectangle();
            this.getGlobalRectangle(_local_2);
            return _local_2.intersects(k);
        }

        public function validateGlobalPointIntersection(k:Point, _arg_2:BitmapData):Bool
        {
            var _local_3= new Point();
            this.getGlobalPosition(_local_3);
            _local_3.x = (k.x - _local_3.x);
            _local_3.y = (k.y - _local_3.y);
            return this.testLocalPointHitAgainstAlpha(_local_3, _arg_2, _mouseThreshold);
        }

        public function getMouseRegion(k:Rectangle)
        {
            var _local_2:Rectangle = null;
            this.getGlobalRectangle(k);
            if (k.width < 0)
            {
                k.width = 0;
            }
            if (k.height < 0)
            {
                k.height = 0;
            }
            if (testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
            {
                _local_2 = new Rectangle();
                this._parent.getMouseRegion(_local_2);
                if (k.left < _local_2.left)
                {
                    k.left = _local_2.left;
                }
                if (k.top < _local_2.top)
                {
                    k.top = _local_2.top;
                }
                if (k.right > _local_2.right)
                {
                    k.right = _local_2.right;
                }
                if (k.bottom > _local_2.bottom)
                {
                    k.bottom = _local_2.bottom;
                }
            }
        }

        function testLocalPointHitAgainstAlpha(k:Point, _arg_2:BitmapData, _arg_3:UInt):Bool
        {
            var _local_5:BitmapData = null;
            var _local_4 = false;
            if (((_w < 1) || (_h < 1)))
            {
                return false;
            }
            if ((this._drawable && (_mouseThreshold > 0)))
            {
                if (!testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
                {
                    if (((k.x <= _w) && (k.y <= _h)))
                    {
                        _local_5 = Std.downcast(this.getGraphicContext(true).fetchDrawBuffer() , BitmapData);
                        if (_local_5 != null)
                        {
                            _local_4 = _local_5.hitTest(_POINT_ZERO, _arg_3, k);
                        }
                    }
                }
                else
                {
                    _local_4 = ((_arg_2 != null) ? _arg_2.hitTest(_POINT_ZERO, _arg_3, k) : false);
                }
            }
            else
            {
                if (((k.x >= 0) && (k.x < _w)))
                {
                    if (((k.y >= 0) && (k.y < _h)))
                    {
                        _local_4 = true;
                    }
                }
            }
            return _local_4;
        }

        public function isCapableOfUsingSharedGraphicContext():Bool
        {
            return true;
        }

        public function resolveVerticalScale():Float
        {
            return _h / _initialRect.height;
        }

        public function resolveHorizontalScale():Float
        {
            return _w / _initialRect.width;
        }

        public function offset(k:Float, _arg_2:Float)
        {
            this.setRectangle(Std.int(_x + k), Std.int(_y + _arg_2), _w, _h);
        }

        public function scale(k:Float, _arg_2:Float)
        {
            this.setRectangle(_x, _y, Std.int(_w + k), Std.int(_h + _arg_2));
        }

        public function scaleToAccommodateChildren()
        {
            var k:IWindow = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:UInt = 0;
            if (this._children == null)
            {
                return;
            }
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = false;
            var _local_7:UInt = (ASCompat.toInt(param )& (ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN)));
            final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.x < _local_2)
                {
                    _local_4 = (_local_4 - (k.x - _local_2));
                    _local_2 = k.x;
                    _local_6 = true;
                }
                if ((k.x + k.width) > _local_4)
                {
                    _local_4 = (k.x + k.width);
                    _local_6 = true;
                }
                if (k.y < _local_3)
                {
                    _local_5 = (_local_5 - (k.y - _local_3));
                    _local_3 = k.y;
                    _local_6 = true;
                }
                if ((k.y + k.height) > _local_5)
                {
                    _local_5 = (k.y + k.height);
                    _local_6 = true;
                }
            }
            if (_local_6)
            {
                _local_8 = [];
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    _local_9 = (ASCompat.toInt(k.param )& (ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER)));
                    k.setParamFlag(_local_9, false);
                    _local_8.push(_local_9);
                }
                if (_local_7 != 0)
                {
                    this.setParamFlag(_local_7, false);
                }
                this.setRectangle((_x + _local_2), (_y + _local_3), _local_4, _local_5);
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.offset(-_local_2, -_local_3);
                    k.setParamFlag(ASCompat.toUInt(_local_8.shift()), true);
                }
                if (_local_7 != 0)
                {
                    this.setParamFlag(_local_7, true);
                }
            }
        }

        public function getStateFlag(k:UInt):Bool
        {
            return !((ASCompat.toInt(_state )& ASCompat.toInt(k)) == 0);
        }

        public function setStateFlag(k:UInt, _arg_2:Bool=true)
        {
            var _local_3= _state;
            _state = (_arg_2 ? (_state = (ASCompat.toInt(_state )| ASCompat.toInt(k))) : (_state = (ASCompat.toInt(_state )& (~ASCompat.toInt(k)))));
            if (_state != _local_3)
            {
                this.renderDynamicStyle();
                _context.invalidate(this, null, WindowRedrawFlag.STATE);
            }
        }

        public function getStyleFlag(k:UInt):Bool
        {
            return !((ASCompat.toInt(_style )& ASCompat.toInt(k)) == 0);
        }

        public function setStyleFlag(k:UInt, _arg_2:Bool=true)
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:UInt = 0;
            var _local_6:WindowController = null;
            var _local_3= _style;
            _style = (_arg_2 ? (_style = (ASCompat.toInt(_style )| ASCompat.toInt(k))) : (_style = (ASCompat.toInt(_style )& (~ASCompat.toInt(k)))));
            if (_style != _local_3)
            {
                _local_4 = new Array<ASAny>();
                this.groupChildrenWithTag(WindowController.TAG_INTERNAL, _local_4);
                _local_5 = _local_4.length;
                while (--_local_5 > -1)
                {
                    _local_6 = ASCompat.dynamicAs(_local_4[ASCompat.toInt(_local_5)] , WindowController);
                    if (_local_6.tags.indexOf(_IGNORE_INHERITED_STYLE) == -1)
                    {
                        _local_6.style = _style;
                    }
                }
                _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            }
        }

        public function getParamFlag(k:UInt):Bool
        {
            return !((ASCompat.toInt(_param )& ASCompat.toInt(k)) == 0);
        }

        public function setParamFlag(k:UInt, _arg_2:Bool=true)
        {
            var _local_3= _param;
            _param = (_arg_2 ? (_param = (ASCompat.toInt(_param )| ASCompat.toInt(k))) : (_param = (ASCompat.toInt(_param )& (~ASCompat.toInt(k)))));
            if (_param != _local_3)
            {
                if (!((ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)) != 0))
                {
                    if (this._graphics == null)
                    {
                        this.setupGraphicsContext();
                        _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
                    }
                }
                else
                {
                    if (((ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)) != 0))
                    {
                        if (this._graphics != null)
                        {
                            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
                        }
                    }
                }
            }
        }

        function updateScaleRelativeToParent()
        {
            var _local_3 = 0;
            var _local_4:UInt = 0;
            var _local_5:UInt = 0;
            if (this._parent == null)
            {
                return;
            }
            var k:ASAny = (!testParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED, WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER));
            var _local_2:ASAny = (!testParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_FIXED, WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER));
            var _local_6= _x;
            var _local_7= _y;
            var _local_8= _w;
            var _local_9= _h;
            if ((ASCompat.toBool(k) || ASCompat.toBool(_local_2)))
            {
                if (k)
                {
                    _local_3 = Std.int(this._parent.width - this._lastParentRect.width);
                    _local_4 = (ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER));
                    if (_local_4 == WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH)
                    {
                        _local_8 = (_local_8 + _local_3);
                    }
                    else
                    {
                        if (_local_4 == WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_MOVE)
                        {
                            _local_6 = (_local_6 + _local_3);
                        }
                        else
                        {
                            if (_local_4 == WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER)
                            {
                                if (((this._parent.width < _local_8) && this.getParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)))
                                {
                                    _local_6 = 0;
                                }
                                else
                                {
                                    _local_6 = Std.int(Math.ffloor((this._parent.width / 2)) - Math.ffloor((_local_8 / 2)));
                                }
                            }
                        }
                    }
                }
                if (_local_2)
                {
                    _local_3 = Std.int(this._parent.height - this._lastParentRect.height);
                    _local_4 = (ASCompat.toInt(_param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER));
                    if (_local_4 == WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH)
                    {
                        _local_9 = (_local_9 + _local_3);
                    }
                    else
                    {
                        if (_local_4 == WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_MOVE)
                        {
                            _local_7 = (_local_7 + _local_3);
                        }
                        else
                        {
                            if (_local_4 == WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER)
                            {
                                if (((this._parent.height < _local_9) && this.getParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)))
                                {
                                    _local_7 = 0;
                                }
                                else
                                {
                                    _local_7 = Std.int(Math.ffloor((this._parent.height / 2)) - Math.ffloor((_local_9 / 2)));
                                }
                            }
                        }
                    }
                }
                _local_5 = _param;
                _param = (ASCompat.toInt(_param )& (~((ASCompat.toInt(WindowParam.WINDOW_PARAM_REFLECT_RESIZE_TO_PARENT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER))));
                this.setRectangle(_local_6, _local_7, _local_8, _local_9);
                _param = _local_5;
            }
            else
            {
                if (testParamFlag(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT))
                {
                    if (this._parent != null)
                    {
                        _local_6 = ((_local_6 < 0) ? 0 : _local_6);
                        _local_7 = ((_local_7 < 0) ? 0 : _local_7);
                        _local_6 = (_local_6 - (((_local_6 + _local_8) > this._parent.width) ? ((_local_6 + _local_8) - this._parent.width) : 0));
                        _local_7 = (_local_7 - (((_local_7 + _local_9) > this._parent.height) ? ((_local_7 + _local_9) - this._parent.height) : 0));
                        _local_8 = (_local_8 - (((_local_6 + _local_8) > this._parent.width) ? ((_local_6 + _local_8) - this._parent.width) : 0));
                        _local_9 = (_local_9 - (((_local_7 + _local_9) > this._parent.height) ? ((_local_7 + _local_9) - this._parent.height) : 0));
                        if (((((!(_local_6 == _x)) || (!(_local_7 == _y))) || (!(_local_8 == _w))) || (!(_local_9 == _h))))
                        {
                            _local_5 = _param;
                            _param = (ASCompat.toInt(_param )& (~((ASCompat.toInt(WindowParam.WINDOW_PARAM_REFLECT_RESIZE_TO_PARENT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER))));
                            this.setRectangle(_local_6, _local_7, _local_8, _local_9);
                            _param = _local_5;
                        }
                    }
                }
            }
        }

        function isChildWindow():Bool
        {
            return !((this._parent : ASAny) == (context.getDesktopWindow() : ASAny));
        }

        public function destroy():Bool
        {
            if (_state == WindowState.DISPOSED)
            {
                return true;
            }
            _state = WindowState.DISPOSED;
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_DESTROY, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_DESTROYED, this, null);
            this.update(this, k);
            k.recycle();
            this.dispose();
            return true;
        }

        public function minimize():Bool
        {
            if (((ASCompat.toInt(_state )& ASCompat.toInt(WindowState.LOCKED)) != 0))
            {
                return false;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_MINIMIZE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.LOCKED, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_MINIMIZED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function maximize():Bool
        {
            if (((ASCompat.toInt(_state )& ASCompat.toInt(WindowState.LOCKED)) != 0))
            {
                return false;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_MAXIMIZE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.LOCKED, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_MAXIMIZED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function restore():Bool
        {
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESTORE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.LOCKED, false);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESTORED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function activate():Bool
        {
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_ACTIVATE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.ACTIVE, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_ACTIVATED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function deactivate():Bool
        {
            if (!this.getStateFlag(WindowState.ACTIVE))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_DEACTIVATE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.ACTIVE, false);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_DEACTIVATED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function lock():Bool
        {
            if (this.getStateFlag(WindowState.LOCKED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_LOCK, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.LOCKED, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_LOCKED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function unlock():Bool
        {
            if (!this.getStateFlag(WindowState.LOCKED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_UNLOCK, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.LOCKED, false);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_UNLOCKED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function enable():Bool
        {
            if (!this.getStateFlag(WindowState.DISABLED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_ENABLE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.DISABLED, false);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_ENABLED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function disable():Bool
        {
            if (this.getStateFlag(WindowState.DISABLED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_DISABLE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.DISABLED, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_DISABLED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function focus():Bool
        {
            if (this.getStateFlag(WindowState.FOCUSED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_FOCUS, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.FOCUSED, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_FOCUSED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function unfocus():Bool
        {
            if (!this.getStateFlag(WindowState.FOCUSED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_UNFOCUS, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            this.setStateFlag(WindowState.FOCUSED, false);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_UNFOCUSED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function getChildUnderPoint(k:Point):IWindow
        {
            var _local_2:Rectangle = null;
            var _local_3 = false;
            var _local_4:IWindow = null;
            var _local_5:UInt = 0;
            if (_visible)
            {
                _local_2 = new Rectangle();
                this.getMouseRegion(_local_2);
                _local_3 = _local_2.containsPoint(k);
                _local_5 = this.numChildren;
                if (_local_3)
                {
                    while (_local_5 > 0)
                    {
                        _local_4 = cast(this._children[ASCompat.toInt(_local_5 - 1)], WindowController).getChildUnderPoint(k);
                        if (_local_4 != null)
                        {
                            return _local_4;
                        }
                        _local_5--;
                    }
                }
                if (this.validateGlobalPointIntersection(k, null))
                {
                    return this;
                }
            }
            return null;
        }

        public function groupChildrenUnderPoint(k:Point, _arg_2:Array<ASAny>)
        {
            var _local_3:WindowController = null;
            if (_visible)
            {
                if (((((k.x >= _x) && (k.x < (_x + _w))) && (k.y >= _y)) && (k.y < (_y + _h))))
                {
                    _arg_2.push(this);
                    if (this._children != null)
                    {
                        k.offset(-_x, -_y);
                        final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_3  = cast(_tmp_, WindowController);
                            _local_3.groupChildrenUnderPoint(k, _arg_2);
                        }
                        k.offset(_x, _y);
                    }
                }
                else
                {
                    if (!_clipping)
                    {
                        if (this._children != null)
                        {
                            k.offset(-_x, -_y);
                            final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_3  = cast(_tmp_, WindowController);
                                _local_3.groupChildrenUnderPoint(k, _arg_2);
                            }
                            k.offset(_x, _y);
                        }
                    }
                }
            }
        }

        public function groupParameterFilteredChildrenUnderPoint(k:Point, _arg_2:Array<ASAny>, _arg_3:UInt=0)
        {
            var _local_4:WindowController = null;
            if (_visible)
            {
                if (((((k.x >= _x) && (k.x < (_x + _w))) && (k.y >= _y)) && (k.y < (_y + _h))))
                {
                    if (((ASCompat.toInt(_param )& ASCompat.toInt(_arg_3)) : UInt) == _arg_3)
                    {
                        _arg_2.push(this);
                    }
                    if (this._children != null)
                    {
                        k.offset(-_x, -_y);
                        final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_4  = cast(_tmp_, WindowController);
                            _local_4.groupParameterFilteredChildrenUnderPoint(k, _arg_2, _arg_3);
                        }
                        k.offset(_x, _y);
                    }
                }
                else
                {
                    if (!_clipping)
                    {
                        if (this._children != null)
                        {
                            k.offset(-_x, -_y);
                            final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_4  = cast(_tmp_, WindowController);
                                _local_4.groupParameterFilteredChildrenUnderPoint(k, _arg_2, _arg_3);
                            }
                            k.offset(_x, _y);
                        }
                    }
                }
            }
        }

        public function addEventListener(k:String, _arg_2:ASFunction, _arg_3:Int=0)
        {
            if (!_disposed)
            {
                if (this._events == null)
                {
                    this._events = new WindowEventDispatcher(this);
                }
                this._events.addEventListener(k, _arg_2, _arg_3);
            }
        }

        public function hasEventListener(k:String):Bool
        {
            return (_disposed || (!(this._events != null))) ? false : this._events.hasEventListener(k);
        }

        public function removeEventListener(k:String, _arg_2:ASFunction)
        {
            if (((!_disposed) && (this._events != null)))
            {
                this._events.removeEventListener(k, _arg_2);
            }
        }

        public var children(get,never):Vector<IWindow>;
public function  get_children():Vector<IWindow>
        {
            return this._children;
        }

        public var numChildren(get,never):Int;
public function  get_numChildren():Int
        {
            return (this._children != null) ? this._children.length : 0;
        }

        public function populate(k:Array<ASAny>)
        {
            var _local_3:WindowController = null;
            var _local_2 = false;
            if (this._children == null)
            {
                this._children = new Vector<IWindow>();
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (((_local_3 != null) && (!((_local_3.parent : ASAny) == (this : ASAny)))))
                {
                    this._children.push(_local_3);
                    _local_3.parent = this;
                    _local_2 = (_local_2 || _local_3.hasGraphicsContext());
                }
            }
            if ((this._forceGraphicContexts || _local_2))
            {
                this.setupGraphicsContext();
            }
        }

        public function addChild(k:IWindow):IWindow
        {
            var _local_2= cast(k, WindowController);
            if (_local_2.parent != null)
            {
                cast(_local_2.parent, WindowController).removeChild(_local_2);
            }
            if (this._children == null)
            {
                this._children = new Vector<IWindow>();
            }
            this._children.push(_local_2);
            _local_2.parent = this;
            if ((this._forceGraphicContexts || _local_2.hasGraphicsContext()))
            {
                this.setupGraphicsContext();
                if ((_local_2.getGraphicContext(true).graphicParent : ASAny) != (this._graphics : ASAny))
                {
                    this._graphics._Str_22175(_local_2.getGraphicContext(true));
                }
            }
            var _local_3= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_ADDED, this, k);
            this.update(this, _local_3);
            _local_3.recycle();
            return k;
        }

        public function addChildAt(k:IWindow, _arg_2:Int):IWindow
        {
            var _local_3= cast(k, WindowController);
            if (_local_3.parent != null)
            {
                cast(_local_3.parent, WindowController).removeChild(_local_3);
            }
            if (this._children == null)
            {
                this._children = new Vector<IWindow>();
            }
            this._children.insertAt(_arg_2, _local_3);
            _local_3.parent = this;
            if ((this._forceGraphicContexts || _local_3.hasGraphicsContext()))
            {
                this.setupGraphicsContext();
                if ((_local_3.getGraphicContext(true).graphicParent : ASAny) != (this._graphics : ASAny))
                {
                    this._graphics._Str_16175(_local_3.getGraphicContext(true), _arg_2);
                }
            }
            var _local_4= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_ADDED, this, k);
            this.update(this, _local_4);
            _local_4.recycle();
            return k;
        }

        public function getChildAt(k:Int):IWindow
        {
            return (this._children != null) ? (((k < this._children.length) && (k > -1)) ? this._children[k] : null) : null;
        }

        public function getChildByID(k:Int):IWindow
        {
            var _local_2:IWindow = null;
            if (this._children != null)
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.id == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public function getChildByName(k:String):IWindow
        {
            var _local_2:IWindow = null;
            if (this._children != null)
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.name == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public function findChildByName(k:String):IWindow
        {
            var _local_2:WindowController = null;
            if (this._children != null)
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    if (_local_2.name == k)
                    {
                        return _local_2;
                    }
                }
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    _local_2 = Std.downcast(_local_2.findChildByName(k) , WindowController);
                    if (_local_2 != null)
                    {
                        return _local_2 ;
                    }
                }
            }
            return null;
        }

        public function getChildByTag(k:String):IWindow
        {
            var _local_2:IWindow = null;
            if (this._children != null)
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.tags.indexOf(k) > -1)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public function findChildByTag(k:String):IWindow
        {
            if (((_tags != null) && (_tags.indexOf(k) > -1)))
            {
                return this;
            }
            var _local_2= cast(this.getChildByTag(k), WindowController);
            if (((_local_2 == null) && (this._children != null)))
            {
                final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = cast(_tmp_, WindowController);
                    _local_2 = Std.downcast(_local_2.findChildByTag(k) , WindowController);
                    if (_local_2 != null) break;
                }
            }
            return _local_2 ;
        }

        public function getChildIndex(k:IWindow):Int
        {
            return (this._children != null) ? this._children.indexOf(k) : -1;
        }

        public function removeChild(k:IWindow):IWindow
        {
            if (this._children == null)
            {
                return null;
            }
            var _local_2= this._children.indexOf(k);
            if (_local_2 < 0)
            {
                return null;
            }
            this._children.splice(_local_2, 1);
            k.parent = null;
            var _local_3= ASCompat.reinterpretAs(k , IGraphicContextHost);
            if (((_local_3 != null) && _local_3.hasGraphicsContext()))
            {
                this._graphics._Str_17938(_local_3.getGraphicContext(true));
            }
            var _local_4= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_REMOVED, this, k);
            this.update(this, _local_4);
            _local_4.recycle();
            return k;
        }

        public function removeChildAt(k:Int):IWindow
        {
            return this.removeChild(this.getChildAt(k));
        }

        public function setChildIndex(k:IWindow, _arg_2:Int)
        {
            var _local_4:WindowController = null;
            if (this._children == null)
            {
                return;
            }
            var _local_3= this._children.indexOf(k);
            if (((_local_3 > -1) && (!(_arg_2 == _local_3))))
            {
                this._children.splice(_local_3, 1);
                this._children.insertAt(_arg_2, k);
                _local_4 = cast(k, WindowController);
                if (_local_4.hasGraphicsContext())
                {
                    this._graphics._Str_19243(_local_4.getGraphicContext(true), this.getChildIndex(_local_4));
                }
            }
        }

        public function swapChildren(k:IWindow, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:IWindow = null;
            var _local_6 = 0;
            if (this._children == null)
            {
                return;
            }
            if ((((!(k == null)) && (!(_arg_2 == null))) && (!(k == _arg_2))))
            {
                _local_3 = this._children.indexOf(k);
                if (_local_3 < 0)
                {
                    return;
                }
                _local_4 = this._children.indexOf(_arg_2);
                if (_local_4 < 0)
                {
                    return;
                }
                if (_local_4 < _local_3)
                {
                    _local_5 = k;
                    k = _arg_2;
                    _arg_2 = _local_5;
                    _local_6 = _local_3;
                    _local_3 = _local_4;
                    _local_4 = _local_6;
                }
                this._children.splice(_local_4, 1);
                this._children.splice(_local_3, 1);
                this._children.insertAt(_local_3, _arg_2);
                this._children.insertAt(_local_4, k);
                if ((cast(k, WindowController).hasGraphicsContext() || cast(_arg_2, WindowController).hasGraphicsContext()))
                {
                    this._graphics._Str_20742(cast(k, WindowController).getGraphicContext(true), cast(_arg_2, WindowController).getGraphicContext(true));
                }
            }
        }

        public function swapChildrenAt(k:Int, _arg_2:Int)
        {
            if (this._children == null)
            {
                return;
            }
            this.swapChildren(this._children[k], this._children[_arg_2]);
            this._graphics._Str_21032(k, _arg_2);
        }

        public function groupChildrenWithID(k:UInt, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            var _local_4:WindowController = null;
            if (this._children == null)
            {
                return 0;
            }
            var _local_5:UInt = 0;
            final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = cast(_tmp_, WindowController);
                if ((_local_4.id : UInt) == k)
                {
                    _arg_2.push(_local_4);
                    _local_5++;
                }
                if (((_arg_3 > 0) || (_arg_3 < 0)))
                {
                    _arg_3--;
                    _local_5 = (_local_5 + _local_4.groupChildrenWithID(k, _arg_2, _arg_3));
                }
            }
            return _local_5;
        }

        public function groupChildrenWithTag(k:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            var _local_4:WindowController = null;
            if (this._children == null)
            {
                return 0;
            }
            var _local_5:UInt = 0;
            final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = cast(_tmp_, WindowController);
                if (_local_4.tags.indexOf(k) > -1)
                {
                    _arg_2.push(_local_4);
                    _local_5++;
                }
                if (((_arg_3 > 0) || (_arg_3 < 0)))
                {
                    _local_5 = (_local_5 + _local_4.groupChildrenWithTag(k, _arg_2, (_arg_3 - 1)));
                }
            }
            return _local_5;
        }

        public function findParentByName(k:String):IWindow
        {
            if (_name == k)
            {
                return this;
            }
            if (this._parent != null)
            {
                if (this._parent.name == k)
                {
                    return this._parent;
                }
                return this._parent.findParentByName(k);
            }
            return null;
        }

        function requiresOwnGraphicContext():Bool
        {
            var k:WindowController = null;
            if (testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
            {
                if (this._children != null)
                {
                    final _iter_ = this._children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
k  = cast(_tmp_, WindowController);
                        if (k.requiresOwnGraphicContext())
                        {
                            return true;
                        }
                    }
                }
                return false;
            }
            return true;
        }

        public function createProperty(k:String, _arg_2:ASObject):PropertyStruct
        {
            var property= this._propertyDefaults.get(k);
            if (property != null)
            {
                return property.withValue(_arg_2);
            }
            return createAdHocProperty(k, _arg_2);
        }

        public function getDefaultProperty(k:String):PropertyStruct
        {
            return this._propertyDefaults.get(k);
        }

        public function isEnabled():Bool
        {
            return !this.getStateFlag(WindowState.DISABLED);
        }

        static function createAdHocProperty(k:String, value:ASObject):PropertyStruct
        {
            var type= PropertyStruct.STRING;
            if (Std.is(value , Bool))
            {
                type = PropertyStruct.BOOLEAN;
            }
            else if (Std.is(value , Int))
            {
                type = PropertyStruct.INT;
            }
            else if (com.sulake.core.utils.ASNumericType.isUInt(value ))
            {
                type = PropertyStruct.UINT;
            }
            else if (Std.is(value , Float))
            {
                type = PropertyStruct.NUMBER;
            }
            else if (Std.is(value , Array))
            {
                type = PropertyStruct.ARRAY;
            }
            else if (Std.is(value , Point))
            {
                type = PropertyStruct.POINT;
            }
            else if (Std.is(value , Rectangle))
            {
                type = PropertyStruct.RECTANGLE;
            }
            else if (Std.is(value , Map))
            {
                type = PropertyStruct.MAP;
            }
            return new PropertyStruct(k, value, type, true);
        }

        public function enableChildren(k:Bool, _arg_2:Array<ASAny>)
        {
            var _local_3:String = null;
            var _local_4:IWindow = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                _local_4 = this.findChildByName(_local_3);
                if (_local_4 != null)
                {
                    if (k)
                    {
                        _local_4.enable();
                    }
                    else
                    {
                        _local_4.disable();
                    }
                }
            }
        }

        public function activateChildren(k:Bool, _arg_2:Array<ASAny>)
        {
            var _local_3:String = null;
            var _local_4:IWindow = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                _local_4 = this.findChildByName(_local_3);
                if (_local_4 != null)
                {
                    if (k)
                    {
                        _local_4.activate();
                    }
                    else
                    {
                        _local_4.deactivate();
                    }
                }
            }
        }

        public function setVisibleChildren(k:Bool, _arg_2:Array<ASAny>)
        {
            var _local_3:String = null;
            var _local_4:IWindow = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                _local_4 = this.findChildByName(_local_3);
                if (_local_4 != null)
                {
                    _local_4.visible = k;
                }
            }
        }
public function  set_immediateClickMode(k:Bool):Bool        {
            var _local_2:IGraphicContext = null;
            if (k != this._immediateClickMode)
            {
                this._immediateClickMode = k;
                _local_2 = this.getGraphicContext(false);
                if (_local_2 != null)
                {
                    if (this._immediateClickMode)
                    {
                        _local_2.mouse = true;
                        _local_2.addEventListener(MouseEvent.CLICK, this.immediateClickHandler);
                    }
                    else
                    {
                        _local_2.mouse = false;
                        _local_2.removeEventListener(MouseEvent.CLICK, this.immediateClickHandler);
                    }
                }
            }
return k;
        }

        function immediateClickHandler(k:Event)
        {
            var _local_6:IWindow = null;
            var _local_2= Std.downcast(k , MouseEvent);
            var _local_3= this.desktop.getDisplayObject().globalToLocal(new Point(_local_2.stageX, _local_2.stageY));
            var _local_4:Array<ASAny> = [];
            this.desktop.groupChildrenUnderPoint(_local_3, _local_4);
            while (_local_4.length > 0)
            {
                _local_6 = _local_4.pop();
                if ((_local_6 : ASAny) == (this : ASAny)) break;
                if (_local_6.getParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR))
                {
                    return;
                }
            }
            this.getRelativeMousePosition(_local_3);
            var _local_5:WindowEvent = WindowMouseEvent.allocate(WindowMouseEvent.CLICK, this, null, _local_3.x, _local_3.y, _local_2.stageX, _local_2.stageY, _local_2.altKey, _local_2.ctrlKey, _local_2.shiftKey, _local_2.buttonDown, _local_2.delta);
            if (this._events != null)
            {
                this._events.dispatchEvent(_local_5);
            }
            if (!_local_5.isWindowOperationPrevented())
            {
                if (this.procedure != null)
                {
                    this.procedure(_local_5, this);
                }
            }
            k.stopImmediatePropagation();
            _local_5.recycle();
        }
    }

