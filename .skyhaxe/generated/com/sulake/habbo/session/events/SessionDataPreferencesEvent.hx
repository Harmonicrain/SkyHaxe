package com.sulake.habbo.session.events
;
    import flash.events.Event;

     class SessionDataPreferencesEvent extends Event 
    {
        public static inline final APUE_UPDATED= "APUE_UPDATED";

        var _uiFlags:Int = 0;

        public function new(k:Int, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            this._uiFlags = k;
            super(APUE_UPDATED, _arg_2, _arg_3);
        }

        public var uiFlags(get,never):Int;
public function  get_uiFlags():Int
        {
            return this._uiFlags;
        }
    }

