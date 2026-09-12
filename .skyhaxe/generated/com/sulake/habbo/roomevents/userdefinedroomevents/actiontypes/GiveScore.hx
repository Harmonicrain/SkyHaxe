package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

     class GiveScore extends DefaultActionType 
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _slider:SliderWindowController;
        var _counterSlider:SliderWindowController;


        override public function  get_code():Int
        {
            return ActionTypeCodes.GIVE_SCORE;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._slider.getValue());
            _local_2.push(this._counterSlider.getValue());
            return _local_2;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_2;
            this._slider = new SliderWindowController(_arg_2, this.getInput(k), _arg_2.assets, 1, 100, 1);
            this._slider.addEventListener(Event.CHANGE, this.onSliderChange);
            this._slider.setValue(1);
            this._counterSlider = new SliderWindowController(_arg_2, this._Str_22476(k), _arg_2.assets, 1, 10, 1);
            this._counterSlider.addEventListener(Event.CHANGE, this._Str_24911);
            this._counterSlider.setValue(1);
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            var _local_4= ASCompat.toInt(_arg_2.intData[1]);
            this._slider.setValue(_local_3);
            this._counterSlider.setValue(_local_4);
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function getInput(k:IWindowContainer):IWindowContainer
        {
            return Std.downcast(k.findChildByName("slider_container") , IWindowContainer);
        }

        function _Str_22476(k:IWindowContainer):IWindowContainer
        {
            return Std.downcast(k.findChildByName("counter_slider_container") , IWindowContainer);
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
                    this._roomEvents.localization.registerParameter("wiredfurni.params.setpoints", "points", ("" + Std.string(_local_4)));
                }
            }
        }

        function _Str_24911(k:Event)
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
                    this._roomEvents.localization.registerParameter("wiredfurni.params.settimesingame", "times", ("" + Std.string(_local_4)));
                }
            }
        }
public function new(){	super();
}
    }

