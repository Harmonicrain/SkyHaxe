package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July searchable, target-aware variable picker. */
     class VariablePickerPreset extends WiredUIPreset
    {
        var _picker:NewVariablePicker;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                             presetManager:PresetManager,
                                             style:WiredStyle,
                                             filter:ASFunction = null,
                                             onSelected:ASFunction = null)
        {
            super(roomEvents, presetManager, style);
            this._picker = new NewVariablePicker(roomEvents,
                Std.downcast(presetManager.createLayout("search_tree_dropdown") , IWindowContainer),
                filter, onSelected, style);
        }

        public function init(variables:AllVariablesInRoom, selectedId:String, variableTarget:Int)
        {
            this._picker.init(variables, selectedId, variableTarget);
        }

        public var variableTarget(never,set):Int;
public function  set_variableTarget(value:Int):Int{ return this._picker.variableTarget = value; }
        public var selected(get,never):WiredVariable;
public function  get_selected():WiredVariable { return this._picker.selected; }

        public var finalizeSelection(get,never):String;
public function  get_finalizeSelection():String
        {
            var value= this.selected;
            this._picker.finalize();
            // July uses optional chaining here. Its newer wire encoder preserves
            // the null slot, while the 2016 Eva encoder silently omits null array
            // entries and corrupts every following field. Use July's explicit
            // no-variable id so the declared variableIds count remains truthful.
            return value == null ? WiredVariable.NONE_ID : value.variableId;
        }

        override public function resizeToWidth(value:Int)
        {
            super.resizeToWidth(value);
            this._picker.width = value;
        }

        override public function  get_window():IWindow { return this._picker.window; }

        override public function dispose()
        {
            if (disposed) { return; }
            super.dispose();
            this._picker.dispose();
            this._picker = null;
        }
    }

