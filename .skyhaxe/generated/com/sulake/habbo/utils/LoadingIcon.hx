package com.sulake.habbo.utils
;
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IIconWindow;
    import flash.events.TimerEvent;
    import flash.events.Event;

     class LoadingIcon implements IDisposable 
    {
        static final _Str_11404:Array<ASAny> = [23, 24, 25, 26];

        var _timer:Timer;
        var _icon:IIconWindow;
        var _frameIndex:Int = 0;

        public function new()
        {
            this._timer = new Timer(160);
            this._timer.addEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
        }

        public function dispose()
        {
            if (this._timer != null)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
                this._timer.stop();
                this._timer = null;
            }
            this._icon = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._timer == null;
        }

        public function setVisible(k:IIconWindow, _arg_2:Bool)
        {
            this._icon = k;
            this._icon.visible = _arg_2;
            if (_arg_2)
            {
                this._icon.style = ASCompat.toUInt(_Str_11404[this._frameIndex]);
                this._timer.start();
            }
            else
            {
                this._timer.stop();
            }
        }

        function onTimer(k:Event)
        {
            if (this._icon == null)
            {
                return;
            }
            this._frameIndex++;
            if (this._frameIndex >= _Str_11404.length)
            {
                this._frameIndex = 0;
            }
            this._icon.style = ASCompat.toUInt(_Str_11404[this._frameIndex]);
        }
    }

