package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;

     class BotReachedStuff extends WiredTrigger 
    {


        override public function  get_code():Int
        {
            return WiredTriggerType.BOT_REACHED_STUFF;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4991;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            return this.getInput(k).text;
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
            var _local_2= cast(k.findChildByName("bot_name"), ITextFieldWindow);
            return _local_2;
        }
public function new(){	super();
}
    }

