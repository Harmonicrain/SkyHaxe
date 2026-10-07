package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.events.RoomObjectPlaySoundIdEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureCuckooClockLogic extends FurnitureMultistateLogic 
    {
        var _state:Int = -1;
        var _loc__com_sulake_habbo_room_object_logic_furniture_FurnitureCuckooClockLogic/*redefined private*/:IVector3d;


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectPlaySoundIdEvent.ROPSIE_PLAY_SOUND_AT_PITCH];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                if (((!(this._state == -1)) && (!(_local_2.state == this._state))))
                {
                    this._Str_18183(this._loc__com_sulake_habbo_room_object_logic_furniture_FurnitureCuckooClockLogic.z);
                }
                this._state = _local_2.state;
            }
            else
            {
                this._loc__com_sulake_habbo_room_object_logic_furniture_FurnitureCuckooClockLogic = k.loc;
            }
        }

        function _Str_18183(k:Float)
        {
            var _local_2= Math.pow(2, (k - 1.2));
            eventDispatcher.dispatchEvent(new RoomObjectPlaySoundIdEvent(RoomObjectPlaySoundIdEvent.ROPSIE_PLAY_SOUND_AT_PITCH, object, "FURNITURE_cuckoo_clock", _local_2));
        }

	public function new() { super(); }
    }

