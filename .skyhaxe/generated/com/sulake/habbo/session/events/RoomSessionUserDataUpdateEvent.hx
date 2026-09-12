package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionUserDataUpdateEvent extends RoomSessionEvent 
    {
        public static inline final RSUDUE_USER_DATA_UPDATED= "rsudue_user_data_updated";

        var _addedUsers:Vector<RoomUserData>;

        public function new(k:IRoomSession, _arg_2:Vector<RoomUserData>, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RSUDUE_USER_DATA_UPDATED, k, _arg_3, _arg_4);
            this._addedUsers = _arg_2;
        }

        public var _Str_24272(get,never):Vector<RoomUserData>;
public function  get__Str_24272():Vector<RoomUserData>
        {
            return this._addedUsers;
        }
    }

