package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TextualButtonPreset extends WiredUIPreset
    {
        var _container:IWindowContainer;
        var _textPreset:TextPreset;
        var _onClick:ASFunction;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._onClick = _arg_5;
            this._container = Std.downcast(_arg_2.createLayout("growing_container_view") , IWindowContainer);
            this._textPreset = _arg_2.createText(_arg_4, new TextParam(0, false, 0, true));
            this._container.addChild(this._textPreset.window);
            this._container.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._container.mouseThreshold = 0;
        }

        public var text(never,set):String;
public function  set_text(_arg_1:String):String        {
            return this._textPreset.text = _arg_1;
        }

        function onClick(_arg_1:WindowMouseEvent)
        {
            this._onClick();
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

        override function  get_childPresets():Array<ASAny>
        {
            return [this._textPreset];
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
            this._textPreset = null;
            this._onClick = null;
        }
    }

