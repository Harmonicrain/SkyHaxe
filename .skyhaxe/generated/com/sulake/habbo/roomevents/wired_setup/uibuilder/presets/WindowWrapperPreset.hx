package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class WindowWrapperPreset extends WiredUIPreset
    {
        var _window:IWindow;
        var _staticWidth:Bool = false;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:IWindow, _arg_5:Bool)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = _arg_4;
            this._staticWidth = _arg_5;
        }

        override public function  get_window():IWindow
        {
            return this._window;
        }

        override public function hasStaticWidth():Bool
        {
            return this._staticWidth;
        }

        override public function  get_staticWidth():Int
        {
            if (!this._staticWidth)
            {
                return -1;
            }
            return this._window.width;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
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
        }
    }

