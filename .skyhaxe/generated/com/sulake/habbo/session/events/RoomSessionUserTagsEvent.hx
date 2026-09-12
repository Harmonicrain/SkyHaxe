package com.sulake.habbo.session.events
;
    import flash.events.Event;

     class RoomSessionUserTagsEvent extends Event 
    {
        public static inline final UTRE_USER_TAGS_RECEIVED= "UTRE_USER_TAGS_RECEIVED";

        var _userId:Int = 0;
        var _tags:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(UTRE_USER_TAGS_RECEIVED, _arg_3, _arg_4);
            this._userId = k;
            this._tags = _arg_2;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var tags(get,never):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return this._tags;
        }
    }

