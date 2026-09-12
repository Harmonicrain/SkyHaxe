package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

     class BotReachedStuffElement extends DefaultElement
    {
        var _botName:TextInputPreset;

        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return WiredTriggerType.BOT_REACHED_STUFF;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.botname")));
            _arg_3.addElements([_arg_1.createSection(l("bot.name"), this._botName)]);
        }

        override public function readStringParamFromForm():String
        {
            return this._botName.text;
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._botName.text = _arg_1.stringData;
        }

        override public function userSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.users.title.bots";
        }
    }

