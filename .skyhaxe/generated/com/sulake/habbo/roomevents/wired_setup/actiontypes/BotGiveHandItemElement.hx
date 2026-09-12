package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    /**
     * Action 24 (bot gives hand item) — May 2026 UI: bot-usage checkbox toggling
     * the bot name input, hand item dropdown with the May default code list, and
     * a capture button that reads your own avatar's current carry item.
     * Payload: intParams = [handItem], stringParam = botName ("" when the bot
     * usage checkbox is off).
     */
     class BotGiveHandItemElement extends DefaultElement
    {
        static final DEFAULT_CODES:Array<ASAny> = [0, 2, 5, 7, 8, 9, 10, 27, 1126, 1127, 1128];

        var _botUsage:CheckboxGroupPreset;
        var _botName:TextInputPreset;
        var _handItemDropdown:DropdownPreset;
        var _captureButton:ButtonPreset;
        var _options:Vector<ExpandableDropdownOption>;

        override public function  get_code():Int
        {
            return ActionTypeCodes.BOT_GIVE_HAND_ITEM;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._botUsage = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("bot.usage"))], this.onBotUsageChange);
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            this._options = this.createOptions(DEFAULT_CODES);
            this._handItemDropdown = _arg_1.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.bot.handitem"), this._options));
            this._captureButton = _arg_1.createButton(l("capture.handitem"), this.captureHanditem);
            _arg_3.addElements(
                [_arg_1.createSection(l("bot.name"), _arg_1.createSimpleListView(true, [this._botUsage, this._botName])),
                _arg_1.createSection(l("handitem"), _arg_1.createSimpleListView(true, [this._handItemDropdown, this._captureButton]))]
            );
        }

        override public function readStringParamFromForm():String
        {
            return this._botUsage.get(0).selected ? this._botName.text : "";
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var _local_1= this._handItemDropdown.selectedId;
            return [(_local_1 == -1) ? 0 : _local_1];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            var _local_2= (_arg_1.stringData != "");
            this._botName.text = _arg_1.stringData;
            this._botUsage.get(0).selected = _local_2;
            this._botName.window.visible = _local_2;
            this.setSelectedHandItemByCode(ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0));
        }

        function onBotUsageChange(_arg_1:Int, _arg_2:Bool)
        {
            if (_arg_1 != 0)
            {
                return;
            }
            this._botName.window.visible = _arg_2;
        }

        function createOptions(_arg_1:Array<ASAny>):Vector<ExpandableDropdownOption>
        {
var _local_2 = 0;            var _local_3= new Vector<ExpandableDropdownOption>();
            if (checkNullIteratee(_arg_1)) for (_tmp_ in _arg_1)
            {
_local_2 = ASCompat.toInt(_tmp_);
                _local_3.push(new ExpandableDropdownOption(_local_2, "${handitem" + Std.string(_local_2) + "}"));
            }
            return _local_3;
        }

        function setSelectedHandItemByCode(_arg_1:Int)
        {
            this.ensureOptionExists(_arg_1);
            this._handItemDropdown.selectedId = _arg_1;
        }

        function ensureOptionExists(_arg_1:Int)
        {
var _local_2:ExpandableDropdownOption  = null;            var _local_4 = 0;
            if (_arg_1 < 0)
            {
                return;
            }
            var _local_3= false;
            final _iter_ = this._options; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2 = _tmp_;
                if (_local_2.id == _arg_1)
                {
                    _local_3 = true;
                    break;
                }
            }
            if (!_local_3)
            {
                this._options.push(new ExpandableDropdownOption(_arg_1, "${handitem" + Std.string(_arg_1) + "}"));
            }
            var _local_5= -1;
            _local_4 = 0;
            while (_local_4 < this._options.length)
            {
                if (this._options[_local_4].id == _arg_1)
                {
                    _local_5 = _local_4;
                }
                _local_4++;
            }
            this._handItemDropdown.reinit(this._options, _local_5);
        }

        function captureHanditem()
        {
            if ((roomEvents.roomSession == null) || (roomEvents.roomEngine == null))
            {
                return;
            }
            var _local_1= Std.int(roomEvents.roomEngine.getRoomObject(roomEvents.roomSession.roomId, roomEvents.roomSession.ownUserRoomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER).getModel().getNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT));
            this.setSelectedHandItemByCode(_local_1);
        }

	public function new() { super(); }
    }

