package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.PresentOpenedMessageEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.session.events.RoomSessionPresentEvent;
    import com.sulake.core.communication.messages.IMessageEvent;

     class PresentHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new PresentOpenedMessageEvent(this.onPresentOpened));
        }

        function onPresentOpened(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PresentOpenedMessageEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            if (((listener != null) && (listener.events != null)))
            {
                listener.events.dispatchEvent(new RoomSessionPresentEvent(RoomSessionPresentEvent.RSPE_PRESENT_OPENED, _local_3, _local_2.classId, _local_2.itemType, _local_2.productCode, _local_2.placedItemId, _local_2.placedItemType, _local_2.isPlacedInRoom, _local_2.petFigureString));
            }
        }
    }

