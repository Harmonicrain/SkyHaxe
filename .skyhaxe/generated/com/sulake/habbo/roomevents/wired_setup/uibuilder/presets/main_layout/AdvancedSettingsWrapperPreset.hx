package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextualButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class AdvancedSettingsWrapperPreset extends WiredUIPreset
    {
        var _container:IItemListWindow;
        var _button:TextualButtonPreset = null;
        var _buttonWrapper:WiredUIPreset = null;
        var _subsectionsPreset:SimpleListViewPreset;
        var _isExpanded:Bool = false;
        var _alwaysExpanded:Bool = false;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array<ASAny>, _arg_5:Bool)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._alwaysExpanded = _arg_5;
            this._container = Std.downcast(_arg_2.createLayout("vertical_list_view") , IItemListWindow);
            this._container.spacing = _arg_3.sectionSpacing;
            this._subsectionsPreset = _presetManager.createSimpleListView(true, _arg_4);
            this._subsectionsPreset.spacing = _arg_3.sectionSpacing;
            this._subsectionsPreset.backgroundColor = _arg_3.advancedBackgroundColor;
            blendingBackgroundColor = ASCompat.toInt(_arg_3.backgroundColor);
            if (!_arg_5)
            {
                this._button = _presetManager.createTextualButtonPreset("${wiredfurni.params.sources.expand}", this.expandOrCollapse);
                this._buttonWrapper = this._button.alignCenter();
                this._container.addListItem(this._buttonWrapper.window);
            }
            else
            {
                this.expanded = true;
            }
        }

        public var expanded(never,set):Bool;
public function  set_expanded(_arg_1:Bool):Bool        {
            if ((this._isExpanded != _arg_1) && (!(this._alwaysExpanded && this._isExpanded)))
            {
                this.expandOrCollapse();
            }
return _arg_1;
        }

        function expandOrCollapse()
        {
            if (this._isExpanded)
            {
                this._container.removeListItem(this._subsectionsPreset.window);
                this._isExpanded = false;
                blendingBackgroundColor = ASCompat.toInt(_style.backgroundColor);
            }
            else
            {
                this._container.addListItem(this._subsectionsPreset.window);
                this._isExpanded = true;
                blendingBackgroundColor = ASCompat.toInt(_style.advancedBackgroundColor);
            }
            if (this._button != null)
            {
                this._button.text = this._isExpanded ? "${wiredfurni.params.sources.collapse}" : "${wiredfurni.params.sources.expand}";
                this._buttonWrapper.resizeToWidth(this._container.width);
            }
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            if (this._buttonWrapper != null)
            {
                this._buttonWrapper.resizeToWidth(_arg_1);
            }
            this._subsectionsPreset.resizeToWidth(_arg_1);
        }

        override function  get_childPresets():Array<ASAny>
        {
            if (this._buttonWrapper == null)
            {
                return [this._subsectionsPreset];
            }
            return [this._buttonWrapper, this._subsectionsPreset];
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
            this._button = null;
            this._buttonWrapper = null;
            this._subsectionsPreset = null;
        }
    }

