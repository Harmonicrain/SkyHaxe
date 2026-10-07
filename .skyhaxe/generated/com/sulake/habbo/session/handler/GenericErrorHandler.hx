package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.handshake.GenericErrorEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.session.events.RoomSessionErrorMessageEvent;
    import com.sulake.habbo.session._enum.GenericErrorEnum;
    import com.sulake.core.communication.messages.IMessageEvent;

     class GenericErrorHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new GenericErrorEvent(this.onGenericError));
        }

        function onGenericError(k:IMessageEvent)
        {
            var _local_4:String = null;
            var _local_2= Std.downcast(k , GenericErrorEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            switch (_local_2.errorCode)
            {
                case GenericErrorEnum.KICKED_BY_OWNER:
                    _local_4 = RoomSessionErrorMessageEvent.RSEME_KICKED;
                    
                default:
                    return;
            }
            if (((listener != null) && (listener.events != null)))
            {
                listener.events.dispatchEvent(new RoomSessionErrorMessageEvent(_local_4, _local_3));
            }
        }
    }

