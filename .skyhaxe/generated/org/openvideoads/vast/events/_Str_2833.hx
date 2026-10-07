package org.openvideoads.vast.events
;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.config.groupings.AdSlotRegionConfig;
    import flash.events.MouseEvent;
    import org.openvideoads.vast.model.NonLinearVideoAd;
    import flash.events.Event;

     class _Str_2833 extends _Str_4535 
    {
        public static inline final _Str_3831= "display-overlay";
        public static inline final _Str_2703= "hide-overlay";
        public static inline final _Str_19712= "display-non-overlay";
        public static inline final _Str_21603= "hide-non-overlay";
        public static inline final _Str_16841= "overlay-clicked";
        public static inline final _Str_18947= "overlay-close-clicked";
        public static inline final FLASH= "flash";
        public static inline final _Str_15057= "html5";

        var _Str_3267:AdSlot = null;
        var _Str_2442:AdSlotRegionConfig = null;
        var _Str_6489:MouseEvent = null;

        public function new(k:String, _arg_2:NonLinearVideoAd, _arg_3:AdSlot, _arg_4:AdSlotRegionConfig=null, _arg_5:MouseEvent=null, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(k, _arg_2, _arg_6, _arg_7);
            this._Str_3267 = _arg_3;
            this._Str_2442 = _arg_4;
            this._Str_6489 = _arg_5;
        }

        public var adSlot(get,never):AdSlot;
public function  get_adSlot():AdSlot
        {
            return this._Str_3267;
        }

        public var region(get,never):AdSlotRegionConfig;
public function  get_region():AdSlotRegionConfig
        {
            return this._Str_2442;
        }

        
        public var _Str_13787(get,set):MouseEvent;
public function  set__Str_13787(k:MouseEvent):MouseEvent        {
            return this._Str_6489 = k;
        }
public function  get__Str_13787():MouseEvent
        {
            return this._Str_6489;
        }

        public var displayMode(get,never):String;
public function  get_displayMode():String
        {
            if (this._Str_2442 != null)
            {
                return this._Str_2442.displayMode;
            }
            return _Str_2833.FLASH;
        }

        override public function clone():Event
        {
            return new _Str_2833(type, nonLinearVideoAd, this._Str_3267, this._Str_2442, this._Str_6489, bubbles, cancelable);
        }

        override public function toString():String
        {
            if (nonLinearVideoAd != null)
            {
                return (((((((((((("resourceType: " + nonLinearVideoAd.resourceType) + ", ") + "creativeType: ") + nonLinearVideoAd.creativeType) + ", ") + "displayMode; ") + this.displayMode) + ", ") + "width: ") + nonLinearVideoAd.width) + ", ") + "height: ") + nonLinearVideoAd.height;
            }
            return "no ad";
        }
    }

