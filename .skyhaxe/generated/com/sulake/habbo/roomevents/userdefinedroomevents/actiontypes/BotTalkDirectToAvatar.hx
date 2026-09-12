package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;

     class BotTalkDirectToAvatar extends DefaultActionType 
    {
        static inline final _Str_4332= "\t";


        override public function  get_code():Int
        {
            return ActionTypeCodes.BOT_TALK_DIRECT_TO_AVTR;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_5431;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            var _local_2= this.getInput(k, "bot_name").text;
            var _local_3= this.getInput(k, "chat_message").text;
            return (_local_2 + _Str_4332) + _local_3;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3:Array<ASAny> = (cast _arg_2.stringData.split(_Str_4332));
            this.getInput(k, "bot_name").text = ((_local_3.length >= 1) ? _local_3[0] : "");
            this.getInput(k, "chat_message").text = ((_local_3.length == 2) ? _local_3[1] : "");
            this._Str_4281(k, "type_selector").setSelected(this._Str_10005(k, ("radio_" + _arg_2.intData[0])));
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            return [this._Str_4281(k, "type_selector").getSelected().id];
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

