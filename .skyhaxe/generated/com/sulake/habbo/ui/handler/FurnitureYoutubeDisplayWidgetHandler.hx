package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.video.YoutubeDisplayWidget;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.YoutubeDisplayVideoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.YoutubeDisplayPlaylistsEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.YoutubeControlVideoMessageEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.GetYoutubeDisplayStatusMessageComposer;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.SetYoutubeDisplayPlaylistMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.ControlYoutubeDisplayPlaybackMessageComposer;

     class FurnitureYoutubeDisplayWidgetHandler implements IRoomWidgetHandler 
    {
        static inline final CONTROL_COMMAND_PREVIOUS_VIDEO= 0;
        static inline final CONTROL_COMMAND_NEXT_VIDEO= 1;
        static inline final CONTROL_COMMAND_PAUSE_VIDEO= 2;
        static inline final CONTROL_COMMAND_CONTINUE_VIDEO= 3;

        var _container:IRoomWidgetHandlerContainer;
        var _widget:YoutubeDisplayWidget;
        var _events:Vector<IMessageEvent>;


        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.YOUTUBE;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
            //this.addMessageEvent(new YoutubeDisplayVideoMessageEvent(this.onVideo));
            //this.addMessageEvent(new YoutubeDisplayPlaylistsEvent(this.onPlaylists));
            //this.addMessageEvent(new YoutubeControlVideoMessageEvent(this.onControlVideo));
        }

        function addMessageEvent(k:IMessageEvent)
        {
            if (this._events == null)
            {
                this._events = new Vector<IMessageEvent>(0);
            }
            this._events.push(k);
            this._container.connection.addMessageEvent(k);
        }

        function removeEvents()
        {
            var k:IMessageEvent = null;
            final _iter_ = this._events; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._container.connection.removeMessageEvent(k);
                k.dispose();
            }
        }

        function onVideo(k:YoutubeDisplayVideoMessageEvent)
        {
            var _local_2= k.getParser();
            this._widget.showVideo(_local_2.furniId, _local_2.videoId, _local_2._Str_25795, _local_2._Str_23507, _local_2.state);
        }

        function onControlVideo(k:YoutubeControlVideoMessageEvent)
        {
            var _local_2= k.getParser();
            this._widget._Str_22371(_local_2.furniId, _local_2.commandId);
        }

        function onPlaylists(k:YoutubeDisplayPlaylistsEvent)
        {
            var _local_2= k.getParser();
            this._widget._Str_24455(_local_2.furniId, _local_2.playlists, _local_2.unknownString);
        }

        public var widget(never,set):YoutubeDisplayWidget;
public function  set_widget(k:YoutubeDisplayWidget):YoutubeDisplayWidget        {
            return this._widget = k;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return null;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processEvent(k:Event)
        {
            return;

            var _local_4 = false;
            if (this._container.roomEngine == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomEngineTriggerWidgetEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.OPEN_WIDGET:
                    if (_local_3 != null)
                    {
                        _local_4 = (this._container.isOwnerOfFurniture(_local_3) || this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE));
                        this._widget.show(_local_3, _local_4);
                        this._container.connection.send(new GetYoutubeDisplayStatusMessageComposer(_local_3.getId()));
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.CLOSE_WIDGET:
                    this._widget.hide(_local_3);
                    return;
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this.removeEvents();
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }

        public function selectPlaylist(k:Int, _arg_2:String)
        {
            this._container.connection.send(new SetYoutubeDisplayPlaylistMessageComposer(k, _arg_2));
        }

        public function switchToPreviousVideo(k:Int)
        {
            this._container.connection.send(new ControlYoutubeDisplayPlaybackMessageComposer(k, CONTROL_COMMAND_PREVIOUS_VIDEO));
        }

        public function switchToNextVideo(k:Int)
        {
            this._container.connection.send(new ControlYoutubeDisplayPlaybackMessageComposer(k, CONTROL_COMMAND_NEXT_VIDEO));
        }

        public function pauseVideo(k:Int)
        {
            this._container.connection.send(new ControlYoutubeDisplayPlaybackMessageComposer(k, CONTROL_COMMAND_PAUSE_VIDEO));
        }

        public function continueVideo(k:Int)
        {
            this._container.connection.send(new ControlYoutubeDisplayPlaybackMessageComposer(k, CONTROL_COMMAND_CONTINUE_VIDEO));
        }
public function new(){}
    }

