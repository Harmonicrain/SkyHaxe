package com.sulake.habbo.session.events
;
    import flash.events.Event;

     class UserNameUpdateEvent extends Event 
    {
        public static inline final UNUE_NAME_UPDATED= "unue_name_updated";

        var _name:String;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(UNUE_NAME_UPDATED, _arg_2, _arg_3);
            this._name = k;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }
    }

