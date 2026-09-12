package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class SpacerPreset extends WiredUIPreset
    {
        var _container:IWindow;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Int)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("container_view");
            this._container.height = _arg_4;
        }

        public var backgroundEnabled(never,set):Bool;
public function  set_backgroundEnabled(_arg_1:Bool):Bool        {
            return this._container.background = _arg_1;
        }

        public var backgroundColor(never,set):Int;
public function  set_backgroundColor(_arg_1:Int):Int        {
            this._container.color = (ASCompat.toInt(0xFF000000 )| _arg_1);
return _arg_1;
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

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
        }
    }

