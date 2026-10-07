package com.sulake.core.window.services
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import flash.utils.Timer;
    import com.sulake.core.window.events.WindowEvent;
    import flash.events.TimerEvent;

     class GestureAgentService implements IGestureAgentService implements  IDisposable 
    {
        var _disposed:Bool = false;
        var _Str_5527:Bool = false;
        var window:IWindow;
        var _timer:Timer;
        var _Str_829:UInt = 0;
        var _callback:ASFunction;
        var _Str_5257:Int = 0;
        var _Str_4979:Int = 0;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this.end(this.window);
            this._disposed = true;
        }

        public function begin(k:IWindow, _arg_2:ASFunction, _arg_3:UInt, _arg_4:Int, _arg_5:Int):IWindow
        {
            this._Str_829 = _arg_3;
            var _local_6= this.window;
            if (this.window != null)
            {
                this.end(this.window);
            }
            if (((k != null) && (!k.disposed)))
            {
                this.window = k;
                this.window.addEventListener(WindowEvent.WINDOW_EVENT_DESTROYED, this._Str_10813);
                this._callback = _arg_2;
                this._Str_5527 = true;
                this._Str_5257 = _arg_4;
                this._Str_4979 = _arg_5;
                this._timer = new Timer(40, 0);
                this._timer.addEventListener(TimerEvent.TIMER, (this.operate : ASAny));
                this._timer.start();
            }
            return _local_6;
        }

        function operate(k:TimerEvent)
        {
            this._Str_5257 = Std.int(this._Str_5257 * 0.75);
            this._Str_4979 = Std.int(this._Str_4979 * 0.75);
            if (((Math.abs(this._Str_5257) <= 1) && (Math.abs(this._Str_4979) <= 1)))
            {
                this.end(this.window);
            }
            else
            {
                if (this._callback != null)
                {
                    this._callback(this._Str_5257, this._Str_4979);
                }
            }
        }

        public function end(k:IWindow):IWindow
        {
            var _local_2= this.window;
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, (this.operate : ASAny));
                this._timer = null;
            }
            if (this._Str_5527)
            {
                if (this.window == k)
                {
                    if (!this.window.disposed)
                    {
                        this.window.removeEventListener(WindowEvent.WINDOW_EVENT_DESTROYED, this._Str_10813);
                    }
                    this.window = null;
                    this._Str_5527 = false;
                }
            }
            return _local_2;
        }

        function _Str_10813(k:WindowEvent)
        {
            this.end(this.window);
        }
public function new(){}
    }

