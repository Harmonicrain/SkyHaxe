package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ButtonPreset extends WiredUIPreset
    {
        public static inline final MODE_SCALE= 0;
        public static inline final MODE_STRETCH= 1;

        var _container:IButtonWindow;
        var _mode:Int = 0;
        var _onClick:ASFunction;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:ASFunction, _arg_6:Int = 0)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._onClick = _arg_5;
            this._container = _arg_3.createButton();
            this._container.caption = _arg_4;
            this._mode = _arg_6;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.buttonClicked);
        }

        function buttonClicked(_arg_1:WindowMouseEvent)
        {
            if (this._onClick != null)
            {
                this._onClick();
            }
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            if (this._mode == MODE_SCALE)
            {
                this._container.limits.minWidth = _arg_1;
                this._container.limits.maxWidth = _arg_1;
                this._container.width = _arg_1;
            }
        }

        override public function hasStaticWidth():Bool
        {
            return this._mode == MODE_STRETCH;
        }

        override public function  get_staticWidth():Int
        {
            if (this._mode == MODE_STRETCH)
            {
                return this._container.width;
            }
            return -1;
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
            this._onClick = null;
        }
    }

