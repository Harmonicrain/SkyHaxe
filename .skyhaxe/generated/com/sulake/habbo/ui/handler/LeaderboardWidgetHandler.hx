package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.messages.parser.games.OpenLeaderboardMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.games.RequestLeaderboardMessageComposer;
    import com.sulake.habbo.room.events.RoomEngineLeaderboardEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.furniture.leaderboard.LeaderboardWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import flash.events.Event;

     class LeaderboardWidgetHandler implements IRoomWidgetHandler
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer;
        var _widget:LeaderboardWidget;

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.LEADERBOARD;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(value:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = value;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var widget(never,set):LeaderboardWidget;
public function  set_widget(value:LeaderboardWidget):LeaderboardWidget        {
            return this._widget = value;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineLeaderboardEvent.OPEN];
        }

        public function processEvent(event:Event)
        {
var leaderboardEvent:RoomEngineLeaderboardEvent  = null, parser:OpenLeaderboardMessageParser  = null;            if (this._disposed || this._widget == null)
            {
                return;
            }
            if (event.type == RoomEngineLeaderboardEvent.OPEN)
            {
leaderboardEvent= Std.downcast(event , RoomEngineLeaderboardEvent);
parser= leaderboardEvent == null ? null : leaderboardEvent.parser;
                this._widget.openLeaderboard(parser);
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [];
        }

        public function processWidgetMessage(message:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function requestLeaderboard(leaderboardId:Int, period:String, offset:Int, limit:Int)
        {
            if (this._disposed || this._container == null || this._container.connection == null)
            {
                return;
            }
            this._container.connection.send(new RequestLeaderboardMessageComposer(leaderboardId, period, offset, limit));
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._container == null ? null : this._container.avatarRenderManager;
        }

        public function showExtendedProfile(userId:Int)
        {
            if (this._disposed || this._container == null || this._container.habboGroupsManager == null || userId <= 0)
            {
                return;
            }
            this._container.habboGroupsManager.showExtendedProfile(userId);
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._widget = null;
            this._container = null;
            this._disposed = true;
        }
public function new(){}
    }

