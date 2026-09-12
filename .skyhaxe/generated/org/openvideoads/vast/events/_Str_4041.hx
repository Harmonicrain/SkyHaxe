package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.model.LinearVideoAd;

     class _Str_4041 extends Event 
    {
        public static inline final _Str_6644= "linear-ad-started";
        public static inline final COMPLETE= "linear-ad-complete";
        public static inline final _Str_4456= "linear-ad-skipped";
        public static inline final _Str_16178= "linear-ad-click-through";

        var _Str_3267:AdSlot = null;

        public function new(k:String, _arg_2:AdSlot, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._Str_3267 = _arg_2;
        }

        public var adSlot(never,set):AdSlot;
public function  set_adSlot(k:AdSlot):AdSlot        {
            return this._Str_3267 = k;
        }

        public var ad(get,never):LinearVideoAd;
public function  get_ad():LinearVideoAd
        {
            return this.linearVideoAd;
        }

        public var linearVideoAd(get,never):LinearVideoAd;
public function  get_linearVideoAd():LinearVideoAd
        {
            if (this._Str_3267 != null)
            {
                return this._Str_3267.videoAd.linearVideoAd;
            }
            return null;
        }
    }

