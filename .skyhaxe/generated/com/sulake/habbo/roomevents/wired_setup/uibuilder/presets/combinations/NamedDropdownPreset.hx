package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
;
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class NamedDropdownPreset extends WiredUIPreset
    {
        var _container:IWindowContainer;
        var _listPreset:SimpleListViewPreset;
        var _textPreset:TextPreset;
        var _dropdownPreset:DropdownPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:DropdownParam, _arg_5:String, _arg_6:Bool = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("growing_container_view") , IWindowContainer);
            this._textPreset = _arg_2.createText(_arg_5, new TextParam(0, _arg_6));
            this._dropdownPreset = _arg_2.createDropdown(_arg_4);
            this._textPreset.window.y = _arg_3.namedDropdownOffset;
            this._listPreset = _arg_2.createSimpleListView(false, [this._textPreset, this._dropdownPreset], true);
            this._container.addChild(this._listPreset.window);
        }

        
        public var selectedId(get,set):Int;
public function  get_selectedId():Int
        {
            return this._dropdownPreset.selectedId;
        }
public function  set_selectedId(_arg_1:Int):Int        {
            return this._dropdownPreset.selectedId = _arg_1;
        }

        public var selected(get,never):ExpandableDropdownOption;
public function  get_selected():ExpandableDropdownOption
        {
            return this._dropdownPreset.selected;
        }

        public function reinit(_arg_1:Vector<ExpandableDropdownOption>, _arg_2:Int)
        {
            this._dropdownPreset.reinit(_arg_1, _arg_2);
        }

        public function reset()
        {
            this._dropdownPreset.reset();
        }

        override public function hasStaticWidth():Bool
        {
            return this._dropdownPreset.hasStaticWidth();
        }

        override public function  get_staticWidth():Int
        {
            if (hasStaticWidth())
            {
                return this._container.width;
            }
            throw new Exception("Named dropdown has no static width");
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._listPreset.resizeToWidth(_arg_1);
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._listPreset];
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._listPreset.dispose();
            this._listPreset = null;
            this._textPreset = null;
            this._dropdownPreset = null;
        }
    }

