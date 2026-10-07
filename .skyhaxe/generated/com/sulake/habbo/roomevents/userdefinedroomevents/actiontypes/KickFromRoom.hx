package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

     class KickFromRoom extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.KICK_FROM_ROOM;
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
            var _local_2= cast(k.findChildByName("chat_message"), ITextFieldWindow);
            return _local_2;
        }

        override public function validate(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents):String
        {
            var _local_4:String = null;
            var _local_3= 100;
            if (this.getInput(k).text.length > _local_3)
            {
                _local_4 = "wiredfurni.chatmsgtoolong";
                return _arg_2.localization.getLocalization(_local_4, _local_4);
            }
            return null;
        }
public function new(){	super();
}
    }

