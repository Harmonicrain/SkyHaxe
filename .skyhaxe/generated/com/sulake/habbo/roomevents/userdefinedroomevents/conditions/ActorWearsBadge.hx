package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;

     class ActorWearsBadge extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.ACTOR_IS_WEARING_BADGE;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_ACTOR_WEARS_BADGE;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            var _local_2= this.getInput(k).text;
            return _local_2;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this.getInput(k).text = _arg_2.stringData;
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getInput(k:IWindowContainer):ITextFieldWindow
        {
            var _local_2= cast(k.findChildByName("badge_code"), ITextFieldWindow);
            return _local_2;
        }
public function new(){	super();
}
    }

