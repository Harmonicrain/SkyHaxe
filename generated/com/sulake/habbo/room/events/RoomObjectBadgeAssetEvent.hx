package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectBadgeAssetEvent extends RoomObjectEvent 
    {
        public static inline final ROGBE_LOAD_BADGE= "ROGBE_LOAD_BADGE";

        var _badgeId:String;
        var _groupBadge:Bool = false;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:String, _arg_4:Bool=true, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_5, _arg_6);
            this._badgeId = _arg_3;
            this._groupBadge = _arg_4;
        }

        public var badgeId(get,never):String;
function  get_badgeId():String
        {
            return this._badgeId;
        }

        public var _Str_14095(get,never):Bool;
function  get__Str_14095():Bool
        {
            return this._groupBadge;
        }
    }

