package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications.SubVariableParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July's checkbox + immutable generated-variable-name control. */
     class SubVariableCreatorPreset extends WiredUIPreset
    {
        var _checkboxGroup:CheckboxGroupPreset;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                                 presets:PresetManager,
                                                 style:WiredStyle,
                                                 localizationPrefix:String,
                                                 variables:Array<ASAny>)
        {
var variable:SubVariableParam  = null, key:String  = null, option:CheckboxOptionParam  = null, textParam:TextParam  = null;            super(roomEvents, presets, style);
            var options:Array<ASAny> = [];
            if (checkNullIteratee(variables)) for (_tmp_ in variables)
            {
variable = _tmp_;
key= localizationPrefix + Std.string(variable.id);
option= new CheckboxOptionParam("${" + key + "}", variable.id);
                option.extra1 = presets.createTextInput(
                    new TextInputParam(variable.name, -1, null, 85, null, false)).alignRight();
                if (variable.hasExtraText)
                {
textParam= new TextParam(1);
                    textParam.textColor = style.softTextColor;
                    option.extra2 = presets.createText("${" + key + ".extra}", textParam);
                }
                options.push(option);
            }
            this._checkboxGroup = presets.createCheckboxGroup(options);
        }

                public var mask(get,set):Int;
public function  set_mask(value:Int):Int{ return this._checkboxGroup.mask = value; }
public function  get_mask():Int { return this._checkboxGroup.mask; }
        override public function  get_window():IWindow { return this._checkboxGroup.window; }
        override public function resizeToWidth(value:Int)
        {
            super.resizeToWidth(value);
            this._checkboxGroup.resizeToWidth(value);
        }
        override function  get_childPresets():Array<ASAny> { return [this._checkboxGroup]; }
        override public function dispose()
        {
            if (disposed) { return; }
            super.dispose();
            this._checkboxGroup = null;
        }
    }

