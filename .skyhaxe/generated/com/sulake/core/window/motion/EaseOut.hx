package com.sulake.core.window.motion
;
     class EaseOut extends EaseRate 
    {
        public function new(k:Interval, _arg_2:Float)
        {
            super(k, _arg_2);
        }

        public override function update(k:Float)
        {
            _interval.update(Math.pow(k, (1 / _Str_21638)));
        }
    }

