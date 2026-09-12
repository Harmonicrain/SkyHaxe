package org.openvideoads.vast.analytics
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.config.groupings.analytics.AnalyticsConfigGroup;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import org.openvideoads.vast.schedule.ads.AdSlot;

     class _Str_2408 extends Debuggable implements _Str_13591 
    {
        public static inline final IMPRESSIONS= "impressions";
        public static inline final ADCALLS= "adCalls";
        public static inline final TEMPLATE= "template";
        public static inline final ADSLOT= "adSlot";
        public static inline final PROGRESS= "progress";
        public static inline final CLICKS= "clicks";
        public static inline final VPAID= "vpaid";
        public static inline final ALL= "all";
        public static inline final LINEAR= "linear";
        public static inline final NONLINEAR= "nonLinear";
        public static inline final COMPANION= "companion";
        public static inline final _Str_19640= "non-interactive";
        public static inline final LOADED= "loaded";
        public static inline final FIRED= "fired";
        public static inline final COMPLETE= "complete";
        public static inline final ERROR= "error";
        public static inline final TIMEOUT= "timeout";
        public static inline final DEFERRED= "deferred";
        public static inline final FAILOVER= "failover";
        public static inline final START= "start";
        public static inline final STOP= "stop";
        public static inline final FIRSTQUARTILE= "firstQuartile";
        public static inline final MIDPOINT= "midpoint";
        public static inline final THIRDQUARTILE= "thirdQuartile";
        public static inline final PAUSE= "pause";
        public static inline final RESUME= "resume";
        public static inline final FULLSCREEN= "fullscreen";
        public static inline final MUTE= "mute";
        public static inline final UNMUTE= "unmute";
        public static inline final EXPAND= "expand";
        public static inline final COLLAPSE= "collapse";
        public static inline final USERACCEPTINVITATION= "userAcceptInvitation";
        public static inline final CLOSE= "close";
        public static inline final STARTED= "started";
        public static inline final STOPPED= "stopped";
        public static inline final LINEARCHANGE= "linearChange";
        public static inline final EXPANDEDCHANGE= "expandedChange";
        public static inline final REMAININGTIMECHANGE= "remainingTimeChange";
        public static inline final VOLUMECHANGE= "volumeChange";
        public static inline final PAUSED= "paused";
        public static inline final PLAYING= "playing";
        public static inline final VIDEOSTART= "videoStart";
        public static inline final VIDEOFIRSTQUARTILE= "videoFirstQuartile";
        public static inline final VIDEOMIDPOINT= "videoMidpoint";
        public static inline final VIDEOTHIRDQUARTILE= "videoThirdQuartile";
        public static inline final VIDEOCOMPLETE= "videoComplete";
        public static inline final SKIPPED= "skipped";
        public static inline final SKIPPABLESTATECHANGE= "skippableStateChange";
        public static inline final SIZECHANGE= "sizeChange";
        public static inline final DURATIONCHANGE= "durationChange";
        public static inline final ADINTERACTION= "adInteraction";
        public static inline final _Str_21975= "pre-roll";
        public static inline final _Str_21159= "mid-roll";
        public static inline final _Str_19626= "post-roll";

        public function new(k:AnalyticsConfigGroup=null)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:AnalyticsConfigGroup)
        {
            if (k != null)
            {
                if (k._Str_25296())
                {
                }
            }
        }

        public function _Str_7633(k:String, _arg_2:AdServerRequest, _arg_3:Bool=false, _arg_4:ASAny=null)
        {
        }

        public function _Str_10768(k:String, _arg_2:ASAny=null)
        {
        }

        public function _Str_11038(k:String, _arg_2:AdSlot, _arg_3:ASAny=null)
        {
        }

        public function _Str_9754(k:String, _arg_2:AdSlot, _arg_3:ASAny, _arg_4:ASAny=null)
        {
        }

        public function _Str_20536(k:String, _arg_2:AdSlot, _arg_3:ASAny, _arg_4:ASAny=null)
        {
        }

        public function _Str_2689(k:String, _arg_2:AdSlot, _arg_3:ASAny, _arg_4:ASAny=null)
        {
        }

        public function _Str_12452(k:String, _arg_2:AdSlot, _arg_3:ASAny, _arg_4:ASAny=null)
        {
        }
    }

