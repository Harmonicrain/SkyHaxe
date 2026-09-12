package com.sulake.core.window.graphics
;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.geom.Point;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.utils.IChildWindowHost;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.IWindowContext;
    import com.sulake.core.window.events.WindowDisposeEvent;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import flash.display.BitmapData;

     class WindowRenderer implements IWindowRenderer 
    {
        static final _Str_6670:Rectangle = new Rectangle();
        static inline final _Str_18683= 3;
        static inline final _Str_13499= 10;

        var _debug:Bool = false;
        var _disposed:Bool = false;
        var _Str_3102:ISkinContainer;
        var _Str_3892:ASDictionary<ASAny,ASAny>;
        var _Str_5929:Vector<IWindow>;
        var _Str_6641:Vector<Array<ASAny>>;
        var _Str_9736:Point;
        var _Str_15784:Rectangle;
        var _Str_2873:Rectangle;
        var _Str_9131:Rectangle;

        public function new(k:ISkinContainer)
        {
            this._disposed = false;
            this._Str_3102 = k;
            this._Str_3892 = new ASDictionary<ASAny,ASAny>(false);
            this._Str_5929 = new Vector<IWindow>();
            this._Str_6641 = new Vector<Array<ASAny>>();
            this._Str_9736 = new Point();
            this._Str_15784 = new Rectangle();
            this._Str_2873 = new Rectangle();
            this._Str_9131 = new Rectangle();
        }

        static function _Str_26210(k:Rectangle, _arg_2:Rectangle, _arg_3:UInt):Bool
        {
            if (k.intersects(_arg_2))
            {
                return true;
            }
            return (((k.left > _arg_2.left) ? (k.left - _arg_2.right) : (_arg_2.left - k.right)) <= _arg_3) && (((k.top > _arg_2.top) ? (k.top - _arg_2.bottom) : (_arg_2.top - k.bottom)) <= _arg_3);
        }

        static function _Str_20870(k:IWindow, _arg_2:Rectangle, _arg_3:Point, _arg_4:Rectangle):Bool
        {
            var _local_6 = 0;
            var _local_5= true;
            _arg_4.x = 0;
            _arg_4.y = 0;
            _arg_4.width = k.renderingWidth;
            _arg_4.height = k.renderingHeight;
            if (!k.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
            {
                if (((k.parent != null) && k.testParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING)))
                {
                    _local_5 = _Str_9519(k.parent, _arg_3, _arg_4);
                    _arg_3.x = _arg_4.x;
                    _arg_3.y = _arg_4.y;
                }
                else
                {
                    _arg_3.x = 0;
                    _arg_3.y = 0;
                }
            }
            else
            {
                if (k.parent != null)
                {
                    _local_5 = _Str_9519(k.parent, _arg_3, _arg_4);
                }
                else
                {
                    _arg_3.x = 0;
                    _arg_3.y = 0;
                }
            }
            if (_arg_2.x > _arg_4.x)
            {
                _local_6 = Std.int(_arg_2.x - _arg_4.x);
                _arg_3.x = (_arg_3.x + _local_6);
                _arg_4.x = (_arg_4.x + _local_6);
                _arg_4.width = (_arg_4.width - _local_6);
            }
            if (_arg_2.y > _arg_4.y)
            {
                _local_6 = Std.int(_arg_2.y - _arg_4.y);
                _arg_3.y = (_arg_3.y + _local_6);
                _arg_4.y = (_arg_4.y + _local_6);
                _arg_4.height = (_arg_4.height - _local_6);
            }
            if (_arg_2.right < _arg_4.right)
            {
                _local_6 = Std.int(_arg_4.right - _arg_2.right);
                _arg_4.width = (_arg_4.width - _local_6);
            }
            if (_arg_2.bottom < _arg_4.bottom)
            {
                _local_6 = Std.int(_arg_4.bottom - _arg_2.bottom);
                _arg_4.height = (_arg_4.height - _local_6);
            }
            return (_local_5 && (_arg_4.width > 0)) && (_arg_4.height > 0);
        }

        static function _Str_9519(k:IWindow, _arg_2:Point, _arg_3:Rectangle):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            if (k.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
            {
                _local_5 = k.renderingX;
                _local_6 = k.renderingY;
                _arg_2.offset(_local_5, _local_6);
                if (k.clipping)
                {
                    if (_arg_2.x < _local_5)
                    {
                        _local_4 = Std.int(_local_5 - _arg_2.x);
                        _arg_3.x = (_arg_3.x + _local_4);
                        _arg_3.width = (_arg_3.width - _local_4);
                        _arg_2.x = _local_5;
                    }
                    if (_arg_2.x < 0)
                    {
                        _arg_3.x = (_arg_3.x - _arg_2.x);
                        _arg_3.width = (_arg_3.width + _arg_2.x);
                        _arg_2.x = 0;
                    }
                    if (_arg_2.y < _local_6)
                    {
                        _local_4 = Std.int(_local_6 - _arg_2.y);
                        _arg_3.y = (_arg_3.y + _local_4);
                        _arg_3.height = (_arg_3.height - _local_4);
                        _arg_2.y = _local_6;
                    }
                    if (_arg_2.y < 0)
                    {
                        _arg_3.y = (_arg_3.y - _arg_2.y);
                        _arg_3.height = (_arg_3.height + _arg_2.y);
                        _arg_2.y = 0;
                    }
                    if ((_arg_2.x + _arg_3.width) > (_local_5 + k.renderingWidth))
                    {
                        _arg_3.width = (_arg_3.width - ((_arg_2.x + _arg_3.width) - (_local_5 + k.renderingWidth)));
                    }
                    if ((_arg_2.y + _arg_3.height) > (_local_6 + k.renderingHeight))
                    {
                        _arg_3.height = (_arg_3.height - ((_arg_2.y + _arg_3.height) - (_local_6 + k.renderingHeight)));
                    }
                }
                if (k.parent != null)
                {
                    _Str_9519(k.parent, _arg_2, _arg_3);
                }
            }
            else
            {
                if (k.clipping)
                {
                    if (_arg_2.x < 0)
                    {
                        _local_4 = Std.int(_arg_2.x);
                        _arg_3.x = (_arg_3.x - _local_4);
                        _arg_3.width = (_arg_3.width + _local_4);
                        _arg_2.x = 0;
                    }
                    if (_arg_2.y < 0)
                    {
                        _local_4 = Std.int(_arg_2.y);
                        _arg_3.y = (_arg_3.y - _local_4);
                        _arg_3.height = (_arg_3.height + _local_4);
                        _arg_2.y = 0;
                    }
                }
            }
            return (_arg_3.width > 0) && (_arg_3.height > 0);
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var debug(get,set):Bool;
public function  set_debug(k:Bool):Bool        {
            return this._debug = k;
        }
public function  get_debug():Bool
        {
            return this._debug;
        }

        public function dispose()
        {
var k:ASObject  = null;            var k:ASObject = null;
            var _local_2:WindowRendererItem = null;
            if (!this._disposed)
            {
                this._disposed = true;
                final _iter_ = this._Str_3892; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    _local_2 = ASCompat.dynamicAs(this._Str_3892[k] , WindowRendererItem);
                    _local_2.dispose();
                    this._Str_3892.remove(k);
                }
                this._Str_3892 = null;
                this._Str_5929 = null;
                this._Str_6641 = null;
            }
        }

        public function purge(k:IWindow=null, _arg_2:Bool=true)
        {
var _local_6:ASObject  = null;            var _local_3:IChildWindowHost = null;
            var _local_4:WindowRendererItem = null;
            var _local_5:Vector<IWindow> = null;
            var _local_6:ASObject = null;
            if (k != null)
            {
                if (((!k.visible) || (!_arg_2)))
                {
                    _local_4 = this._Str_3892[k];
                    if (_local_4 != null)
                    {
                        _local_4.dispose();
                        this._Str_3892.remove(k);
                    }
                    _arg_2 = false;
                }
                _local_3 = ASCompat.reinterpretAs(k , IChildWindowHost);
                if (_local_3 != null)
                {
                    final _iter_ = _local_3.children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
k  = _tmp_;
                        this.purge(k, _arg_2);
                    }
                }
            }
            else
            {
                _local_5 = new Vector<IWindow>();
                final _iter_ = this._Str_3892; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
_local_6 = _tmp_;
                    k = ASCompat.dynamicAs(_local_6 , IWindow);
                    if ((((!k.visible) || (!_arg_2)) || ((k.parent == null) && (!Std.is(k , IDesktopWindow)))))
                    {
                        _local_5.push(k);
                    }
                }
                while (_local_5.length != 0)
                {
                    this.purge(_local_5.pop(), _arg_2);
                }
            }
        }

        public function _Str_18389(k:IWindow, _arg_2:Rectangle, _arg_3:UInt)
        {
            var _local_4 = 0;
            var _local_5:Array<ASAny> = null;
            var _local_6:IWindow = null;
            var _local_7:IDesktopWindow = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10:Rectangle = null;
            var _local_11:Rectangle = null;
            var _local_12 = 0;
            if (_arg_2 == null)
            {
                _arg_2 = this._Str_2873;
                this._Str_2873.x = 0;
                this._Str_2873.y = 0;
                this._Str_2873.width = k.renderingWidth;
                this._Str_2873.height = k.renderingHeight;
            }
            else
            {
                this._Str_2873.x = _arg_2.x;
                this._Str_2873.y = _arg_2.y;
                this._Str_2873.width = _arg_2.width;
                this._Str_2873.height = _arg_2.height;
            }
            if (_arg_2.isEmpty())
            {
                return;
            }
            if (this._Str_16090(k).invalidate(k, _arg_3))
            {
                if ((k.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT) || k.testParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING)))
                {
                    _local_7 = k.context.getDesktopWindow();
                    while (true)
                    {
                        _local_6 = k.parent;
                        if (_local_6 == null)
                        {
                            return;
                        }
                        if ((_local_6 : ASAny) == (_local_7 : ASAny)) break;
                        if (!_local_6.visible)
                        {
                            return;
                        }
                        _local_8 = _local_6.renderingWidth;
                        _local_9 = _local_6.renderingHeight;
                        this._Str_2873.offset(k.renderingX, k.renderingY);
                        if (_local_6.clipping)
                        {
                            if (((((this._Str_2873.x > _local_8) || (this._Str_2873.y > _local_9)) || (this._Str_2873.right < 0)) || (this._Str_2873.bottom < 0)))
                            {
                                return;
                            }
                            if (this._Str_2873.x < 0)
                            {
                                this._Str_2873.width = (this._Str_2873.width + this._Str_2873.x);
                                this._Str_2873.x = 0;
                            }
                            if (this._Str_2873.y < 0)
                            {
                                this._Str_2873.height = (this._Str_2873.height + this._Str_2873.y);
                                this._Str_2873.y = 0;
                            }
                            if (this._Str_2873.right > _local_8)
                            {
                                this._Str_2873.right = _local_8;
                            }
                            if (this._Str_2873.bottom > _local_9)
                            {
                                this._Str_2873.bottom = _local_9;
                            }
                        }
                        if (this._Str_2873.isEmpty())
                        {
                            return;
                        }
                        k = _local_6;
                        if (((!k.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)) && (!k.testParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING))))
                        {
                            break;
                        }
                    }
                }
                this._Str_16090(k).invalidate(k, WindowRedrawFlag.CASCADE);
                _local_4 = this._Str_5929.indexOf(k);
                if (_local_4 > -1)
                {
                    _local_5 = this._Str_6641[_local_4];
                    _local_10 = this._Str_2873;
                    _local_12 = _local_5.length;
                    if (_local_12 > _Str_18683)
                    {
                        _local_10 = _local_10.union(_local_5.pop());
                        _local_12--;
                    }
                    _local_4 = 0;
                    while (_local_4 < _local_12)
                    {
                        _local_11 = _local_5[_local_4++];
                        if (((((_local_11.left > _local_10.left) ? (_local_11.left - _local_10.right) : (_local_10.left - _local_11.right)) <= _Str_13499) && (((_local_11.top > _local_10.top) ? (_local_11.top - _local_10.bottom) : (_local_10.top - _local_11.bottom)) <= _Str_13499)))
                        {
                            _local_5.splice((_local_4 - 1), 1);
                            _local_10 = _local_10.union(_local_11);
                            _local_12--;
                            _local_4 = 0;
                        }
                    }
                    _local_5.push(((_local_10 == this._Str_2873) ? _local_10.clone() : _local_10));
                }
                else
                {
                    this._Str_5929.push(k);
                    this._Str_6641.push([this._Str_2873.clone()]);
                }
            }
        }

        public function _Str_22792()
        {
            if (((this._Str_5929.length != 0) || (this._Str_6641.length != 0)))
            {
                this._Str_5929.splice(0, this._Str_5929.length);
                this._Str_6641.splice(0, this._Str_6641.length);
            }
        }

        public function invalidate(k:IWindowContext, _arg_2:Rectangle)
        {
            var _local_5:IWindow = null;
            var _local_3= k.getDesktopWindow();
            var _local_4:UInt = _local_3.numChildren;
            while (_local_4-- > 0)
            {
                _local_5 = _local_3.getChildAt(ASCompat.toInt(_local_4));
                this._Str_18389(_local_5, null, WindowRedrawFlag.REDRAW);
            }
        }

        function _Str_16090(k:IWindow):WindowRendererItem
        {
            var _local_2= ASCompat.dynamicAs(this._Str_3892[k] , WindowRendererItem);
            if (_local_2 == null)
            {
                this._Str_24507(k);
                _local_2 = this._Str_3892[k];
            }
            return _local_2;
        }

        public function _Str_24507(k:IWindow)
        {
            var _local_2= ASCompat.dynamicAs(this._Str_3892[k] , WindowRendererItem);
            if (_local_2 == null)
            {
                _local_2 = new WindowRendererItem(this._Str_3102);
                this._Str_3892[k] = _local_2;
                k.addEventListener(WindowDisposeEvent.DISPOSED, this._Str_21915);
            }
        }

        public function _Str_23836(k:IWindow)
        {
            k.removeEventListener(WindowDisposeEvent.DISPOSED, this._Str_21915);
            var _local_2= ASCompat.dynamicAs(this._Str_3892[k] , WindowRendererItem);
            if (_local_2 != null)
            {
                _local_2.dispose();
                this._Str_3892.remove(k);
            }
        }

        function _Str_21915(k:WindowDisposeEvent)
        {
            this._Str_23836(k.window);
        }

        public function _Str_19855(k:IWindow):BitmapData
        {
            var _local_3:Rectangle = null;
            var _local_4:TrackedBitmapData = null;
            var _local_2= ASCompat.dynamicAs(this._Str_3892[k] , WindowRendererItem);
            if (_local_2 == null)
            {
                _local_3 = new Rectangle(0, 0, k.renderingWidth, k.renderingHeight);
                _local_4 = new TrackedBitmapData(this, k.renderingWidth, k.renderingHeight);
                _local_2 = new WindowRendererItem(this._Str_3102);
                _local_2.invalidate(k, WindowRedrawFlag.REDRAW);
                _local_2.render(k, new Point(), _local_3, k.renderingRectangle, _local_4);
                _local_4.dispose();
                this._Str_3892[k] = _local_2;
            }
            return (_local_2 != null) ? _local_2.buffer : null;
        }

        public function render()
        {
            var k:IWindow = null;
            var _local_2:Rectangle = null;
            var _local_3:Array<ASAny> = null;
            var _local_5:BitmapData = null;
            var _local_4:UInt = this._Str_5929.length;
            while (_local_4-- > 0)
            {
                k = this._Str_5929.pop();
                _local_3 = this._Str_6641.pop();
                if (!k.disposed)
                {
                    _local_5 = Std.downcast(k.fetchDrawBuffer() , BitmapData);
                    if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                    {
_local_2  = _tmp_;
                        this._Str_9131.x = k.renderingX;
                        this._Str_9131.y = k.renderingY;
                        this._Str_9131.width = k.renderingWidth;
                        this._Str_9131.height = k.renderingHeight;
                        this._Str_17598(k, _local_2, this._Str_9131, _local_5);
                    }
                }
            }
        }

        function _Str_17598(k:IWindow, _arg_2:Rectangle, _arg_3:Rectangle, _arg_4:BitmapData)
        {
            var _local_6:Vector<IWindow> = null;
            var _local_7:IWindow = null;
            var _local_8:IGraphicContextHost = null;
            var _local_5= cast(k, IGraphicContextHost).getGraphicContext(false);
            if (_local_5 != null)
            {
                _local_5.visible = k.visible;
            }
            if (k.visible)
            {
                this._Str_9736.x = k.renderingX;
                this._Str_9736.y = k.renderingY;
                if (_Str_20870(k, _arg_2, this._Str_9736, this._Str_15784))
                {
                    if (k.clipping)
                    {
                        _arg_3 = _arg_3.intersection(k.renderingRectangle);
                    }
                    _arg_3.offset(-k.x, -k.y);
                    _arg_4 = this._Str_16090(k).render(k, this._Str_9736, this._Str_15784, _arg_3, _arg_4);
                    if (!Std.is(k , IChildWindowHost))
                    {
                        return;
                    }
                    _local_6 = cast(k, IChildWindowHost).children;
                    if (_local_6 == null)
                    {
                        return;
                    }
                    if (k.clipping)
                    {
                        _arg_2 = _arg_2.clone();
                        if (_arg_2.x < 0)
                        {
                            _arg_2.width = (_arg_2.width + _arg_2.x);
                            _arg_2.x = 0;
                        }
                        if (_arg_2.y < 0)
                        {
                            _arg_2.height = (_arg_2.height + _arg_2.y);
                            _arg_2.y = 0;
                        }
                        if (_arg_2.width > k.width)
                        {
                            _arg_2.width = k.renderingWidth;
                        }
                        if (_arg_2.height > k.height)
                        {
                            _arg_2.height = k.renderingHeight;
                        }
                    }
                    if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                    {
_local_7  = _tmp_;
                        _Str_6670.x = _local_7.x;
                        _Str_6670.y = _local_7.y;
                        _Str_6670.width = _local_7.width;
                        _Str_6670.height = _local_7.height;
                        if (_Str_6670.intersects(_arg_2))
                        {
                            if (_local_7.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
                            {
                                _arg_2.offset(-_local_7.x, -_local_7.y);
                                this._Str_17598(_local_7, _arg_2, _arg_3, _arg_4);
                                _arg_2.offset(_local_7.x, _local_7.y);
                            }
                            else
                            {
                                if (_local_7.testParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING))
                                {
                                    _arg_2.offset(-_local_7.x, -_local_7.y);
                                    this._Str_17598(_local_7, _arg_2, _arg_3, Std.downcast(_local_7.fetchDrawBuffer() , BitmapData));
                                    _arg_2.offset(_local_7.x, _local_7.y);
                                }
                                else
                                {
                                    if (_local_7.visible)
                                    {
                                        _local_8 = cast(_local_7, IGraphicContextHost);
                                        if (_local_8.hasGraphicsContext())
                                        {
                                            _local_8.getGraphicContext(true).visible = true;
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (!_Str_6670.intersects(_arg_3))
                            {
                                _local_8 = cast(_local_7, IGraphicContextHost);
                                if (_local_8.hasGraphicsContext())
                                {
                                    _local_8.getGraphicContext(true).visible = false;
                                }
                            }
                        }
                    }
                    _arg_3.offset(k.renderingX, k.renderingY);
                }
                else
                {
                    if (!k.testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT))
                    {
                        if (k.testParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING))
                        {
                            if (_local_5 == null)
                            {
                                _local_5 = cast(k, IGraphicContextHost).getGraphicContext(true);
                            }
                            _local_5._Str_15334(k.renderingRectangle, false, this._Str_15784);
                            _local_5.visible = false;
                        }
                    }
                }
            }
        }
    }
