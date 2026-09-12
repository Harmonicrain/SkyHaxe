package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomToObjectEvent;
    import com.sulake.room.utils.IVector3d;

     class RoomToObjectOwnAvatarMoveEvent extends RoomToObjectEvent 
    {
        public static inline final ROAME_MOVE_TO= "ROAME_MOVE_TO";

        var _targetLoc:IVector3d;

        public function new(k:String, _arg_2:IVector3d, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._targetLoc = _arg_2;
        }

        public var _Str_7569(get,never):IVector3d;
public function  get__Str_7569():IVector3d
        {
            return this._targetLoc;
        }
    }

