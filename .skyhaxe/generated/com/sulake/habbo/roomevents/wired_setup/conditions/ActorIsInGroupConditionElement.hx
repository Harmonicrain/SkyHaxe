package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildMembershipsMessageComposer;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    /**
     * Condition codes 10/21 (actor is / is not group member) — May 2026 payload.
     *
     * stringParam = specific group id, or "" meaning the room's own group. The
     * group dropdown is populated from a GetGuildMemberships round-trip routed
     * through the controller's onGuildMemberships hook (May §_-8j§ behavior).
     */
     class ActorIsInGroupConditionElement extends DefaultElement
    {
        static var REQUEST_TIMEOUT:Int = 5;

        var _guilds:Array<ASAny>;
        var _selectedGroupId:Int = -1;
        var _lastRequestTime:Float = 0;
        var _groupType:RadioGroupPreset;
        var _groupDropdown:DropdownPreset;

        override public function  get_code():Int
        {
            return ConditionCodes.ACTOR_IS_GROUP_MEMBER;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_ACTOR_IN_GROUP;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._groupDropdown = _arg_1.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.group"), new Vector<ExpandableDropdownOption>()));
            this._groupType = _arg_1.createRadioGroup([new RadioButtonParam(0, l("grouptype.0")), new RadioButtonParam(1, l("grouptype.1"), null, this._groupDropdown)]);
            _arg_3.addElements([_arg_1.createSection(l("groupselection"), this._groupType)]);
        }

        override public function readStringParamFromForm():String
        {
            if (this._groupType.selected != 1)
            {
                return "";
            }
            var _local_1= this._groupDropdown.selected;
            if (_local_1 == null)
            {
                return "";
            }
            return Std.string(_local_1.id);
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._selectedGroupId = (_arg_1.stringData == "") ? -1 : ASCompat.toInt(_arg_1.stringData);
            this.initGuilds((this._guilds == null) ? [] : this._guilds);
            this.maybeGetGuildMemberships();
            this._groupType.selected = (_arg_1.stringData != "") ? 1 : 0;
        }

        function maybeGetGuildMemberships()
        {
            var _local_1= Date.now().getTime();
            if (_local_1 > (this._lastRequestTime + (1000 * REQUEST_TIMEOUT)))
            {
                this._lastRequestTime = _local_1;
                roomEvents.send(new GetGuildMembershipsMessageComposer());
            }
        }

        function initGuilds(_arg_1:Array<ASAny>)
        {
            var _local_2:HabboGroupEntryData = null;
            var _local_3= new Vector<ExpandableDropdownOption>();
            var selectedIndex= -1;
            this._guilds = _arg_1;
            var _local_4= 0;
            while (_local_4 < this._guilds.length)
            {
                _local_2 = this._guilds[_local_4];
                if (_local_2.groupId == this._selectedGroupId)
                {
                    selectedIndex = _local_3.length;
                }
                _local_3.push(new ExpandableDropdownOption(_local_2.groupId, _local_2.groupName));
                _local_4++;
            }
            this._groupDropdown.reinit(_local_3, selectedIndex);
        }

        override public function onGuildMemberships(_arg_1:Array<ASAny>)
        {
            this.initGuilds(_arg_1);
        }

	public function new() { super(); }
    }

