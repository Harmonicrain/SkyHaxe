package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 7: movement-collision physics flags. */
     class MovementPhysicsAddonElement extends DefaultElement
    {
        var _options:CheckboxGroupPreset;

        override public function  get_code():Int { return AddonCodes.MOVEMENT_PHYSICS; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._options = manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("movephysics.keep_altitude"), 0),
                new CheckboxOptionParam(this.l("movephysics.move_through_furni"), 1),
                new CheckboxOptionParam(this.l("movephysics.move_through_users"), 2),
                new CheckboxOptionParam(this.l("movephysics.block_by_furni"), 3)
            ]);
            builder.addElements([manager.createSection(this.l("select_options"), this._options)]);
        }

        override public function onEditStart(definition:Triggerable)
        {
var index = 0;            var index = 0;
            for (_tmp_ in 0...4)
            {
index= _tmp_;
                this._options.get(index).selected = definition.intData.length > index &&
                    ASCompat.toInt(definition.intData[index]) == 1;
            }
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [
                this._options.get(0).selected ? 1 : 0,
                this._options.get(1).selected ? 1 : 0,
                this._options.get(2).selected ? 1 : 0,
                this._options.get(3).selected ? 1 : 0
            ];
        }

        override public function furniSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.furni.title.physics." + Std.string(index);
        }

        override public function userSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.users.title.physics." + Std.string(index);
        }

	public function new() { super(); }
    }

