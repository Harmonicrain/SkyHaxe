package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ContainerButtonPreset extends PaddedContainerPreset
    {
        var _onClick:ASFunction;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset, _arg_5:ASFunction, _arg_6:Bool = true)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_3.containerButtonPaddingLeft, _arg_3.containerButtonPaddingTop, _arg_3.containerButtonPaddingLeft, _arg_3.containerButtonPaddingTop, _arg_3.createContainerButton(), _arg_6);
            this._onClick = _arg_5;
            this.button.addEventListener(WindowMouseEvent.CLICK, this.buttonClicked);
        }

        function buttonClicked(_arg_1:WindowMouseEvent)
        {
            if (this._onClick != null)
            {
                this._onClick();
            }
        }

        var button(get,never):IContainerButtonWindow;
function  get_button():IContainerButtonWindow
        {
            return Std.downcast(_window , IContainerButtonWindow);
        }
    }

