package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;

     class StuffsInFormation extends WiredCondition 
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _slider:SliderWindowController;


        override public function  get_code():Int
        {
            return ConditionCodes.STUFFS_IN_FORMATION;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_STUFFS_IN_FORMATION;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4873;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(Std.int(this._slider.getValue()));
            _local_2.push(this._Str_21596(k).getSelected().id);
            return _local_2;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_2;
            this._slider = new SliderWindowController(_arg_2, this.getInput(k), _arg_2.assets, 2, 10, 1);
            this._slider.setValue(3);
            this._slider.addEventListener(Event.CHANGE, this.onSliderChange);
            _arg_2.refreshButton(k, "move_diag", true, null, 0);
            _arg_2.refreshButton(k, "move_vrt", true, null, 0);
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this._slider.setValue(ASCompat.toNumber(_arg_2.intData[0]));
            var _local_3= ASCompat.toInt(_arg_2.intData[1]);
            this._Str_21596(k).setSelected(this._Str_24795(k, _local_3));
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getInput(k:IWindowContainer):IWindowContainer
        {
            return Std.downcast(k.findChildByName("slider_container") , IWindowContainer);
        }

        function onSliderChange(k:Event)
        {
            var _local_2:SliderWindowController = null;
            var _local_3 = Math.NaN;
            var _local_4 = 0;
            if (k.type == Event.CHANGE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , SliderWindowController);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getValue();
                    _local_4 = Std.int(_local_3);
                    this._roomEvents.localization.registerParameter("wiredfurni.params.requiredformationsize", "furnis", ("" + Std.string(_local_4)));
                }
            }
        }

        function _Str_24795(k:IWindowContainer, _arg_2:Int):IRadioButtonWindow
        {
            return cast(k.findChildByName((("formation_" + Std.string(_arg_2)) + "_radio")), IRadioButtonWindow);
        }

        function _Str_21596(k:IWindowContainer):ISelectorWindow
        {
            return cast(k.findChildByName("formation_selector"), ISelectorWindow);
        }
public function new(){	super();
}
    }

