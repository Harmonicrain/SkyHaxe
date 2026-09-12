package com.sulake.habbo.roomevents.wired_setup
;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.AdvancedSettingsWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FooterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.HeaderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;

    /**
     * Value struct snapshotting one built editor window's presets so the controller
     * can restore it from its keyed cache (May WiredConfigurationCache).
     * Input-source presets remain an Array because a configuration can expose
     * several independently typed source slots.
     */
     class WiredConfigurationCache
    {
        var _frame:FramePreset;
        var _headerPreset:HeaderPreset;
        var _selectorOptionsPreset:CheckboxGroupPreset;
        var _furniPicksSectionPreset:SectionPreset;
        var _delayPreset:SliderSection;
        var _initialWidth:Int = 0;
        var _advancedSettingsWrapperPreset:AdvancedSettingsWrapperPreset;
        var _conditionQuantifierOptions:RadioGroupPreset;
        var _inputSourcePresets:Array<ASAny>;
        var _footerPreset:FooterPreset;

        public function new(_arg_1:FramePreset, _arg_2:HeaderPreset, _arg_3:CheckboxGroupPreset, _arg_4:SectionPreset, _arg_5:SliderSection, _arg_6:AdvancedSettingsWrapperPreset, _arg_7:RadioGroupPreset, _arg_8:Array<ASAny>, _arg_9:FooterPreset, _arg_10:Int)
        {
            this._frame = _arg_1;
            this._headerPreset = _arg_2;
            this._selectorOptionsPreset = _arg_3;
            this._furniPicksSectionPreset = _arg_4;
            this._delayPreset = _arg_5;
            this._advancedSettingsWrapperPreset = _arg_6;
            this._conditionQuantifierOptions = _arg_7;
            this._inputSourcePresets = _arg_8;
            this._footerPreset = _arg_9;
            this._initialWidth = _arg_10;
        }

        public var frame(get,never):FramePreset;
public function  get_frame():FramePreset
        {
            return this._frame;
        }

        public var headerPreset(get,never):HeaderPreset;
public function  get_headerPreset():HeaderPreset
        {
            return this._headerPreset;
        }

        public var selectorOptionsPreset(get,never):CheckboxGroupPreset;
public function  get_selectorOptionsPreset():CheckboxGroupPreset
        {
            return this._selectorOptionsPreset;
        }

        public var furniPicksSectionPreset(get,never):SectionPreset;
public function  get_furniPicksSectionPreset():SectionPreset
        {
            return this._furniPicksSectionPreset;
        }

        public var delayPreset(get,never):SliderSection;
public function  get_delayPreset():SliderSection
        {
            return this._delayPreset;
        }

        public var advancedSettingsWrapperPreset(get,never):AdvancedSettingsWrapperPreset;
public function  get_advancedSettingsWrapperPreset():AdvancedSettingsWrapperPreset
        {
            return this._advancedSettingsWrapperPreset;
        }

        public var conditionQuantifierOptions(get,never):RadioGroupPreset;
public function  get_conditionQuantifierOptions():RadioGroupPreset
        {
            return this._conditionQuantifierOptions;
        }

        public var inputSourcePresets(get,never):Array<ASAny>;
public function  get_inputSourcePresets():Array<ASAny>
        {
            return this._inputSourcePresets;
        }

        public var footerPreset(get,never):FooterPreset;
public function  get_footerPreset():FooterPreset
        {
            return this._footerPreset;
        }

        public var initialWidth(get,never):Int;
public function  get_initialWidth():Int
        {
            return this._initialWidth;
        }
    }

