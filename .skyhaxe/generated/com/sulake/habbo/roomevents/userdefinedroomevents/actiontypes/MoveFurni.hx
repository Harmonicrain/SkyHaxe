package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;

     class MoveFurni extends DefaultActionType 
    {


        override public function  get_code():Int
        {
            return ActionTypeCodes.MOVE_FURNI;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_5430;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            _arg_2.refreshButton(k, "move_0", true, null, 0);
            _arg_2.refreshButton(k, "move_2", true, null, 0);
            _arg_2.refreshButton(k, "move_4", true, null, 0);
            _arg_2.refreshButton(k, "move_6", true, null, 0);
            _arg_2.refreshButton(k, "move_diag", true, null, 0);
            _arg_2.refreshButton(k, "move_rnd", true, null, 0);
            _arg_2.refreshButton(k, "move_vrt", true, null, 0);
            _arg_2.refreshButton(k, "rotate_ccw", true, null, 0);
            _arg_2.refreshButton(k, "rotate_cw", true, null, 0);
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            var _local_4= ASCompat.toInt(_arg_2.intData[1]);
            this._Str_19968(k).setSelected(this._Str_25584(k, _local_3));
            this._Str_21784(k).setSelected(this._Str_23005(k, _local_4));
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            var _local_3= this._Str_19968(k).getSelected().id;
            var _local_4= this._Str_21784(k).getSelected().id;
            _local_2.push(_local_3);
            _local_2.push(_local_4);
            return _local_2;
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function _Str_25584(k:IWindowContainer, _arg_2:Int):IRadioButtonWindow
        {
            return cast(k.findChildByName((("move_" + Std.string(_arg_2)) + "_radio")), IRadioButtonWindow);
        }

        function _Str_23005(k:IWindowContainer, _arg_2:Int):IRadioButtonWindow
        {
            return cast(k.findChildByName((("rotate_" + Std.string(_arg_2)) + "_radio")), IRadioButtonWindow);
        }

        function _Str_19968(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("move_selector"), ISelectorWindow);
        }

        function _Str_21784(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("rotate_selector"), ISelectorWindow);
        }
public function new(){	super();
}
    }

