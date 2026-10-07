package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;

     class ActorIsWearingEffect extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.ACTOR_IS_WEARING_EFFECT;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_ACTOR_WEARING_EFFECT;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2:Array<ASAny> = [];
            _local_2.push(ASCompat.toInt(this.getSpecialInputTextField(k).text));
            return _local_2;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this.getSpecialInputTextField(k).text = _arg_2.intData[0];
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getSpecialInputTextField(k:IWindowContainer):ITextFieldWindow
        {
            var _local_2= cast(k.findChildByName("effect_id"), ITextFieldWindow);
            return _local_2;
        }
public function new(){	super();
}
    }

