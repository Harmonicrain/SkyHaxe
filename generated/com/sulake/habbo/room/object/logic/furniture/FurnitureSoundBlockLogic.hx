package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectSamplePlaybackEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureSoundBlockLogic extends FurnitureMultistateLogic 
    {
        static inline final HIGHEST_SEMITONE= 12;
        static inline final LOWEST_SEMITONE= -12;
        static inline final STATE_UNINITIALIZED= -1;

        var _state:Int = -1;
        var _sampleId:Int = -1;
        var _noPitch:Bool = false;
        var _lastLocZ:Float = 0;


        override public function dispose()
        {
            if (this._state != -1)
            {
                eventDispatcher.dispatchEvent(new RoomObjectSamplePlaybackEvent(RoomObjectSamplePlaybackEvent.ROPSPE_ROOM_OBJECT_DISPOSED, object, this._sampleId));
            }
            super.dispose();
        }

        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectSamplePlaybackEvent.ROPSPE_PLAY_SAMPLE, RoomObjectSamplePlaybackEvent.ROPSPE_ROOM_OBJECT_DISPOSED, RoomObjectSamplePlaybackEvent.ROPSPE_ROOM_OBJECT_INITIALIZED];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("sound");
            if (_local_2.length() == 0)
            {
                return;
            }
            var _local_3= k.child("sound").child("sample");
            if (_local_3.length() == 0)
            {
                return;
            }
            this._sampleId = ASCompat.toInt(_local_3.attribute("id").toString());
            this._noPitch = (_local_3.attribute("nopitch") .toString()== "true");
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_SOUNDBLOCK_RELATIVE_ANIMATION_SPEED, 1);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(k);
            var _local_2= object.getLocation();
            var _local_3= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_3 != null)
            {
                if (((this._state == STATE_UNINITIALIZED) && (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)))
                {
                    this._lastLocZ = _local_2.z;
                    eventDispatcher.dispatchEvent(new RoomObjectSamplePlaybackEvent(RoomObjectSamplePlaybackEvent.ROPSPE_ROOM_OBJECT_INITIALIZED, object, this._sampleId, this._Str_17428(_local_2.z)));
                }
                if (((!(this._state == STATE_UNINITIALIZED)) && (!(_local_2 == null))))
                {
                    if (this._lastLocZ != _local_2.z)
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectSamplePlaybackEvent(RoomObjectSamplePlaybackEvent.ROPSPE_CHANGE_PITCH, object, this._sampleId, this._Str_17428(_local_2.z)));
                        this._lastLocZ = _local_2.z;
                    }
                }
                if ((((!(this._state == STATE_UNINITIALIZED)) && (!(_local_3.state == this._state))) && (!(_local_2 == null))))
                {
                    this._Str_18183(_local_2.z);
                }
                this._state = _local_3.state;
            }
        }

        function _Str_18183(k:Float)
        {
            var _local_2= this._Str_17428(k);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_SOUNDBLOCK_RELATIVE_ANIMATION_SPEED, _local_2);
            eventDispatcher.dispatchEvent(new RoomObjectSamplePlaybackEvent(RoomObjectSamplePlaybackEvent.ROPSPE_PLAY_SAMPLE, object, this._sampleId, _local_2));
        }

        function _Str_17428(k:Float):Float
        {
            var _local_2= Std.int(k * 2);
            if (_local_2 > HIGHEST_SEMITONE)
            {
                _local_2 = Std.int(Math.min(0, (LOWEST_SEMITONE + ((_local_2 - HIGHEST_SEMITONE) - 1))));
            }
            return this._noPitch ? 1 : Math.pow(2, (_local_2 / 12));
        }

	public function new() { super(); }
    }

