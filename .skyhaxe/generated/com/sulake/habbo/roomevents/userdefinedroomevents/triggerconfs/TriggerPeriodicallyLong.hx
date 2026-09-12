package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import flash.events.Event;
    import com.sulake.habbo.utils.FriendlyTime;

     class TriggerPeriodicallyLong extends TriggerPeriodically 
    {


        override public function  get_code():Int
        {
            return WiredTriggerType.TRIGGER_PERIODICALLY_LONG;
        }

        override function onSliderChange(k:Event)
        {
            var _local_2:SliderWindowController = null;
            var _local_3 = Math.NaN;
            var _local_4:String = null;
            if (k.type == Event.CHANGE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , SliderWindowController);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getValue();
                    _local_4 = FriendlyTime.format(_Str_16492.localization, (_local_3 * 5));
                    _Str_16492.localization.registerParameter("wiredfurni.params.setlongtime", "time", _local_4);
                }
            }
        }

	public function new() { super(); }
    }

