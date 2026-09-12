package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

     class TriggerOnce extends WiredTrigger 
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _slider:SliderWindowController;


        public static function _Str_11919(k:Int):String
        {
            var _local_2= Std.int(Math.ffloor((k / 2)));
            if ((k % 2) == 0)
            {
                return "" + Std.string(_local_2);
            }
            return Std.string(_local_2) + ".5";
        }


        override public function  get_code():Int
        {
            return WiredTriggerType.TRIGGER_ONCE;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._slider.getValue());
            return _local_2;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_2;
            this._slider = new SliderWindowController(_arg_2, this.getInput(k), _arg_2.assets, 1, 1200, 1);
            this._slider.setValue(1);
            this._slider.addEventListener(Event.CHANGE, this.onSliderChange);
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            this._slider.setValue(_local_3);
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
            var _local_5:String = null;
            if (k.type == Event.CHANGE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , SliderWindowController);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getValue();
                    _local_4 = Std.int(_local_3);
                    _local_5 = TriggerOnce._Str_11919(_local_4);
                    this._roomEvents.localization.registerParameter("wiredfurni.params.settime", "seconds", _local_5);
                }
            }
        }
public function new(){	super();
}
    }

