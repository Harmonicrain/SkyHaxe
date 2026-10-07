package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;

     class AvatarSaysSomething extends WiredTrigger 
    {
        override public function  get_code():Int
        {
            return WiredTriggerType.AVATAR_SAYS_SOMETHING;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push((this._Str_20767(k).Selected ? 1 : 0));
            return _local_2;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            return this.getInput(k).text;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            k.findChildByName("me_txt").caption = _arg_2.userName;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this.getInput(k).text = _arg_2.stringData;
            if (((_arg_2.intData.length > 0) && (_arg_2.intData[0] == 1)))
            {
                this._Str_4281(k).setSelected(this._Str_20767(k));
            }
            else
            {
                this._Str_4281(k).setSelected(this._Str_16153(k));
            }
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getInput(k:IWindowContainer):ITextFieldWindow
        {
            var _local_2= cast(k.findChildByName("chat_txt"), ITextFieldWindow);
            return _local_2;
        }

        function _Str_16153(k:IWindowContainer):IRadioButtonWindow
        {
            return cast(k.findChildByName("any_avatar_radio"), IRadioButtonWindow);
        }

        function _Str_20767(k:IWindowContainer):IRadioButtonWindow
        {
            return cast(k.findChildByName("me_radio"), IRadioButtonWindow);
        }

        function _Str_4281(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("avatar_radio"), ISelectorWindow);
        }
public function new(){	super();
}
    }

