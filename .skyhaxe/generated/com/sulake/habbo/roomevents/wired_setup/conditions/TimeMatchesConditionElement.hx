package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.ChronoFieldRangeFilter;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.ChronoRangeFilterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TimeMatchesConditionElement extends ChronoConditionElement
    {
        var _seconds:ChronoRangeFilterPreset;
        var _minutes:ChronoRangeFilterPreset;
        var _hours:ChronoRangeFilterPreset;

        override public function  get_code():Int { return ConditionCodes.TIME_MATCHES; }
        override public function  get_inputMode():Int { return com.sulake.habbo.roomevents.wired_setup.DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(m:PresetManager, style:WiredStyle, b:WiredUIBuilder)
        {
            this._hours = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 23, 25);
            this._minutes = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 59, 25);
            this._seconds = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 59, 25);
            b.addElements([m.createSection(l("time.hour_selection"), this._hours),
                m.createSection(l("time.minute_selection"), this._minutes),
                m.createSection(l("time.second_selection"), this._seconds),
                createTimezoneSection(m)]);
        }

        override public function onEditStart(d:Triggerable)
        {
            super.onEditStart(d);
            var a= d.intData;
            this._seconds.applyFilter(new ChronoFieldRangeFilter("second", a.length > 0 && a[0] == 1,
                ASCompat.toInt(a.length > 3 ? ASCompat.toInt(a[3] ): 0), ASCompat.toInt(a.length > 4 ? ASCompat.toInt(a[4] ): 0)));
            this._minutes.applyFilter(new ChronoFieldRangeFilter("minute", a.length > 1 && a[1] == 1,
                ASCompat.toInt(a.length > 5 ? ASCompat.toInt(a[5] ): 0), ASCompat.toInt(a.length > 6 ? ASCompat.toInt(a[6] ): 0)));
            this._hours.applyFilter(new ChronoFieldRangeFilter("hour", a.length > 2 && a[2] == 1,
                ASCompat.toInt(a.length > 7 ? ASCompat.toInt(a[7] ): 0), ASCompat.toInt(a.length > 8 ? ASCompat.toInt(a[8] ): 0)));
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var s= this._seconds.getFilter("second");
            var m= this._minutes.getFilter("minute");
            var h= this._hours.getFilter("hour");
            return [s.useFilter ? 1 : 0, m.useFilter ? 1 : 0, h.useFilter ? 1 : 0,
                s.min, s.max, m.min, m.max, h.min, h.max];
        }

	public function new() { super(); }
    }

