package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.RoomPetData;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetInfoUpdateEvent extends RoomSessionEvent 
    {
        public static inline final PET_INFO= "RSPIUE_PET_INFO";

        var _petInfo:RoomPetData;

        public function new(k:IRoomSession, _arg_2:RoomPetData, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RoomSessionPetInfoUpdateEvent.PET_INFO, k, _arg_3, _arg_4);
            this._petInfo = _arg_2;
        }

        public var _Str_24727(get,never):RoomPetData;
public function  get__Str_24727():RoomPetData
        {
            return this._petInfo;
        }
    }

