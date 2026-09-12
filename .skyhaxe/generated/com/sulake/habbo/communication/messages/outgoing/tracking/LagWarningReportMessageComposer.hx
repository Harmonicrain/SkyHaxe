package com.sulake.habbo.communication.messages.outgoing.tracking
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class LagWarningReportMessageComposer implements IMessageComposer 
    {
        var _warningCount:Int = 0;

        public function new(k:Int)
        {
            this._warningCount = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._warningCount];
        }

        public function dispose()
        {
        }
    }

