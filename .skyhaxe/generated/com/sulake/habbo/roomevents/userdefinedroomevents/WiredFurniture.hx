package com.sulake.habbo.roomevents.userdefinedroomevents
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
	import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class WiredFurniture
    {
        public var code(get,never):Int;
public function  get_code():Int
        {
            return -1;
        }

        public var negativeCode(get,never):Int;
public function  get_negativeCode():Int
        {
            return -1;
        }

        public var requiresFurni(get,never):Int;
public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_5431;
        }

        public var hasStateSnapshot(get,never):Bool;
public function  get_hasStateSnapshot():Bool
        {
            return false;
        }

        public function readIntegerParamsFromForm(k:IWindowContainer):Array<ASAny>
        {
            return new Array<ASAny>();
        }

        public function readStringParamFromForm(k:IWindowContainer):String
        {
            return "";
        }

        public function onInit(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents)
        {
        }

        public function onEditStart(k:IWindowContainer, _arg_2:Triggerable)
        {
        }

        public var hasSpecialInputs(get,never):Bool;
public function  get_hasSpecialInputs():Bool
        {
            return false;
        }

        public function validate(k:IWindowContainer, _arg_2:HabboUserDefinedRoomEvents):String
        {
            return null;
        }

	public function new() {}
    }

