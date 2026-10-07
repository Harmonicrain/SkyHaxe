package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetUserTagsUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final USER_TAGS= "RWUTUE_USER_TAGS";

        var _userId:Int = 0;
        var _tags:Array<ASAny>;
        var _Str_8426:Bool = false;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:Bool, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(USER_TAGS, _arg_4, _arg_5);
            this._userId = k;
            this._tags = _arg_2;
            this._Str_8426 = _arg_3;
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

        public var isOwnUser(get,never):Bool;
public function  get_isOwnUser():Bool
        {
            return this._Str_8426;
        }
    }

