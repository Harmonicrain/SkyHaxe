package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ICheckBoxWindow;

     class MatchSnapshot extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.STATES_MATCH;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_STATES_MATCH;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4873;
        }

        override public function  get_hasStateSnapshot():Bool
        {
            return true;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this.select(this._Str_10847(k), _arg_2.getBoolean(0));
            this.select(this._Str_10700(k), _arg_2.getBoolean(1));
            this.select(this._Str_10629(k), _arg_2.getBoolean(2));
        }

        function select(k:ICheckBoxWindow, _arg_2:Bool)
        {
            if (_arg_2)
            {
                k.select();
            }
            else
            {
                k.unselect();
            }
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._Str_7329(this._Str_10847(k)));
            _local_2.push(this._Str_7329(this._Str_10700(k)));
            _local_2.push(this._Str_7329(this._Str_10629(k)));
            return _local_2;
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function _Str_10847(k:IWindowContainer):ICheckBoxWindow
        {
            return cast(k.findChildByName("include_state_checkbox"), ICheckBoxWindow);
        }

        function _Str_10700(k:IWindowContainer):ICheckBoxWindow
        {
            return cast(k.findChildByName("include_rotation_checkbox"), ICheckBoxWindow);
        }

        function _Str_10629(k:IWindowContainer):ICheckBoxWindow
        {
            return cast(k.findChildByName("include_location_checkbox"), ICheckBoxWindow);
        }

        function _Str_7329(k:ICheckBoxWindow):Int
        {
            return k.Selected ? 1 : 0;
        }
public function new(){	super();
}
    }

