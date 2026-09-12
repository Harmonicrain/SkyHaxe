package com.sulake.core.window.motion
;
	import com.sulake.core.window.motion.Motion;
     class Queue extends Motion 
    {
        var _motion:Motion;
        var _queue:Vector<Motion>;

        public function new( k:Array<ASAny> = null)
        {
if (k == null) k = [];
            var _local_2:Motion = null;
            this._queue = new Vector<Motion>();
            super(((k != null) ? cast(k[0], Motion).target : null));
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this._queue.push(_local_2);
            }
            this._motion = k[0];
            _complete = (this._motion == null);
        }

        override public function  get_running():Bool
        {
            return (_running && (this._motion != null)) ? this._motion.running : false;
        }

        override public function start()
        {
            super.start();
            this._motion.start();
        }

        override public function update(k:Float)
        {
            super.update(k);
            if (this._motion.running)
            {
                this._motion.update(k);
            }
        }

        override public function stop()
        {
            super.stop();
            this._motion.stop();
        }

        override public function tick(k:Int)
        {
            super.tick(k);
            var _local_2 = 0;
            this._motion.tick(k);
            if (this._motion.complete)
            {
                this._motion.stop();
                _local_2 = this._queue.indexOf(this._motion);
                if (_local_2 < (this._queue.length - 1))
                {
                    this._motion = this._queue[(_local_2 + 1)];
                    _target = this._motion.target;
                    this._motion.start();
                }
                else
                {
                    _complete = true;
                }
            }
        }
    }

