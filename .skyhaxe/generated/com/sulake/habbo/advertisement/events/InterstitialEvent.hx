package com.sulake.habbo.advertisement.events
;
    import flash.events.Event;

     class InterstitialEvent extends Event 
    {
        public static inline final INTERSTITIAL_SHOW= "AE_INTERSTITIAL_SHOW";
        public static inline final INTERSTITIAL_NOT_SHOWN= "AE_INTERSTITIAL_NOT_SHOWN";
        public static inline final INTERSTITIAL_COMPLETE= "AE_INTERSTITIAL_COMPLETE";

        var _status:String;

        public function new(k:String, status:String=null, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._status = status;
        }

        public var status(get,never):String;
public function  get_status():String
        {
            return this._status;
        }
    }

