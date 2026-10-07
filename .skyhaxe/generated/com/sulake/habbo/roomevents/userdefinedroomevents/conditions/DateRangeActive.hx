package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.globalization.DateTimeFormatter;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

     class DateRangeActive extends WiredCondition 
    {


        static function getDate(k:IWindowContainer, _arg_2:String):Float
        {
            return ASCompat.dateParse(cast(k.findChildByName(_arg_2), ITextFieldWindow).text);
        }


        override public function  get_code():Int
        {
            return ConditionCodes.DATE_RANGE_ACTIVE;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_4 = Math.NaN;
            var _local_2:Array<ASAny> = [];
            var _local_3= getDate(k, "start_date");
            if (!Math.isNaN(_local_3))
            {
                _local_2.push(Std.int((_local_3 / 1000)));
                _local_4 = getDate(k, "end_date");
                if (!Math.isNaN(_local_4))
                {
                    _local_2.push(Std.int((_local_4 / 1000)));
                }
            }
            return _local_2;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_4:Date = null;
            var _local_5:Date = null;
            var _local_3= new DateTimeFormatter("en-US");
            _local_3.setDateTimePattern("yyyy/MM/dd HH:mm");
            if (_arg_2.intData.length > 0)
            {
                _local_4 = ASCompat.dateFromValue((ASCompat.toNumber(_arg_2.intData[0]) * 1000));
                cast(k.findChildByName("start_date"), ITextFieldWindow).text = _local_3.format(_local_4);
            }
            else
            {
                cast(k.findChildByName("start_date"), ITextFieldWindow).text = "";
            }
            if (_arg_2.intData.length > 1)
            {
                _local_5 = ASCompat.dateFromValue((ASCompat.toNumber(_arg_2.intData[1]) * 1000));
                cast(k.findChildByName("end_date"), ITextFieldWindow).text = _local_3.format(_local_5);
            }
            else
            {
                cast(k.findChildByName("end_date"), ITextFieldWindow).text = "";
            }
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }
public function new(){	super();
}
    }

