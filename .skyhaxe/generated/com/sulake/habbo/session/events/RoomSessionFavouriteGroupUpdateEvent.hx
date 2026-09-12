package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionFavouriteGroupUpdateEvent extends RoomSessionEvent 
    {
        public static inline final RSFGUE_FAVOURITE_GROUP_UPDATE= "rsfgue_favourite_group_update";

        var _roomIndex:Int = 0;
        var _habboGroupId:Int = 0;
        var _habboGroupName:String;
        var _status:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(RSFGUE_FAVOURITE_GROUP_UPDATE, k, _arg_6, _arg_7);
            this._roomIndex = _arg_2;
            this._habboGroupId = _arg_3;
            this._habboGroupName = _arg_5;
            this._status = _arg_4;
        }

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var habboGroupId(get,never):Int;
public function  get_habboGroupId():Int
        {
            return this._habboGroupId;
        }

        public var habboGroupName(get,never):String;
public function  get_habboGroupName():String
        {
            return this._habboGroupName;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }
    }

