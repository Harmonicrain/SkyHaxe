package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR actions 30/37. Both codes share the same two-boolean editor. */
     class SendSignalActionElement extends DefaultElement
    {
        var _signalOptions:CheckboxGroupPreset;
        var _ignoreCheckboxEvents:Bool = false;

        override public function  get_code():Int
        {
            return ActionTypeCodes.SEND_SIGNAL;
        }

        override public function  get_negativeCode():Int
        {
            return ActionTypeCodes.NEG_SEND_SIGNAL;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.SIGNALS;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._signalOptions = _arg_1.createCheckboxGroup([
                new CheckboxOptionParam(l("signal.split_furni")),
                new CheckboxOptionParam(l("signal.split_users"))
            ], this.onChangeCheckbox);
            _arg_3.addElements([_arg_1.createSection(l("signal.send_options"), this._signalOptions)]);
        }

        function onChangeCheckbox(_arg_1:Int, _arg_2:Bool)
        {
            if (this._ignoreCheckboxEvents || !_arg_2)
            {
                return;
            }
            var optionId= _arg_1;
            this.roomEvents.windowManager.confirm(
                "${wiredfurni.params.signal_warning.title}",
                "${wiredfurni.params.signal_warning.desc}",
                0,
                function(_arg_1:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                {
                    _arg_1.dispose();
                    if (_arg_2.type != WindowEvent.WINDOW_EVENT_OK)
                    {
                        _signalOptions.get(optionId).selected = false;
                    }
                });
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._ignoreCheckboxEvents = true;
            this._signalOptions.get(0).selected = (_arg_1.intData.length > 0) && (ASCompat.toInt(_arg_1.intData[0]) != 0);
            this._signalOptions.get(1).selected = (_arg_1.intData.length > 1) && (ASCompat.toInt(_arg_1.intData[1]) != 0);
            this._ignoreCheckboxEvents = false;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [
                this._signalOptions.get(0).selected ? 1 : 0,
                this._signalOptions.get(1).selected ? 1 : 0
            ];
        }

        override public function furniSelectionTitle(_arg_1:Int):String
        {
            return _arg_1 == 0
                ? "wiredfurni.params.sources.furni.title.signal_antenna"
                : "wiredfurni.params.sources.furni.title.signal_forward";
        }

        override public function userSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.users.title.signal_forward";
        }

	public function new() { super(); }
    }

