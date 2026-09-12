package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class SelectorElement extends DefaultElement
    {
        public static inline final MODE_NONE= 0;
        public static inline final MODE_STATE_MATCH= 1;
        public static inline final MODE_USER_TYPE= 2;
        public static inline final MODE_TEAM= 3;
        public static inline final MODE_ON_FURNI= 4;
        public static inline final MODE_AREA= 5;
        public static inline final MODE_NAMES= 6;
        public static inline final MODE_HANDITEM= 7;
        public static inline final MODE_GROUP= 8;

        var _code:Int = 0;
        var _mode:Int = 0;
        var _requiresFurni:Bool = false;
        var _radio:RadioGroupPreset;
        var _checkbox:CheckboxGroupPreset;
        var _text:TextInputPreset;
        var _areaText:TextAreaPreset;
        var _numbers:Array<ASAny>;

        public function new(k:Int, _arg_2:Int = 0, _arg_3:Bool = false)
        {
            super();
            this._code = k;
            this._mode = _arg_2;
            this._requiresFurni = _arg_3;
        }

        override public function  get_code():Int { return this._code; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiresFurniSelection():Bool { return this._requiresFurni; }

        override public function buildInputs(k:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._numbers = [];
            if (this._mode == MODE_STATE_MATCH)
            {
                this._checkbox = k.createCheckboxGroup([new CheckboxOptionParam(l("state_match"), 0)]);
                _arg_3.addElements([k.createSection(l("select_options"), this._checkbox)]);
            }
            else if (this._mode == MODE_USER_TYPE)
            {
                this._radio = k.createRadioGroup([new RadioButtonParam(1, l("selector.users.type.any")), new RadioButtonParam(2, l("selector.users.type.habbos")), new RadioButtonParam(4, l("selector.users.type.bots"))]);
                _arg_3.addElements([k.createSection(l("selector.user_type"), this._radio)]);
            }
            else if (this._mode == MODE_TEAM)
            {
                this._radio = k.createRadioGroup([new RadioButtonParam(0, l("team.any")), new RadioButtonParam(1, l("team.1")), new RadioButtonParam(2, l("team.2")), new RadioButtonParam(3, l("team.3")), new RadioButtonParam(4, l("team.4"))]);
                _arg_3.addElements([k.createSection(l("team"), this._radio)]);
            }
            else if (this._mode == MODE_ON_FURNI)
            {
                this._radio = k.createRadioGroup([new RadioButtonParam(0, l("onfurni.any")), new RadioButtonParam(1, l("onfurni.lowest")), new RadioButtonParam(2, l("onfurni.highest")), new RadioButtonParam(3, l("onfurni.all"))]);
                _arg_3.addElements([k.createSection(l("onfurni.mode"), this._radio)]);
            }
            else if (this._mode == MODE_AREA)
            {
                this._numbers.push(k.createNamedNumberInput(new NumberInputParam(0, 0, 200), "x"));
                this._numbers.push(k.createNamedNumberInput(new NumberInputParam(0, 0, 200), "y"));
                this._numbers.push(k.createNamedNumberInput(new NumberInputParam(1, 1, 200), "w"));
                this._numbers.push(k.createNamedNumberInput(new NumberInputParam(1, 1, 200), "h"));
                _arg_3.addElements([k.createSection(l("area"), k.createSimpleListView(true, this._numbers))]);
            }
            else if (this._mode == MODE_NAMES)
            {
                this._areaText = k.createTextArea(new TextAreaParam(140, -1, 20, -1, 1000, ""));
                _arg_3.addElements([k.createSection(l("enter_names"), this._areaText)]);
            }
            else if (this._mode == MODE_HANDITEM)
            {
                this._numbers.push(k.createNumberInput(new NumberInputParam(0, 0, 99999)));
                _arg_3.addElements([k.createSection(l("handitem"), this._numbers[0])]);
            }
            else if (this._mode == MODE_GROUP)
            {
                this._text = k.createTextInput(new TextInputParam("", 32));
                _arg_3.addElements([k.createSection(l("group.id"), this._text)]);
            }
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
var k:Array<ASAny>  = null, _local_2:ASObject  = null;            if (this._radio != null)
            {
                return [this._radio.selected];
            }
            if (this._checkbox != null)
            {
                return [this._checkbox.get(0).selected ? 1 : 0];
            }
            if (this._numbers != null && this._numbers.length > 0)
            {
k= [];
                final _iter_ = this._numbers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2 = _tmp_;
                    k.push(ASCompat.toInt(_local_2.value));
                }
                return k;
            }
            return [];
        }

        override public function readStringParamFromForm():String
        {
            if (this._areaText != null)
            {
                return new compat.RegExp("\\r\\n|\\r|\\n|\\t", "g").replace(this._areaText.text, "\t");
            }
            if (this._text != null)
            {
                return this._text.text;
            }
            return "";
        }

        override public function onEditStart(k:Triggerable)
        {
            var _local_2 = 0;
            if (this._radio != null)
            {
                this._radio.selected = ASCompat.toInt((k.intData.length > 0) ? ASCompat.toInt(k.intData[0] ): 0);
            }
            if (this._checkbox != null)
            {
                this._checkbox.mask = (k.intData.length > 0 && k.intData[0] != 0) ? 1 : 0;
            }
            if (this._numbers != null)
            {
                _local_2 = 0;
                while (_local_2 < this._numbers.length)
                {
                    this._numbers[_local_2].value = (k.intData.length > _local_2) ? k.intData[_local_2] : ((_local_2 < 2) ? 0 : 1);
                    _local_2++;
                }
            }
            if (this._areaText != null)
            {
                this._areaText.text = new compat.RegExp("\\r\\n|\\r|\\n|\\t", "g").replace(k.stringData, "\n");
            }
            if (this._text != null)
            {
                this._text.text = k.stringData;
            }
        }
    }

