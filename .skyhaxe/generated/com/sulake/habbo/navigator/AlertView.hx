package com.sulake.habbo.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class AlertView implements IDisposable 
    {
        static var _Str_4602:ASDictionary<ASAny,ASAny> = new ASDictionary();

        var _navigator:IHabboTransitionalNavigator;
        var _Str_4389:IFrameWindow;
        var _Str_4188:String;
        var _title:String;
        var _disposed:Bool = false;

        public function new(k:IHabboTransitionalNavigator, _arg_2:String, _arg_3:String=null)
        {
            this._navigator = k;
            this._Str_4188 = _arg_2;
            this._title = _arg_3;
        }

        public static function _Str_22232(k:IWindow):AlertView
        {
            var _local_2:AlertView = null;
            if (_Str_4602 != null)
            {
                final _iter_ = _Str_4602; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if ((_local_2._Str_4389 : ASAny) == (k : ASAny))
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }


        public function show()
        {
            var k= ASCompat.dynamicAs(_Str_4602[this._Str_4188] , AlertView);
            if (k != null)
            {
                k.dispose();
            }
            this._Str_4389 = this._Str_24090();
            if (this._title != null)
            {
                this._Str_4389.caption = this._title;
            }
            this.setupAlertWindow(this._Str_4389);
            var _local_2= Util._Str_10228(this._Str_4389.desktop, this._Str_4389.width, this._Str_4389.height);
            this._Str_4389.x = Std.int(_local_2.x);
            this._Str_4389.y = Std.int(_local_2.y);
            _Str_4602[this._Str_4188] = this;
            this._Str_4389.activate();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (_Str_4602[this._Str_4188] == this)
            {
                _Str_4602[this._Str_4188] = null;
            }
            this._disposed = true;
            if (this._Str_4389 != null)
            {
                this._Str_4389.destroy();
                this._Str_4389 = null;
            }
            this._navigator = null;
        }

        @:allow(com.sulake.habbo.navigator) function setupAlertWindow(k:IFrameWindow)
        {
        }

        @:allow(com.sulake.habbo.navigator) function onCloseHandler(k:WindowMouseEvent)
        {
            this.dispose();
        }

        function _Str_24090():IFrameWindow
        {
            var k= Std.downcast(this._navigator.getXmlWindow(this._Str_4188, 2) , IFrameWindow);
            var _local_2= k.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            return k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var navigator(get,never):IHabboTransitionalNavigator;
public function  get_navigator():IHabboTransitionalNavigator
        {
            return this._navigator;
        }
    }

