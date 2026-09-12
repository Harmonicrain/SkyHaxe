package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July target-aware variable picker section, optionally linked to a merged source slot. */
     class ChooseVariableSection extends AbstractSectionPreset implements ISourceTypeListener
    {
        var _picker:VariablePickerPreset;
        var _mergedSelectionId:Int = 0;
        var _target:Int = 0;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                              manager:PresetManager, style:WiredStyle,
                                              mergedSelectionId:Int, sourceOptions:Array<ASAny>,
                                              filter:ASFunction, onSelected:ASFunction,
                                              title:String = null)
        {
            super(roomEvents, manager, style);
            this._mergedSelectionId = mergedSelectionId;
            var sectionParam:SectionParam = sourceOptions == null ? null :
                new SectionParam(new SourceTypeSelectorParam(sourceOptions, this));
            this._picker = manager.createVariablePicker(filter, onSelected);
            this.initializeSection(title == null ? this.l("variables.variable_selection") : title,
                this._picker, sectionParam);
        }

        public function init(variables:AllVariablesInRoom, selectedId:String, target:Int)
        {
            this._picker.init(variables, selectedId, target);
            this._target = target;
        }

        public function onEditInitialized()
        {
            var selector:ASAny = this.getSourceTypeSelector();
            if (selector != null) { selector.select(this._target); }
        }

                public var target(get,set):Int;
public function  set_target(value:Int):Int        {
            this._target = value;
            return this._picker.variableTarget = value;
        }
public function  get_target():Int { return this._target; }
        public var finalizeSelection(get,never):String;
public function  get_finalizeSelection():String { return this._picker.finalizeSelection; }
        public var selected(get,never):WiredVariable;
public function  get_selected():WiredVariable { return this._picker.selected; }

        public var sourceType(never,set):Int;
public function  set_sourceType(value:Int):Int        {
            if (this._mergedSelectionId != -1)
            {
                this._roomEvents.wiredCtrl.setMergedSourceType(this._mergedSelectionId, value);
            }
            else
            {
                this.target = value;
            }
return value;
        }
    }

