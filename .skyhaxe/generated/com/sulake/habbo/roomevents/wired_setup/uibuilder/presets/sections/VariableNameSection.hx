package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Variable-name input with the normalization used by the July client. */
     class VariableNameSection extends AbstractSectionPreset
    {
        var _name:TextInputPreset;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                            presetManager:PresetManager,
                                            style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._name = presetManager.createTextInput(new TextInputParam("", 40));
            this._name.addListener(this.onNameChanged);
            this.initializeSection(l("variables.variable_name"), this._name);
        }

        function onNameChanged(value:String)
        {
            var normalized= normalize(value);
            if (this._name.text != normalized)
            {
                this._name.text = normalized;
            }
        }

        static function normalize(value:String):String
        {
            return (value != null ? value : "").split(" ").join("_").toLowerCase();
        }

        
        public var variableName(get,set):String;
public function  set_variableName(value:String):String        {
            this._name.text = value != null ? value : "";
            this.onNameChanged(this._name.text);
return value;
        }
public function  get_variableName():String
        {
            return normalize(this._name.text);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._name = null;
        }
    }

