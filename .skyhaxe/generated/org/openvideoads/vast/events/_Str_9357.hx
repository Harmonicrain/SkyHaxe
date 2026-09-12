package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.schedule.ads.AdSlot;

     class _Str_9357 extends Event 
    {
        public static inline final _Str_7412= "schedule-non-linear";

        var _Str_3267:AdSlot = null;

        public function new(k:String, _arg_2:AdSlot, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._Str_3267 = _arg_2;
        }

        
        public var adSlot(get,set):AdSlot;
public function  set_adSlot(k:AdSlot):AdSlot        {
            return this._Str_3267 = k;
        }
public function  get_adSlot():AdSlot
        {
            return this._Str_3267;
        }
    }

