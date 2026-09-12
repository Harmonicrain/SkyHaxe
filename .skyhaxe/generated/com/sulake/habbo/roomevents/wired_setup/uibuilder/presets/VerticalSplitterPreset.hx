package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class VerticalSplitterPreset extends WiredUIPreset
    {
        static inline final SPLITTER_WIDTH= 1;

        var _window:IWindowContainer;
        var _height:Int = 0;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Int)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._height = _arg_4;
            this._window = Std.downcast(_arg_2.createLayout("container_view") , IWindowContainer);
            this._window.width = SPLITTER_WIDTH;
            this._window.height = this._height;
            this._window.background = true;
            this._window.color = _arg_3.verticalSplitterColor;
        }

        override public function  get_window():IWindow
        {
            return this._window;
        }

        override public function hasStaticWidth():Bool
        {
            return true;
        }

        override public function  get_staticWidth():Int
        {
            return SPLITTER_WIDTH;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._window.width = SPLITTER_WIDTH;
            this._window.height = this._height;
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

