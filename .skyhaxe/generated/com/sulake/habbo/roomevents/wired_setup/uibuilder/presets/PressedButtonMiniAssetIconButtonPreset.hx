package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.components.InteractiveController;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class PressedButtonMiniAssetIconButtonPreset extends MiniAssetIconButtonPreset
    {
        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:String, _arg_6:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this.clickArea.addEventListener(WindowMouseEvent.OUT, this.maybeCancelEvent);
            this.clickArea.addEventListener(WindowMouseEvent.UP, this.maybeCancelEvent);
            this.updateUI();
        }

        function maybeCancelEvent(_arg_1:WindowMouseEvent)
        {
            if ((_arg_1.type == WindowMouseEvent.OUT) && this._selected)
            {
                _arg_1.preventWindowOperation();
            }
            if (_arg_1.type == WindowMouseEvent.UP)
            {
                this.iconClicked(null);
                _arg_1.preventWindowOperation();
            }
        }

        override function updateUI()
        {
            var controller= cast(this.clickArea, InteractiveController);
            controller.setStateFlag(16, this._selected);
            controller.setStateFlag(4, this._hovered);
            if (!this._hovered && !this._selected)
            {
                this.clickArea.color = 0xFFFFFF;
                return;
            }
            this.clickArea.color = lightenColor(this.selectedColor, (this._hovered && !this._selected) ? 1.6 : 1.38);
        }

        static function lightenColor(_arg_1:UInt, _arg_2:Float):UInt
        {
            var r:UInt = Std.int(Math.min(255, ((ASCompat.toInt(_arg_1 )>> 16) & 0xFF) * _arg_2));
            var g:UInt = Std.int(Math.min(255, ((ASCompat.toInt(_arg_1 )>> 8) & 0xFF) * _arg_2));
            var b:UInt = Std.int(Math.min(255, (ASCompat.toInt(_arg_1 )& 0xFF) * _arg_2));
            return (ASCompat.toInt(r )<< 16) | (ASCompat.toInt(g )<< 8) | ASCompat.toInt(b);
        }
    }

