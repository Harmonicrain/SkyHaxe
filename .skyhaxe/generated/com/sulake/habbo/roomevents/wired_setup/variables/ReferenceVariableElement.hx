package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedVariableList;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ReferenceVariableElement extends VariableElement
    {
        var _variableName:VariableNameSection;
        var _roomDropdown:DropdownPreset;
        var _variableDropdown:DropdownPreset;
        var _settings:CheckboxGroupPreset;
        var _initialVariable:WiredVariable;
        var _rooms:Array<ASAny>;
        var _variablesByRoom:ASDictionary<ASAny,ASAny>;
        var _variableIds:Array<ASAny>;
        var _variables:Array<ASAny>;
        var _selectedRoomId:Int = -1;
        var _ready:Bool = false;

        override public function  get_code():Int { return VariableCodes.REFERENCE_VARIABLE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variableName = manager.createVariableNameSection();
            this._roomDropdown = manager.createDropdown(new DropdownParam(
                l("variables.room_selection.tooltip"), null, this.onRoomSelected));
            this._variableDropdown = manager.createDropdown(new DropdownParam(
                l("variables.variable_selection.tooltip"), null, this.onVariableSelected));
            this._settings = manager.createCheckboxGroup([
                new CheckboxOptionParam(l("variables.settings.read_only"))
            ]);
            builder.addElements([this._variableName,
                manager.createSection(l("variables.room_selection"), this._roomDropdown),
                manager.createSection(l("variables.variable_ref_selection"),
                    this._variableDropdown),
                manager.createSection(l("variables.settings"), this._settings)]);
        }

        override public function onEditStart(data:Triggerable)
        {
            super.onEditStart(data);
            var selectedId= data.variableIds.length > 0
                ? ASCompat.toString(data.variableIds[0]) : WiredVariable.NONE_ID;
            this._settings.get(0).selected = data.intData.length > 0 &&
                ASCompat.toInt(data.intData[0]) != 0;
            this._ready = false;
            var shared= data.wiredContext.referenceVariablesList;
            this.initRooms(selectedId, shared);
            this.refreshVariables(selectedId);
            this._initialVariable = this.findVariableById(selectedId);
            this.initialVariableName = data.stringData;
            this._ready = true;
            this.setEditable(shared != null);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._settings.get(0).selected ? 1 : 0];
        }
        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName;
        }
        override public function readVariableIdsFromForm():Array<ASAny>
        {
            var index= this._variableDropdown.selectedId;
            if (index < 0 || index >= this._variableIds.length)
            {
                return [WiredVariable.NONE_ID];
            }
            return [this._variableIds[index]];
        }

        function setEditable(value:Bool)
        {
            this._variableName.disabled = !value;
            this._roomDropdown.disabled = !value;
            this._variableDropdown.disabled = !value;
            this._settings.disabled = !value;
        }

        function initRooms(selectedId:String, list:SharedVariableList)
        {
var shared:SharedVariable  = null, room:ASObject  = null;            this._variablesByRoom = new ASDictionary<ASAny,ASAny>();
            this._rooms = [];
            this._selectedRoomId = -1;
            var roomMap= new ASDictionary<ASAny,ASAny>();
            var selectedRoom:ASObject = null;
            if (list != null)
            {
                final _iter_ = list.sharedVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
shared = _tmp_;
room= roomMap[shared.roomId];
                    if (room == null)
                    {
                        room = {"id":shared.roomId, "name":shared.roomName};
                        roomMap[shared.roomId] = room;
                        this._rooms.push(room);
                        this._variablesByRoom[shared.roomId] = ([] : Array<Dynamic>);
                    }
                    this._variablesByRoom[shared.roomId].push(shared.wiredVariable);
                    if (shared.wiredVariable.variableId == selectedId) { selectedRoom = room; }
                }
                ASCompat.ASArray.sortOn(this._rooms, "name", ASCompat.ASArray.CASEINSENSITIVE);
            }
            if (selectedRoom != null) { this._selectedRoomId = ASCompat.toInt(selectedRoom.id); }
            var roomOptions=
                new Vector<ExpandableDropdownOption>();
            final _iter_ = this._rooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
room  = _tmp_;
                roomOptions.push(new ExpandableDropdownOption(ASCompat.toInt(room.id), room.name));
            }
            this._roomDropdown.reinit(roomOptions, this._selectedRoomId);
        }

        function refreshVariables(selectedId:String)
        {
var variable:WiredVariable  = null, index = 0;            this._variableIds = [];
            this._variables = [];
            var options=
                new Vector<ExpandableDropdownOption>();
            var selectedIndex= -1;
            var roomVariables:Array<ASAny> = ASCompat.dynamicAs(this._variablesByRoom[this._selectedRoomId] , Array);
            if (roomVariables != null)
            {
                if (checkNullIteratee(roomVariables)) for (_tmp_ in roomVariables)
                {
variable = _tmp_;
index= options.length;
                    options.push(new ExpandableDropdownOption(index, variable.variableName));
                    this._variableIds.push(variable.variableId);
                    this._variables.push(variable);
                    if (variable.variableId == selectedId) { selectedIndex = index; }
                }
            }
            this._variableDropdown.reinit(options, selectedIndex);
        }

        function onRoomSelected(option:ExpandableDropdownOption)
        {
            if (!this._ready || option == null || this._selectedRoomId == option.id) { return; }
            this._selectedRoomId = option.id;
            this.refreshVariables(WiredVariable.NONE_ID);
            this.onVariableSelected(null);
        }

        function onVariableSelected(option:ExpandableDropdownOption)
        {
            if (!this._ready) { return; }
            var index= option == null ? -1 : option.id;
            var selected:WiredVariable = index >= 0 && index < this._variables.length
                ? this._variables[index] : null;
            if (this._variableName.variableName.length == 0 ||
                this._initialVariable != null &&
                this._initialVariable.variableName == this._variableName.variableName)
            {
                this._variableName.variableName =
                    selected == null ? "" : selected.variableName;
            }
            this._initialVariable = selected;
        }

        function findVariableById(id:String):WiredVariable
        {
var roomVariables:Array<ASAny>  = null, variable:WiredVariable  = null;            final _iter_ = this._variablesByRoom; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
roomVariables = _tmp_;
                if (checkNullIteratee(roomVariables)) for (_tmp_ in roomVariables)
                {
variable = _tmp_;
                    if (variable.variableId == id) { return variable; }
                }
            }
            return null;
        }
        override function  get_variableNameSection():VariableNameSection
        {
            return this._variableName;
        }

	public function new() { super(); }
    }

