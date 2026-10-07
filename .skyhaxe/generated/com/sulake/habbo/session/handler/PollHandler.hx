package com.sulake.habbo.session.handler
;
    import com.sulake.habbo.communication.messages.incoming.poll.PollContentsEvent;
    import com.sulake.habbo.communication.messages.incoming.poll.PollOfferEvent;
    import com.sulake.habbo.communication.messages.incoming.poll.PollErrorEvent;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.session.events.RoomSessionPollEvent;

     class PollHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
            k.addMessageEvent(new PollContentsEvent(this.parsePollContentsEvent));
            k.addMessageEvent(new PollOfferEvent(this.parsePollOfferEvent));
            k.addMessageEvent(new PollErrorEvent(this.parsePollErrorEvent));
        }

        function parsePollOfferEvent(k:PollOfferEvent)
        {
            var _local_4:RoomSessionPollEvent = null;
            if (k == null)
            {
                return;
            }
            var _local_2= listener.getSession(_xxxRoomId);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_4 = new RoomSessionPollEvent(RoomSessionPollEvent.RSPE_POLL_OFFER, _local_2, _local_3.id);
            _local_4.summary = _local_3.headline;
            _local_4.summary = _local_3.summary;
            listener.events.dispatchEvent(_local_4);
        }

        function parsePollErrorEvent(k:PollErrorEvent)
        {
            var _local_4:RoomSessionPollEvent = null;
            if (k == null)
            {
                return;
            }
            var _local_2= listener.getSession(_xxxRoomId);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_4 = new RoomSessionPollEvent(RoomSessionPollEvent.ERROR, _local_2, -1);
            _local_4.headline = "???";
            _local_4.summary = "???";
            listener.events.dispatchEvent(_local_4);
        }

        function parsePollContentsEvent(k:PollContentsEvent)
        {
            var _local_4:RoomSessionPollEvent = null;
            if (k == null)
            {
                return;
            }
            var _local_2= listener.getSession(_xxxRoomId);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_4 = new RoomSessionPollEvent(RoomSessionPollEvent.RSPE_POLL_CONTENT, _local_2, _local_3.id);
            _local_4._Str_6013 = _local_3._Str_6013;
            _local_4._Str_5838 = _local_3._Str_5838;
            _local_4.numQuestions = _local_3.numQuestions;
            _local_4._Str_5643 = _local_3._Str_5643;
            _local_4._Str_6196 = _local_3._Str_6196;
            listener.events.dispatchEvent(_local_4);
        }
    }

