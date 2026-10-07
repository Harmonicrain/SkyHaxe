package com.sulake.core.window.motion
;

     class Wait extends Motion 
    {
        var _startTimeMs:Int = 0;
        var _waitTimeMs:Int = 0;

        public function new(k:Int)
        {
            super(null);
            this._waitTimeMs = k;
        }

        override public function  get_running():Bool
        {
            return _running;
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
            _complete = ((k - this._startTimeMs) >= this._waitTimeMs);
            if (_complete)
            {
                stop();
            }
        }
    }

