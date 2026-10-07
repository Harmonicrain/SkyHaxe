package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetOpenPetPackageMessage extends RoomWidgetMessage 
    {
        public static inline final RWOPPM_OPEN_PET_PACKAGE= "RWOPPM_OPEN_PET_PACKAGE";

        var _objectId:Int = 0;
        var _name:String;

        public function new(k:String, _arg_2:Int, _arg_3:String)
        {
            super(k);
            this._objectId = _arg_2;
            this._name = _arg_3;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }
    }

