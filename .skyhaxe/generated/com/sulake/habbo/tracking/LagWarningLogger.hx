package com.sulake.habbo.tracking
;
    import com.sulake.habbo.communication.messages.outgoing.tracking.LagWarningReportMessageComposer;

     class LagWarningLogger 
    {
        var _lastWarning:Int = 0;
        var _warningCount:Int = 0;
        var _habboTracking:HabboTracking;

        public function new(k:HabboTracking)
        {
            this._habboTracking = k;
        }

        public function chatLagDetected(k:Int)
        {
            if (((!this.enabled) || (this.warningInterval <= 0)))
            {
                return;
            }
            this._warningCount++;
            this.reportWarningsAsNeeded(k);
        }

        public function update(k:Int)
        {
            this.reportWarningsAsNeeded(k);
        }

        function reportWarningsAsNeeded(k:Int)
        {
            var _local_2:LagWarningReportMessageComposer = null;
            if (this._warningCount == 0)
            {
                return;
            }
            if (((this._lastWarning == 0) || ((k - this._lastWarning) > this.warningInterval)))
            {
                _local_2 = new LagWarningReportMessageComposer(this._warningCount);
                this._habboTracking.send(_local_2);
                this._lastWarning = k;
                this._warningCount = 0;
            }
        }

        var enabled(get,never):Bool;
function  get_enabled():Bool
        {
            return this._habboTracking.getBoolean("lagWarningLog.enabled");
        }

        var warningInterval(get,never):Int;
function  get_warningInterval():Int
        {
            return this._habboTracking.getInteger("lagWarningLog.interval.seconds", 10) * 1000;
        }
    }

