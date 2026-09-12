package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class StaticHeightPreset extends WiredUIPreset
    {
        var _window:IWindowContainer;
        var _subPreset:WiredUIPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset, _arg_5:Int)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = Std.downcast(_arg_2.createLayout("container_view") , IWindowContainer);
            this._subPreset = _arg_4;
            this._window.addChild(this._subPreset.window);
            this._window.height = _arg_5;
        }

        override public function  get_window():IWindow
        {
            return this._window;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
            this._subPreset.resizeToWidth(_arg_1);
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._subPreset];
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._subPreset = null;
        }
    }

