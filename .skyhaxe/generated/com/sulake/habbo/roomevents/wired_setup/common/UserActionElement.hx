package com.sulake.habbo.roomevents.wired_setup.common
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.WiredUserAction;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared May 2026 action editor used by the action trigger, condition and selector. */
     class UserActionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _negativeCode:Int = 0;
        var _actionDropdown:DropdownPreset;
        var _signCheckbox:CheckboxGroupPreset;
        var _danceCheckbox:CheckboxGroupPreset;
        var _signDropdown:DropdownPreset;
        var _danceDropdown:DropdownPreset;
        var _signSection:SectionPreset;
        var _danceSection:SectionPreset;

        public function new(code:Int, negativeCode:Int = -1)
        {
            super();
            this._code = code;
            this._negativeCode = negativeCode;
        }

        override public function  get_code():Int
        {
            return this._code;
        }

        override public function  get_negativeCode():Int
        {
            return this._negativeCode;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(presets:PresetManager, style:WiredStyle, builder:WiredUIBuilder)
        {
            this._actionDropdown = presets.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.action"), this.buildActionOptions(), this.onActionSelected));
            var actionSection= presets.createSection(l("action_selection"), this._actionDropdown);

            this._signDropdown = presets.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.sign"), this.buildSignOptions()));
            var signParam= new CheckboxOptionParam(l("sign_filter"), 0);
            signParam.extra2 = this._signDropdown;
            this._signCheckbox = presets.createCheckboxGroup([signParam]);
            this._signSection = presets.createSection(l("sign_selection"), this._signCheckbox);

            this._danceDropdown = presets.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.dance"), this.buildDanceOptions()));
            var danceParam= new CheckboxOptionParam(l("dance_filter"), 0);
            danceParam.extra2 = this._danceDropdown;
            this._danceCheckbox = presets.createCheckboxGroup([danceParam]);
            this._danceSection = presets.createSection(l("dance_selection"), this._danceCheckbox);

            this._signSection.visible = false;
            this._danceSection.visible = false;
            builder.addElements([actionSection, this._signSection, this._danceSection]);
        }

        override public function onEditStart(triggerable:Triggerable)
        {
            this._actionDropdown.selectedId = ASCompat.toInt(triggerable.intData.length > 0 ? ASCompat.toInt(triggerable.intData[0] ): 0);
            this.updateExtraSections(triggerable.stringData);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var action= this.selectedAction;
            return [action != null ? action.code : 0];
        }

        override public function readStringParamFromForm():String
        {
            var action= this.selectedAction;
            if (action == null || !action.hasExtra)
            {
                return "";
            }

            var extraCode= this.selectedExtraCode(action.code);
            return extraCode == -1 ? "" : action.convertCodeToExtraString(extraCode);
        }

        function onActionSelected(option:ExpandableDropdownOption)
        {
            this.updateExtraSections();
        }

        function updateExtraSections(extra:String = "")
        {
            var action= this.selectedAction;
            if (action == null || !action.hasExtra)
            {
                this._signSection.visible = false;
                this._danceSection.visible = false;
                return;
            }

            var isSign= action.code == WiredUserAction.SIGN_ACTION_CODE;
            var isDance= action.code == WiredUserAction.DANCE_ACTION_CODE;
            this._signSection.visible = isSign;
            this._danceSection.visible = isDance;

            if (isSign)
            {
                this._signCheckbox.get(0).selected = extra != "";
                this._signDropdown.selectedId = extra == "" ? -1 : action.convertExtraStringToCode(extra);
            }
            if (isDance)
            {
                this._danceCheckbox.get(0).selected = extra != "";
                this._danceDropdown.selectedId = extra == "" ? -1 : action.convertExtraStringToCode(extra);
            }
        }

        var selectedAction(get,never):WiredUserAction;
function  get_selectedAction():WiredUserAction
        {
            return WiredUserAction.getByCode(this._actionDropdown.selectedId);
        }

        function selectedExtraCode(actionCode:Int):Int
        {
            if (actionCode == WiredUserAction.SIGN_ACTION_CODE)
            {
                return this._signCheckbox.get(0).selected ? this._signDropdown.selectedId : -1;
            }
            if (actionCode == WiredUserAction.DANCE_ACTION_CODE)
            {
                return this._danceCheckbox.get(0).selected ? this._danceDropdown.selectedId : -1;
            }
            return -1;
        }

        function buildActionOptions():Vector<ExpandableDropdownOption>
        {
var action:WiredUserAction  = null;            var options= new Vector<ExpandableDropdownOption>();
            final _iter_ = WiredUserAction.allWiredUserActions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
action = _tmp_;
                options.push(new ExpandableDropdownOption(action.code, l("action." + Std.string(action.code))));
            }
            return options;
        }

        function buildSignOptions():Vector<ExpandableDropdownOption>
        {
var i = 0;            var options= new Vector<ExpandableDropdownOption>();
            for (_tmp_ in 0...18)
            {
i= _tmp_;
                options.push(new ExpandableDropdownOption(i, l("action.sign." + Std.string(i))));
            }
            return options;
        }

        function buildDanceOptions():Vector<ExpandableDropdownOption>
        {
var i = 0;            var options= new Vector<ExpandableDropdownOption>();
            for (_tmp_ in 1...5)
            {
i= _tmp_;
                options.push(new ExpandableDropdownOption(i, l("action.dance." + Std.string(i))));
            }
            return options;
        }
    }

