package com.sulake.habbo.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window._enum.WindowState;

     class _Str_3942 implements IDisposable 
    {
        public static inline final _Str_22156= 0;
        public static inline final _Str_22144= 1;
        public static inline final _Str_20404= 2;

        var _window:IWindow;
        var _Str_4242:IDesktopWindow;
        var _disposed:Bool = false;
        var _Str_14954:ASFunction;
        var _Str_8663:ASFunction;

        public function new(k:IWindow, _arg_2:IDesktopWindow, _arg_3:ASFunction=null, _arg_4:ASFunction=null)
        {
            this._window = k;
            this._Str_4242 = _arg_2;
            this._Str_14954 = _arg_3;
            this._Str_8663 = _arg_4;
        }

        public static function _Str_9211(k:IWindow):Bool
        {
            var _local_7:IWindow = null;
            var _local_2= k.desktop;
            var _local_3= _local_2.numChildren;
            var _local_4= _local_2.getChildIndex(k);
            if (_local_4 < 0)
            {
                throw new ASError("Window must be contained by the desktop!");
            }
            var _local_5= new Rectangle();
            k.getGlobalRectangle(_local_5);
            var _local_6= new Rectangle();
            var _local_8= (_local_4 + 1);
            while (_local_8 < _local_3)
            {
                _local_7 = _local_2.getChildAt(_local_8);
                if (_local_7.visible)
                {
                    _local_7.getGlobalRectangle(_local_6);
                    if (_local_5.intersects(_local_6))
                    {
                        return true;
                    }
                }
                _local_8++;
            }
            return false;
        }


        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return ((this._window != null) && this._window.visible) && (this._window.parent != null);
        }

        public var active(get,never):Bool;
public function  get_active():Bool
        {
            return this.visible && this._window.getStateFlag(WindowState.ACTIVE);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
                this._Str_4242 = null;
                this._disposed = true;
                this._Str_14954 = null;
                this._Str_8663 = null;
            }
        }

        public function show()
        {
            if (!this._window.disposed)
            {
                if ((this._window.parent : ASAny) != (this._Str_4242 : ASAny))
                {
                    this._Str_4242.addChild(this._window);
                }
                if (!this._window.visible)
                {
                    this._window.visible = true;
                }
                this._window.activate();
            }
        }

        public function hide()
        {
            if (!this._window.disposed)
            {
                if ((this._window.parent : ASAny) == (this._Str_4242 : ASAny))
                {
                    this._Str_4242.removeChild(this._window);
                }
                if (this._window.visible)
                {
                    this._window.visible = false;
                }
                this._window.deactivate();
            }
        }

        public function toggle()
        {
            if (this.visible)
            {
                if (this.active)
                {
                    if ((this._Str_8663 == null))
                    {
                        this.hide();
                    }
                    else
                    {
                        this._Str_8663();
                    }
                }
                else
                {
                    if (_Str_9211(this._window))
                    {
                        this._window.activate();
                    }
                    else
                    {
                        if ((this._Str_8663 == null))
                        {
                            this.hide();
                        }
                        else
                        {
                            this._Str_8663();
                        }
                    }
                }
            }
            else
            {
                if ((this._Str_14954 == null))
                {
                    this.show();
                }
                else
                {
                    this._Str_14954();
                }
            }
        }
    }

