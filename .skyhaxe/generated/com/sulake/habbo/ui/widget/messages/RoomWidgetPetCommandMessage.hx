package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetPetCommandMessage extends RoomWidgetMessage 
    {
        public static inline final RWPCM_REQUEST_PET_COMMANDS= "RWPCM_REQUEST_PET_COMMANDS";
        public static inline final RWPCM_PET_COMMAND= "RWPCM_PET_COMMAND";
        public static inline final _Str_16282= 46;

        var _petId:Int = 0;
        var _value:String;

        public function new(k:String, _arg_2:Int, _arg_3:String=null)
        {
            super(k);
            this._petId = _arg_2;
            this._value = _arg_3;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._petId;
        }

        public var value(get,never):String;
public function  get_value():String
        {
            return this._value;
        }
    }

