package org.openvideoads.vast.events
;
    import flash.events.Event;

     class AdTagEvent extends Event 
    {
        public static inline final _Str_18229= "adcall-started";
        public static inline final _Str_18441= "adcall-failover";
        public static inline final _Str_16223= "adcall-complete";

        var _Str_6360:ASAny;

        public function new(k:String, _arg_2:ASAny, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._Str_6360 = _arg_2;
        }

        public function _Str_25894():Bool
        {
            if (this._Str_6360 != null)
            {
                if (this._Str_6360.masterTag != null)
                {
                    return this._Str_6360.masterTag.callOnDemand;
                }
            }
            return false;
        }

        public function includesLinearAds():Bool
        {
            if (this._Str_6360 != null)
            {
                if (this._Str_6360.masterTag != null)
                {
                    return this._Str_6360.masterTag.includesLinearAds();
                }
            }
            return false;
        }

        public var _Str_26256(get,never):ASAny;
public function  get__Str_26256():ASAny
        {
            return this._Str_6360;
        }
    }

