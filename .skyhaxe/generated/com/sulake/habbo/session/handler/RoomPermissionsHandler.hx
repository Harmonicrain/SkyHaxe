package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.room.permissions.YouAreControllerMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.permissions.YouAreNotControllerMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.permissions.YouAreOwnerMessageEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.session._enum.RoomControllerLevel;

     class RoomPermissionsHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new YouAreControllerMessageEvent(this.onYouAreController));
            k.addMessageEvent(new YouAreNotControllerMessageEvent(this.onYouAreNotController));
            k.addMessageEvent(new YouAreOwnerMessageEvent(this.onYouAreOwner));
        }

        function onYouAreController(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , YouAreControllerMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.roomControllerLevel = _local_2.getParser().roomControllerLevel;
        }

        function onYouAreNotController(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , YouAreNotControllerMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.roomControllerLevel = RoomControllerLevel.NONE;
        }

        function onYouAreOwner(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , YouAreOwnerMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.isRoomOwner = true;
        }
    }

