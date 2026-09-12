package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;

    /** Shared July timezone selector for chronological conditions. */
     class ChronoConditionElement extends DefaultElement
    {
        var _timezone:DropdownPreset;
        var _values:Vector<String>;
        var _section:SectionPreset;
        var _currentTimezone:String = "UTC";

        function createTimezoneSection(manager:PresetManager):SectionPreset
        {
            this._timezone = manager.createDropdown(new DropdownParam(
                loc("wiredfurni.tooltip.timezone"), this.options(this._currentTimezone)));
            this._section = manager.createSection(l("time.timezone_selection"), this._timezone);
            this._section.window.visible = this._values.length > 1;
            return this._section;
        }

        override public function onEditStart(definition:Triggerable)
        {
            this._currentTimezone = definition.stringData == "" ? "UTC" : definition.stringData;
            this._timezone.reinit(this.options(this._currentTimezone), 0);
            if (this._section != null)
            {
                this._section.window.visible = this._values.length > 1;
            }
        }

        override public function readStringParamFromForm():String
        {
            var id= this._timezone == null ? -1 : this._timezone.selectedId;
            this._currentTimezone = id >= 0 && id < this._values.length ? this._values[id] : "UTC";
            return this._currentTimezone;
        }

        function options(selected:String):Vector<ExpandableDropdownOption>
        {
var value:String  = null,             i = 0;            var raw= roomEvents.getProperty("wired.timezones");
            var source:Array<ASAny> = raw == null || raw == "" ? ["UTC"] : (cast raw.split(","));
            this._values = new Vector<String>();
            if (selected != "") this._values.push(selected);
            if (checkNullIteratee(source)) for (_tmp_ in source)
            {
value = _tmp_;
                if (value != selected) this._values.push(value);
            }
            var result= new Vector<ExpandableDropdownOption>();
            i= 0;while (i < this._values.length)
                {result.push(new ExpandableDropdownOption(i, this._values[i]));
i++;
};
            return result;
        }

	public function new() { super(); }
    }

