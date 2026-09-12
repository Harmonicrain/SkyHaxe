package com.sulake.habbo.tracking
;
     class ToolbarClickTracker 
    {
        var _tracking:HabboTracking;
        var _eventCount:Int = 0;

        public function new(k:HabboTracking)
        {
            this._tracking = k;
        }

        public function track(k:String)
        {
            if (!this._tracking.getBoolean("toolbar.tracking.enabled"))
            {
                return;
            }
            this._eventCount++;
            if (this._eventCount <= this._tracking.getInteger("toolbar.tracking.max.events", 100))
            {
                this._tracking.trackGoogle("toolbar", k);
            }
        }
    }

