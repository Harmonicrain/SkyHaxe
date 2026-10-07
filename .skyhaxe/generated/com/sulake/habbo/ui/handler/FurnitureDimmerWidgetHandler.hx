package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDimmerSavePresetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDimmerChangeStateMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDimmerPreviewMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.session.events.RoomSessionDimmerPresetsEvent;
    import com.sulake.habbo.room.events.RoomEngineDimmerStateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetDimmerUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_5572;
    import com.sulake.habbo.session.events.RoomSessionDimmerPresetsEventPresetItem;
    import flash.events.Event;

     class FurnitureDimmerWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_DIMMER;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_DIMMER, RoomWidgetDimmerSavePresetMessage.RWSDPM_SAVE_PRESET, RoomWidgetDimmerChangeStateMessage.RWCDSM_CHANGE_STATE, RoomWidgetDimmerPreviewMessage.RWDPM_PREVIEW_DIMMER_PRESET];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2 = 0;
            var _local_3:RoomWidgetDimmerPreviewMessage = null;
            var _local_4:RoomWidgetDimmerSavePresetMessage = null;
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_DIMMER:
                    if (this._Str_6826())
                    {
                        this._container.roomSession.sendRoomDimmerGetPresetsMessage();
                    }
                    
                case RoomWidgetDimmerSavePresetMessage.RWSDPM_SAVE_PRESET:
                    if (this._Str_6826())
                    {
                        _local_4 = Std.downcast(k , RoomWidgetDimmerSavePresetMessage);
                        this._container.roomSession.sendRoomDimmerSavePresetMessage(_local_4._Str_25037, _local_4._Str_24446, _local_4.color, _local_4.brightness, _local_4.apply);
                    }
                    
                case RoomWidgetDimmerChangeStateMessage.RWCDSM_CHANGE_STATE:
                    if (this._Str_6826())
                    {
                        this._container.roomSession.sendRoomDimmerChangeStateMessage();
                    }
                    
                case RoomWidgetDimmerPreviewMessage.RWDPM_PREVIEW_DIMMER_PRESET:
                    _local_2 = this._container.roomSession.roomId;
                    _local_3 = Std.downcast(k , RoomWidgetDimmerPreviewMessage);
                    if (((_local_3 == null) || (this._container.roomEngine == null)))
                    {
                        return null;
                    }
                    this._container.roomEngine.updateObjectRoomColor(_local_2, _local_3.color, _local_3.brightness, _local_3.bgOnly);
                    
            }
            return null;
        }

        function _Str_6826():Bool
        {
            var k= this._container.roomSession.isRoomOwner;
            var _local_2:ASAny = (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST);
            var _local_3= this._container.sessionDataManager.isAnyRoomController;
            return (k || _local_3) || ASCompat.toBool(_local_2);
        }

        public function getProcessedEvents():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomSessionDimmerPresetsEvent.RSDPE_PRESETS);
            k.push(RoomEngineDimmerStateEvent.REDSE_ROOM_COLOR);
            k.push(RoomEngineTriggerWidgetEvent.RETWE_REMOVE_DIMMER);
            return k;
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionDimmerPresetsEvent = null;
            var _local_3:RoomWidgetDimmerUpdateEvent = null;
            var _local_4:RoomEngineDimmerStateEvent = null;
            var _local_5:_Str_5572 = null;
            var _local_6 = 0;
            var _local_7:RoomSessionDimmerPresetsEventPresetItem = null;
            if (((this._container == null) || (this._container.events == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionDimmerPresetsEvent.RSDPE_PRESETS:
                    _local_2 = Std.downcast(k , RoomSessionDimmerPresetsEvent);
                    _local_3 = new RoomWidgetDimmerUpdateEvent(RoomWidgetDimmerUpdateEvent.RWDUE_PRESETS);
                    _local_3._Str_6226 = _local_2._Str_6226;
                    _local_6 = 0;
                    while (_local_6 < _local_2._Str_10888)
                    {
                        _local_7 = _local_2.getPreset(_local_6);
                        if (_local_7 != null)
                        {
                            _local_3.storePreset(_local_7.id, _local_7.type, ASCompat.toInt(_local_7.color), _local_7.brightness);
                        }
                        _local_6++;
                    }
                    this._container.events.dispatchEvent(_local_3);
                    return;
                case RoomEngineDimmerStateEvent.REDSE_ROOM_COLOR:
                    _local_4 = Std.downcast(k , RoomEngineDimmerStateEvent);
                    _local_5 = new _Str_5572(_local_4.state, _local_4._Str_14686, _local_4.effectId, _local_4.color, _local_4.brightness);
                    this._container.events.dispatchEvent(_local_5);
                    return;
                case RoomEngineTriggerWidgetEvent.RETWE_REMOVE_DIMMER:
                    this._container.events.dispatchEvent(new RoomWidgetDimmerUpdateEvent(RoomWidgetDimmerUpdateEvent.RWDUE_HIDE));
                    return;
            }
        }

        public function update()
        {
        }
public function new(){}
    }

