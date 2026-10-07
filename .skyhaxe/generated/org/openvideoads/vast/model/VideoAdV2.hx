package org.openvideoads.vast.model
;
     class VideoAdV2 extends VideoAd 
    {
        var _Str_22246:String;


        
        public var _Str_22008(get,set):String;
public function  get__Str_22008():String
        {
            return this._Str_22246;
        }
public function  set__Str_22008(k:String):String        {
            return this._Str_22246 = k;
        }

        override public function injectAllTrackingData(k:VideoAd):VideoAd
        {
            var _local_2 = 0;
            k.addImpressions(_Str_3519);
            k.addTrackingEventItems(_Str_3053);
            if (_Str_2815 != null)
            {
                if (Std.is(k , VideoAdV2))
                {
                    k.linearVideoAd.addTrackingEventItems(_Str_2815.trackingEvents);
                    k.linearVideoAd.addClickTrackingItems(_Str_2815.clickTracking);
                    k.linearVideoAd.addCustomClickTrackingItems(_Str_2815.customClicks);
                }
                else
                {
                    k.addTrackingEventItems(_Str_2815.trackingEvents);
                    k.addClickTrackingItems(_Str_2815.clickTracking);
                    k.addCustomClickTrackingItems(_Str_2815.customClicks);
                }
            }
            if (hasNonLinearAds())
            {
                _local_2 = 0;
                while (_local_2 < _Str_2587.length)
                {
                    if (_local_2 < k.nonLinearVideoAds.length)
                    {
                        k.nonLinearVideoAds[_local_2].addTrackingEventItems(_Str_2587[_local_2].trackingEvents);
                    }
                    _local_2++;
                }
            }
            if (hasCompanionAds())
            {
            }
            return k;
        }

        public function _Str_23669():Bool
        {
            if (hasLinearAd())
            {
                return _Str_2815.hasTrackingEvents();
            }
            return false;
        }

        override public function  get_trackingEvents():Array<ASAny>
        {
            if (isLinear())
            {
                return _Str_2815.trackingEvents;
            }
            return new Array<ASAny>();
        }

        public function _Str_24198():Bool
        {
            var k = 0;
            if (hasNonLinearAds())
            {
                k = 0;
                while (k < _Str_2587.length)
                {
                    if (_Str_2587[k].hasTrackingEvents())
                    {
                        return true;
                    }
                    k++;
                }
            }
            return false;
        }

        override public function hasTrackingEvents():Bool
        {
            return this._Str_23669() || this._Str_24198();
        }

        override function _triggerTrackingEvent(k:String, _arg_2:String=null)
        {
            if (isLinear())
            {
                _Str_2815.triggerTrackingEvent(k);
                super._triggerTrackingEvent(k, _arg_2);
            }
            else
            {
                if (!isNonLinear())
                {
                    if (_Str_9554())
                    {
                    }
                }
            }
        }

	public function new() { super(); }
    }

