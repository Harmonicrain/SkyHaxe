package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    /**
     * Condition (actor has hand item) — May 2026 UI: hand item dropdown with the
     * May default code list plus a capture button reading your own carry item,
     * replacing the raw number input. Payload unchanged: intParams = [handItem].
     */
     class ActorHasHandItemConditionElement extends DefaultElement
    {
        static final DEFAULT_CODES:Array<ASAny> = [0, 2, 5, 7, 8, 9, 10, 27];

        var _handItemDropdown:DropdownPreset;
        var _captureButton:ButtonPreset;
        var _options:Vector<ExpandableDropdownOption>;

        override public function  get_code():Int
        {
            return ConditionCodes.ACTOR_HAS_HANDITEM;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._options = this.createOptions(DEFAULT_CODES);
            this._handItemDropdown = _arg_1.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.handitem"), this._options));
            this._captureButton = _arg_1.createButton(l("capture.handitem"), this.captureHanditem);
            _arg_3.addElements([_arg_1.createSection(l("handitem"), _arg_1.createSimpleListView(true, [this._handItemDropdown, this._captureButton]))]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var _local_1= this._handItemDropdown.selectedId;
            return [(_local_1 == -1) ? 0 : _local_1];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this.setSelectedHandItemByCode(ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0));
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
            var _local_1:ASObject = roomEvents.roomEngine.getRoomObject(roomEvents.roomSession.roomId, roomEvents.roomSession.ownUserRoomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            if ((_local_1 == null) || (_local_1.getModel() == null))
            {
                return;
            }
            this.setSelectedHandItemByCode(ASCompat.toInt(_local_1.getModel().getNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT)));
        }

	public function new() { super(); }
    }

