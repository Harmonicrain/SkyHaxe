package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.room.chat.ChatMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.WhisperMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.ShoutMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.RoomUserRespect;
    import com.sulake.habbo.communication.messages.incoming.users.PetRespectNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.users.PetSupplementedNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.FloodControlMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HandItemReceivedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.chat.RemainingMutePeriodEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.communication.messages.parser.room.chat.ChatMessageParser;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.ui.widget.enums.SystemChatStyleEnum;
    import com.sulake.habbo.communication.messages.incoming.users.PetSupplementTypeEnum;
    import com.sulake.habbo.communication.messages.parser.room.chat.FloodControlMessageParser;

     class RoomChatHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new ChatMessageEvent(this.onRoomChat));
            k.addMessageEvent(new WhisperMessageEvent(this.onRoomWhisper));
            k.addMessageEvent(new ShoutMessageEvent(this.onRoomShout));
            k.addMessageEvent(new RoomUserRespect(this.onRespectNotification));
            k.addMessageEvent(new PetRespectNotificationEvent(this._Str_23513));
            k.addMessageEvent(new PetSupplementedNotificationEvent(this._Str_23073));
            k.addMessageEvent(new FloodControlMessageEvent(this.onFloodControl));
            k.addMessageEvent(new HandItemReceivedMessageEvent(this._Str_23267));
            k.addMessageEvent(new RemainingMutePeriodEvent(this._Str_22326));
        }

        function onRoomChat(k:IMessageEvent)
        {
            var _local_2:ChatMessageEvent = null;
            var _local_3:IRoomSession = null;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:ChatMessageParser = null;
            if (((listener != null) && (listener.events != null)))
            {
                _local_2 = Std.downcast(k , ChatMessageEvent);
                if (((_local_2 != null) && (_local_2.getParser() != null)))
                {
                    _local_3 = listener.getSession(_xxxRoomId);
                    if (_local_3 == null)
                    {
                        return;
                    }
                    _local_4 = RoomSessionChatEvent.RSCE_CHAT_EVENT;
                    _local_5 = RoomSessionChatEvent.CHAT_TYPE_SPEAK;
                    _local_6 = _local_2.getParser();
                    if (_local_6.animationLength != -1)
                    {
                        _local_3.receivedChatWithTrackingId(_local_6.animationLength);
                    }
                    listener.events.dispatchEvent(new RoomSessionChatEvent(_local_4, _local_3, _local_6.userId, _local_6.text, _local_5, _local_6.styleId, _local_6.links));
                }
            }
        }

        function onRespectNotification(k:IMessageEvent)
        {
            var _local_3:IRoomSession = null;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:RoomUserData = null;
            var _local_7:String = null;
            var _local_2= Std.downcast(k , RoomUserRespect);
            if (((listener != null) && (listener.events != null)))
            {
                _local_3 = listener.getSession(_xxxRoomId);
                if (_local_3 == null)
                {
                    return;
                }
                _local_4 = RoomSessionChatEvent.RSCE_CHAT_EVENT;
                _local_5 = RoomSessionChatEvent.CHAT_TYPE_RESPECT;
                _local_6 = _local_3.userDataManager.getUserData(_local_2.userId);
                if (_local_6 == null)
                {
                    return;
                }
                _local_7 = "";
                listener.events.dispatchEvent(new RoomSessionChatEvent(_local_4, _local_3, _local_6.roomObjectId, _local_7, _local_5, SystemChatStyleEnum.GENERIC));
            }
        }

        function _Str_23513(k:PetRespectNotificationEvent)
        {
            if ((((k == null) || (listener == null)) || (listener.events == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= RoomSessionChatEvent.RSCE_CHAT_EVENT;
            var _local_5= RoomSessionChatEvent.CHAT_TYPE_PETRESPECT;
            if (_local_2.isTreat())
            {
                _local_5 = RoomSessionChatEvent.CHAT_TYPE_PETTREAT;
            }
            var _local_6= _local_3.userDataManager._Str_8631(_local_2.petData.id);
            if (_local_6 == null)
            {
                return;
            }
            listener.events.dispatchEvent(new RoomSessionChatEvent(_local_4, _local_3, _local_6.roomObjectId, "", _local_5, SystemChatStyleEnum.GENERIC));
        }

        function _Str_23073(k:PetSupplementedNotificationEvent)
        {
            if ((((k == null) || (listener == null)) || (listener.events == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= listener.getSession(_xxxRoomId);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= RoomSessionChatEvent.RSCE_CHAT_EVENT;
            var _local_5= RoomSessionChatEvent.CHAT_TYPE_PETREVIVE;
            switch (_local_2.supplementType)
            {
                case PetSupplementTypeEnum.REVIVE:
                    _local_5 = RoomSessionChatEvent.CHAT_TYPE_PETREVIVE;
                    
                case PetSupplementTypeEnum.REBREED_FERTILIZER:
                    _local_5 = RoomSessionChatEvent.CHAT_TYPE_PET_REBREED_FERTILIZE;
                    
                case PetSupplementTypeEnum.SPEED_FERTILIZER:
                    _local_5 = RoomSessionChatEvent.CHAT_TYPE_PET_SPEED_FERTILIZE;
                    
            }
            var _local_6= _local_3.userDataManager._Str_8631(_local_2.petId);
            if (_local_6 == null)
            {
                return;
            }
            var _local_7= -1;
            var _local_8= _local_3.userDataManager.getUserData(_local_2.userId);
            if (_local_8 != null)
            {
                _local_7 = _local_8.roomObjectId;
            }
            listener.events.dispatchEvent(new RoomSessionChatEvent(_local_4, _local_3, _local_6.roomObjectId, "", _local_5, SystemChatStyleEnum.GENERIC, null, _local_7));
        }

        function _Str_23267(k:HandItemReceivedMessageEvent)
        {
            var _local_2:IRoomSession = null;
            if (((listener != null) && (listener.events != null)))
            {
                _local_2 = listener.getSession(_xxxRoomId);
                if (_local_2 != null)
                {
                    listener.events.dispatchEvent(new RoomSessionChatEvent(RoomSessionChatEvent.RSCE_CHAT_EVENT, _local_2, k.giverUserId, "", RoomSessionChatEvent.CHAT_TYPE_HAND_ITEM_RECEIVED, SystemChatStyleEnum.GENERIC, null, k.handItemType));
                }
            }
        }

        function _Str_22326(k:RemainingMutePeriodEvent)
        {
            var _local_2:IRoomSession = null;
            if (((listener != null) && (listener.events != null)))
            {
                _local_2 = listener.getSession(_xxxRoomId);
                if (_local_2 != null)
                {
                    listener.events.dispatchEvent(new RoomSessionChatEvent(RoomSessionChatEvent.RSCE_CHAT_EVENT, _local_2, _local_2.ownUserRoomId, "", RoomSessionChatEvent._Str_8909, SystemChatStyleEnum.GENERIC, null, k.secondsRemaining));
                }
            }
        }

        function onRoomWhisper(k:IMessageEvent)
        {
            var _local_2:WhisperMessageEvent = null;
            var _local_3:IRoomSession = null;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:ChatMessageParser = null;
            if (((listener != null) && (listener.events != null)))
            {
                _local_2 = Std.downcast(k , WhisperMessageEvent);
                if (((_local_2 != null) && (_local_2.getParser() != null)))
                {
                    _local_3 = listener.getSession(_xxxRoomId);
                    if (_local_3 == null)
                    {
                        return;
                    }
                    _local_4 = RoomSessionChatEvent.RSCE_CHAT_EVENT;
                    _local_5 = RoomSessionChatEvent.CHAT_TYPE_WHISPER;
                    _local_6 = _local_2.getParser();
                    listener.events.dispatchEvent(new RoomSessionChatEvent(_local_4, _local_3, _local_6.userId, _local_6.text, _local_5, _local_6.styleId, _local_6.links));
                }
            }
        }

        function onRoomShout(k:IMessageEvent)
        {
            var _local_2:ShoutMessageEvent = null;
            var _local_3:IRoomSession = null;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:ChatMessageParser = null;
            if (((listener != null) && (listener.events != null)))
            {
                _local_2 = Std.downcast(k , ShoutMessageEvent);
                if (((_local_2 != null) && (_local_2.getParser() != null)))
                {
                    _local_3 = listener.getSession(_xxxRoomId);
                    if (_local_3 == null)
                    {
                        return;
                    }
                    _local_4 = RoomSessionChatEvent.RSCE_CHAT_EVENT;
                    _local_5 = RoomSessionChatEvent.CHAT_TYPE_SHOUT;
                    _local_6 = _local_2.getParser();
                    listener.events.dispatchEvent(new RoomSessionChatEvent(_local_4, _local_3, _local_6.userId, _local_6.text, _local_5, _local_6.styleId, _local_6.links));
                }
            }
        }

        function onFloodControl(k:IMessageEvent)
        {
            var _local_2:FloodControlMessageParser = null;
            var _local_3:IRoomSession = null;
            var _local_4 = 0;
            if (((listener != null) && (listener.events != null)))
            {
                _local_2 = Std.downcast(k , FloodControlMessageEvent).getParser();
                _local_3 = listener.getSession(_xxxRoomId);
                if (_local_3 == null)
                {
                    return;
                }
                _local_4 = _local_2.seconds;
                Logger.log([(("received flood control event for " + Std.string(_local_4)) + " seconds")]);
                listener.events.dispatchEvent(new RoomSessionChatEvent(RoomSessionChatEvent.RSCE_FLOOD_EVENT, _local_3, -1, ("" + Std.string(_local_4)), 0, 0, null));
            }
        }
    }

