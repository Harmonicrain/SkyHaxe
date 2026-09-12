package com.sulake.habbo.tracking
;
     class FramerateTracker 
    {
        var _lastReport:Int = 0;
        var _updateCounter:Int = 0;
        var _averageUpdateInterval:Float = Math.NaN;
        var _eventCounter:Int = 0;
        var _habboTracking:HabboTracking;

        public function new(k:HabboTracking)
        {
            this._habboTracking = k;
        }

        public var frameRate(get,never):Int;
public function  get_frameRate():Int
        {
            return Std.int(Math.fround((1000 / this._averageUpdateInterval)));
        }

        public function trackUpdate(k:UInt, _arg_2:Int)
        {
            var _local_3 = Math.NaN;
            this._updateCounter++;
            if (this._updateCounter == 1)
            {
                this._averageUpdateInterval = k;
                this._lastReport = _arg_2;
            }
            else
            {
                _local_3 = this._updateCounter;
                this._averageUpdateInterval = (((this._averageUpdateInterval * (_local_3 - 1)) / _local_3) + (k / _local_3));
            }
            if ((_arg_2 - this._lastReport) >= (this._habboTracking.getInteger("tracking.framerate.reportInterval.seconds", 300) * 1000))
            {
                this._updateCounter = 0;
                if (this._eventCounter < this._habboTracking.getInteger("tracking.framerate.maximumEvents", 5))
                {
                    this._habboTracking.trackGoogle("performance", "averageFramerate", this.frameRate);
                    this._eventCounter++;
                    this._lastReport = _arg_2;
                }
            }
        }
    }

