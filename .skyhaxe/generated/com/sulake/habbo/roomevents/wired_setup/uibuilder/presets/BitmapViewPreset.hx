package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class BitmapViewPreset extends WiredUIPreset
    {
        var _window:IBitmapWrapperWindow;
        var _width:Int = 0;
        var _height:Int = 0;

        public function new(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presets, style);
            this._window = Std.downcast(presets.createLayout("bitmap_wrapper_view") , IBitmapWrapperWindow);
        }

        public var bitmapWindow(get,never):IBitmapWrapperWindow;
public function  get_bitmapWindow():IBitmapWrapperWindow { return this._window; }
        override public function  get_window():IWindow { return this._window; }
        override public function hasStaticWidth():Bool { return true; }
        override public function  get_staticWidth():Int { return this._width; }
        public function setBitmapSize(width:Int, height:Int) { this._width = width; this._height = height; }

        override public function resizeToWidth(width:Int)
        {
            super.resizeToWidth(width);
            this._window.width = this._width;
            this._window.height = this._height;
        }

        override public function dispose()
        {
            if (disposed) return;
            super.dispose();
            this._window.dispose();
            this._window = null;
        }
    }

