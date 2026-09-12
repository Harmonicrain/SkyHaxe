package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.ui.widget.roomtools.RoomToolsWidget;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.communication.messages.incoming.navigator.GetGuestRoomResultEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.session.events.SessionDataPreferencesEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetZoomToggleMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RateFlatMessageComposer;

     class RoomToolsWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _communicationManagerMessageEvents:Vector<IMessageEvent>;
        var _communicationManager:IHabboCommunicationManager;
        var _navigator:IHabboNavigator;
        var _widget:RoomToolsWidget;
        var _container:IRoomWidgetHandlerContainer;

        public function new()
        {
            this._communicationManagerMessageEvents = new Vector<IMessageEvent>();
        }

        public var widget(never,set):RoomToolsWidget;
public function  set_widget(k:RoomToolsWidget):RoomToolsWidget        {
            return this._widget = k;
        }

        function onRoomInfo(k:IMessageEvent)
        {
            var _local_4:String = null;
            var _local_2= cast(k, GetGuestRoomResultEvent).getParser();
            var _local_3= _local_2.data;
            if (_local_3 != null)
            {
                this._widget.updateRoomData(_local_3);
            }
            if (_local_2._Str_15487)
            {
                if (_local_3 != null)
                {
                    _local_4 = (_local_3.showOwner ? ((this._widget.localizations.getLocalizationWithParams("room.tool.room.owner.prefix", "By") + " ") + _local_3.ownerName) : this._widget.localizations.getLocalizationWithParams("room.tool.public.room", "Public room"));
                    this._widget.showRoomInfo(true, _local_3.roomName, _local_4, _local_3.tags);
                    this._widget.storeRoomData(_local_3);
                    this._widget.enterNewRoom(_local_3.flatId);
                }
            }
        }

        public function toggleRoomInfoWindow()
        {
            this._navigator.toggleRoomInfoVisibility();
        }

        public function goToPrivateRoom(k:Int)
        {
            this._navigator.goToPrivateRoom(k);
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_TOOLS;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._container.sessionDataManager.events.addEventListener(SessionDataPreferencesEvent.APUE_UPDATED, this._Str_10326);
return k;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetZoomToggleMessage.RWZTM_ZOOM_TOGGLE];
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
        }

        function _Str_10326(k:SessionDataPreferencesEvent)
        {
        }

        public function update()
        {
        }

        public function dispose()
        {
            var k:IMessageEvent = null;
            this._disposed = true;
            if (this._communicationManager != null)
            {
                final _iter_ = this._communicationManagerMessageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communicationManager.removeHabboConnectionMessageEvent(k);
                }
                this._communicationManagerMessageEvents = null;
                this._communicationManager = null;
            }
            if (((this._container != null) && (this._container.sessionDataManager != null)))
            {
                this._container.sessionDataManager.events.removeEventListener(SessionDataPreferencesEvent.APUE_UPDATED, this._Str_10326);
            }
            this._navigator = null;
            this._widget = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var navigator(get,set):IHabboNavigator;
public function  set_navigator(k:IHabboNavigator):IHabboNavigator        {
            return this._navigator = k;
        }
public function  get_navigator():IHabboNavigator
        {
            return this._navigator;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._container.sessionDataManager;
        }

        public var communicationManager(never,set):IHabboCommunicationManager;
public function  set_communicationManager(k:IHabboCommunicationManager):IHabboCommunicationManager        {
            this._communicationManager = k;
            this._communicationManagerMessageEvents.push(this._communicationManager.addHabboConnectionMessageEvent(new GetGuestRoomResultEvent(this.onRoomInfo)));
return k;
        }

        public function rateRoom()
        {
            this._container.connection.send(new RateFlatMessageComposer(1));
        }

        public var _Str_5090(get,never):Bool;
public function  get__Str_5090():Bool
        {
            return this._navigator.canRateRoom();
        }
    }

