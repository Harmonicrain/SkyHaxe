package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import flash.globalization.DateTimeFormatter;

     class DateRangeActiveElement extends DefaultElement
    {
        var _start:TextInputPreset;
        var _end:TextInputPreset;

        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return ConditionCodes.DATE_RANGE_ACTIVE;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._start = _arg_1.createTextInput(new TextInputParam("", 32, "YYYY/MM/DD HH:MM"));
            this._end = _arg_1.createTextInput(new TextInputParam("", 32, "YYYY/MM/DD HH:MM"));
            _arg_3.addElements([_arg_1.createSection(l("startdate"), this._start), _arg_1.createSection(l("enddate"), this._end)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var _local_1:Array<ASAny> = [];
            var _local_2= ASCompat.dateParse(this._start.text);
            var _local_3= ASCompat.dateParse(this._end.text);
            if (!Math.isNaN(_local_2))
            {
                _local_1.push(Std.int(_local_2 / 1000));
                if (!Math.isNaN(_local_3))
                {
                    _local_1.push(Std.int(_local_3 / 1000));
                }
            }
            return _local_1;
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            var _local_2= new DateTimeFormatter("en-US");
            _local_2.setDateTimePattern("yyyy/MM/dd HH:mm");
            this._start.text = (_arg_1.intData.length > 0) ? _local_2.format(ASCompat.dateFromValue(ASCompat.toNumber(_arg_1.intData[0]) * 1000)) : "";
            this._end.text = (_arg_1.intData.length > 1) ? _local_2.format(ASCompat.dateFromValue(ASCompat.toNumber(_arg_1.intData[1]) * 1000)) : "";
        }
    }

