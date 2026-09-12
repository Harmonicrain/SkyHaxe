package com.sulake.core.window.motion
;

     class Combo extends Motion 
    {
        var _runningMotions:Vector<Motion>;
        var _removedMotions:Vector<Motion>;

        public function new( k:Array<ASAny> = null)
        {
if (k == null) k = [];
            var _local_2:Motion = null;
            this._runningMotions = new Vector<Motion>();
            this._removedMotions = new Vector<Motion>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this._runningMotions.push(_local_2);
            }
            super(((this._runningMotions.length > 0) ? this._runningMotions[0].target : null));
        }

        override public function start()
        {
            super.start();
            var k:Motion = null;
            final _iter_ = this._runningMotions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.start();
            }
        }

        override public function tick(k:Int)
        {
            super.tick(k);
            var _local_2:Motion = null;
            while ((_local_2 = this._removedMotions.pop()) != null)
            {
                this._runningMotions.splice(this._removedMotions.indexOf(_local_2), 1);
                if (_local_2.running)
                {
                    _local_2.stop();
                }
            }
            final _iter_ = this._runningMotions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.running)
                {
                    _local_2.tick(k);
                }
                if (_local_2.complete)
                {
                    this._removedMotions.push(_local_2);
                }
            }
            if (this._runningMotions.length > 0)
            {
                final _iter_ = this._runningMotions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    _target = _local_2.target;
                    if (((_target != null) && (!_target.disposed)))
                    {
                        break;
                    }
                }
                _complete = false;
            }
            else
            {
                _complete = true;
            }
        }
    }

