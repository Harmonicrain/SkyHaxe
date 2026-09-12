package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class BotMessageActionElement extends BotNameActionElement
    {
        static inline final SEPARATOR= "\t";

        var _message:TextAreaPreset;
        var _mode:RadioGroupPreset;
        var _firstLabel:String;
        var _firstId:Int = 0;
        var _secondLabel:String;
        var _secondId:Int = 0;

        public function new(_arg_1:Int, _arg_2:String, _arg_3:Int, _arg_4:String, _arg_5:Int)
        {
            super(_arg_1);
            this._firstLabel = _arg_2;
            this._firstId = _arg_3;
            this._secondLabel = _arg_4;
            this._secondId = _arg_5;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            this._message = _arg_1.createTextArea(new TextAreaParam(40, -1, 4, -1, 100, "", null, null, true, true, loc("wiredfurni.tooltip.bot.chatmessage")));
            this._mode = _arg_1.createRadioGroup([new RadioButtonParam(this._firstId, this._firstLabel), new RadioButtonParam(this._secondId, this._secondLabel)]);
            _arg_3.addElements([_arg_1.createSection(l("bot.name"), this._botName), _arg_1.createSection(l("message"), _arg_1.createSimpleListView(true, [this._message, this._mode]))]);
        }

        override public function readStringParamFromForm():String
        {
            return (this._botName.text + SEPARATOR) + this._message.text;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._mode.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            var _local_2:Array<ASAny> = (cast _arg_1.stringData.split(SEPARATOR));
            this._botName.text = (_local_2.length >= 1) ? _local_2[0] : "";
            this._message.text = (_local_2.length >= 2) ? _local_2[1] : "";
            this._mode.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): this._firstId);
        }

        override public function validate():String
        {
            if (this._message.text.length > 100)
            {
                return loc("wiredfurni.chatmsgtoolong");
            }
            return null;
        }
    }

