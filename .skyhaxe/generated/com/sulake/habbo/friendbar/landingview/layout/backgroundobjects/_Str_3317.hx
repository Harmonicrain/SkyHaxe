package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.IWindow;
    import flash.events.EventDispatcher;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;

     class _Str_3317 implements IDisposable implements  IUpdateReceiver 
    {
        var _id:Int = 0;
        var _window:IWindow;
        var _events:EventDispatcher;
        var _sprite:IStaticBitmapWrapperWindow;

        public function new(k:Int, _arg_2:IWindowContainer, _arg_3:EventDispatcher, _arg_4:HabboLandingView, _arg_5:String, _arg_6:Bool=false)
        {
            this._id = k;
            this._window = _arg_2;
            this._events = _arg_3;
            if (_arg_6)
            {
                this._sprite = cast(_arg_4.getXmlWindow("moving_object"), IStaticBitmapWrapperWindow);
            }
            else
            {
                this._sprite = cast(_arg_4.getXmlWindow("moving_object_floating"), IStaticBitmapWrapperWindow);
            }
            _arg_2.addChild(this._sprite);
        }

        public function dispose()
        {
            this._window = null;
            this._sprite = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }

        
        public var sprite(get,set):IStaticBitmapWrapperWindow;
public function  set_sprite(k:IStaticBitmapWrapperWindow):IStaticBitmapWrapperWindow        {
            return this._sprite = k;
        }
public function  get_sprite():IStaticBitmapWrapperWindow
        {
            return this._sprite;
        }

        
        public var window(get,set):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }
public function  set_window(k:IWindow):IWindow        {
            return this._window = k;
        }

        public var events(get,never):EventDispatcher;
public function  get_events():EventDispatcher
        {
            return this._events;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public function update(k:UInt)
        {
            if (this._sprite == null)
            {
                return;
            }
        }
    }

