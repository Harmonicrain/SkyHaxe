package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ChronoMaskFilterPreset extends WiredUIPreset
    {
        var _group:CheckboxGroupPreset;

        public function new(events:HabboUserDefinedRoomEvents, manager:PresetManager,
                                               style:WiredStyle, labels:Array<ASAny>, columns:Int = 1)
        {
var             i = 0;            super(events, manager, style);
            var options:Array<ASAny> = [];
            i= 0;while (i < labels.length)
                {options.push(new CheckboxOptionParam(labels[i], i));
i++;
};
            this._group = manager.createCheckboxGroup(options, null, columns);
        }

                public var mask(get,set):Int;
public function  get_mask():Int { return this._group.mask; }
public function  set_mask(value:Int):Int{ return this._group.mask = value; }
        override public function  get_window():IWindow { return this._group.window; }
        override public function resizeToWidth(value:Int) { super.resizeToWidth(value); this._group.resizeToWidth(value); }
        override function  get_childPresets():Array<ASAny> { return [this._group]; }
    }

