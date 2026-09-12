package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class IconButtonPreset extends WiredUIPreset
    {
        var _container:IWindow;
        var _onClick:ASFunction;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_3.createIconButton(_arg_4);
            this._onClick = _arg_5;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.iconClicked);
        }

        function iconClicked(_arg_1:WindowMouseEvent)
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
            this._container.width = _arg_1;
        }

        override public function hasStaticWidth():Bool
        {
            return true;
        }

        override public function  get_staticWidth():Int
        {
            return this._container.width;
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

