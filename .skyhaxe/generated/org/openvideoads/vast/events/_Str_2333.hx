package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.schedule.ads.AdSlot;

     class _Str_2333 extends Event 
    {
        public static inline final _Str_18913= "ova-vpaid-linear-loading";
        public static inline final _Str_16423= "nl-loading";
        public static inline final _Str_16473= "ova-vpaid-linear-loaded";
        public static inline final _Str_13330= "ova-vpaid-nl-loaded";
        public static inline final _Str_16657= "ova-vpaid-linear-impression";
        public static inline final _Str_15304= "ova-vpaid-nl-impression";
        public static inline final _Str_17321= "ova-vpaid-linear-start";
        public static inline final _Str_17593= "ova-vpaid-linear-complete";
        public static inline final _Str_18409= "ova-vpaid-linear-error";
        public static inline final _Str_19033= "ova-vpaid-linear-linear-change";
        public static inline final _Str_18146= "ova-vpaid-linear-expanded-change";
        public static inline final _Str_16922= "ova-vpaid-linear-time-change";
        public static inline final _Str_14757= "ova-vpaid-nl-start";
        public static inline final _Str_15573= "ova-vpaid-nl-complete";
        public static inline final _Str_14364= "ova-vpaid-nl-error";
        public static inline final _Str_15816= "ova-vpaid-nl-linear-change";
        public static inline final _Str_14288= "ova-vpaid-nl-expanded-change";
        public static inline final _Str_13294= "ova-vpaid-nl-time-change";
        public static inline final _Str_14526= "ova-video-ad-start";
        public static inline final _Str_15420= "ova-video-ad-first-quartile";
        public static inline final _Str_12528= "ova-video-ad-midpoint";
        public static inline final _Str_15164= "ova-video-ad-third-quartile";
        public static inline final _Str_14824= "ova-video-ad-complete";
        public static inline final _Str_18603= "ova-linear-click-thru";
        public static inline final _Str_13941= "ova-vpaid-nl-click-thru";
        public static inline final _Str_18117= "ova-vpaid-linear-user-accept-invitation";
        public static inline final _Str_16665= "ova-vpaid-linear-user-minimize";
        public static inline final _Str_16340= "ova-vpaid-linear-user-close";
        public static inline final _Str_15854= "ova-vpaid-nl-user-accept-invitation";
        public static inline final _Str_13270= "ova-vpaid-nl-user-minimize";
        public static inline final _Str_13997= "ova-vpaid-nl-user-close";
        public static inline final _Str_15390= "ova-vpaid-linear-volume-change";
        public static inline final _Str_15728= "ova-vpaid-nl-volume-change";
        public static inline final _Str_4456= "ova-vpaid-skipped";
        public static inline final _Str_6020= "ova-vpaid-skippable-state-change";
        public static inline final _Str_5704= "ova-vpaid-size-change";
        public static inline final _Str_5647= "ova-vpaid-duration-change";
        public static inline final _Str_5708= "ova-vpaid-ad-interaction";
        public static inline final _Str_12726= "ova-vpaid-ad-log";

        var _data:ASAny = null;
        var _Str_3267:AdSlot = null;

        public function new(k:String, _arg_2:AdSlot, _arg_3:ASAny=null, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._Str_3267 = _arg_2;
            this._data = _arg_3;
        }

        public var adSlot(get,never):AdSlot;
public function  get_adSlot():AdSlot
        {
            return this._Str_3267;
        }

        public function _Str_13568():Bool
        {
            return !(this._data == null);
        }

        public var data(get,never):ASAny;
public function  get_data():ASAny
        {
            return this._data;
        }

        override public function clone():Event
        {
            return new _Str_2333(type, this.adSlot, this.data, bubbles, cancelable);
        }
    }

