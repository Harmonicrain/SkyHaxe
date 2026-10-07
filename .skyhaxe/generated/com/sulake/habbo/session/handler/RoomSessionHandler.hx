package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.room.session.OpenConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.FlatAccessibleMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatAccessDeniedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomQueueStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.YouAreSpectatorMessageEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.communication.messages.outgoing.room.session.GoToFlatMessageComposer;
    import com.sulake.habbo.session.events.RoomSessionDoorbellEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomReadyMessageParser;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomQueueSet;
    import com.sulake.habbo.session.events.RoomSessionQueueEvent;

     class RoomSessionHandler extends BaseHandler 
    {
        public static inline final RS_CONNECTED= "RS_CONNECTED";
        public static inline final RS_READY= "RS_READY";
        public static inline final RS_DISCONNECTED= "RS_DISCONNECTED";

        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new OpenConnectionMessageEvent(this.onRoomConnected));
            k.addMessageEvent(new FlatAccessibleMessageEvent(this.onFlatAccessible));
            k.addMessageEvent(new RoomReadyMessageEvent(this.onRoomReady));
            k.addMessageEvent(new CloseConnectionMessageEvent(this.onRoomDisconnected));
            k.addMessageEvent(new FlatAccessDeniedMessageEvent(this.onFlatAccessDenied));
            k.addMessageEvent(new RoomQueueStatusMessageEvent(this.onRoomQueueStatus));
            k.addMessageEvent(new YouAreSpectatorMessageEvent(this.onYouAreSpectator));
        }

        function onRoomConnected(k:IMessageEvent)
        {
            var _local_2= _xxxRoomId;
            if (listener != null)
            {
                listener.sessionUpdate(_local_2, RoomSessionHandler.RS_CONNECTED);
            }
        }

        function onFlatAccessible(k:FlatAccessibleMessageEvent)
        {
            var session:IRoomSession = null;
            var roomId= _xxxRoomId;
            var parser= k.getParser();
            if (parser == null)
            {
                return;
            }
            var userName= parser.userName;
            if (((userName == null) || (userName.length == 0)))
            {
                connection.send(new GoToFlatMessageComposer(roomId));
            }
            else
            {
                if (((listener != null) && (listener.events != null)))
                {
                    session = listener.getSession(roomId);
                    if (session != null)
                    {
                        listener.events.dispatchEvent(new RoomSessionDoorbellEvent(RoomSessionDoorbellEvent.RSDE_ACCEPTED, session, userName));
                    }
                }
            }
        }

        function onRoomReady(k:IMessageEvent)
        {
            var _local_5:RoomReadyMessageParser = null;
            var _local_2= _xxxRoomId;
            var _local_3= _local_2;
            var _local_4= Std.downcast(k , RoomReadyMessageEvent);
            if (_local_4 != null)
            {
                _local_5 = _local_4.getParser();
                if (_local_5 != null)
                {
                    _local_3 = _local_5.roomId;
                }
                ErrorReportStorage.addDebugData("RoomID", ("Room id: " + Std.string(_local_5.roomId)));
            }
            if (listener != null)
            {
                listener.sessionReinitialize(_local_2, _local_3);
                listener.sessionUpdate(_local_2, RoomSessionHandler.RS_READY);
            }
        }

        function onFlatAccessDenied(k:FlatAccessDeniedMessageEvent)
        {
            var _local_5:IRoomSession = null;
            var _local_2= _xxxRoomId;
            var _local_3= k.getParser();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.userName;
            if (((_local_4 == null) || (_local_4.length == 0)))
            {
                if (listener != null)
                {
                    listener.sessionUpdate(_local_2, RoomSessionHandler.RS_DISCONNECTED);
                }
            }
            else
            {
                if (((listener != null) && (listener.events != null)))
                {
                    _local_5 = listener.getSession(_local_2);
                    if (_local_5 != null)
                    {
                        listener.events.dispatchEvent(new RoomSessionDoorbellEvent(RoomSessionDoorbellEvent.REJECTED, _local_5, _local_4));
                    }
                }
            }
        }

        function onRoomDisconnected(k:IMessageEvent)
        {
            var _local_2= _xxxRoomId;
            ErrorReportStorage.addDebugData("RoomID", "");
            if (listener != null)
            {
                listener.sessionUpdate(_local_2, RoomSessionHandler.RS_DISCONNECTED);
            }
        }

        function onRoomQueueStatus(k:RoomQueueStatusMessageEvent)
        {
            var _local_4:RoomQueueSet = null;
            var _local_5:RoomSessionQueueEvent = null;
            var _local_7:Array<ASAny> = null;
            var _local_9 = 0;
            var _local_10:String = null;
            if (((listener == null) || (listener.events == null)))
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
            var _local_6= _local_2.getQueueSetTargets();
            var _local_8= _local_2.activeTarget;
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_9  = ASCompat.toInt(_tmp_);
                _local_4 = _local_2.getQueueSet(_local_9);
                _local_5 = new RoomSessionQueueEvent(_local_3, _local_4.name, _local_4.target, (_local_4.target == _local_8));
                _local_7 = _local_4.queueTypes;
                if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
                {
_local_10  = _tmp_;
                    _local_5.addQueue(_local_10, _local_4.getQueueSize(_local_10));
                }
                listener.events.dispatchEvent(_local_5);
            }
        }

        function onYouAreSpectator(k:YouAreSpectatorMessageEvent)
        {
            if (listener == null)
            {
                return;
            }
            var _local_2= listener.getSession(_xxxRoomId);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.isSpectatorMode = true;
        }
    }

