package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class PaddedContainerPreset extends WiredUIPreset
    {
        var _window:IWindowContainer;
        var _subPreset:WiredUIPreset;
        var _left:Int = 0;
        var _top:Int = 0;
        var _right:Int = 0;
        var _bottom:Int = 0;
        var _stretchMode:Bool = false;
        var _cachedWidth:Int = 0;
        var _ignoreListeners:Bool = false;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:IWindowContainer = null, _arg_10:Bool = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._left = _arg_5;
            this._top = _arg_6;
            this._right = _arg_7;
            this._bottom = _arg_8;
            this._stretchMode = _arg_10;
            this._window = _arg_9;
            if (this._window == null)
            {
                this._window = Std.downcast(_arg_2.createLayout("growing_container_view") , IWindowContainer);
            }
            this._window.addChild(_arg_4.window);
            this._subPreset = _arg_4;
            this._subPreset.window.x = this._left;
            this._subPreset.window.y = this._top;
            this._subPreset.window.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResizeListener);
        }

        function onResizeListener(_arg_1:WindowEvent)
        {
            if (this._ignoreListeners)
            {
                return;
            }
            this.resizeToWidth(this._cachedWidth);
        }

        override public function  get_window():IWindow
        {
            return this._window;
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._subPreset];
        }

        override public function hasStaticWidth():Bool
        {
            return this._stretchMode;
        }

        override public function  get_staticWidth():Int
        {
            if (this._stretchMode)
            {
                return (this._subPreset.window.width + this._left + this._right);
            }
            return -1;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            this._cachedWidth = _arg_1;
            this._ignoreListeners = true;
            if (this._stretchMode)
            {
                _arg_1 = this.staticWidth;
            }
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
            this._subPreset.resizeToWidth((_arg_1 - this._left) - this._right);
            this._window.height = ((this._subPreset.window.height + this._top) + this._bottom);
            this._ignoreListeners = false;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this._subPreset.window.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResizeListener);
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._subPreset = null;
        }
    }

