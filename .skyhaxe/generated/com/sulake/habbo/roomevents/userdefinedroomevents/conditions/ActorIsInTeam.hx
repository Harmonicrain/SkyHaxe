package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;

     class ActorIsInTeam extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.ACTOR_IS_IN_TEAM;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_ACTOR_IN_TEAM;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            this._Str_6616(k).setSelected(this._Str_9779(k, _local_3));
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._Str_6616(k).getSelected().id);
            return _local_2;
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function _Str_9779(k:IWindowContainer, _arg_2:Int):IRadioButtonWindow
        {
            return cast(k.findChildByName((("team_" + Std.string(_arg_2)) + "_radio")), IRadioButtonWindow);
        }

        function _Str_6616(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("team_selector"), ISelectorWindow);
        }
public function new(){	super();
}
    }

