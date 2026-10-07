package com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.events
;
    import flash.events.Event;

     class PathResetEvent extends Event 
    {
        public static inline final LWMOPRE_MOVING_OBJECT_PATH_RESET= "LWMOPRE_MOVING_OBJECT_PATH_RESET";

        var _objectId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            this._objectId = _arg_2;
            super(LWMOPRE_MOVING_OBJECT_PATH_RESET, _arg_3, _arg_4);
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }
    }

