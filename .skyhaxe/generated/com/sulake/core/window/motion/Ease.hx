package com.sulake.core.window.motion
;
     class Ease extends Interval 
    {
        var _interval:Interval;

        public function new(k:Interval)
        {
            super(k.target, k.duration);
            this._interval = k;
        }

        public override function start()
        {
            super.start();
            this._interval.start();
        }

        public override function update(k:Float)
        {
            super.update(k);
            this._interval.update(k);
        }

        public override function stop()
        {
            super.stop();
            this._interval.stop();
        }
    }

