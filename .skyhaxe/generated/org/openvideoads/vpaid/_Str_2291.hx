package org.openvideoads.vpaid
;
    import flash.events.Event;

     class _Str_2291 extends Event 
    {
        public static inline final AdLoaded= "AdLoaded";
        public static inline final AdStarted= "AdStarted";
        public static inline final AdStopped= "AdStopped";
        public static inline final AdLinearChange= "AdLinearChange";
        public static inline final AdExpandedChange= "AdExpandedChange";
        public static inline final AdRemainingTimeChange= "AdRemainingTimeChange";
        public static inline final AdVolumeChange= "AdVolumeChange";
        public static inline final AdImpression= "AdImpression";
        public static inline final AdVideoStart= "AdVideoStart";
        public static inline final AdVideoFirstQuartile= "AdVideoFirstQuartile";
        public static inline final AdVideoMidpoint= "AdVideoMidpoint";
        public static inline final AdVideoThirdQuartile= "AdVideoThirdQuartile";
        public static inline final AdVideoComplete= "AdVideoComplete";
        public static inline final AdClickThru= "AdClickThru";
        public static inline final AdUserAcceptInvitation= "AdUserAcceptInvitation";
        public static inline final AdUserMinimize= "AdUserMinimize";
        public static inline final AdUserClose= "AdUserClose";
        public static inline final AdPaused= "AdPaused";
        public static inline final AdPlaying= "AdPlaying";
        public static inline final AdLog= "AdLog";
        public static inline final AdError= "AdError";
        public static inline final AdSkipped= "AdSkipped";
        public static inline final AdSizeChange= "AdSizeChange";
        public static inline final AdSkippableStateChange= "AdSkippableStateChange";
        public static inline final AdDurationChange= "AdDurationChange";
        public static inline final AdInteraction= "AdInteraction";

        var _data:ASObject = null;

        public function new(k:String, _arg_2:ASObject=null, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            if (Std.is(_arg_2 , String))
            {
                this._data = {"message":_arg_2};
            }
            else
            {
                this._data = _arg_2;
            }
        }

        public var data(get,never):ASObject;
public function  get_data():ASObject
        {
            return this._data;
        }
    }

