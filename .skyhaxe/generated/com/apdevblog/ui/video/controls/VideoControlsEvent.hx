package com.apdevblog.ui.video.controls
;
    import flash.events.Event;

     class VideoControlsEvent extends Event 
    {
        public static inline final SEEK= "seek";
        public static inline final SCRUB= "scrub";
        public static inline final TOGGLEFULLSCREEN= "toggleFullscreen";
        public static inline final TOGGLEPLAYPAUSE= "togglePlayPause";
        public static inline final TOGGLESOUND= "toggleSound";
        public static inline final SETVOLUME= "setVolume";
        public static inline final ENTERFULLSCREEN= "enterFullscreen";
        public static inline final STATEUPDATE= "stateUpdate";

        var _data:ASAny;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false, _arg_4:ASAny=null)
        {
            super(k, _arg_2, _arg_3);
            this._data = _arg_4;
        }

        override public function clone():Event
        {
            return new VideoControlsEvent(type, bubbles, cancelable, this.data);
        }

        override public function toString():String
        {
            return formatToString("VideoControlsEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
        }

        
        public var data(get,set):ASAny;
public function  get_data():ASAny
        {
            return this._data;
        }
public function  set_data(k:ASAny):ASAny        {
            return this._data = k;
        }
    }

