package com.sulake.habbo.campaign.calendar
;
    import com.sulake.core.window.IWindow;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

     class CalendarItemWiggle 
    {
        static inline final _Str_16741= 80;
        static inline final _Str_14575= 10;
        static inline final _Str_18522= 40;
        static inline final _Str_9823= 7;

        var _window:IWindow;
        var _timer:Timer;
        var _direction:Int = 0;
        var _counter:Int = 0;
        var _initialY:Int = 0;

        public function new(k:IWindow)
        {
            if (k == null)
            {
                return;
            }
            this._window = k;
            this._initialY = k.y;
            k.y = (k.y - _Str_14575);
            this._direction = 1;
            this._timer = new Timer(_Str_16741);
            this._timer.addEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
            this._timer.start();
        }

        function onTimerEvent(k:TimerEvent)
        {
            if (this._window == null)
            {
                this.dispose();
            }
            var _local_2= (_Str_14575 * ((_Str_9823 - this._counter) / _Str_9823));
            var _local_3= (Math.abs((this._window.y - this._initialY)) / _local_2);
            var _local_4= (Math.max(2, (Math.sin(_local_3) * _Str_18522)) * this._direction);
            this._window.y = Std.int(this._window.y + _local_4);
            if (this._direction > 0)
            {
                if (this._window.y > this._initialY)
                {
                    this._direction = (this._direction * -1);
                    this._window.y = this._initialY;
                    this._counter++;
                }
            }
            else
            {
                if (this._window.y <= (this._initialY - _local_2))
                {
                    this._direction = (this._direction * -1);
                    this._window.y = Std.int(this._initialY - _local_2);
                    this._counter++;
                }
            }
            if (this._counter >= _Str_9823)
            {
                this.dispose();
            }
        }

        function dispose()
        {
            this._window.y = this._initialY;
            this._window = null;
            this._timer.reset();
            this._timer = null;
        }
    }

