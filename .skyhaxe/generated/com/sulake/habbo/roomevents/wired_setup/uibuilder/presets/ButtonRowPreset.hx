package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ButtonRowPreset extends WiredUIPreset
    {
        var _container:IWindowContainer;
        var _listPreset:SimpleListViewPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array<ASAny>)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("growing_container_view") , IWindowContainer);
            this._listPreset = _arg_2.createSimpleListView(false, _arg_4);
            this._listPreset.spacing = _arg_3.buttonRowSpacing;
            this._container.addChild(this._listPreset.window);
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
            this._container.dispose();
            this._container = null;
            this._listPreset = null;
        }
    }

