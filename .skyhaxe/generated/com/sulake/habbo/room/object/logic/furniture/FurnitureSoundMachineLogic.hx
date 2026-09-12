package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureSoundMachineLogic extends FurnitureMultistateLogic 
    {
        var _disposeEventsAllowed:Bool = false;
        var _isInitialized:Bool = false;
        var _currentState:Int = -1;


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectFurnitureActionEvent.SOUND_MACHINE_START, RoomObjectFurnitureActionEvent.SOUND_MACHINE_STOP, RoomObjectFurnitureActionEvent.SOUND_MACHINE_DISPOSE, RoomObjectFurnitureActionEvent.SOUND_MACHINE_INIT];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function dispose()
        {
            this._Str_18894();
            super.dispose();
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_2:RoomObjectDataUpdateMessage = null;
            var _local_3 = 0;
            super.processUpdateMessage(k);
            if (object == null)
            {
                return;
            }
            if (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)
            {
                if (!this._isInitialized)
                {
                    this.requestInitialize();
                }
                _local_2 = Std.downcast(k , RoomObjectDataUpdateMessage);
                if (_local_2 == null)
                {
                    return;
                }
                _local_3 = object.getState(0);
                if (_local_3 != this._currentState)
                {
                    this._currentState = _local_3;
                    if (_local_3 == 1)
                    {
                        this.requestPlayList();
                    }
                    else
                    {
                        if (_local_3 == 0)
                        {
                            this._Str_18998();
                        }
                    }
                }
            }
        }

        function requestInitialize()
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            }
            this._disposeEventsAllowed = true;
            var k= new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.SOUND_MACHINE_INIT, object);
            eventDispatcher.dispatchEvent(k);
            this._isInitialized = true;
        }

        function requestPlayList()
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            }
            this._disposeEventsAllowed = true;
            var k= new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.SOUND_MACHINE_START, object);
            eventDispatcher.dispatchEvent(k);
        }

        function _Str_18998()
        {
            if (((object == null) || (eventDispatcher == null)))
            {
                return;
            }
            var k= new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.SOUND_MACHINE_STOP, object);
            eventDispatcher.dispatchEvent(k);
        }

        function _Str_18894()
        {
            if (!this._disposeEventsAllowed)
            {
                return;
            }
            var k= new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.SOUND_MACHINE_DISPOSE, object);
            eventDispatcher.dispatchEvent(k);
        }

	public function new() { super(); }
    }

