package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class AlignCenterWrapperPreset extends WiredUIPreset
    {
        var _window:IWindowContainer;
        var _subPreset:WiredUIPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = Std.downcast(_arg_2.createLayout("container_view") , IWindowContainer);
            this._subPreset = _arg_4;
            this._window.addChild(this._subPreset.window);
        }

        override public function  get_window():IWindow
        {
            return this._window;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            var _local_3 = 0;
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
            if (this._subPreset.hasStaticWidth())
            {
                this._subPreset.resizeToWidth(this._subPreset.staticWidth);
                _local_3 = this._subPreset.staticWidth;
            }
            else
            {
                this._subPreset.resizeToWidth(_arg_1);
                _local_3 = this._subPreset.window.width;
            }
            var _local_2= Std.int(Math.max(0, (_arg_1 / 2) - (_local_3 / 2)));
            this._subPreset.window.x = _local_2;
            this._window.height = this._subPreset.window.height;
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

