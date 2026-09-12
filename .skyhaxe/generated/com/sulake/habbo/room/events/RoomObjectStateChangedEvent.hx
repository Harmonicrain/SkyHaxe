package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectStateChangedEvent extends RoomObjectEvent 
    {
        public static inline final STATE_CHANGE= "ROSCE_STATE_CHANGE";
        public static inline final STATE_RANDOM= "ROSCE_STATE_RANDOM";

        var _param:Int = 0;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Int=0, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_2, _arg_4, _arg_5);
            this._param = _arg_3;
        }

        public var param(get,never):Int;
public function  get_param():Int
        {
            return this._param;
        }
    }

