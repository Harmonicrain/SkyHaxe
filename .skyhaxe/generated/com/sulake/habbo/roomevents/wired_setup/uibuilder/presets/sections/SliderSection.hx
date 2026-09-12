package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.ISliderValueConverter;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValuePulses;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SliderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.events.Event;

     class SliderSection extends AbstractSectionPreset
    {
        public static final CONVERTER_ECHO:ISliderValueConverter = new SliderValueEcho();
        public static final CONVERTER_PULSES:ISliderValueConverter = new SliderValuePulses();

        var _sliderPreset:SliderPreset;
        var _converter:ISliderValueConverter;
        var _localizationKey:String;
        var _localizationParamName:String;
        var _numberInput:NumberInputPreset;
        var _ignoreListeners:Bool = false;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:String, _arg_6:ISliderValueConverter, _arg_7:Float = 0, _arg_8:Float = 1, _arg_9:Float = 0, _arg_10:Bool = true, _arg_11:SectionParam = null)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._converter = _arg_6;
            this._localizationKey = _arg_4;
            this._localizationParamName = _arg_5;
            this._sliderPreset = _arg_2.createSliderPreset(_arg_7, _arg_8, _arg_9);
            if (_arg_10 && ((_arg_11 == null) || (_arg_11.headerOptionLeft == null)))
            {
                this._numberInput = _arg_2.createNumberInput(new NumberInputParam(0, Std.int(_arg_7), Std.int(_arg_8), 40, _arg_6.precision, _arg_6.endsWithFive));
                this._numberInput.onValueChange = this.onTextValueChange;
                if (_arg_11 == null)
                {
                    _arg_11 = new SectionParam();
                }
                _arg_11.headerOptionLeft = this._numberInput;
                _arg_11.titleYOffset = _arg_3.namedInputOffset;
            }
            initializeSection(_arg_1.localization.getLocalization(_arg_4), this._sliderPreset, _arg_11);
            if (!_arg_10)
            {
                this.updateName();
            }
            this._sliderPreset.addEventListener(Event.CHANGE, this.onSliderChange);
        }

        function onTextValueChange(_arg_1:Int)
        {
            if (this._ignoreListeners)
            {
                return;
            }
            this._ignoreListeners = true;
            this._sliderPreset.value = _arg_1;
            this._ignoreListeners = false;
        }

        function onSliderChange(_arg_1:Event)
        {
            if (this._ignoreListeners)
            {
                return;
            }
            if (this._numberInput != null)
            {
                this._ignoreListeners = true;
                this._numberInput.value = this._sliderPreset.value;
                this._ignoreListeners = false;
            }
            else
            {
                this.updateName();
            }
        }

        function updateName()
        {
            sectionTitle = localizations.getLocalizationWithParams(this._localizationKey, "", [this._localizationParamName, this._converter.toString(this.value)]);
        }

        
        public var value(get,set):Int;
public function  get_value():Int
        {
            return this._sliderPreset.value;
        }
public function  set_value(_arg_1:Int):Int        {
            this._ignoreListeners = true;
            this._sliderPreset.value = _arg_1;
            if (this._numberInput != null)
            {
                this._numberInput.value = _arg_1;
            }
            this.updateName();
            this._ignoreListeners = false;
return _arg_1;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._sliderPreset = null;
            this._converter = null;
            this._numberInput = null;
        }
    }

