package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.OpenPetPackageRequestedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.OpenPetPackageResultMessageEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.session.events.RoomSessionPetPackageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;

     class PetPackageHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new OpenPetPackageRequestedMessageEvent(this.onOpenPetPackageRequested));
            k.addMessageEvent(new OpenPetPackageResultMessageEvent(this.onOpenPetPackageResult));
        }

        function onOpenPetPackageRequested(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , OpenPetPackageRequestedMessageEvent).getParser();
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
                listener.events.dispatchEvent(new RoomSessionPetPackageEvent(RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_REQUESTED, _local_3, _local_2.objectId, _local_2.figureData, 0, null));
            }
        }

        function onOpenPetPackageResult(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , OpenPetPackageResultMessageEvent).getParser();
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
                listener.events.dispatchEvent(new RoomSessionPetPackageEvent(RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_RESULT, _local_3, _local_2.objectId, null, _local_2.nameValidationStatus, _local_2.nameValidationInfo));
            }
        }
    }

