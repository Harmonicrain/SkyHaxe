package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
;
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class NamedNumberInputPreset extends WiredUIPreset
    {
        var _container:IItemListWindow;
        var _textPreset:TextPreset;
        var _numberInputPreset:NumberInputPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:NumberInputParam, _arg_5:String, _arg_6:Bool = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("horizontal_list_view") , IItemListWindow);
            this._textPreset = _arg_2.createText(_arg_5, new TextParam(0, _arg_6));
            this._textPreset.window.y = _arg_3.namedTextYOffset;
            this._numberInputPreset = _arg_2.createNumberInput(_arg_4);
            this._textPreset.window.y = _arg_3.namedInputOffset;
            this._container.spacing = _arg_3.genericHorizontalSpacing;
            this._container.addListItem(this._textPreset.window);
            this._container.addListItem(this._numberInputPreset.window);
            this._container.height = Std.int(Math.max(this._textPreset.window.height, this._numberInputPreset.window.height));
        }

        
        public var value(get,set):Int;
public function  get_value():Int
        {
            return this._numberInputPreset.value;
        }
public function  set_value(_arg_1:Int):Int        {
            return this._numberInputPreset.value = _arg_1;
        }

        public function reset()
        {
            this._numberInputPreset.reset();
        }

        public var onValueChange(never,set):ASFunction;
public function  set_onValueChange(_arg_1:ASFunction):ASFunction        {
            return this._numberInputPreset.onValueChange = _arg_1;
        }

        override public function hasStaticWidth():Bool
        {
            return this._numberInputPreset.hasStaticWidth();
        }

        override public function  get_staticWidth():Int
        {
            if (hasStaticWidth())
            {
                return this._container.width;
            }
            throw new Exception("Named number input has no static width");
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._textPreset.resizeToWidth(this._textPreset.width);
            this._numberInputPreset.resizeToWidth(_arg_1 - this._numberInputPreset.window.x);
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._textPreset, this._numberInputPreset];
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
            this._numberInputPreset = null;
        }
    }

