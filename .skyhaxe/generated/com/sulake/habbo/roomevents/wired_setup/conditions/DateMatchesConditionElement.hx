package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.ChronoFieldRangeFilter;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.ChronoMaskFilterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.ChronoRangeFilterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class DateMatchesConditionElement extends ChronoConditionElement
    {
        var _weekdays:ChronoMaskFilterPreset;
        var _day:ChronoRangeFilterPreset;
        var _months:ChronoMaskFilterPreset;
        var _year:ChronoRangeFilterPreset;

        override public function  get_code():Int { return ConditionCodes.DATE_MATCHES; }
        override public function  get_inputMode():Int { return com.sulake.habbo.roomevents.wired_setup.DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(m:PresetManager, style:WiredStyle, b:WiredUIBuilder)
        {
            this._weekdays = m.createChronoMaskFilter(labels("time.weekday.", 7), 2);
            this._day = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 1, 1, 31, 25);
            this._months = m.createChronoMaskFilter(labels("time.month.", 12), 3);
            this._year = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 9999, 35);
            b.addElements([m.createSection(l("time.weekday_selection"), this._weekdays),
                m.createSection(l("time.day_selection"), this._day),
                m.createSection(l("time.month_selection"), this._months),
                m.createSection(l("time.year_selection"), this._year),
                createTimezoneSection(m)]);
        }

        override public function onEditStart(d:Triggerable)
        {
            super.onEditStart(d);
            var a= d.intData;
            this._weekdays.mask = ASCompat.toInt(a.length > 2 ? ASCompat.toInt(a[2] ): 0);
            this._day.applyFilter(new ChronoFieldRangeFilter("day", a.length > 0 && a[0] == 1,
                ASCompat.toInt(a.length > 3 ? ASCompat.toInt(a[3] ): 1), ASCompat.toInt(a.length > 4 ? ASCompat.toInt(a[4] ): 1), 1));
            this._months.mask = ASCompat.toInt(a.length > 5 ? ASCompat.toInt(a[5] ): 0);
            this._year.applyFilter(new ChronoFieldRangeFilter("year", a.length > 1 && a[1] == 1,
                ASCompat.toInt(a.length > 6 ? ASCompat.toInt(a[6] ): 0), ASCompat.toInt(a.length > 7 ? ASCompat.toInt(a[7] ): 0)));
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var d= this._day.getFilter("day");
            var y= this._year.getFilter("year");
            return [d.useFilter ? 1 : 0, y.useFilter ? 1 : 0, this._weekdays.mask,
                d.min, d.max, this._months.mask, y.min, y.max];
        }

        function labels(prefix:String, count:Int):Array<ASAny>
        {
var i = 0;            var result:Array<ASAny> = [];
            for (_tmp_ in 1...count + 1) {i= _tmp_;
result.push(l(prefix + Std.string(i)));
};
            return result;
        }

	public function new() { super(); }
    }

