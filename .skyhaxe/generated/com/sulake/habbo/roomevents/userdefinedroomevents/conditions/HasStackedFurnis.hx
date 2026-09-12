package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;

     class HasStackedFurnis extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.HAS_STACKED_FURNIS;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4873;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._Str_11170(k).getSelected().id);
            return _local_2;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            this._Str_11170(k).setSelected(this._Str_16683(k, _local_3));
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function _Str_16683(k:IWindowContainer, _arg_2:Int):IRadioButtonWindow
        {
            return cast(k.findChildByName((("eval_" + Std.string(_arg_2)) + "_radio")), IRadioButtonWindow);
        }

        function _Str_11170(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("eval_selector"), ISelectorWindow);
        }
public function new(){	super();
}
    }

