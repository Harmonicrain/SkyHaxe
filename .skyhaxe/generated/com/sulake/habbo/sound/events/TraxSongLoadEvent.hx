package com.sulake.habbo.sound.events
;
    import flash.events.Event;

     class TraxSongLoadEvent extends Event 
    {
        public static inline final TSLE_TRAX_LOAD_COMPLETE= "TSLE_TRAX_LOAD_COMPLETE";
        public static inline final TSLE_TRAX_LOAD_FAILED= "TSLE_TRAX_LOAD_FAILED";

        var _id:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._id = _arg_2;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }
    }

