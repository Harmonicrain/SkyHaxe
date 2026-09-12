package com.sulake.habbo.catalog.clubcenter.util
;
    import flash.display.BitmapData;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import com.sulake.habbo.session.ISessionDataManager;

     class BadgeResolver 
    {
        public static inline final _Str_16636= "HC1";
        public static final _Str_16347:Array<ASAny> = ["ACH_VipHC1", "ACH_VipHC2", "ACH_VipHC3", "ACH_VipHC4", "ACH_VipHC5", "HC1", "HC2", "HC3", "HC4", "HC5"];


        public static function _Str_25437(k:Array<ASAny>):String
        {
            var _local_2:String = null;
            var _local_3:String = null;
            final _iter_ = _Str_16347; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (k.indexOf(_local_3) > -1)
                {
                    _local_2 = _local_3;
                }
            }
            return _local_2;
        }

        public static function _Str_24209(k:String, _arg_2:ASFunction, _arg_3:ISessionDataManager):BitmapData
        {
            if (k == null)
            {
                return null;
            }
            var _local_4= _arg_3.requestBadgeImage(k);
            if (_local_4 == null)
            {
                _arg_3.events.addEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, _arg_2);
            }
            return _local_4;
        }

	public function new() {}
    }

