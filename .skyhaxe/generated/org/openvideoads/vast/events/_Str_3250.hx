package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.schedule.ads.AdSlot;

     class _Str_3250 extends Event 
    {
        public static inline final _Str_3592= "adslot-load-success";
        public static inline final _Str_18922= "adslot-load-error";
        public static inline final _Str_6699= "adslot-load-timeout";
        public static inline final _Str_6462= "adslot-load-deferred";

        var _Str_3267:AdSlot = null;
        var _Str_10947:Event = null;

        public function new(k:String, _arg_2:AdSlot, _arg_3:Event=null, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._Str_10947 = _arg_3;
            this._Str_3267 = _arg_2;
        }

        public function _Str_25908():Bool
        {
            return !(this._Str_3267 == null);
        }

        public var adSlot(get,never):AdSlot;
public function  get_adSlot():AdSlot
        {
            return this._Str_3267;
        }

        public function _Str_26007():Bool
        {
            return !(this._Str_10947 == null);
        }

        public var _Str_26197(get,never):Event;
public function  get__Str_26197():Event
        {
            return this._Str_10947;
        }

        public function _Str_26310():Bool
        {
            if (this._Str_3267 != null)
            {
                return this._Str_3267.hasLinearAd();
            }
            return false;
        }

        override public function toString():String
        {
            if (this._Str_10947 != null)
            {
                return this._Str_10947.toString();
            }
            if (this._Str_3267 != null)
            {
                return this._Str_3267.toString();
            }
            return "no data";
        }
    }

