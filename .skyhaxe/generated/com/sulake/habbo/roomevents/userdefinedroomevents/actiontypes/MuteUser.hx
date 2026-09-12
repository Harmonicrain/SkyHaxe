package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.common.SliderWindowController;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.core.window.components.ITextFieldWindow;
    import flash.events.Event;

     class MuteUser extends DefaultActionType 
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _slider:SliderWindowController;


        override public function  get_code():Int
        {
            return ActionTypeCodes.MUTE_USER;
        }

        override public function readStringParamFromForm(k:IWindowContainer):String
        {
            var _local_2= this._Str_17881(k).text;
            return _local_2;
        }

        override public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            _local_2.push(this._slider.getValue());
            return _local_2;
        }

        override public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
            this._Str_17881(k).text = _arg_2.stringData;
            var _local_3= ASCompat.toInt(_arg_2.intData[0]);
            this._slider.setValue(_local_3);
        }

        override public function  get_hasSpecialInputs():Bool
        {
            return true;
        }

        function _Str_17881(k:IWindowContainer):ITextFieldWindow
        {
            var _local_2= cast(k.findChildByName("chat_message"), ITextFieldWindow);
            return _local_2;
        }

        override public function validate(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents):String
        {
            var _local_4:String = null;
            var _local_3= 100;
            if (this._Str_17881(k).text.length > _local_3)
            {
                _local_4 = "wiredfurni.chatmsgtoolong";
                return _arg_2.localization.getLocalization(_local_4, _local_4);
            }
            return null;
        }

        override public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_2;
            this._slider = new SliderWindowController(_arg_2, this._Str_25532(k), _arg_2.assets, 0, 10, 1);
            this._slider.setValue(1);
            this._slider.addEventListener(Event.CHANGE, this.onSliderChange);
        }

        function _Str_25532(k:IWindowContainer):IWindowContainer
        {
            return Std.downcast(k.findChildByName("slider_container") , IWindowContainer);
        }

        function onSliderChange(k:Event)
        {
            var _local_2:SliderWindowController = null;
            var _local_3 = Math.NaN;
            var _local_4:String = null;
            if (k.type == Event.CHANGE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , SliderWindowController);
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getValue();
                    _local_4 = Std.string(Std.int(_local_3));
                    this._roomEvents.localization.registerParameter("wiredfurni.params.length.minutes", "minutes", _local_4);
                }
            }
        }

        var _Str_16492(get,never):HabboUserDefinedRoomEvents;
function  get__Str_16492():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        public var slider(get,never):SliderWindowController;
public function  get_slider():SliderWindowController
        {
            return this._slider;
        }
public function new(){	super();
}
    }

