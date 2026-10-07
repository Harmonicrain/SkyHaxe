package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.IDropMenuWindow;

     class BotGiveHandItem extends DefaultActionType 
    {


        override public function  get_code():Int
        {
            return ActionTypeCodes.BOT_GIVE_HAND_ITEM;
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
            var _local_2:Array<ASAny> = [];
            _local_2.push(this._Str_17055(k));
            return _local_2;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this.getInput(k, "bot_name").text = _arg_2.stringData;
            this._Str_18464(k, ASCompat.toInt(_arg_2.intData[0]));
        }

        function _Str_17055(k:IWindowContainer):Int
        {
            var _local_2= this._Str_5671(k, "menu_handitem").items();
            var _local_3= this._Str_5671(k, "menu_handitem").selection;
            if (_local_3 == -1)
            {
                return 0;
            }
            return this._Str_10826(_local_2[_local_3]);
        }

        function _Str_18464(k:IWindowContainer, _arg_2:Int)
        {
            var _local_3= this._Str_5671(k, "menu_handitem").items();
            var _local_4= -1;
            var _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                if (this._Str_10826(_local_3[_local_5]) == _arg_2)
                {
                    _local_4 = _local_5;
                }
                _local_5++;
            }
            this._Str_5671(k, "menu_handitem").selection = _local_4;
        }

        function _Str_10826(k:String):Int
        {
            return ASCompat.parseInt(k.substr(10, (k.length - 11)));
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

        function _Str_5671(k:IWindowContainer, _arg_2:String):IDropMenuWindow
        {
            var _local_3= cast(k.findChildByName(_arg_2), IDropMenuWindow);
            return _local_3;
        }
public function new(){	super();
}
    }

