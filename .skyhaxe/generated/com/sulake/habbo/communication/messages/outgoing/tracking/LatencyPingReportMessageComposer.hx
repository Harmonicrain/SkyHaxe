package com.sulake.habbo.communication.messages.outgoing.tracking
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class LatencyPingReportMessageComposer implements IMessageComposer 
    {
        var _averagePing:Int = 0;
        var _clearedAveragePing:Int = 0;
        var _pingCount:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._averagePing = k;
            this._clearedAveragePing = _arg_2;
            this._pingCount = _arg_3;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._averagePing, this._clearedAveragePing, this._pingCount];
        }

        public function dispose()
        {
        }
    }

