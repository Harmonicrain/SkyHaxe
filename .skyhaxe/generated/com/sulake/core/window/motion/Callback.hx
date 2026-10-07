package com.sulake.core.window.motion
;
     class Callback extends Motion 
    {
        var _callback:ASFunction;

        public function new(k:ASFunction)
        {
            super(null);
            this._callback = k;
        }

        override public function  get_running():Bool
        {
            return _running && (!(this._callback == null));
        }

        override public function tick(k:Int)
        {
			super.tick(k);
            if (this._callback != null)
            {
                this._callback(this);
                this._callback = null;
            }
        }
    }

