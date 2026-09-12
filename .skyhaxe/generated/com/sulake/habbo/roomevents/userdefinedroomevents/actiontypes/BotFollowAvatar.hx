package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;

     class BotFollowAvatar extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.BOT_FOLLOW_AVATAR;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_5431;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            var _local_2= this.getInput(k, "bot_name").text;
            return _local_2;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            return [this._Str_4281(k, "type_selector").getSelected().id];
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this.getInput(k, "bot_name").text = _arg_2.stringData;
            this._Str_4281(k, "type_selector").setSelected(this._Str_10005(k, ("radio_" + _arg_2.intData[0])));
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getInput(k:IWindowContainer, _arg_2:String):ITextFieldWindow
        {
            var _local_3= cast(k.findChildByName(_arg_2), ITextFieldWindow);
            return _local_3;
        }

        function _Str_4281(k:IWindowContainer, _arg_2:String):ISelectorWindow
        {
            return cast(k.findChildByName(_arg_2), ISelectorWindow);
        }

        function _Str_10005(k:IWindowContainer, _arg_2:String):IRadioButtonWindow
        {
            return cast(k.findChildByName(_arg_2), IRadioButtonWindow);
        }
public function new(){	super();
}
    }

