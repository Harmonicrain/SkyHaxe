package com.sulake.habbo.session
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import com.sulake.habbo.configuration._enum.HabboComponentFlags;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.runtime.ComponentDependency;
	import com.sulake.habbo.ui.widget.infobuspolls.RoomPollHandler;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboFreeFlowChat;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomVisualizationSettingsEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.handler.RoomSessionHandler;
    import com.sulake.habbo.session.handler.RoomChatHandler;
    import com.sulake.habbo.session.handler.RoomUsersHandler;
    import com.sulake.habbo.session.handler.RoomPermissionsHandler;
    import com.sulake.habbo.session.handler.AvatarEffectsHandler;
    import com.sulake.habbo.session.handler.RoomDataHandler;
    import com.sulake.habbo.session.handler.PresentHandler;
    import com.sulake.habbo.session.handler.GenericErrorHandler;
    import com.sulake.habbo.session.handler.PollHandler;
    import com.sulake.habbo.session.handler.WordQuizHandler;
    import com.sulake.habbo.session.handler.RoomDimmerPresetsHandler;
    import com.sulake.habbo.session.handler.PetPackageHandler;
    import flash.display.DisplayObject;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.events.Event;
    import com.sulake.room.utils.Vector3d;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.outgoing.roomdirectory.RoomNetworkOpenConnectionMessageComposer;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.session.handler.BaseHandler;
    import com.sulake.iid.*;

     class RoomSessionManager extends Component implements IRoomSessionManager implements  IRoomHandlerListener 
    {
        public static inline final SETUP_WITHOUT_COMMUNICATION:UInt = 2;
        public static inline final SETUP_WITHOUT_TRACKING:UInt = 3;
        public static inline final SETUP_WITHOUT_ROOMENGINE:UInt = 4;

        var _communication:IHabboCommunicationManager = null;
        var _handlers:Array<ASAny> = null;
        var _roomEngineReady:Bool = false;
        var _sessions:Map = null;
        var _pendingSessionRequest:RoomSession;
        var _sessionStarting:Bool = false;
        var _habboTracking:IHabboTracking;
        var _roomEngine:IRoomEngine;
        var _freeFlowChat:IHabboFreeFlowChat;
        var _gotVisualisations:Bool = false;
        var _roomViewerMode:Bool = false;
        var _pendingResources:Array<ASAny>;
        var _viewerSession:RoomSession;

        public function new(k:IContext, _arg_2:UInt=0)
        {
            super(k, _arg_2);
            this._roomViewerMode = (!((ASCompat.toInt(_arg_2 )& HabboComponentFlags.ROOM_VIEWER_MODE) == 0));
            this._handlers = [];
            this._sessions = new Map();
        }

        public var initialized(get,never):Bool;
public function  get_initialized():Bool
        {
            return allRequiredDependenciesInjected && this._roomEngineReady;
        }

        public var sessionStarting(get,never):Bool;
public function  get_sessionStarting():Bool
        {
            return this._sessionStarting;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_COMMUNICATION)) == 0)), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _habboTracking = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_TRACKING)) == 0)), new ComponentDependency(new IIDHabboFreeFlowChat(), function (k:IHabboFreeFlowChat)
            {
                _freeFlowChat = k;
            }, false), new ComponentDependency(new IIDHabboConfigurationManager(), null), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
                if (((_roomEngine != null) && _roomEngine.isInitialized))
                {
                    onRoomEngineInitialized(null);
                }
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_ROOMENGINE)) == 0), [{
                "type":RoomEngineEvent.ENGINE_INITIALIZED,
                "callback":this.onRoomEngineInitialized
            }])]));
        }

        override function initComponent()
        {
            this.createHandlers();
            if ((this._roomViewerMode && (!(this._communication == null))))
            {
                this._communication.addHabboConnectionMessageEvent(new RoomVisualizationSettingsEvent(this.onRoomVisualizationSettings));
            }
            this.executePendingSessionRequest();
        }

        override public function dispose()
        {
            var k:String = null;
            var _local_2:RoomSession = null;
            var _local_3 = 0;
            var _local_4:IDisposable = null;
            if (disposed)
            {
                return;
            }
            if (this._sessions != null)
            {
                while (this._sessions.length > 0)
                {
                    k = ASCompat.asString(this._sessions.getKey(0) );
                    _local_2 = ASCompat.dynamicAs(this._sessions.remove(k) , RoomSession);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                }
                this._sessions.dispose();
                this._sessions = null;
            }
            if (this._handlers != null)
            {
                _local_3 = 0;
                while (_local_3 < this._handlers.length)
                {
                    _local_4 = ASCompat.dynamicAs(this._handlers[_local_3] , IDisposable);
                    if (_local_4 != null)
                    {
                        _local_4.dispose();
                    }
                    _local_3++;
                }
                this._handlers = null;
            }
            super.dispose();
        }

        function onRoomEngineInitialized(k:RoomEngineEvent)
        {
            if (this._roomEngineReady)
            {
                return;
            }
            this._roomEngineReady = true;
            this.executePendingSessionRequest();
        }

        function createHandlers()
        {
            var k:IConnection = null;
            if (this._communication != null)
            {
                k = this._communication.connection;
                this._handlers.push(new RoomSessionHandler(k, this));
                this._handlers.push(new RoomChatHandler(k, this));
                this._handlers.push(new RoomUsersHandler(k, this));
                this._handlers.push(new RoomPermissionsHandler(k, this));
                this._handlers.push(new AvatarEffectsHandler(k, this));
                this._handlers.push(new RoomDataHandler(k, this));
                this._handlers.push(new PresentHandler(k, this));
                this._handlers.push(new GenericErrorHandler(k, this));
                this._handlers.push(new PollHandler(k, this));
                this._handlers.push(new WordQuizHandler(k, this));
                this._handlers.push(new RoomDimmerPresetsHandler(k, this));
                this._handlers.push(new PetPackageHandler(k, this));
				this._handlers.push(new RoomPollHandler(k, this));
            }
        }

        function executePendingSessionRequest()
        {
            if ((this.initialized && (!(this._pendingSessionRequest == null))))
            {
                this.createSession(this._pendingSessionRequest);
                this._pendingSessionRequest = null;
            }
        }

        function onRoomVisualizationSettings(k:RoomVisualizationSettingsEvent)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:DisplayObject = null;
            var _local_9:IRoomGeometry = null;
            if ((this._gotVisualisations || (!this._roomViewerMode)))
            {
                return;
            }
            this._gotVisualisations = true;
            var _local_2= this.getSession(0);
            if (_local_2 != null)
            {
                _local_3 = 1;
                _local_4 = 2;
                _local_5 = 2;
                _local_6 = 0x0400;
                _local_7 = 0x0300;
                _local_8 = this._roomEngine.createRoomCanvas(_local_2.roomId, _local_3, _local_6, _local_7, 64);
                if (_local_8 != null)
                {
                    context.displayObjectContainer.addChild(_local_8);
                    context.displayObjectContainer.addEventListener(Event.RESIZE, (this.onResize : ASAny));
                    this._roomEngine.setRoomCanvasMask(_local_2.roomId, _local_3, true);
                    _local_9 = this._roomEngine.getRoomCanvasGeometry(_local_2.roomId, _local_3);
                    if (_local_9 != null)
                    {
                        _local_9.adjustLocation(new Vector3d(_local_4, _local_5, 0), 30);
                    }
                    this._roomEngine.setRoomCanvasScreenOffset(_local_2.roomId, _local_3, new Point(0, -400));
                }
                if (((!(this._freeFlowChat == null)) && (this._freeFlowChat.displayObject != null)))
                {
                    context.displayObjectContainer.addChild(this._freeFlowChat.displayObject);
                }
            }
        }

        function onResize(k:Event)
        {
            if (!this._roomViewerMode)
            {
                return;
            }
            var _local_2= this.getSession(0);
            if (_local_2 == null)
            {
                return;
            }
            this._roomEngine.modifyRoomCanvas(_local_2.roomId, 1, Std.int(context.displayObjectContainer.width), Std.int(context.displayObjectContainer.height));
        }

        public function gotoRoom(k:Int, _arg_2:String="", _arg_3:String=""):Bool
        {
            var _local_4= new RoomSession();
            _local_4.roomId = k;
            _local_4.roomPassword = _arg_2;
            _local_4.roomResources = _arg_3;
            _local_4.habboTracking = this._habboTracking;
            return this.createSession(_local_4);
        }

        public function gotoRoomNetwork(k:Int, _arg_2:Int):Bool
        {
            var _local_3= new RoomSession();
            _local_3.roomId = 1;
            _local_3.roomPassword = "";
            _local_3.habboTracking = this._habboTracking;
            _local_3.openConnectionComposer = new RoomNetworkOpenConnectionMessageComposer(k, _arg_2);
            return this.createSession(_local_3);
        }

        function createSession(k:RoomSession):Bool
        {
            if (!this.initialized)
            {
                this._pendingSessionRequest = k;
                return false;
            }
            var _local_2= this.getRoomIdentifier(k.roomId);
            this._sessionStarting = true;
            if (this._sessions.getValue(_local_2) != null)
            {
                this.disposeSession(k.roomId, false);
            }
            k.connection = ((this._communication != null) ? this._communication.connection : null);
            this._sessions.add(_local_2, k);
            events.dispatchEvent(new RoomSessionEvent(RoomSessionEvent.CREATED, k));
            if (this._roomViewerMode)
            {
                this._roomEngine.events.addEventListener("RCLE_SUCCESS", this.onRoomContentLoaded);
                this._pendingResources = new Array<ASAny>();
                this._viewerSession = k;
                if (this._pendingResources.length == 0)
                {
                    this.startSession(k);
                }
            }
            return true;
        }

        function onRoomContentLoaded(k:Event)
        {
            if (((this._pendingResources == null) || (this._pendingResources.length == 0)))
            {
                return;
            }
            var _local_2= this._pendingResources.indexOf((k : ASAny)["contentType"]);
            if (_local_2 != -1)
            {
                this._pendingResources.splice(_local_2, 1);
            }
            if (this._pendingResources.length == 0)
            {
                this.startSession(this._viewerSession);
            }
        }

        public function startSession(k:IRoomSession):Bool
        {
            if (k.state == RoomSessionEvent.STARTED)
            {
                return false;
            }
            if (k.isGameSession)
            {
                return true;
            }
            if (k.start())
            {
                this._sessionStarting = false;
                events.dispatchEvent(new RoomSessionEvent(RoomSessionEvent.STARTED, k));
                this.updateHandlers(k);
            }
            else
            {
                this.disposeSession(k.roomId);
                this._sessionStarting = false;
                return false;
            }
            return true;
        }

        public function startGameSession()
        {
            var k= new RoomSession();
            k.roomId = 1;
            k.habboTracking = this._habboTracking;
            k.isGameSession = true;
            k.connection = this._communication.connection;
            this._sessions.add(this.getRoomIdentifier(k.roomId), k);
            events.dispatchEvent(new RoomSessionEvent(RoomSessionEvent.CREATED, k));
        }

        public function disposeGameSession()
        {
            var k= this.getRoomIdentifier(1);
            var _local_2:RoomSession = this._sessions.getValue(k);
            if (((_local_2 != null) && _local_2.isGameSession))
            {
                this.disposeSession(1, false);
            }
        }

        public function sessionUpdate(k:Int, _arg_2:String)
        {
            var _local_3= this.getSession(k);
            if (_local_3 != null)
            {
                switch (_arg_2)
                {
                    case RoomSessionHandler.RS_CONNECTED:
                        return;
                    case RoomSessionHandler.RS_READY:
                        return;
                    case RoomSessionHandler.RS_DISCONNECTED:
                        this.disposeSession(k);
                        return;
                }
            }
        }

        public function sessionReinitialize(k:Int, _arg_2:Int)
        {
            var _local_5:RoomSession = null;
            var _local_3= this.getRoomIdentifier(k);
            var _local_4= ASCompat.dynamicAs(this._sessions.remove(_local_3) , RoomSession);
            if (_local_4 != null)
            {
                _local_4.reset(_arg_2);
                _local_3 = this.getRoomIdentifier(_arg_2);
                _local_5 = this._sessions.remove(_local_3);
                if (_local_5 != null)
                {
                }
                this._sessions.add(_local_3, _local_4);
                this.updateHandlers(_local_4);
            }
        }

        public function getSession(k:Int):IRoomSession
        {
            var _local_2= this.getRoomIdentifier(k);
            return ASCompat.dynamicAs(this._sessions.getValue(_local_2) , IRoomSession);
        }

        public function disposeSession(k:Int, _arg_2:Bool=true)
        {
            var _local_3= this.getRoomIdentifier(k);
            var _local_4= ASCompat.dynamicAs(this._sessions.remove(_local_3) , RoomSession);
            if (_local_4 != null)
            {
                events.dispatchEvent(new RoomSessionEvent(RoomSessionEvent.ENDED, _local_4, _arg_2));
                _local_4.dispose();
            }
        }

        function updateHandlers(k:IRoomSession)
        {
            var _local_2 = 0;
            var _local_3:BaseHandler = null;
            if (((!(k == null)) && (!(this._handlers == null))))
            {
                _local_2 = 0;
                while (_local_2 < this._handlers.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._handlers[_local_2] , BaseHandler);
                    if (_local_3 != null)
                    {
                        _local_3._xxxRoomId = k.roomId;
                    }
                    _local_2++;
                }
            }
        }

        function getRoomIdentifier(k:Int):String
        {
            return "hard_coded_room_id";
        }
    }

