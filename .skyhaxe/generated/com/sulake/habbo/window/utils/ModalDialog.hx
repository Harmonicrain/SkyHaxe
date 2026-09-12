package com.sulake.habbo.window.utils
;
    import flash.geom.ColorTransform;
    import flash.display.Stage;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import com.sulake.core.window.IWindowContext;
    import com.sulake.core.window.components.IDesktopWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.WindowController;
    import flash.geom.Matrix;
    import com.sulake.habbo.utils.HabboWebTools;

     class ModalDialog implements IModalDialog
    {
        static inline final _Str_4923= 3;
        static final _Str_5846:ColorTransform = new ColorTransform(0.25, 0.25, 0.25);
        static var _Str_2691:Stage = null;
        static var _windowManager:HabboWindowManagerComponent;
        static var _container:IWindowContainer;
        static var _Str_7821:Int = 0;

        var _disposed:Bool = false;
        var _Str_7545:IWindow;
        var _background:IBitmapWrapperWindow;

        public function new(k:HabboWindowManagerComponent, _arg_2:com.sulake.core.utils.xml.XML)
        {
            _Str_22219(k);
            this._background = Std.downcast(_Str_20664.create("", "", WindowType.WINDOW_TYPE_BITMAP_WRAPPER, 0, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, new Rectangle(0, 0, 1, 1), null, _container, 0) , IBitmapWrapperWindow);
            this._Str_7545 = _windowManager.buildFromXML(_arg_2, _Str_4923);
            _container.addChild(this._Str_7545);
            this._Str_7545.center();
            _container.visible = true;
            refresh();
        }

        static function _Str_22219(k:HabboWindowManagerComponent)
        {
            if (((_windowManager != null) && (_windowManager != k)))
            {
                resetStaticState();
            }
            if (_Str_2691 == null)
            {
                _windowManager = k;
                _Str_2691 = _windowManager.context.displayObjectContainer.stage;
                _container = Std.downcast(_Str_20664.create("", "", WindowType.WINDOW_TYPE_CONTAINER, 0, 0, new Rectangle(0, 0, 1, 1), null, null, 0) , IWindowContainer);
                _Str_2691.addEventListener(Event.RESIZE, (onResize : ASAny));
                _Str_2691.addEventListener(Event.ENTER_FRAME, (_Str_749 : ASAny));
            }
        }

        public static function resetStaticState()
        {
            if (_Str_2691 != null)
            {
                _Str_2691.removeEventListener(Event.RESIZE, (onResize : ASAny));
                _Str_2691.removeEventListener(Event.ENTER_FRAME, (_Str_749 : ASAny));
            }
            if (_container != null)
            {
                try
                {
                    _container.dispose();
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
            _Str_2691 = null;
            _windowManager = null;
            _container = null;
            _Str_7821 = 0;
        }

        static var _Str_20664(get,never):IWindowContext;
static function  get__Str_20664():IWindowContext
        {
            return _windowManager.getWindowContext(_Str_4923);
        }

        static function refresh()
        {
            var i = 0;
            var desktop:IDesktopWindow = null;
            var child:IWindow = null;
            var context:IWindowContext = null;
            var wrapper:IBitmapWrapperWindow = null;
            var window:IWindow = null;
            var hasLoginBackground = false;
            if (_container == null)
            {
                return;
            }
            var noModalDialogs= (_container.numChildren == 0);
            i = 0;
            while (i < _Str_4923)
            {
                desktop = _windowManager.getWindowContext(i).getDesktopWindow();
                desktop.visible = noModalDialogs;
                if (noModalDialogs)
                {
                    final _iter_ = desktop.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
                    {
child  = _tmp_;
                        child.invalidate();
                    }
                }
                i = (i + 1);
            }
            if (noModalDialogs)
            {
                return;
            }
            desktop = _windowManager.getWindowContext(_Str_4923).getDesktopWindow();
            var rectangle= new Rectangle(0, 0, Math.max(1, desktop.width), Math.max(1, desktop.height));
            _container.rectangle = rectangle;
            i = 0;
            while (i < _container.numChildren)
            {
                child = _container.getChildAt(i);
                if ((i % 2) == 0)
                {
                    child.rectangle = rectangle;
                    cast(child, IBitmapWrapperWindow).bitmap = null;
                }
                else
                {
                    child.center();
                }
                i = (i + 1);
            }
            var image= new BitmapData(Std.int(rectangle.width), Std.int(rectangle.height), false, 0);
            hasLoginBackground = HabboWebTools.renderAirLoginBackground(image);
            if (!hasLoginBackground)
            {
                i = 0;
                while (i < _Str_4923)
                {
                    context = _windowManager.getWindowContext(i);
                    if (context != null)
                    {
                        try
                        {
                            image.draw(context.getDesktopWindow().getDisplayObject());
                        }
                        catch(e:openfl.errors.SecurityError)
                        {
                            Logger.log([("[ModalDialog] security error while drawing modal dialog:" + e.message)]);
                        }
                    }
                    i = (i + 1);
                }
                image.colorTransform(image.rect, _Str_5846);
            }
            i = 0;
            while (i < _container.numChildren)
            {
                child = _container.getChildAt(i);
                if ((i % 2) == 0)
                {
                    wrapper = Std.downcast(child , IBitmapWrapperWindow);
                    if (i >= 2)
                    {
                        wrapper.bitmap = image.clone();
                        image = wrapper.bitmap;
                        window = _container.getChildAt((i - 1));
                        image.draw(cast(window, WindowController).getGraphicContext(true), new Matrix(1, 0, 0, 1, window.x, window.y), _Str_5846);
                    }
                    else
                    {
                        wrapper.bitmap = image;
                    }
                }
                child.visible = (i >= (_container.numChildren - 2));
                child.invalidate();
                i = (i + 1);
            }
        }

        static function onResize(k:Event)
        {
            if (((_container == null) || (_container.numChildren <= 0)))
            {
                return;
            }
            _Str_7821 = 2;
            _container.getChildAt((_container.numChildren - 1)).center();
        }

        static function _Str_749(k:Event)
        {
            if (((_container == null) || (_container.numChildren <= 0)))
            {
                return;
            }
            if (_Str_7821 > 0)
            {
                _Str_7821--;
                if (_Str_7821 == 0)
                {
                    refresh();
                }
            }
        }


        public var rootWindow(get,never):IWindow;
public function  get_rootWindow():IWindow
        {
            return this._Str_7545;
        }

        public var background(get,never):IBitmapWrapperWindow;
public function  get_background():IBitmapWrapperWindow
        {
            return this._background;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._background != null)
                {
                    this._background.dispose();
                    this._background = null;
                }
                if (this._Str_7545 != null)
                {
                    this._Str_7545.dispose();
                    this._Str_7545 = null;
                }
                refresh();
                if (((!(_container == null)) && (_container.numChildren == 0)))
                {
                    _container.visible = false;
                }
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

