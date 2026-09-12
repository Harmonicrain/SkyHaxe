package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.navigator.GetGuestRoomResultEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.session.events.RoomSessionPropertyUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.core.communication.messages.IMessageEvent;

     class RoomDataHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new GetGuestRoomResultEvent(this.onRoomResult));
        }

        function onRoomResult(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , GetGuestRoomResultEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (_local_3._Str_18882)
            {
                return;
            }
            var _local_4= listener.getSession(_xxxRoomId);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= _local_3.data;
            _local_4.tradeMode = _local_5.tradeMode;
            _local_4.isGuildRoom = (!(_local_5.habboGroupId == 0));
            _local_4.doorMode = _local_5.doorMode;
            _local_4.arePetsAllowed = _local_5.allowPets;
            _local_4.roomModerationSettings = _local_3.roomModerationSettings;
            listener.events.dispatchEvent(new RoomSessionPropertyUpdateEvent(RoomSessionPropertyUpdateEvent.RSDUE_ALLOW_PETS, _local_4));
            listener.events.dispatchEvent(new RoomSessionEvent(RoomSessionEvent.ROOM_DATA, _local_4));
        }
    }

