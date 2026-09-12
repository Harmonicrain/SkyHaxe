package com.sulake.habbo.tracking
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.outgoing.tracking.LatencyPingRequestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.LatencyPingReportMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.tracking.LatencyPingResponseMessageEvent;

     class LatencyTracker implements IDisposable 
    {
        var _state:Bool = false;
        var _testId:Int = 0;
        var _testInterval:Int = 0;
        var _reportIndex:Int = 0;
        var _reportDelta:Int = 0;
        var _lastTestTime:Int = 0;
        var _lastReportedLatency:Int = 0;
        var _latencyValues:Array<ASAny>;
        var _timeStampMap:Map;
        var _habboTracking:HabboTracking;

        public function new(k:HabboTracking)
        {
            this._habboTracking = k;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._state = false;
            if (this._timeStampMap != null)
            {
                this._timeStampMap.dispose();
                this._timeStampMap = null;
            }
            this._latencyValues = null;
            this._habboTracking = null;
        }

        public function init()
        {
            this._testInterval = this._habboTracking.getInteger("latencytest.interval", 20000);
            this._reportIndex = this._habboTracking.getInteger("latencytest.report.index", 100);
            this._reportDelta = this._habboTracking.getInteger("latencytest.report.delta", 3);
            if (this._testInterval < 1)
            {
                return;
            }
            this._timeStampMap = new Map();
            this._latencyValues = [];
            this._state = true;
        }

        public function update(k:UInt, _arg_2:Int)
        {
            if (!this._state)
            {
                return;
            }
            if ((_arg_2 - this._lastTestTime) > this._testInterval)
            {
                this.testLatency();
            }
        }

        function testLatency()
        {
            this._lastTestTime = flash.Lib.getTimer();
            this._timeStampMap.add(this._testId, this._lastTestTime);
            this._habboTracking.send(new LatencyPingRequestMessageComposer(this._testId));
            this._testId++;
        }

        public function _Str_17172(k:LatencyPingResponseMessageEvent)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11:LatencyPingReportMessageComposer = null;
            if (((this._timeStampMap == null) || (this._latencyValues == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            var _local_3= ASCompat.toInt(this._timeStampMap.getValue(_local_2.requestId));
            this._timeStampMap.remove(_local_2.requestId);
            var _local_4= (flash.Lib.getTimer() - _local_3);
            this._latencyValues.push(_local_4);
            if (((this._latencyValues.length == this._reportIndex) && (this._reportIndex > 0)))
            {
                _local_5 = 0;
                _local_6 = 0;
                _local_7 = 0;
                _local_8 = 0;
                while (_local_8 < this._latencyValues.length)
                {
                    _local_5 = ASCompat.toInt(_local_5 + this._latencyValues[_local_8]);
                    _local_8++;
                }
                _local_9 = Std.int(_local_5 / this._latencyValues.length);
                _local_8 = 0;
                while (_local_8 < this._latencyValues.length)
                {
                    if (this._latencyValues[_local_8] < (_local_9 * 2))
                    {
                        _local_6 = ASCompat.toInt(_local_6 + this._latencyValues[_local_8]);
                        _local_7++;
                    }
                    _local_8++;
                }
                if (_local_7 == 0)
                {
                    this._latencyValues = [];
                    return;
                }
                _local_10 = Std.int(_local_6 / _local_7);
                if (((Math.abs((_local_9 - this._lastReportedLatency)) > this._reportDelta) || (this._lastReportedLatency == 0)))
                {
                    this._lastReportedLatency = _local_9;
                    _local_11 = new LatencyPingReportMessageComposer(_local_9, _local_10, this._latencyValues.length);
                    this._habboTracking.send(_local_11);
                }
                this._latencyValues = [];
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._habboTracking == null;
        }
    }

