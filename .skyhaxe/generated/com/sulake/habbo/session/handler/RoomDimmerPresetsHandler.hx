package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RoomDimmerPresetsEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RoomDimmerPresetsMessageData;
    import com.sulake.habbo.session.events.RoomSessionDimmerPresetsEvent;
    import com.sulake.core.communication.messages.IMessageEvent;

     class RoomDimmerPresetsHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new RoomDimmerPresetsEvent(this.onRoomDimmerPresets));
        }

        function onRoomDimmerPresets(k:IMessageEvent)
        {
            var _local_7:RoomDimmerPresetsMessageData = null;
            var _local_2= Std.downcast(k , RoomDimmerPresetsEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            var _local_4= listener.getSession(_xxxRoomId);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= new RoomSessionDimmerPresetsEvent(RoomSessionDimmerPresetsEvent.RSDPE_PRESETS, _local_4);
            _local_5._Str_6226 = _local_3._Str_6226;
            var _local_6 = 0;
            while (_local_6 < _local_3._Str_10888)
            {
                _local_7 = _local_3.getPreset(_local_6);
                if (_local_7 != null)
                {
                    _local_5.storePreset(_local_7.id, _local_7.type, ASCompat.toInt(_local_7.color), _local_7.brightness);
                }
                _local_6++;
            }
            if (((listener != null) && (listener.events != null)))
            {
                listener.events.dispatchEvent(_local_5);
            }
        }
    }

