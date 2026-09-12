package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class Interval extends Motion 
    {
        var _startTimeMs:Int = 0;
        var _duration:Int = 0;

        public function new(k:IWindow, _arg_2:Int)
        {
            super(k);
            _complete = false;
            this._duration = _arg_2;
        }

        public var duration(get,never):Int;
public function  get_duration():Int
        {
            return this._duration;
        }

        override public function start()
        {
            super.start();
            _complete = false;
            this._startTimeMs = flash.Lib.getTimer();
        }

        override public function tick(k:Int)
        {
			super.tick(k);
            var _local_2= ((k - this._startTimeMs) / this._duration);
            if (_local_2 < 1)
            {
                update(_local_2);
            }
            else
            {
                update(1);
                _complete = true;
            }
        }
    }

