package com.sulake.habbo.friendlist.events
;
    import flash.events.Event;

     class _Str_2948 extends Event 
    {
        public static inline final FRE_ACCEPTED= "FRE_ACCEPTED";
        public static inline final FRE_DECLINED= "FRE_DECLINED";

        var _requestId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._requestId = _arg_2;
        }

        public var requestId(get,never):Int;
public function  get_requestId():Int
        {
            return this._requestId;
        }
    }

