package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionUserBadgesEvent extends RoomSessionEvent 
    {
        public static inline final RSUBE_BADGES= "RSUBE_BADGES";

        var _userId:Int = 0;
        var _badges:Array<ASAny>;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            this._badges = [];
            super(RSUBE_BADGES, k, _arg_4, _arg_5);
            this._userId = _arg_2;
            this._badges = _arg_3;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var badges(get,never):Array<ASAny>;
public function  get_badges():Array<ASAny>
        {
            return this._badges;
        }
    }

