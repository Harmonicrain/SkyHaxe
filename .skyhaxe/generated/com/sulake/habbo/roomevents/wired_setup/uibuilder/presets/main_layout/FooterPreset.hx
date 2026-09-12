package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SplitterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class FooterPreset extends WiredUIPreset
    {
        var _container:IItemListWindow;
        var _splitter:SplitterPreset;
        var _buttonRow:ButtonRowPreset;
        var _saveButton:ButtonPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:ASFunction, _arg_5:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("vertical_list_view") , IItemListWindow);
            this._splitter = _arg_2.createSplitter();
            this._saveButton = _arg_2.createButton(loc("wiredfurni.ready"), _arg_4);
            var _local_6= _arg_2.createButton(loc("cancel"), _arg_5);
            this._buttonRow = _arg_2.createButtonRow([this._saveButton, _local_6]);
            this._buttonRow.window.x = _arg_3.sectionLeftRightMargin;
            this._container.spacing = _style.sectionSpacing;
            this._container.addListItem(this._splitter.window);
            this._container.addListItem(this._buttonRow.window);
        }

        public var saveButtonDisabled(never,set):Bool;
public function  set_saveButtonDisabled(_arg_1:Bool):Bool        {
            return this._saveButton.disabled = _arg_1;
        }

        public var saveButtonCaption(never,set):String;
public function  set_saveButtonCaption(_arg_1:String):String        {
            if ((this._saveButton != null) && (this._saveButton.window != null))
            {
                this._saveButton.window.caption = _arg_1;
            }
return _arg_1;
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        public var splitterVisible(never,set):Bool;
public function  set_splitterVisible(_arg_1:Bool):Bool        {
            return this._splitter.visible = _arg_1;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            this._splitter.resizeToWidth(_arg_1);
            this._buttonRow.resizeToWidth(_arg_1 - (_style.sectionLeftRightMargin * 2));
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._splitter, this._buttonRow];
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._splitter = null;
            this._buttonRow = null;
            this._saveButton = null;
        }
    }

