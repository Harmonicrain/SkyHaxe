package com.sulake.habbo.room
;
    import com.sulake.core.runtime.Component;
    import com.sulake.room.IRoomManagerListener;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.room.renderer.IRoomRendererFactory;
    import com.sulake.room.IRoomManager;
    import com.sulake.room.IRoomObjectFactory;
	import com.sulake.habbo.room.object.RoomObjectLogicEnum;
    import com.sulake.room.object.IRoomObjectVisualizationFactory;
    import com.sulake.habbo.advertisement.IAdManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.room.utils.NumberBank;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.habbo.roomevents.IHabboUserDefinedRoomEvents;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDRoomObjectFactory;
    import com.sulake.iid.IIDRoomObjectVisualizationFactory;
    import com.sulake.iid.IIDRoomManager;
    import com.sulake.iid.IIDRoomRendererFactory;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDHabboAdManager;
    import com.sulake.habbo.advertisement.events.AdEvent;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDHabboGameManager;
    import com.sulake.iid.IIDHabboUserDefinedRoomEvents;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.utils.RoomInstanceData;
    import com.sulake.habbo.room.utils.FurniStackingHeightMap;
    import com.sulake.habbo.room.utils.LegacyWallGeometry;
    import com.sulake.habbo.room.utils.TileObjectMap;
    import com.sulake.habbo.room.utils.RoomCamera;
    import com.sulake.habbo.room.utils.SelectedRoomObjectData;
    import com.sulake.room.IRoomInstance;
    import com.sulake.room.utils.RoomEnterEffect;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.habbo.room.messages.RoomObjectRoomFloorHoleUpdateMessage;
    import com.sulake.habbo.room.events.RoomEngineAreaHideStateWidgetEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.utils.FurnitureData;
    import com.sulake.room.RoomInstance;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.renderer.IRoomRenderingCanvas;
    import flash.geom.Rectangle;
    import com.sulake.room.utils.Vector3d;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import com.sulake.room.utils.RoomGeometry;
    import com.sulake.room.utils.IVector3d;
    import flash.events.Event;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.room.utils.RoomData;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.room.messages.RoomObjectRoomUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectRoomMaskUpdateMessage;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.messages.RoomObjectRoomColorUpdateMessage;
    import com.sulake.habbo.room.events.RoomBackgroundColorEvent;
    import com.sulake.habbo.room.events.RoomObjectHSLColorEnabledEvent;
    import com.sulake.habbo.room.messages.RoomObjectRoomPlaneVisibilityUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectRoomPlanePropertyUpdateMessage;
    import flash.display.Sprite;
    import com.sulake.room.renderer.IRoomRenderer;
    import flash.display.DisplayObject;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import com.sulake.habbo.room.events.RoomEngineDragWidgetMouseEvent;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import flash.display.Bitmap;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.habbo.room.object.RoomObjectUserTypes;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectTileCursorUpdateMessage;
    import com.sulake.habbo.room.object.data.StuffDataFactory;
    import com.sulake.habbo.room.messages.RoomObjectModelDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectHeightUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.utils._Str_6093;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.habbo.room.messages.RoomObjectItemDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarFigureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarDirectionUpdateMessage;
    import com.sulake.habbo.room.events.RoomToObjectOwnAvatarMoveEvent;
    import com.sulake.habbo.room.messages.RoomObjectAvatarFlatControlUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectUpdateStateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarOwnMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarChatUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSleepUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarTypingUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarMutedUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarCarryObjectUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarUseObjectUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarDanceUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarExperienceUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPlayerValueUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSignUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarExpressionUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPlayingGameMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarGuideStatusUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarHabbiconUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPostureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarGestureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPetGestureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarEffectUpdateMessage;
    import flash.utils.ByteArray;
    import flash.net.FileReference;
    import com.sulake.core.utils.PlayerVersionCheck;
    import com.sulake.habbo.utils.images.PNGEncoder;
    import com.sulake.habbo.avatar.pets.PetCustomPart;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.room.object.visualization.IRoomObjectSpriteVisualization;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import com.sulake.habbo.room.messages.RoomObjectRoomAdUpdateMessage;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import com.sulake.habbo.session.events.FurniIconImageReadyEvent;
    import com.sulake.habbo.room.utils.RoomObjectBadgeImageAssetListener;
    import com.sulake.habbo.room.utils.RoomObjectFurniIconAssetListener;
    import com.sulake.habbo.room.utils.RoomAreaSelectionManager;
    import com.sulake.habbo.room.messages.RoomObjectGroupBadgeUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectFurniIconUpdateMessage;
    import com.sulake.habbo.room.events.RoomEngineUseProductEvent;
    import com.sulake.habbo.room.utils.SpriteDataCollector;
    import com.sulake.habbo.communication.messages.outgoing.camera.RenderRoomThumbnailMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.camera.RenderRoomMessageComposer;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.iid.*;
    import com.sulake.room.object.*;

     class RoomEngine extends Component implements IRoomEngine implements  IRoomManagerListener implements  IRoomCreator implements  IRoomEngineServices implements  IUpdateReceiver implements  IRoomContentListener 
    {
        public static inline final _lastUpdateTime:UInt = 1;
        public static inline final SETUP_WITHOUT_TOOLBAR:UInt = 2;
        public static inline final SETUP_WITHOUT_CATALOG:UInt = 4;
        public static inline final SETUP_WITHOUT_COMMUNICATION:UInt = 5;
        static inline final TEMPORARY_ROOM= "temporary_room";
        public static inline final OBJECT_ID_ROOM= -1;
        static inline final ROOM= "room";
        static inline final OBJECT_ID_ROOM_HIGHLIGHTER= -2;
        static inline final TILE_CURSOR= "tile_cursor";
        static inline final OBJECT_ID_SELECTION_ARROW= -3;
        static inline final SELECTION_ARROW= "selection_arrow";
        static inline final OVERLAY= "overlay";
        static inline final OBJECT_ICON_SPRITE= "object_icon_sprite";
        static inline final FURNI_ICON_PLACEHOLDER= "loading_icon";
        static inline final ROOM_DRAG_THRESHOLD= 15;
        static inline final FURNITURE_CREATION_TIME_LIMIT_MILLISECONDS= 40;

        var _communicationManager:IHabboCommunicationManager = null;
        var _roomRendererFactory:IRoomRendererFactory = null;
        var _roomManager:IRoomManager = null;
        var _roomObjectFactory:IRoomObjectFactory = null;
        var _visualizationFactory:IRoomObjectVisualizationFactory = null;
        var _adManager:IAdManager = null;
        var _sessionDataManager:ISessionDataManager = null;
        var _roomSessionManager:IRoomSessionManager = null;
        var _toolbar:IHabboToolbar = null;
        var _catalog:IHabboCatalog = null;
        var _windowManager:IHabboWindowManager;
        var _roomObjectEventHandler:RoomObjectEventHandler = null;
        var _roomMessageHandler:RoomMessageHandler = null;
        var _roomContentLoader:RoomContentLoader = null;
        var _contentLoaderReady:Bool = false;
        var _imageObjectIdBank:NumberBank;
        var _imageCallbacks:Map;
        var _Str_7020:NumberBank;
        var _thumbnailCallbacks:Map;
        var _roomManagerInitialized:Bool = false;
        var _activeRoomId:Int = 0;
        var _activeRoomActiveCanvas:Int = -1;
        var _activeRoomActiveCanvasMouseX:Int = 0;
        var _activeRoomActiveCanvasMouseY:Int = 0;
        var _activeRoomIsDragged:Bool = false;
        var _activeRoomWasDragged:Bool = false;
        var _activeRoomDragStartX:Int = 0;
        var _activeRoomDragStartY:Int = 0;
        var _activeRoomDragX:Int = 0;
        var _activeRoomDragY:Int = 0;
        var _cameraCentered:Bool = false;
        var _roomDatas:Map = null;
        var _roomInstanceDatas:Map = null;
        var _pendingPublicRoomInit:ASObject = {};
        var _skipFurnitureCreationForNextFrame:Bool = false;
        var _mouseCursorUpdate:Bool = false;
        var _badgeListenerObjects:Map = null;
        var _furniIconListenerObjects:Map = null;
        var _furniIconListenerAttached:Bool = false;
        var _gameManager:IHabboGameManager;
        var _roomEvents:IHabboUserDefinedRoomEvents;
        var _isSelectedObjectInValidPosition:Bool = false;
        var _playerUnderCursor:Int = -1;
        var _mouseEventsDisabledAboveY:Int = 0;
        var _mouseEventsDisabledLeftToX:Int = 0;
        var _mouseEventsDisabledAboveYWas:Int = 0;
        var _mouseEventsDisabledLeftToXWas:Int = 0;
        var _areaSelectionManager:RoomAreaSelectionManager;
        var _moveBlocked:Bool = false;
        var _clickThroughUserOwners:Array<ASAny> = [];
        var _clickThroughFurniOwners:Array<ASAny> = [];

        public function new(k:IContext, _arg_2:UInt=0)
        {
            super(k, _arg_2);
        }

        static function furniIconListenerKey(wallItem:Bool, typeId:Int, extra:String):String
        {
            return (wallItem ? "1" : "0") + "-" + Std.string(typeId) + "-" + (extra == null ? "" : extra);
        }

        
        public var mouseEventsDisabledAboveY(get,set):Int;
public function  get_mouseEventsDisabledAboveY():Int
        {
            return this._mouseEventsDisabledAboveY;
        }
public function  set_mouseEventsDisabledAboveY(k:Int):Int        {
            return this._mouseEventsDisabledAboveY = k;
        }

        
        public var mouseEventsDisabledLeftToX(get,set):Int;
public function  get_mouseEventsDisabledLeftToX():Int
        {
            return this._mouseEventsDisabledLeftToX;
        }
public function  set_mouseEventsDisabledLeftToX(k:Int):Int        {
            return this._mouseEventsDisabledLeftToX = k;
        }

        public var areaSelectionManager(get,never):IRoomAreaSelectionManager;
public function  get_areaSelectionManager():IRoomAreaSelectionManager
        {
            return this._areaSelectionManager;
        }

        public function isAreaSelectionMode():Bool
        {
            return (this._areaSelectionManager != null) && (this._areaSelectionManager.areaSelectionState != RoomAreaSelectionManager.NOT_ACTIVE);
        }

        public function setMoveBlocked(k:Bool)
        {
            this._moveBlocked = k;
        }

        public function isMoveBlocked():Bool
        {
            return this._moveBlocked;
        }

        public function isWhereYouClickWhereYouGo():Bool
        {
            return !this.isAreaSelectionMode();
        }

        public var isInitialized(get,never):Bool;
public function  get_isInitialized():Bool
        {
            return this._roomManagerInitialized;
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._communicationManager.connection;
        }

        public var activeRoomId(get,never):Int;
public function  get_activeRoomId():Int
        {
            return this._activeRoomId;
        }

        public var roomManager(get,never):IRoomManager;
public function  get_roomManager():IRoomManager
        {
            return this._roomManager;
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return this;
        }

        var eventHandler(get,never):RoomObjectEventHandler;
function  get_eventHandler():RoomObjectEventHandler
        {
            return this._roomObjectEventHandler;
        }

        var useOffsetScrolling(get,never):Bool;
function  get_useOffsetScrolling():Bool
        {
            return true;
        }

        public var gameEngine(get,never):IHabboGameManager;
public function  get_gameEngine():IHabboGameManager
        {
            return this._gameManager;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDRoomObjectFactory(), function (k:IRoomObjectFactory)
            {
                _roomObjectFactory = k;
            }), new ComponentDependency(new IIDRoomObjectVisualizationFactory(), function (k:IRoomObjectVisualizationFactory)
            {
                _visualizationFactory = k;
            }), new ComponentDependency(new IIDRoomManager(), function (k:IRoomManager)
            {
                _roomManager = k;
            }), new ComponentDependency(new IIDRoomRendererFactory(), function (k:IRoomRendererFactory)
            {
                _roomRendererFactory = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_COMMUNICATION)) == 0)), new ComponentDependency(new IIDHabboConfigurationManager(), null), new ComponentDependency(new IIDHabboAdManager(), function (k:IAdManager)
            {
                _adManager = k;
            }, false, [{
                "type":AdEvent.ROOM_AD_SHOW,
                "callback":this.showRoomAd
            }, {
                "type":AdEvent.ROOM_AD_IMAGE_LOADED,
                "callback":this.onRoomAdImageLoaded
            }, {
                "type":AdEvent.ROOM_AD_IMAGE_LOADING_FAILED,
                "callback":this.onRoomAdImageLoaded
            }]), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, false, [{
                "type":RoomSessionEvent.STARTED,
                "callback":this.onRoomSessionEvent
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.onRoomSessionEvent
            }]), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onToolbarClicked
            }]), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }, false), new ComponentDependency(new IIDHabboUserDefinedRoomEvents(), function (k:IHabboUserDefinedRoomEvents)
            {
                _roomEvents = k;
            }, false), new ComponentDependency(new IIDHabboGameManager(), function (k:IHabboGameManager)
            {
                _gameManager = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_CATALOG)) == 0)), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            })]));
        }

        override function initComponent()
        {
            this._roomInstanceDatas = new Map();
            this._imageObjectIdBank = new NumberBank(1000);
            this._Str_7020 = new NumberBank(1000);
            this._imageCallbacks = new Map();
            this._thumbnailCallbacks = new Map();
            this._roomDatas = new Map();
            this._roomObjectEventHandler = this.createRoomObjectEventHandlerInstance();
            this._roomMessageHandler = new RoomMessageHandler(this);
            this._areaSelectionManager = new RoomAreaSelectionManager(this);
            var k= context.displayObjectContainer;
            var _local_2= k.loaderInfo;
            this._roomContentLoader = new RoomContentLoader(_local_2.loaderURL);
            registerUpdateReceiver(this, 1);
            this._roomObjectFactory.addObjectEventListener(this.roomObjectEventHandler);
            this._roomContentLoader.visualizationFactory = this._visualizationFactory;
            this._roomContentLoader.roomManager = this._roomManager;
            this._roomManager.addObjectUpdateCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            this._roomManager.addObjectUpdateCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            this._roomManager.addObjectUpdateCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            this._roomManager.addObjectUpdateCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR);
            this._roomManager.addObjectUpdateCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM);
            this._roomManager.setContentLoader(this._roomContentLoader);
            if (this._communicationManager != null)
            {
                this._roomMessageHandler.connection = this._communicationManager.connection;
            }
            this._roomContentLoader.initialize(events, this);
            this._roomContentLoader.iconAssets = assets;
            this._roomContentLoader.iconListener = this;
            this._cameraCentered = getBoolean("room.dragging.always_center");
            this._roomContentLoader.sessionDataManager = this._sessionDataManager;
            events.addEventListener(RoomContentLoader.RCL_LOADER_READY, this.onConfigurationComplete);
        }

        function createRoomObjectEventHandlerInstance():RoomObjectEventHandler
        {
            return new RoomObjectEventHandler(this);
        }

        override public function dispose()
        {
            var k = 0;
            var _local_2:RoomInstanceData = null;
            if (disposed)
            {
                return;
            }
            removeUpdateReceiver(this);
            if (this._imageObjectIdBank != null)
            {
                this._imageObjectIdBank.dispose();
                this._imageObjectIdBank = null;
            }
            if (this._Str_7020 != null)
            {
                this._Str_7020.dispose();
                this._Str_7020 = null;
            }
            if (this._imageCallbacks != null)
            {
                this._imageCallbacks.dispose();
            }
            if (this._thumbnailCallbacks != null)
            {
                this._thumbnailCallbacks.dispose();
            }
            if (this._roomObjectEventHandler != null)
            {
                this._roomObjectEventHandler.dispose();
                this._roomObjectEventHandler = null;
            }
            if (this._roomMessageHandler != null)
            {
                this._roomMessageHandler.dispose();
                this._roomMessageHandler = null;
            }
            if (this._areaSelectionManager != null)
            {
                this._areaSelectionManager.dispose();
                this._areaSelectionManager = null;
            }
            if (this._roomContentLoader != null)
            {
                this._roomContentLoader.dispose();
                this._roomContentLoader = null;
            }
            if (this._roomDatas != null)
            {
                this._roomDatas.dispose();
                this._roomDatas = null;
            }
            if (this._roomInstanceDatas != null)
            {
                k = 0;
                while ((k : UInt) < this._roomInstanceDatas.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._roomInstanceDatas.getWithIndex(k) , RoomInstanceData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._roomInstanceDatas.dispose();
                this._roomInstanceDatas = null;
            }
            if (this._badgeListenerObjects != null)
            {
                this._badgeListenerObjects.dispose();
                this._badgeListenerObjects = null;
            }
            this.detachFurniIconListener();
            if (this._furniIconListenerObjects != null)
            {
                this._furniIconListenerObjects.dispose();
                this._furniIconListenerObjects = null;
            }
            super.dispose();
        }

        public var disableUpdate(never,set):Bool;
public function  set_disableUpdate(k:Bool):Bool        {
            if (k)
            {
                removeUpdateReceiver(this);
            }
            else
            {
                removeUpdateReceiver(this);
                registerUpdateReceiver(this, 1);
            }
return k;
        }

        public function runUpdate()
        {
            this.update(1);
        }

        function getRoomInstanceData(k:Int):RoomInstanceData
        {
            var _local_2= this.getRoomIdentifier(k);
            var _local_3:RoomInstanceData = null;
            if (this._roomInstanceDatas != null)
            {
                _local_3 = ASCompat.dynamicAs(this._roomInstanceDatas.getValue(_local_2) , RoomInstanceData);
                if (_local_3 == null)
                {
                    _local_3 = new RoomInstanceData(k);
                    this._roomInstanceDatas.add(_local_2, _local_3);
                }
            }
            return _local_3;
        }

        public function setFurniStackingHeightMap(k:Int, _arg_2:FurniStackingHeightMap)
        {
            var _local_3= this.getRoomInstanceData(k);
            if (_local_3 != null)
            {
                _local_3._Str_18267 = _arg_2;
            }
        }

        public function getFurniStackingHeightMap(k:Int):FurniStackingHeightMap
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2._Str_18267;
            }
            return null;
        }

        public function loadRoomResources(k:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:String = null;
            var _local_4:Array<ASAny> = [];
            var _local_5 = 0;
            var _local_7:String = null;
            if (((this._roomContentLoader == null) || (this._roomManager == null) || (k == null) || (k.length == 0)))
            {
                return _local_4;
            }
            _local_2 = (cast k.split(","));
            while (_local_5 < _local_2.length)
            {
                _local_3 = StringUtil.trim(_local_2[_local_5]);
                if (_local_3.length > 0)
                {
                    _local_4.push(_local_3);
                }
                _local_5++;
            }
            if (_local_4.length > 0)
            {
                _local_7 = _local_4[0];
                _local_5 = 1;
                while (_local_5 < _local_4.length)
                {
                    _local_7 = ((_local_7 + ",") + _local_4[_local_5]);
                    _local_5++;
                }
                if (this._roomContentLoader.loadObjectContent(_local_7, events))
                {
                    return [_local_4[0]];
                }
            }
            return [];
        }

        public function setWorldType(k:Int, _arg_2:String, _arg_3:Bool=false)
        {
            var _local_3= this.getRoomInstanceData(k);
            if (_local_3 != null)
            {
                _local_3._Str_17166 = _arg_2;
                _local_3.isPublic = _arg_3;
            }
        }

        public function getWorldType(k:Int):String
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2._Str_17166;
            }
            return null;
        }

        public function getPublicRoomContentType(k:String):String
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getPublicRoomContentType(k);
            }
            return k;
        }

        public function isPublicRoom(k:Int):Bool
        {
            var _local_2= this.getRoomInstanceData(k);
            return ((_local_2 != null) && _local_2.isPublic);
        }

        public function getLegacyGeometry(k:Int):LegacyWallGeometry
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2.legacyGeometry;
            }
            return null;
        }

        public function getTileObjectMap(k:Int):TileObjectMap
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2.tileObjectMap;
            }
            return null;
        }

        function getActiveRoomCamera():RoomCamera
        {
            return this.getRoomCamera(this._activeRoomId);
        }

        function getRoomCamera(k:Int):RoomCamera
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2.roomCamera;
            }
            return null;
        }

        public function setSelectedObjectData(k:Int, _arg_2:SelectedRoomObjectData)
        {
            var _local_3= this.getRoomInstanceData(k);
            if (_local_3 != null)
            {
                _local_3._Str_16852 = _arg_2;
                if (_arg_2 != null)
                {
                    _local_3._Str_15689 = null;
                }
            }
        }

        public function getSelectedObjectData(k:Int):ISelectedRoomObjectData
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2._Str_16852;
            }
            return null;
        }

        public function setPlacedObjectData(k:Int, _arg_2:SelectedRoomObjectData)
        {
            var _local_3= this.getRoomInstanceData(k);
            if (_local_3 != null)
            {
                _local_3._Str_15689 = _arg_2;
            }
        }

        public function getPlacedObjectData(k:Int):ISelectedRoomObjectData
        {
            var _local_2= this.getRoomInstanceData(k);
            if (_local_2 != null)
            {
                return _local_2._Str_15689;
            }
            return null;
        }

        public function addObjectUpdateCategory(k:Int)
        {
            this._roomManager.addObjectUpdateCategory(k);
        }

        public function removeObjectUpdateCategory(k:Int)
        {
            this._roomManager.removeObjectUpdateCategory(k);
        }

        public function update(k:UInt)
        {
            var _local_2 = 0;
            var _local_3:IRoomInstance = null;
            RoomEnterEffect.turnVisualizationOn();
            if (this._roomManager != null)
            {
                this.createRoomFurniture();
                this._roomManager.update(k);
                _local_2 = 0;
                while (_local_2 < this._roomManager.getRoomCount())
                {
                    _local_3 = this._roomManager.getRoomWithIndex(_local_2);
                    if (((!(_local_3 == null)) && (!(_local_3.getRenderer() == null))))
                    {
                        _local_3.getRenderer().update(k);
                    }
                    _local_2++;
                }
                this.updateRoomCameras(k);
                if (this._mouseCursorUpdate)
                {
                    this.updateMouseCursor();
                }
            }
            RoomEnterEffect.turnVisualizationOff();
        }

        function updateMouseCursor()
        {
            this._mouseCursorUpdate = false;
            var k= this.getRoomInstanceData(this._activeRoomId);
            if (((k != null) && k.hasButtonMouseCursorOwners()))
            {
                Mouse.cursor = MouseCursor.BUTTON;
            }
            else
            {
                Mouse.cursor = MouseCursor.AUTO;
            }
        }

        public function requestMouseCursor(k:String, _arg_2:Int, _arg_3:String)
        {
            var _local_4= this.getRoomObjectCategory(_arg_3);
            switch (k)
            {
                case RoomObjectFurnitureActionEvent.MOUSE_BUTTON:
                    if ((this.setIsSelectedObjectInValidPosition && (_local_4 == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)))
                    {
                        this._playerUnderCursor = _arg_2;
                    }
                    this.addButtonMouseCursorOwner(this._activeRoomId, _local_4, _arg_2);
                    return;
                default:
                    if ((this.setIsSelectedObjectInValidPosition && (_local_4 == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)))
                    {
                        this._playerUnderCursor = -1;
                    }
                    this.removeButtonMouseCursorOwner(this._activeRoomId, _local_4, _arg_2);
            }
        }

        function addButtonMouseCursorOwner(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_5:String = null;
            var _local_6:RoomInstanceData = null;
            var _local_4= this._roomSessionManager.getSession(k);
            if ((((!(_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)) && (!(_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM))) || ((!(_local_4 == null)) && (_local_4.roomControllerLevel >= RoomControllerLevel.GUEST))))
            {
                _local_5 = ((Std.string(_arg_2) + "_") + Std.string(_arg_3));
                _local_6 = this.getRoomInstanceData(k);
                if (_local_6 != null)
                {
                    if (_local_6.addButtonMouseCursorOwner(_local_5))
                    {
                        this._mouseCursorUpdate = true;
                    }
                }
            }
        }

        function removeButtonMouseCursorOwner(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_5:String = null;
            var _local_4= this.getRoomInstanceData(k);
            if (_local_4 != null)
            {
                _local_5 = ((Std.string(_arg_2) + "_") + Std.string(_arg_3));
                if (_local_4.removeButtonMouseCursorOwner(_local_5))
                {
                    this._mouseCursorUpdate = true;
                }
            }
        }

        public function addFloorHole(k:Int, _arg_2:Int)
        {
            var _local_3:IRoomObjectController = null;
            var _local_4:IRoomObjectController = null;
            var _local_5:String = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            if (_arg_2 >= 0)
            {
                _local_3 = this.getObjectRoom(k);
                _local_4 = this.getObjectFurniture(k, _arg_2);
                if (((((!(_local_4 == null)) && (!(_local_4.getModel() == null))) && (!(_local_3 == null))) && (!(_local_3.getEventHandler() == null))))
                {
                    _local_5 = RoomObjectRoomFloorHoleUpdateMessage.RORPFHUM_ADD;
                    _local_6 = Std.int(_local_4.getLocation().x);
                    _local_7 = Std.int(_local_4.getLocation().y);
                    _local_8 = Std.int(_local_4.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_X));
                    _local_9 = Std.int(_local_4.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Y));
                    _local_3.getEventHandler().processUpdateMessage(new RoomObjectRoomFloorHoleUpdateMessage(_local_5, _arg_2, _local_6, _local_7, _local_8, _local_9));
                }
            }
        }

        public function removeFloorHole(k:Int, _arg_2:Int)
        {
            var _local_3:IRoomObjectController = null;
            var _local_4:String = null;
            if (_arg_2 >= 0)
            {
                _local_3 = this.getObjectRoom(k);
                if (((!(_local_3 == null)) && (!(_local_3.getEventHandler() == null))))
                {
                    _local_4 = RoomObjectRoomFloorHoleUpdateMessage.RORPFHUM_REMOVE;
                    _local_3.getEventHandler().processUpdateMessage(new RoomObjectRoomFloorHoleUpdateMessage(_local_4, _arg_2));
                }
            }
        }

        function createRoomFurniture()
        {
            var _local_3 = 0;
            var _local_4:RoomInstanceData = null;
            var _local_5 = 0;
            var _local_6:FurnitureData = null;
            var _local_7 = false;
            var _local_8:String = null;
            var _local_9:RoomInstance = null;
            if (this._skipFurnitureCreationForNextFrame)
            {
                this._skipFurnitureCreationForNextFrame = false;
                return;
            }
            var k= flash.Lib.getTimer();
            var _local_2= 5;
            final _iter_ = this._roomInstanceDatas; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_4  = _tmp_;
                _local_5 = 0;
                _local_6 = null;
                _local_7 = false;
                while ((_local_6 = _local_4.getFurnitureData()) != null)
                {
                    _local_7 = this.addObjectFurnitureFromData(_local_4.roomId, _local_6.id, _local_6);
                    if ((++_local_5 % _local_2) == 0)
                    {
                        _local_3 = flash.Lib.getTimer();
                        if ((((_local_3 - k) >= FURNITURE_CREATION_TIME_LIMIT_MILLISECONDS) && (!this._isSelectedObjectInValidPosition)))
                        {
                            this._skipFurnitureCreationForNextFrame = true;
                            break;
                        }
                    }
                }
                while (((!this._skipFurnitureCreationForNextFrame) && (!((_local_6 = _local_4.getWallItemData()) == null))))
                {
                    _local_7 = this.addObjectWallItemFromData(_local_4.roomId, _local_6.id, _local_6);
                    if ((++_local_5 % _local_2) == 0)
                    {
                        _local_3 = flash.Lib.getTimer();
                        if ((((_local_3 - k) >= FURNITURE_CREATION_TIME_LIMIT_MILLISECONDS) && (!this._isSelectedObjectInValidPosition)))
                        {
                            this._skipFurnitureCreationForNextFrame = true;
                            break;
                        }
                    }
                }
                if ((_local_7 && this._isSelectedObjectInValidPosition))
                {
                    _local_8 = this.getRoomIdentifier(_local_4.roomId);
                    _local_9 = Std.downcast(this._roomManager.getRoom(_local_8) , RoomInstance);
                    if (!_local_9.hasUninitializedObjects())
                    {
                        this.objectsInitialized(_local_8);
                    }
                }
                if (this._skipFurnitureCreationForNextFrame)
                {
                    return;
                }
            }
        }

        function updateRoomCameras(k:UInt)
        {
            var _local_5:RoomInstanceData = null;
            var _local_6:RoomCamera = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10:IRoomObject = null;
            var _local_2= 1;
            var _local_3 = 0;
            while ((_local_3 : UInt) < this._roomInstanceDatas.length)
            {
                _local_5 = ASCompat.dynamicAs(this._roomInstanceDatas.getWithIndex(_local_3) , RoomInstanceData);
                _local_6 = null;
                _local_7 = 0;
                if (_local_5 != null)
                {
                    _local_6 = _local_5.roomCamera;
                    _local_7 = _local_5.roomId;
                }
                if (_local_6 != null)
                {
                    _local_8 = _local_6._Str_10760;
                    _local_9 = _local_6._Str_16562;
                    _local_10 = this.getRoomObject(_local_7, _local_8, _local_9);
                    if (_local_10 != null)
                    {
                        if (((!(_local_7 == this._activeRoomId)) || (!this._activeRoomIsDragged)))
                        {
                            this.updateRoomCamera(_local_7, _local_2, _local_10.getLocation(), k);
                        }
                    }
                }
                _local_3++;
            }
            var _local_4= this.getRoomCanvas(this._activeRoomId, _local_2);
            if (_local_4 != null)
            {
                if (this._activeRoomIsDragged)
                {
                    _local_4.screenOffsetX = (_local_4.screenOffsetX + this._activeRoomDragX);
                    _local_4.screenOffsetY = (_local_4.screenOffsetY + this._activeRoomDragY);
                    this._activeRoomDragX = 0;
                    this._activeRoomDragY = 0;
                }
            }
        }

        public function updateRoomCamera(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:UInt)
        {
            var _local_10 = Math.NaN;
            var _local_11:Rectangle = null;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14:Rectangle = null;
            var _local_15:Vector3d = null;
            var _local_16 = Math.NaN;
            var _local_17 = Math.NaN;
            var _local_18 = Math.NaN;
            var _local_19 = Math.NaN;
            var _local_20 = Math.NaN;
            var _local_21 = Math.NaN;
            var _local_22 = Math.NaN;
            var _local_23:Point = null;
            var _local_24 = Math.NaN;
            var _local_25 = Math.NaN;
            var _local_26:Matrix = null;
            var _local_27 = Math.NaN;
            var _local_28 = Math.NaN;
            var _local_29 = Math.NaN;
            var _local_30 = Math.NaN;
            var _local_31 = Math.NaN;
            var _local_32 = Math.NaN;
            var _local_33:Point = null;
            var _local_34 = false;
            var _local_35 = false;
            var _local_36 = false;
            var _local_37 = false;
            var _local_38 = Math.NaN;
            var _local_39 = Math.NaN;
            var _local_40 = Math.NaN;
            var _local_41 = Math.NaN;
            var _local_42 = Math.NaN;
            var _local_43 = 0;
            var _local_44 = 0;
            var _local_45:Point = null;
            var _local_46:Vector3d = null;
            var _local_5= this.getRoomCanvas(k, _arg_2);
            var _local_6= this.getRoomInstanceData(k);
            if ((((_local_5 == null) || (_local_6 == null)) || (!(_local_5.scale == 1))))
            {
                return;
            }
            var _local_7= Std.downcast(_local_5.geometry , RoomGeometry);
            var _local_8= _local_6.roomCamera;
            var _local_9= this.getRoom(k);
            if ((((!(_local_7 == null)) && (!(_local_8 == null))) && (!(_local_9 == null))))
            {
                _local_10 = (Math.ffloor(_arg_3.z) + 1);
                _local_11 = this.getRoomCanvasRectangle(k, _arg_2);
                if (_local_11 != null)
                {
                    _local_12 = Std.int(Math.fround(_local_11.width));
                    _local_13 = Std.int(Math.fround(_local_11.height));
                    _local_14 = this.getActiveRoomBoundingRectangle(_arg_2);
                    if (((!(_local_14 == null)) && ((((_local_14.right < 0) || (_local_14.bottom < 0)) || (_local_14.left >= _local_12)) || (_local_14.top >= _local_13))))
                    {
                        _local_8.reset();
                    }
                    if (((((((!(_local_8._Str_7609 == _local_12)) || (!(_local_8._Str_7902 == _local_13))) || (!(_local_8.scale == _local_7.scale))) || (!(_local_8._Str_16377 == _local_7.updateId))) || (!Vector3d.isEqual(_arg_3, _local_8._Str_16185))) || _local_8.isMoving))
                    {
                        _local_8._Str_16185 = _arg_3;
                        _local_15 = new Vector3d();
                        _local_15.assign(_arg_3);
                        _local_15.x = Math.fround(_local_15.x);
                        _local_15.y = Math.fround(_local_15.y);
                        _local_16 = (_local_9.getNumber(RoomVariableEnum.ROOM_MIN_X) - 0.5);
                        _local_17 = (_local_9.getNumber(RoomVariableEnum.ROOM_MIN_Y) - 0.5);
                        _local_18 = (_local_9.getNumber(RoomVariableEnum.ROOM_MAX_X) + 0.5);
                        _local_19 = (_local_9.getNumber(RoomVariableEnum.ROOM_MAX_Y) + 0.5);
                        _local_20 = Math.fround(((_local_16 + _local_18) / 2));
                        _local_21 = Math.fround(((_local_17 + _local_19) / 2));
                        _local_22 = 2;
                        _local_23 = new Point((_local_15.x - _local_20), (_local_15.y - _local_21));
                        _local_24 = (_local_7.scale / Math.sqrt(2));
                        _local_25 = (_local_24 / 2);
                        _local_26 = new Matrix();
                        _local_26.rotate(((-(_local_7.direction.x + 90) / 180) * Math.PI));
                        _local_23 = _local_26.transformPoint(_local_23);
                        _local_23.y = (_local_23.y * (_local_25 / _local_24));
                        _local_27 = (((_local_11.width / 2) / _local_24) - 1);
                        _local_28 = (((_local_11.height / 2) / _local_25) - 1);
                        _local_29 = 0;
                        _local_30 = 0;
                        _local_31 = 0;
                        _local_32 = 0;
                        _local_33 = _local_7.getScreenPoint(new Vector3d(_local_20, _local_21, _local_22));
                        if (_local_33 == null)
                        {
                            return;
                        }
                        _local_33.x = (_local_33.x + Math.fround((_local_11.width / 2)));
                        _local_33.y = (_local_33.y + Math.fround((_local_11.height / 2)));
                        if (_local_14 != null)
                        {
                            _local_14.offset(-_local_5.screenOffsetX, -_local_5.screenOffsetY);
                            if (((_local_14.width > 1) && (_local_14.height > 1)))
                            {
                                _local_29 = (((_local_14.left - _local_33.x) - (_local_7.scale * 0.25)) / _local_24);
                                _local_31 = (((_local_14.right - _local_33.x) + (_local_7.scale * 0.25)) / _local_24);
                                _local_30 = (((_local_14.top - _local_33.y) - (_local_7.scale * 0.5)) / _local_25);
                                _local_32 = (((_local_14.bottom - _local_33.y) + (_local_7.scale * 0.5)) / _local_25);
                            }
                            else
                            {
                                _local_7.adjustLocation(new Vector3d(-30, -30), 25);
                                return;
                            }
                        }
                        else
                        {
                            _local_7.adjustLocation(new Vector3d(0, 0), 25);
                            return;
                        }
                        _local_34 = false;
                        _local_35 = false;
                        _local_36 = false;
                        _local_37 = false;
                        _local_38 = Math.fround(((_local_31 - _local_29) * _local_24));
                        if (_local_38 < _local_11.width)
                        {
                            _local_10 = 2;
                            _local_23.x = ((_local_31 + _local_29) / 2);
                            _local_36 = true;
                        }
                        else
                        {
                            if (_local_23.x > (_local_31 - _local_27))
                            {
                                _local_23.x = (_local_31 - _local_27);
                                _local_34 = true;
                            }
                            if (_local_23.x < (_local_29 + _local_27))
                            {
                                _local_23.x = (_local_29 + _local_27);
                                _local_34 = true;
                            }
                        }
                        _local_39 = Math.fround(((_local_32 - _local_30) * _local_25));
                        if (_local_39 < _local_11.height)
                        {
                            _local_10 = 2;
                            _local_23.y = ((_local_32 + _local_30) / 2);
                            _local_37 = true;
                        }
                        else
                        {
                            if (_local_23.y > (_local_32 - _local_28))
                            {
                                _local_23.y = (_local_32 - _local_28);
                                _local_35 = true;
                            }
                            if (_local_23.y < (_local_30 + _local_28))
                            {
                                _local_23.y = (_local_30 + _local_28);
                                _local_35 = true;
                            }
                            if (_local_35)
                            {
                                _local_23.y = (_local_23.y / (_local_25 / _local_24));
                            }
                        }
                        _local_26.invert();
                        _local_23 = _local_26.transformPoint(_local_23);
                        _local_23.x = (_local_23.x + _local_20);
                        _local_23.y = (_local_23.y + _local_21);
                        _local_40 = 0.35;
                        _local_41 = 0.2;
                        _local_42 = 0.2;
                        _local_43 = 10;
                        _local_44 = 10;
                        if ((_local_42 * _local_12) > 100)
                        {
                            _local_42 = (100 / _local_12);
                        }
                        if ((_local_40 * _local_13) > 150)
                        {
                            _local_40 = (150 / _local_13);
                        }
                        if ((_local_41 * _local_13) > 150)
                        {
                            _local_41 = (150 / _local_13);
                        }
                        if (((_local_8._Str_10235 && (_local_8._Str_7609 == _local_12)) && (_local_8._Str_7902 == _local_13)))
                        {
                            _local_42 = 0;
                        }
                        if (((_local_8._Str_10446 && (_local_8._Str_7609 == _local_12)) && (_local_8._Str_7902 == _local_13)))
                        {
                            _local_40 = 0;
                            _local_41 = 0;
                        }
                        _local_11.right = (_local_11.right * (1 - (_local_42 * 2)));
                        _local_11.bottom = (_local_11.bottom * (1 - (_local_40 + _local_41)));
                        if (_local_11.right < _local_43)
                        {
                            _local_11.right = _local_43;
                        }
                        if (_local_11.bottom < _local_44)
                        {
                            _local_11.bottom = _local_44;
                        }
                        if ((_local_40 + _local_41) > 0)
                        {
                            _local_11.offset((-_local_11.width / 2), (-_local_11.height * (_local_41 / (_local_40 + _local_41))));
                        }
                        else
                        {
                            _local_11.offset((-_local_11.width / 2), (-_local_11.height / 2));
                        }
                        _local_33 = _local_7.getScreenPoint(_local_15);
                        if (_local_33 == null)
                        {
                            return;
                        }
                        if (_local_33 != null)
                        {
                            _local_33.x = (_local_33.x + _local_5.screenOffsetX);
                            _local_33.y = (_local_33.y + _local_5.screenOffsetY);
                            _local_15.z = _local_10;
                            _local_15.x = (Math.fround((_local_23.x * 2)) / 2);
                            _local_15.y = (Math.fround((_local_23.y * 2)) / 2);
                            if (_local_8.location == null)
                            {
                                _local_7.location = _local_15;
                                if (this.useOffsetScrolling)
                                {
                                    _local_8.initializeLocation(new Vector3d(0, 0, 0));
                                }
                                else
                                {
                                    _local_8.initializeLocation(_local_15);
                                }
                            }
                            _local_45 = _local_7.getScreenPoint(_local_15);
                            _local_46 = new Vector3d(0, 0, 0);
                            if (_local_45 != null)
                            {
                                _local_46.x = _local_45.x;
                                _local_46.y = _local_45.y;
                            }
                            if (((((((((_local_33.x < _local_11.left) || (_local_33.x > _local_11.right)) && (!_local_8._Str_8564)) || (((_local_33.y < _local_11.top) || (_local_33.y > _local_11.bottom)) && (!_local_8._Str_8690))) || ((_local_36 && (!_local_8._Str_8564)) && (!(_local_8._Str_7609 == _local_12)))) || ((_local_37 && (!_local_8._Str_8690)) && (!(_local_8._Str_7902 == _local_13)))) || ((!(_local_8._Str_18975 == _local_14.width)) || (!(_local_8._Str_15953 == _local_14.height)))) || ((!(_local_8._Str_7609 == _local_12)) || (!(_local_8._Str_7902 == _local_13)))))
                            {
                                _local_8._Str_10235 = _local_34;
                                _local_8._Str_10446 = _local_35;
                                if (this.useOffsetScrolling)
                                {
                                    _local_8.target = _local_46;
                                }
                                else
                                {
                                    _local_8.target = _local_15;
                                }
                            }
                            else
                            {
                                if (!_local_34)
                                {
                                    _local_8._Str_10235 = false;
                                }
                                if (!_local_35)
                                {
                                    _local_8._Str_10446 = false;
                                }
                            }
                        }
                        _local_8._Str_8564 = _local_36;
                        _local_8._Str_8690 = _local_37;
                        _local_8._Str_7609 = _local_12;
                        _local_8._Str_7902 = _local_13;
                        _local_8.scale = Std.int(_local_7.scale);
                        _local_8._Str_16377 = _local_7.updateId;
                        _local_8._Str_18975 = Std.int(_local_14.width);
                        _local_8._Str_15953 = Std.int(_local_14.height);
                        if (!this._sessionDataManager.isRoomCameraFollowDisabled)
                        {
                            if (this.useOffsetScrolling)
                            {
                                _local_8.update(_arg_4, 8);
                            }
                            else
                            {
                                _local_8.update(_arg_4, 0.5);
                            }
                        }
                        if (this.useOffsetScrolling)
                        {
                            _local_5.screenOffsetX = Std.int(-_local_8.location.x);
                            _local_5.screenOffsetY = Std.int(-_local_8.location.y);
                        }
                        else
                        {
                            _local_7.adjustLocation(_local_8.location, 25);
                        }
                    }
                    else
                    {
                        _local_8._Str_10235 = false;
                        _local_8._Str_10446 = false;
                        _local_8._Str_8564 = false;
                        _local_8._Str_8690 = false;
                    }
                }
            }
        }

        function onConfigurationComplete(k:Event)
        {
            this._contentLoaderReady = true;
            this._roomManager.initialize(new com.sulake.core.utils.xml.XML("<nothing/>")
            , this);
        }

        function onRoomSessionEvent(k:RoomSessionEvent)
        {
            switch (k.type)
            {
                case RoomSessionEvent.STARTED:
                    if (this._roomMessageHandler != null)
                    {
                        this._roomMessageHandler.setCurrentRoom(k.session.roomId);
                    }
                    return;
                case RoomSessionEvent.ENDED:
                    if (this._roomMessageHandler != null)
                    {
                        this._roomMessageHandler.resetCurrentRoom();
                        this.disposeRoom(k.session.roomId);
                    }
                    return;
            }
        }

        function onToolbarClicked(k:HabboToolbarEvent)
        {
            var _local_2:RoomCamera = null;
            if (k.iconId == HabboToolbarIconEnum.MEMENU)
            {
                _local_2 = this.getActiveRoomCamera();
                if (_local_2 != null)
                {
                    _local_2.activateFollowing(this.cameraFollowDuration);
                    _local_2.reset();
                }
            }
        }

        public function roomManagerInitialized(k:Bool)
        {
            var _local_2 = 0;
            var _local_3:RoomData = null;
            if (k)
            {
                this._roomManagerInitialized = true;
                events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.ENGINE_INITIALIZED, 0));
                _local_2 = 0;
                while ((_local_2 : UInt) < this._roomDatas.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._roomDatas.getWithIndex(_local_2) , RoomData);
                    if (_local_3 != null)
                    {
                        this.initializeRoom(_local_3.roomId, _local_3.data, _local_3.cameraInitPosition, _local_3.areaHideData);
                    }
                    _local_2++;
                }
            }
        }

        public function setActiveRoom(k:Int)
        {
            this._activeRoomId = k;
        }

        public function getRoomIdentifier(k:Int):String
        {
            return Std.string(k);
        }

        function getRoomId(k:String):Int
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = (cast k.split("_"));
                if (_local_2.length > 0)
                {
                    return ASCompat.toInt(_local_2[0]);
                }
            }
            return -1;
        }

        public function getRoomNumberValue(k:Int, _arg_2:String):Float
        {
            var _local_3= this.getRoom(k);
            if (_local_3 != null)
            {
                return _local_3.getNumber(_arg_2);
            }
            return Math.NaN;
        }

        public function getRoomStringValue(k:Int, _arg_2:String):String
        {
            var _local_3= this.getRoom(k);
            if (_local_3 != null)
            {
                return _local_3.getString(_arg_2);
            }
            return null;
        }

        public function setIsPlayingGame(k:Int, _arg_2:Bool)
        {
            var _local_4 = 0;
            var _local_3= this.getRoom(k);
            if (_local_3 != null)
            {
                _local_4 = (_arg_2 ? 1 : 0);
                _local_3.setNumber(RoomVariableEnum.IS_PLAYING_GAME, _local_4);
                if (_local_4 == 0)
                {
                    events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.NORMAL_MODE, k));
                }
                else
                {
                    events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.GAME_MODE, k));
                }
            }
        }

        public function getIsPlayingGame(k:Int):Bool
        {
            var _local_3 = Math.NaN;
            if (((k == this._activeRoomId) && (this._roomEvents != null)) && this._roomEvents.isGameMode)
            {
                return true;
            }
            var _local_2= this.getRoom(k);
            if (_local_2 != null)
            {
                _local_3 = _local_2.getNumber(RoomVariableEnum.IS_PLAYING_GAME);
                if (_local_3 > 0)
                {
                    return true;
                }
            }
            return false;
        }

        public function updateAreaHide(k:Int, _arg_2:Int, _arg_3:Bool, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Bool)
        {
            events.dispatchEvent(new RoomEngineAreaHideStateWidgetEvent(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, _arg_3));
            var _local_9= this.getObjectRoom(k);
            if (((_local_9 == null) || (_local_9.getEventHandler() == null)))
            {
                return;
            }
            var _local_10= (_arg_3 ? RoomObjectRoomFloorHoleUpdateMessage.RORPFHUM_ADD : RoomObjectRoomFloorHoleUpdateMessage.RORPFHUM_REMOVE);
            _local_9.getEventHandler().processUpdateMessage(new RoomObjectRoomFloorHoleUpdateMessage(_local_10, _arg_2, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8));
        }

        public function setHanditemControlBlocked(k:Int, _arg_2:Bool)
        {
            this.setRoomBoolean(k, RoomVariableEnum.HANDITEM_CONTROL_BLOCKED, _arg_2);
        }

        public function setChooserDisabled(k:Int, _arg_2:Bool)
        {
            this.setRoomBoolean(k, RoomVariableEnum.CHOOSER_DISABLED, _arg_2);
        }

        public function setFreeFurniMovementsMode(k:Int, _arg_2:Bool)
        {
            this.setRoomBoolean(k, RoomVariableEnum.FREE_FURNI_MOVEMENTS_MODE, _arg_2);
        }

        public function setInvisibleFurni(k:Int, _arg_2:Bool)
        {
            var _local_3= this.getRoom(k);
            var _local_4:IRoomObject = null;
            var _local_5:Array<ASAny> = null;
            if (_local_3 == null)
            {
                return;
            }
            _local_3.setNumber(RoomVariableEnum.INVISIBLE_FURNI, (_arg_2 ? 1 : 0));
            _local_5 = this.getRoomObjects(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_4  = _tmp_;
                this.applyInvisibleFurniState(_local_4, _arg_2);
            }
            _local_5 = this.getRoomObjects(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_4  = _tmp_;
                this.applyInvisibleFurniState(_local_4, _arg_2);
            }
        }

        function applyInvisibleFurniState(k:IRoomObject, _arg_2:Bool)
        {
            var _local_3= Std.downcast(k , IRoomObjectController);
            if (((_local_3 != null) && (_local_3.getModelController() != null)))
            {
                _local_3.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_INVISIBLE_LAYER, (_arg_2 ? 1 : 0));
            }
        }

        function applyCurrentInvisibleFurniState(k:Int, _arg_2:IRoomObjectController)
        {
            var _local_3= this.getRoom(k);
            this.applyInvisibleFurniState(_arg_2, ((_local_3 != null) && (_local_3.getNumber(RoomVariableEnum.INVISIBLE_FURNI) > 0)));
        }

        public function getActiveRoomIsPlayingGame():Bool
        {
            return this.getIsPlayingGame(this._activeRoomId);
        }

        public var activeRoomHasHanditemControlBlocked(get,never):Bool;
public function  get_activeRoomHasHanditemControlBlocked():Bool
        {
            return this.isRoomBooleanActive(
                this._activeRoomId, RoomVariableEnum.HANDITEM_CONTROL_BLOCKED);
        }

        public var activeRoomHasChooserDisabled(get,never):Bool;
public function  get_activeRoomHasChooserDisabled():Bool
        {
            return this.isRoomBooleanActive(
                this._activeRoomId, RoomVariableEnum.CHOOSER_DISABLED);
        }

        public var activeRoomHasFreeFurniMovementsMode(get,never):Bool;
public function  get_activeRoomHasFreeFurniMovementsMode():Bool
        {
            return this.isRoomBooleanActive(
                this._activeRoomId, RoomVariableEnum.FREE_FURNI_MOVEMENTS_MODE);
        }

        function setRoomBoolean(k:Int, _arg_2:String, _arg_3:Bool)
        {
            var _local_4= this.getRoom(k);
            if (_local_4 != null)
            {
                _local_4.setNumber(_arg_2, (_arg_3 ? 1 : 0));
            }
        }

        function isRoomBooleanActive(k:Int, _arg_2:String):Bool
        {
            var _local_3= this.getRoom(k);
            return _local_3 != null && _local_3.getNumber(_arg_2) > 0;
        }

        public function getRoom(k:Int):IRoomInstance
        {
            if (!this._roomManagerInitialized)
            {
                return null;
            }
            var _local_2= this.getRoomIdentifier(k);
            var _local_3= this._roomManager.getRoom(_local_2);
            return _local_3;
        }

        public function initializeRoom(k:Int, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:IVector3d=null, _arg_4:Vector<IAreaHideInfo>=null)
        {
var _local_9:IAreaHideInfo  = null;            var _local_3= this.getRoomIdentifier(k);
            var _local_4:RoomData = null;
            var _local_5= "111";
            var _local_6= "201";
            var _local_7= "1";
            if (!this._roomManagerInitialized)
            {
                _local_4 = this._roomDatas.remove(_local_3);
                if (_local_4 != null)
                {
                    _local_5 = _local_4.floorType;
                    _local_6 = _local_4.wallType;
                    _local_7 = _local_4.landscapeType;
                }
                _local_4 = new RoomData(k, _arg_2);
                _local_4.floorType = _local_5;
                _local_4.wallType = _local_6;
                _local_4.landscapeType = _local_7;
                _local_4.cameraInitPosition = _arg_3;
                _local_4.areaHideData = _arg_4;
                this._roomDatas.add(_local_3, _local_4);
                Logger.log(["Room Engine not initilized yet, can not create room. Room data stored for later initialization."]);
                return;
            }
            if (_arg_2 == null)
            {
                Logger.log(["Room property messages received before floor height map, will initialize when floor height map received."]);
                return;
            }
            _local_4 = this._roomDatas.remove(_local_3);
            if (_local_4 != null)
            {
                if (((!(_local_4.floorType == null)) && (_local_4.floorType.length > 0)))
                {
                    _local_5 = _local_4.floorType;
                }
                if (((!(_local_4.wallType == null)) && (_local_4.wallType.length > 0)))
                {
                    _local_6 = _local_4.wallType;
                }
                if (((!(_local_4.landscapeType == null)) && (_local_4.landscapeType.length > 0)))
                {
                    _local_7 = _local_4.landscapeType;
                }
                if (_local_4.cameraInitPosition != null)
                {
                    _arg_3 = _local_4.cameraInitPosition;
                }
                if (_local_4.areaHideData != null)
                {
                    _arg_4 = _local_4.areaHideData;
                }
            }
            var _local_8= this.createRoom(_local_3, _arg_2, _local_5, _local_6, _local_7, this.getWorldType(k), this.isPublicRoom(k), _arg_3);
            if (_arg_4 != null)
            {
                if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
                {
_local_9 = _tmp_;
                    this.updateAreaHide(k, _local_9.furniId, _local_9.on, _local_9.rootX, _local_9.rootY, _local_9.width, _local_9.length, _local_9.invert);
                }
            }
            if (_local_8 == null)
            {
                return;
            }
            events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.INITIALIZED, k));
        }

        function createRoom(k:String, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:Bool=false, _arg_8:IVector3d=null):IRoomInstance
        {
            var _local_11 = 0;
            var _local_12:com.sulake.core.utils.xml.XML = null;
            var _local_13 = Math.NaN;
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            var _local_17:RoomObjectRoomUpdateMessage = null;
            var _local_18:com.sulake.core.utils.xml.XMLList = null;
            var _local_19:Array<ASAny> = null;
            var _local_20:RoomObjectRoomMaskUpdateMessage = null;
            var _local_21 = 0;
            var _local_22:com.sulake.core.utils.xml.XML = null;
            var _local_23 = Math.NaN;
            var _local_24 = Math.NaN;
            var _local_25 = Math.NaN;
            var _local_26 = Math.NaN;
            var _local_27:String = null;
            var _local_28:String = null;
            var _local_29:Vector3d = null;
            var _local_30 = false;
            var _local_31:String = null;
            var _local_32 = 0;
            if (!this._roomManagerInitialized)
            {
                return null;
            }
            var _local_7= this._roomManager.createRoom(k, _arg_2);
            if (_local_7 == null)
            {
                return null;
            }
            var _local_8= RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM;
            var _local_9:IRoomObjectController = null;
            var _local_10:Float = 1;
            _local_30 = ((_arg_7 && (!(_arg_6 == null))) && (_arg_6.length > 0));
            _local_31 = (_local_30 ? this.getPublicRoomContentType(_arg_6) : ROOM);
            _local_9 = Std.downcast(_local_7.createRoomObject(OBJECT_ID_ROOM, _local_31, _local_8) , IRoomObjectController);
            _local_7.setNumber(RoomVariableEnum.ROOM_IS_PUBLIC, (_local_30 ? 1 : 0), true);
            if (((_local_30 && (!(_local_9 == null))) && (!(_local_9.getModelController() == null))))
            {
                _local_9.getModelController().setString(RoomObjectVariableEnum.ROOM_WORLD_TYPE, _arg_6, true);
                if (this._roomContentLoader != null)
                {
                    _local_10 = this._roomContentLoader.getPublicRoomWorldHeightScale(_arg_6);
                }
                _local_32 = ASCompat.parseInt((propertyExists("ads.billboard.displayDelayMillis") ? getProperty("ads.billboard.displayDelayMillis") : "1000"));
                _local_9.getModelController().setNumber(RoomVariableEnum.AD_DISPLAY_DELAY, _local_32, true);
            }
            _local_7.setNumber(RoomVariableEnum.ROOM_Z_SCALE, _local_10, true);
            if (_arg_8 != null)
            {
                _local_7.setNumber(RoomVariableEnum.CAMERA_INIT_X, _arg_8.x);
                _local_7.setNumber(RoomVariableEnum.CAMERA_INIT_Y, _arg_8.y);
                _local_7.setNumber(RoomVariableEnum.CAMERA_INIT_Z, _arg_8.z);
            }
            if (_arg_2 != null)
            {
                _local_11 = 0;
                if (_arg_2.child("dimensions").length() == 1)
                {
                    _local_12 = _arg_2.child("dimensions").at(0);
                    _local_13 = ASCompat.toNumber(ASCompat.xmlListToString(_local_12.attribute("minX")));
                    _local_14 = ASCompat.toNumber(ASCompat.xmlListToString(_local_12.attribute("maxX")));
                    _local_15 = ASCompat.toNumber(ASCompat.xmlListToString(_local_12.attribute("minY")));
                    _local_16 = ASCompat.toNumber(ASCompat.xmlListToString(_local_12.attribute("maxY")));
                    _local_7.setNumber(RoomVariableEnum.ROOM_MIN_X, _local_13);
                    _local_7.setNumber(RoomVariableEnum.ROOM_MAX_X, _local_14);
                    _local_7.setNumber(RoomVariableEnum.ROOM_MIN_Y, _local_15);
                    _local_7.setNumber(RoomVariableEnum.ROOM_MAX_Y, _local_16);
                    _local_11 = Std.int(_local_11 + ((((_local_13 * 423) + (_local_14 * 671)) + (_local_15 * 913)) + (_local_16 * 7509)));
                    if (((!(_local_9 == null)) && (!(_local_9.getModelController() == null))))
                    {
                        _local_9.getModelController().setNumber(RoomObjectVariableEnum.ROOM_RANDOM_SEED, _local_11, true);
                    }
                }
            }
            if (!this.applyRoomObjectProperties(this.getRoomId(k), _arg_2, _arg_3, _arg_4, _arg_5))
            {
                if (_local_30)
                {
ASCompat.setDynamicProperty(                    this._pendingPublicRoomInit, _local_31, {"roomId":this.getRoomId(k), "xml":_arg_2, "floor":_arg_3, "wall":_arg_4, "landscape":_arg_5});
                }
            }
            _local_7.createRoomObject(OBJECT_ID_ROOM_HIGHLIGHTER, TILE_CURSOR, RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR);
            if (!getBoolean("avatar.widget.enabled"))
            {
                _local_7.createRoomObject(OBJECT_ID_SELECTION_ARROW, SELECTION_ARROW, RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR);
            }
            return _local_7;
        }

        function applyRoomObjectProperties(k:Int, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:String):Bool
        {
            var _local_6:RoomObjectRoomUpdateMessage = null;
            var _local_7:com.sulake.core.utils.xml.XMLList = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:RoomObjectRoomMaskUpdateMessage = null;
            var _local_10 = 0;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:Vector3d = null;
            var _local_19= this._roomManager.getRoom(this.getRoomIdentifier(k));
            var _local_20= this.getObjectRoom(k);
            if (((_local_19 == null) || (_local_20 == null) || (_local_20.getEventHandler() == null)))
            {
                return false;
            }
            _local_20.getEventHandler().initialize(_arg_2);
            if (_arg_3 != null)
            {
                _local_6 = new RoomObjectRoomUpdateMessage(RoomObjectRoomUpdateMessage.RORUM_ROOM_FLOOR_UPDATE, _arg_3);
                _local_20.getEventHandler().processUpdateMessage(_local_6);
                _local_19.setString(RoomObjectVariableEnum.ROOM_FLOOR_TYPE, _arg_3);
            }
            if (_arg_4 != null)
            {
                _local_6 = new RoomObjectRoomUpdateMessage(RoomObjectRoomUpdateMessage.RORUM_ROOM_WALL_UPDATE, _arg_4);
                _local_20.getEventHandler().processUpdateMessage(_local_6);
                _local_19.setString(RoomObjectVariableEnum.ROOM_WALL_TYPE, _arg_4);
            }
            if (_arg_5 != null)
            {
                _local_6 = new RoomObjectRoomUpdateMessage(RoomObjectRoomUpdateMessage.RORUM_ROOM_LANDSCAPE_UPDATE, _arg_5);
                _local_20.getEventHandler().processUpdateMessage(_local_6);
                _local_19.setString(RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE, _arg_5);
            }
            if (_arg_2 != null)
            {
                if (_arg_2.child("doors").child("door").length() > 0)
                {
                    _local_7 = _arg_2.child("doors").child("door");
                    _local_8 = ["x", "y", "z", "dir"];
                    _local_10 = 0;
                    while (_local_10 < _local_7.length())
                    {
                        _local_11 = _local_7.at(_local_10);
                        if (XMLValidator.checkRequiredAttributes(_local_11, _local_8))
                        {
                            _local_12 = ASCompat.toNumber(ASCompat.xmlListToString(_local_11.attribute("x")));
                            _local_13 = ASCompat.toNumber(ASCompat.xmlListToString(_local_11.attribute("y")));
                            _local_14 = ASCompat.toNumber(ASCompat.xmlListToString(_local_11.attribute("z")));
                            _local_15 = ASCompat.toNumber(ASCompat.xmlListToString(_local_11.attribute("dir")));
                            _local_16 = RoomObjectRoomMaskUpdateMessage.DOOR;
                            _local_17 = ("door_" + Std.string(_local_10));
                            _local_18 = new Vector3d(_local_12, _local_13, _local_14);
                            _local_9 = new RoomObjectRoomMaskUpdateMessage(RoomObjectRoomMaskUpdateMessage.RORMUM_ADD_MASK, _local_17, _local_16, _local_18, RoomObjectRoomMaskUpdateMessage.HOLE);
                            _local_20.getEventHandler().processUpdateMessage(_local_9);
                            if (((_local_15 == 90) || (_local_15 == 180)))
                            {
                                if (_local_15 == 90)
                                {
                                    _local_19.setNumber(RoomObjectVariableEnum.ROOM_DOOR_X, (_local_12 - 0.5), true);
                                    _local_19.setNumber(RoomObjectVariableEnum.ROOM_DOOR_Y, _local_13, true);
                                }
                                if (_local_15 == 180)
                                {
                                    _local_19.setNumber(RoomObjectVariableEnum.ROOM_DOOR_X, _local_12, true);
                                    _local_19.setNumber(RoomObjectVariableEnum.ROOM_DOOR_Y, (_local_13 - 0.5), true);
                                }
                                _local_19.setNumber(RoomObjectVariableEnum.ROOM_DOOR_Z, _local_14, true);
                                _local_19.setNumber(RoomObjectVariableEnum.ROOM_DOOR_DIR, _local_15, true);
                            }
                        }
                        _local_10++;
                    }
                }
            }
            return true;
        }

        public function getObjectRoom(k:Int):IRoomObjectController
        {
            return this.getObject(this.getRoomIdentifier(k), OBJECT_ID_ROOM, RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM);
        }

        public function updatePublicRoomParkBusDoor(k:Int, _arg_2:Bool)
        {
            if (this.getWorldType(k) != "park_a")
            {
                return;
            }
            var _local_3= this.getObjectRoom(k);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.getModelController();
            if (_local_4 == null)
            {
                return;
            }
            _local_4.setNumber(RoomObjectVariableEnum.ROOM_PUBLIC_PARK_BUS_DOOR_STATUS, (_arg_2 ? 1 : 0));
        }

        public function updateObjectRoom(k:Int, _arg_2:String=null, _arg_3:String=null, _arg_4:String=null, _arg_5:Bool=false):Bool
        {
            var _local_9:String = null;
            var _local_10:RoomData = null;
            var _local_6= this.getObjectRoom(k);
            var _local_7= this.getRoom(k);
            if (_local_6 == null)
            {
                _local_9 = this.getRoomIdentifier(k);
                _local_10 = this._roomDatas.getValue(_local_9);
                if (_local_10 == null)
                {
                    _local_10 = new RoomData(k, null);
                    this._roomDatas.add(_local_9, _local_10);
                }
                if (_arg_2 != null)
                {
                    _local_10.floorType = _arg_2;
                }
                if (_arg_3 != null)
                {
                    _local_10.wallType = _arg_3;
                }
                if (_arg_4 != null)
                {
                    _local_10.landscapeType = _arg_4;
                }
                return true;
            }
            if (_local_6.getEventHandler() == null)
            {
                return false;
            }
            var _local_8:RoomObjectRoomUpdateMessage = null;
            if (_arg_2 != null)
            {
                if (((!(_local_7 == null)) && (!_arg_5)))
                {
                    _local_7.setString(RoomObjectVariableEnum.ROOM_FLOOR_TYPE, _arg_2);
                }
                _local_8 = new RoomObjectRoomUpdateMessage(RoomObjectRoomUpdateMessage.RORUM_ROOM_FLOOR_UPDATE, _arg_2);
                _local_6.getEventHandler().processUpdateMessage(_local_8);
            }
            if (_arg_3 != null)
            {
                if (((!(_local_7 == null)) && (!_arg_5)))
                {
                    _local_7.setString(RoomObjectVariableEnum.ROOM_WALL_TYPE, _arg_3);
                }
                _local_8 = new RoomObjectRoomUpdateMessage(RoomObjectRoomUpdateMessage.RORUM_ROOM_WALL_UPDATE, _arg_3);
                _local_6.getEventHandler().processUpdateMessage(_local_8);
            }
            if (_arg_4 != null)
            {
                if (((!(_local_7 == null)) && (!_arg_5)))
                {
                    _local_7.setString(RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE, _arg_4);
                }
                _local_8 = new RoomObjectRoomUpdateMessage(RoomObjectRoomUpdateMessage.RORUM_ROOM_LANDSCAPE_UPDATE, _arg_4);
                _local_6.getEventHandler().processUpdateMessage(_local_8);
            }
            return true;
        }

        public function updateObjectRoomColor(k:Int, _arg_2:UInt, _arg_3:Int, _arg_4:Bool):Bool
        {
            var _local_5= this.getObjectRoom(k);
            if (((_local_5 == null) || (_local_5.getEventHandler() == null)))
            {
                return false;
            }
            var _local_6:RoomObjectRoomColorUpdateMessage = null;
            _local_6 = new RoomObjectRoomColorUpdateMessage(RoomObjectRoomColorUpdateMessage.RORCUM_BACKGROUND_COLOR, _arg_2, _arg_3, _arg_4);
            _local_5.getEventHandler().processUpdateMessage(_local_6);
            events.dispatchEvent(new RoomBackgroundColorEvent(k, _arg_2, _arg_3, _arg_4));
            return true;
        }

        public function updateObjectRoomBackgroundColor(k:Int, _arg_2:Bool, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool
        {
            var _local_6= this.getObjectRoom(k);
            if (((_local_6 == null) || (_local_6.getEventHandler() == null)))
            {
                return false;
            }
            events.dispatchEvent(new RoomObjectHSLColorEnabledEvent(RoomObjectHSLColorEnabledEvent.ROOM_BACKGROUND_COLOR, k, _arg_2, _arg_3, _arg_4, _arg_5));
            return true;
        }

        public function updateObjectRoomVisibilities(k:Int, _arg_2:Bool, _arg_3:Bool=true):Bool
        {
            var _local_4= this.getObjectRoom(k);
            if (((_local_4 == null) || (_local_4.getEventHandler() == null)))
            {
                return false;
            }
            var _local_5:RoomObjectRoomPlaneVisibilityUpdateMessage = null;
            _local_5 = new RoomObjectRoomPlaneVisibilityUpdateMessage(RoomObjectRoomPlaneVisibilityUpdateMessage.RORPVUM_WALL_VISIBILITY, _arg_2);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            _local_5 = new RoomObjectRoomPlaneVisibilityUpdateMessage(RoomObjectRoomPlaneVisibilityUpdateMessage.RORPVUM_FLOOR_VISIBILITY, _arg_3);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            return true;
        }

        public function updateObjectRoomPlaneThicknesses(k:Int, _arg_2:Float, _arg_3:Float):Bool
        {
            var _local_4= this.getObjectRoom(k);
            if (((_local_4 == null) || (_local_4.getEventHandler() == null)))
            {
                return false;
            }
            var _local_5:RoomObjectRoomPlanePropertyUpdateMessage = null;
            _local_5 = new RoomObjectRoomPlanePropertyUpdateMessage(RoomObjectRoomPlanePropertyUpdateMessage.RORPPUM_WALL_THICKNESS, _arg_2);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            _local_5 = new RoomObjectRoomPlanePropertyUpdateMessage(RoomObjectRoomPlanePropertyUpdateMessage.RORPVUM_FLOOR_THICKNESS, _arg_3);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            return true;
        }

        public function disposeRoom(k:Int)
        {
            var _local_2= this.getRoomIdentifier(k);
            this._roomManager.disposeRoom(_local_2);
            var _local_3:RoomInstanceData = this._roomInstanceDatas.remove(_local_2);
            if (_local_3 != null)
            {
                _local_3.dispose();
            }
            events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.DISPOSED, k));
        }

        public function setOwnUserId(k:Int, _arg_2:Int)
        {
            var _local_3= this._roomSessionManager.getSession(k);
            if (_local_3 != null)
            {
                _local_3.ownUserRoomId = _arg_2;
            }
            var _local_4= this.getRoomCamera(k);
            if (_local_4 != null)
            {
                _local_4._Str_10760 = _arg_2;
                _local_4._Str_16562 = RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
                _local_4.activateFollowing(this.cameraFollowDuration);
            }
        }

        public function createRoomCanvas(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int):DisplayObject
        {
            var _local_11 = Math.NaN;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_14 = Math.NaN;
            var _local_15:Vector3d = null;
            var _local_16:Vector3d = null;
            var _local_17:Sprite = null;
            var _local_6= this.getRoomIdentifier(k);
            var _local_7= this._roomManager.getRoom(_local_6);
            if (_local_7 == null)
            {
                return null;
            }
            var _local_8= Std.downcast(_local_7.getRenderer() , IRoomRenderer);
            if (_local_8 == null)
            {
                _local_8 = this._roomRendererFactory.createRenderer();
            }
            if (_local_8 == null)
            {
                return null;
            }
            _local_8.roomObjectVariableAccurateZ = RoomObjectVariableEnum.OBJECT_ACCURATE_Z_VALUE;
            _local_7.setRenderer(_local_8);
            var _local_18= _arg_5;
            // Public rooms default to zoomed-out, EXCEPT small interior worlds that should use the
            // normal guest-room zoom (the infobus interior, the rooftop cafe).
            var _local_19= this.getWorldType(k);
            if ((((_local_7.getNumber(RoomVariableEnum.ROOM_IS_PUBLIC) == 1) && (!(_local_19 == "park_b"))) && (!(_local_19 == "rooftop_2"))))
            {
                _local_18 = Std.int(RoomGeometry.SCALE_ZOOMED_OUT);
            }
            var _local_9= _local_8.createCanvas(_arg_2, _arg_3, _arg_4, _local_18);
            if (_local_9 == null)
            {
                return null;
            }
            _local_9.mouseListener = this._roomObjectEventHandler;
            if (_local_9.geometry != null)
            {
                _local_9.geometry.z_scale = _local_7.getNumber(RoomVariableEnum.ROOM_Z_SCALE);
            }
            if (_local_9.geometry != null)
            {
                _local_11 = _local_7.getNumber(RoomObjectVariableEnum.ROOM_DOOR_X);
                _local_12 = _local_7.getNumber(RoomObjectVariableEnum.ROOM_DOOR_Y);
                _local_13 = _local_7.getNumber(RoomObjectVariableEnum.ROOM_DOOR_Z);
                _local_14 = _local_7.getNumber(RoomObjectVariableEnum.ROOM_DOOR_DIR);
                _local_15 = new Vector3d(_local_11, _local_12, _local_13);
                _local_16 = null;
                if (_local_14 == 90)
                {
                    _local_16 = new Vector3d(-2000, 0, 0);
                }
                if (_local_14 == 180)
                {
                    _local_16 = new Vector3d(0, -2000, 0);
                }
                _local_9.geometry.setDisplacement(_local_15, _local_16);
            }
            var _local_10= Std.downcast(_local_9.displayObject , Sprite);
            if (_local_10 != null)
            {
                _local_17 = new Sprite();
                _local_17.name = OVERLAY;
                _local_17.mouseEnabled = false;
                _local_10.addChild(_local_17);
            }
            return _local_10;
        }

        public function setRoomCanvasScale(k:Int, _arg_2:Int, _arg_3:Float, _arg_4:Point=null, _arg_5:Point=null, _arg_6:Bool=false, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            if (!getBoolean("zoom.enabled"))
            {
                return;
            }
            if (!_arg_7)
            {
                _arg_3 = (_arg_6 ? -1 : ((_arg_3 < 1) ? 0.5 : Math.ffloor(_arg_3)));
            }
            var _local_9= this.getRoomCanvas(k, _arg_2);
            if (_local_9 != null)
            {
                _local_9.setScale(_arg_3, _arg_4, _arg_5, _arg_8);
                this.syncRoomCameraLocationToCanvasOffset(k, _local_9);
                events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.ROOM_ZOOMED, k));
            }
        }

        public function getRoomCanvasScale(k:Int=-1000, _arg_2:Int=-1):Float
        {
            if (k == -1000)
            {
                k = this._activeRoomId;
            }
            if (_arg_2 == -1)
            {
                _arg_2 = this._activeRoomActiveCanvas;
            }
            var _local_3= this.getRoomCanvas(k, _arg_2);
            if (_local_3 == null)
            {
                return 1;
            }
            return _local_3.scale;
        }

        public function getRoomCanvas(k:Int, _arg_2:Int):IRoomRenderingCanvas
        {
            var _local_3= this.getRoomIdentifier(k);
            var _local_4= this._roomManager.getRoom(_local_3);
            if (_local_4 == null)
            {
                return null;
            }
            var _local_5= Std.downcast(_local_4.getRenderer() , IRoomRenderer);
            if (_local_5 == null)
            {
                return null;
            }
            var _local_6= _local_5.getCanvas(_arg_2);
            return _local_6;
        }

        public function modifyRoomCanvas(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):Bool
        {
            var _local_5= this.getRoomCanvas(k, _arg_2);
            if (_local_5 == null)
            {
                return false;
            }
            _local_5.initialize(_arg_3, _arg_4);
            return true;
        }

        public function setRoomCanvasMask(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            var _local_4= this.getRoomCanvas(k, _arg_2);
            if (_local_4 == null)
            {
                return;
            }
            _local_4.useMask = _arg_3;
        }

        function getRoomCanvasRectangle(k:Int, _arg_2:Int):Rectangle
        {
            var _local_3= this.getRoomCanvas(k, _arg_2);
            if (_local_3 == null)
            {
                return null;
            }
            return new Rectangle(0, 0, _local_3.width, _local_3.height);
        }

        public function getRoomCanvasGeometry(k:Int, _arg_2:Int=-1):IRoomGeometry
        {
            if (_arg_2 == -1)
            {
                _arg_2 = this._activeRoomActiveCanvas;
            }
            var _local_3= this.getRoomCanvas(k, _arg_2);
            if (_local_3 == null)
            {
                return null;
            }
            return _local_3.geometry;
        }

        public function getRoomCanvasScreenOffset(k:Int, _arg_2:Int=-1):Point
        {
            if (_arg_2 == -1)
            {
                _arg_2 = this._activeRoomActiveCanvas;
            }
            var _local_3= this.getRoomCanvas(k, _arg_2);
            if (_local_3 == null)
            {
                return null;
            }
            return new Point(_local_3.screenOffsetX, _local_3.screenOffsetY);
        }

        public function setRoomCanvasScreenOffset(k:Int, _arg_2:Int, _arg_3:Point):Bool
        {
            var _local_4= this.getRoomCanvas(k, _arg_2);
            if (((_local_4 == null) || (_arg_3 == null)))
            {
                return false;
            }
            _local_4.screenOffsetX = Std.int(_arg_3.x);
            _local_4.screenOffsetY = Std.int(_arg_3.y);
            return true;
        }

        public function snapshotRoomCanvasToBitmap(k:Int, _arg_2:Int, _arg_3:BitmapData, _arg_4:Matrix, _arg_5:Bool):Bool
        {
            var _local_6= this.getRoomCanvas(k, _arg_2);
            if (_local_6 == null)
            {
                return false;
            }
            var _local_7= _local_6.displayObject;
            if (_local_7 == null)
            {
                return false;
            }
            _arg_3.draw(_local_7, _arg_4, null, null, null, _arg_5);
            return true;
        }

        function handleRoomDragging(k:IRoomRenderingCanvas, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool):Bool
        {
            var _local_10:RoomInstanceData = null;
            var _local_11:RoomCamera = null;
            if (this._isSelectedObjectInValidPosition)
            {
                return false;
            }
            if ((this._areaSelectionManager != null) && (this._areaSelectionManager.areaSelectionState == RoomAreaSelectionManager.SELECTING))
            {
                this._activeRoomIsDragged = false;
                this._activeRoomWasDragged = false;
                return false;
            }
            var _local_8= (_arg_2 - this._activeRoomActiveCanvasMouseX);
            var _local_9= (_arg_3 - this._activeRoomActiveCanvasMouseY);
            if (_arg_4 == MouseEvent.MOUSE_DOWN)
            {
                if (((((!_arg_5) && (!_arg_6)) && (!_arg_7)) && (!this.getIsSelectedObjectInValidPosition)))
                {
                    this._activeRoomIsDragged = true;
                    this._activeRoomWasDragged = false;
                    this._activeRoomDragStartX = this._activeRoomActiveCanvasMouseX;
                    this._activeRoomDragStartY = this._activeRoomActiveCanvasMouseY;
                    this._mouseEventsDisabledLeftToXWas = this._mouseEventsDisabledLeftToX;
                    this._mouseEventsDisabledLeftToX = 0;
                }
            }
            else
            {
                if (_arg_4 == MouseEvent.MOUSE_UP)
                {
                    if (this._activeRoomIsDragged)
                    {
                        this._activeRoomIsDragged = false;
                        if (this._activeRoomWasDragged)
                        {
                            _local_10 = this.getRoomInstanceData(this._activeRoomId);
                            if (_local_10 != null)
                            {
                                _local_11 = _local_10.roomCamera;
                                if (_local_11 != null)
                                {
                                    if (this.useOffsetScrolling)
                                    {
                                        if (!_local_11.isMoving)
                                        {
                                            _local_11._Str_8564 = false;
                                            _local_11._Str_8690 = false;
                                        }
                                        _local_11.resetLocation(new Vector3d(-this.normalizeScreenOffsetForScale(k.screenOffsetX, k.width, k.scale), -this.normalizeScreenOffsetForScale(k.screenOffsetY, k.height, k.scale)));
                                    }
                                    if (this._cameraCentered)
                                    {
                                        _local_11.reset();
                                    }
                                }
                            }
                            events.dispatchEvent(new RoomEngineDragWidgetMouseEvent(RoomEngineDragWidgetMouseEvent.DRAG_END, this._activeRoomId));
                        }
                    }
                    if (this._mouseEventsDisabledLeftToXWas != 0)
                    {
                        this._mouseEventsDisabledLeftToX = this._mouseEventsDisabledLeftToXWas;
                        this._mouseEventsDisabledLeftToXWas = 0;
                    }
                }
                else
                {
                    if (_arg_4 == MouseEvent.MOUSE_MOVE)
                    {
                        if (this._activeRoomIsDragged)
                        {
                            if (!this._activeRoomWasDragged)
                            {
                                _local_8 = (_arg_2 - this._activeRoomDragStartX);
                                _local_9 = (_arg_3 - this._activeRoomDragStartY);
                                if (((((_local_8 <= -ROOM_DRAG_THRESHOLD) || (_local_8 >= ROOM_DRAG_THRESHOLD)) || (_local_9 <= -ROOM_DRAG_THRESHOLD)) || (_local_9 >= ROOM_DRAG_THRESHOLD)))
                                {
                                    this._activeRoomWasDragged = true;
                                    events.dispatchEvent(new RoomEngineDragWidgetMouseEvent(RoomEngineDragWidgetMouseEvent.DRAG_START, this._activeRoomId));
                                }
                                _local_8 = 0;
                                _local_9 = 0;
                            }
                            if (((!(_local_8 == 0)) || (!(_local_9 == 0))))
                            {
                                this._activeRoomDragX = (this._activeRoomDragX + _local_8);
                                this._activeRoomDragY = (this._activeRoomDragY + _local_9);
                                if (!this._activeRoomWasDragged)
                                {
                                    events.dispatchEvent(new RoomEngineDragWidgetMouseEvent(RoomEngineDragWidgetMouseEvent.DRAG_START, this._activeRoomId));
                                }
                                this._activeRoomWasDragged = true;
                            }
                        }
                    }
                    else
                    {
                        if (((_arg_4 == MouseEvent.CLICK) || (_arg_4 == MouseEvent.DOUBLE_CLICK)))
                        {
                            this._activeRoomIsDragged = false;
                            if (this._activeRoomWasDragged)
                            {
                                this._activeRoomWasDragged = false;
                                return true;
                            }
                        }
                    }
                }
            }
            return false;
        }

        function normalizeScreenOffsetForScale(k:Float, _arg_2:Float, _arg_3:Float):Float
        {
            var _local_4 = Math.NaN;
            var _local_5 = Math.NaN;
            if (((_arg_3 == 0) || (_arg_3 == 1)))
            {
                return k;
            }
            _local_4 = (_arg_2 / _arg_3);
            _local_5 = (_local_4 / 2);
            return (_local_5 - ((_local_5 - k) / _arg_3));
        }

        function syncRoomCameraLocationToCanvasOffset(k:Int, _arg_2:IRoomRenderingCanvas)
        {
            var _local_3:RoomInstanceData = null;
            if ((((!this.useOffsetScrolling) || (_arg_2 == null)) || (_arg_2.scale <= 0)))
            {
                return;
            }
            _local_3 = this.getRoomInstanceData(k);
            if (((_local_3 == null) || (_local_3.roomCamera == null)))
            {
                return;
            }
            _local_3.roomCamera.resetLocation(new Vector3d(-this.normalizeScreenOffsetForScale(_arg_2.screenOffsetX, _arg_2.width, _arg_2.scale), -this.normalizeScreenOffsetForScale(_arg_2.screenOffsetY, _arg_2.height, _arg_2.scale)));
        }

        public function handleRoomCanvasMouseEvent(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Bool, _arg_6:Bool, _arg_7:Bool, _arg_8:Bool)
        {
            var _local_10:Sprite = null;
            var _local_11:Sprite = null;
            var _local_12 = Math.NaN;
            var _local_13:Rectangle = null;
            var _local_14:String = null;
            var _local_15:RoomObjectEvent = null;
            if (((this._mouseEventsDisabledAboveY > 0) && (_arg_3 < this._mouseEventsDisabledAboveY)))
            {
                return;
            }
            if (((this._mouseEventsDisabledLeftToX > 0) && (_arg_2 < this._mouseEventsDisabledLeftToX)))
            {
                return;
            }
            var _local_9= this.getRoomCanvas(this._activeRoomId, k);
            if (_local_9 != null)
            {
                if ((((this._sessionDataManager.isPerkAllowed(PerkEnum.MOUSE_ZOOM) && (_arg_4 == MouseEvent.CLICK)) && _arg_6) && _arg_5))
                {
                    _local_12 = (_arg_7 ? (Std.int(_local_9.scale )>> 1) : ((_local_9.scale < 1) ? 1 : (Std.int(_local_9.scale )<< 1)));
                    this.setRoomCanvasScale(this.activeRoomId, this._activeRoomActiveCanvas, _local_12, new Point(_arg_2, _arg_3));
                    return;
                }
                _local_10 = this.getOverlaySprite(_local_9);
                _local_11 = this.getOverlayIconSprite(_local_10, OBJECT_ICON_SPRITE);
                if (_local_11 != null)
                {
                    _local_13 = _local_11.getRect(_local_11);
                    _local_11.x = (_arg_2 - (_local_13.width / 2));
                    _local_11.y = (_arg_3 - (_local_13.height / 2));
                }
                if (((_arg_4 == MouseEvent.CLICK) && (this._areaSelectionManager != null)) && this._areaSelectionManager.finishSelecting())
                {
                }
                else if (!this.handleRoomDragging(_local_9, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7))
                {
                    if (!_local_9.handleMouseEvent(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8))
                    {
                        _local_14 = "";
                        if (_arg_4 == MouseEvent.CLICK)
                        {
                            if (events != null)
                            {
                                events.dispatchEvent(new RoomEngineObjectEvent(RoomEngineObjectEvent.DESELECTED, this._activeRoomId, -1, RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN));
                            }
                            _local_14 = RoomObjectMouseEvent.ROE_MOUSE_CLICK;
                        }
                        else
                        {
                            if (_arg_4 == MouseEvent.MOUSE_MOVE)
                            {
                                _local_14 = RoomObjectMouseEvent.ROE_MOUSE_MOVE;
                            }
                            else
                            {
                                if (_arg_4 == MouseEvent.MOUSE_DOWN)
                                {
                                    _local_14 = RoomObjectMouseEvent.ROE_MOUSE_DOWN;
                                }
                            }
                        }
                        if (this._roomObjectEventHandler != null)
                        {
                            _local_15 = new RoomObjectMouseEvent(_local_14, this.getRoomObject(this._activeRoomId, OBJECT_ID_ROOM, RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM), null, _arg_5);
                            this._roomObjectEventHandler.handleRoomObjectEvent(_local_15, this._activeRoomId);
                        }
                    }
                }
                this._activeRoomActiveCanvas = k;
                this._activeRoomActiveCanvasMouseX = _arg_2;
                this._activeRoomActiveCanvasMouseY = _arg_3;
            }
        }

        function getOverlaySprite(k:IRoomRenderingCanvas):Sprite
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= Std.downcast(k.displayObject , Sprite);
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= Std.downcast(_local_2.getChildByName(OVERLAY) , Sprite);
            return _local_3;
        }

        function addOverlayIconSprite(k:Sprite, _arg_2:String, _arg_3:BitmapData):Sprite
        {
            if (((k == null) || (_arg_3 == null)))
            {
                return null;
            }
            var _local_4= this.getOverlayIconSprite(k, _arg_2);
            if (_local_4 != null)
            {
                return null;
            }
            _local_4 = new Sprite();
            _local_4.name = _arg_2;
            _local_4.mouseEnabled = false;
            var _local_5= new Bitmap(_arg_3);
            _local_4.addChild(_local_5);
            k.addChild(_local_4);
            return _local_4;
        }

        function removeOverlayIconSprite(k:Sprite, _arg_2:String):Bool
        {
            var _local_4:Sprite = null;
            var _local_5:Bitmap = null;
            if (k == null)
            {
                return false;
            }
            var _local_3= (k.numChildren - 1);
            while (_local_3 >= 0)
            {
                _local_4 = Std.downcast(k.getChildAt(_local_3) , Sprite);
                if (_local_4 != null)
                {
                    if (_local_4.name == _arg_2)
                    {
                        k.removeChildAt(_local_3);
                        _local_5 = Std.downcast(_local_4.getChildAt(0) , Bitmap);
                        if (((!(_local_5 == null)) && (!(_local_5.bitmapData == null))))
                        {
                            _local_5.bitmapData.dispose();
                            _local_5.bitmapData = null;
                        }
                        return true;
                    }
                }
                _local_3--;
            }
            return false;
        }

        function getOverlayIconSprite(k:Sprite, _arg_2:String):Sprite
        {
            var _local_4:Sprite = null;
            if (k == null)
            {
                return null;
            }
            var _local_3= (k.numChildren - 1);
            while (_local_3 >= 0)
            {
                _local_4 = Std.downcast(k.getChildAt(_local_3) , Sprite);
                if (_local_4 != null)
                {
                    if (_local_4.name == _arg_2)
                    {
                        return _local_4;
                    }
                }
                _local_3--;
            }
            return null;
        }

        public function setObjectMoverIconSprite(k:Int, _arg_2:Int, _arg_3:Bool, _arg_4:String=null, _arg_5:IStuffData=null, _arg_6:Int=-1, _arg_7:Int=-1, _arg_8:String=null)
        {
            var _local_11:String = null;
            var _local_12 = 0;
            var _local_13:PetFigureData = null;
            var _local_14:Sprite = null;
            var _local_15:Sprite = null;
            var _local_9:ImageResult = null;
            if (_arg_3)
            {
                _local_9 = this.getRoomObjectImage(this._activeRoomId, k, _arg_2, new Vector3d(), 1, null);
            }
            else
            {
                if (this._roomContentLoader != null)
                {
                    _local_11 = null;
                    _local_12 = 0;
                    if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
                    {
                        _local_11 = this._roomContentLoader.getActiveObjectType(k);
                        _local_12 = this._roomContentLoader.getActiveObjectColorIndex(k);
                    }
                    else
                    {
                        if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                        {
                            _local_11 = this._roomContentLoader.getWallItemType(k, _arg_4);
                            _local_12 = this._roomContentLoader.getWallItemColorIndex(k);
                        }
                    }
                    if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                    {
                        _local_11 = RoomObjectUserTypes.getName(k);
                        if (_local_11 == "pet")
                        {
                            _local_11 = this.getPetType(_arg_4);
                            _local_13 = new PetFigureData(_arg_4);
                            _local_9 = this.getPetImage(_local_13.typeId, _local_13.paletteId, _local_13.color, new Vector3d(180), 64, null, true, 0, _local_13._Str_3542, _arg_8);
                        }
                        else
                        {
                            _local_9 = this.getGenericRoomObjectImage(_local_11, _arg_4, new Vector3d(180), 1, null, 0, null, _arg_5, _arg_6, _arg_7, _arg_8);
                        }
                    }
                    else
                    {
                        _local_9 = this.getGenericRoomObjectImage(_local_11, Std.string(_local_12), new Vector3d(), 1, null, 0, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
                    }
                }
            }
            if (((_local_9 == null) || (_local_9.data == null)))
            {
                return;
            }
            var _local_10= this.getActiveRoomActiveCanvas();
            if (_local_10 != null)
            {
                _local_14 = this.getOverlaySprite(_local_10);
                this.removeOverlayIconSprite(_local_14, OBJECT_ICON_SPRITE);
                _local_15 = this.addOverlayIconSprite(_local_14, OBJECT_ICON_SPRITE, _local_9.data);
                if (_local_15 != null)
                {
                    _local_15.x = (this._activeRoomActiveCanvasMouseX - (_local_9.data.width / 2));
                    _local_15.y = (this._activeRoomActiveCanvasMouseY - (_local_9.data.height / 2));
                }
            }
        }

        public function setObjectMoverIconSpriteVisible(k:Bool)
        {
            var _local_3:Sprite = null;
            var _local_4:Sprite = null;
            var _local_2= this.getActiveRoomActiveCanvas();
            if (_local_2 != null)
            {
                _local_3 = this.getOverlaySprite(_local_2);
                _local_4 = this.getOverlayIconSprite(_local_3, OBJECT_ICON_SPRITE);
                if (_local_4 != null)
                {
                    _local_4.visible = k;
                }
            }
        }

        public function removeObjectMoverIconSprite()
        {
            var _local_2:Sprite = null;
            var k= this.getActiveRoomActiveCanvas();
            if (k != null)
            {
                _local_2 = this.getOverlaySprite(k);
                this.removeOverlayIconSprite(_local_2, OBJECT_ICON_SPRITE);
            }
        }

        public function getRoomObjectCount(k:Int, _arg_2:Int):Int
        {
            if (!this._roomManagerInitialized)
            {
                return 0;
            }
            var _local_3= this.getRoomIdentifier(k);
            var _local_4= this._roomManager.getRoom(_local_3);
            if (_local_4 == null)
            {
                return 0;
            }
            return _local_4.getObjectCount(_arg_2);
        }

        public function getRoomObject(k:Int, _arg_2:Int, _arg_3:Int):IRoomObject
        {
            if (!this._roomManagerInitialized)
            {
                return null;
            }
            var _local_4= this.getRoomIdentifier(k);
            if (k == 0)
            {
                _local_4 = TEMPORARY_ROOM;
            }
            return this.getObject(_local_4, _arg_2, _arg_3);
        }

        public function getObjectsByCategory(k:Int):Array<ASAny>
        {
            var _local_2:IRoomInstance = null;
            if (this._roomManager != null)
            {
                _local_2 = this._roomManager.getRoom(this.getRoomIdentifier(this._activeRoomId));
            }
            if (_local_2 == null)
            {
                return [];
            }
            return _local_2.getObjects(k);
        }

        public function getRoomObjectWithIndex(k:Int, _arg_2:Int, _arg_3:Int):IRoomObject
        {
            if (!this._roomManagerInitialized)
            {
                return null;
            }
            var _local_4= this.getRoomIdentifier(k);
            var _local_5= this._roomManager.getRoom(_local_4);
            if (_local_5 == null)
            {
                return null;
            }
            var _local_6= _local_5.getObjectWithIndex(_arg_2, _arg_3);
            return _local_6;
        }

        public function getRoomObjects(k:Int, _arg_2:Int):Array<ASAny>
        {
            var _local_3:String = null;
            var _local_4:IRoomInstance = null;
            if (this._roomManagerInitialized)
            {
                _local_3 = this.getRoomIdentifier(k);
                _local_4 = this._roomManager.getRoom(_local_3);
                if (_local_4 != null)
                {
                    return _local_4.getObjects(_arg_2);
                }
            }
            return [];
        }

        public function modifyRoomObject(k:Int, _arg_2:Int, _arg_3:String):Bool
        {
            if (this._roomObjectEventHandler != null)
            {
                return this._roomObjectEventHandler.modifyRoomObject(this._activeRoomId, k, _arg_2, _arg_3);
            }
            return false;
        }

        public function modifyRoomObjectDataWithMap(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Map):Bool
        {
            if (this._roomObjectEventHandler != null)
            {
                if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
                {
                    return this._roomObjectEventHandler.modifyRoomObjectData(this._activeRoomId, k, _arg_2, _arg_3, _arg_4);
                }
            }
            return false;
        }

        public function modifyRoomObjectData(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String):Bool
        {
            if (this._roomObjectEventHandler != null)
            {
                if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                {
                    return this._roomObjectEventHandler.modifyWallItemData(this._activeRoomId, k, _arg_3, _arg_4);
                }
            }
            return false;
        }

        public function deleteRoomObject(k:Int, _arg_2:Int):Bool
        {
            if (this._roomObjectEventHandler != null)
            {
                if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                {
                    return this._roomObjectEventHandler.deleteWallItem(this._activeRoomId, k);
                }
            }
            return false;
        }

        public function initializeRoomObjectInsert(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String=null, _arg_6:IStuffData=null, _arg_7:Int=-1, _arg_8:Int=-1, _arg_9:String=null):Bool
        {
            var _local_10= this.getRoom(this._activeRoomId);
            if (((_local_10 == null) || (!(_local_10.getNumber(RoomVariableEnum.ROOM_IS_PUBLIC) == 0))))
            {
                return false;
            }
            if (this._roomObjectEventHandler != null)
            {
                return this._roomObjectEventHandler.initializeRoomObjectInsert(k, this._activeRoomId, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
            }
            return false;
        }

        public function cancelRoomObjectInsert()
        {
            if (this._roomObjectEventHandler != null)
            {
                this._roomObjectEventHandler.cancelRoomObjectInsert(this._activeRoomId);
            }
        }

        public function useRoomObjectInActiveRoom(k:Int, _arg_2:Int):Bool
        {
            var _local_4:IRoomObjectEventHandler = null;
            var _local_3= this.getRoomObject(this._activeRoomId, k, _arg_2);
            if (_local_3 != null)
            {
                _local_4 = Std.downcast(_local_3.getMouseHandler() , IRoomObjectEventHandler);
                if (_local_4 != null)
                {
                    _local_4.useObject();
                    return true;
                }
            }
            return false;
        }

        function getRoomObjectAdURL(k:String):String
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getRoomObjectAdURL(k);
            }
            return "";
        }

        public function setRoomObjectAlias(k:String, _arg_2:String)
        {
            if (this._roomContentLoader != null)
            {
                this._roomContentLoader.setRoomObjectAlias(k, _arg_2);
            }
        }

        public function getRoomObjectCategory(k:String):Int
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getObjectCategory(k);
            }
            return RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN;
        }

        public function getFurnitureType(k:Int):String
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getActiveObjectType(k);
            }
            return "";
        }

        public function getFurnitureTypeId(k:String):Int
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getActiveObjectTypeId(k);
            }
            return 0;
        }

        public function getWallItemType(k:Int, _arg_2:String=null):String
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getWallItemType(k, _arg_2);
            }
            return "";
        }

        public function getPetTypeId(k:String):Int
        {
            var _local_3:Array<ASAny> = null;
            var _local_2= -1;
            if (k != null)
            {
                _local_3 = (cast k.split(" "));
                if (_local_3.length > 1)
                {
                    _local_2 = ASCompat.parseInt(_local_3[0]);
                }
            }
            return _local_2;
        }

        function getPetType(k:String):String
        {
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            if (k != null)
            {
                _local_2 = (cast k.split(" "));
                if (_local_2.length > 1)
                {
                    _local_3 = ASCompat.parseInt(_local_2[0]);
                    if (this._roomContentLoader != null)
                    {
                        return this._roomContentLoader.getPetType(_local_3);
                    }
                    return "pet";
                }
            }
            return null;
        }

        public function getPetColor(k:Int, _arg_2:Int):PetColorResult
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getPetColor(k, _arg_2);
            }
            return null;
        }

        public function getPetColorsByTag(k:Int, _arg_2:String):Array<ASAny>
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getPetColorsByTag(k, _arg_2);
            }
            return null;
        }

        public function getPetLayerIdForTag(k:Int, _arg_2:String):Int
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getPetLayerIdForTag(k, _arg_2);
            }
            return -1;
        }

        public function getPetDefaultPalette(k:Int, _arg_2:String):PetColorResult
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getPetDefaultPalette(k, _arg_2);
            }
            return null;
        }

        function getFurnitureColorIndex(k:Int):Int
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getActiveObjectColorIndex(k);
            }
            return 0;
        }

        function getWallItemColorIndex(k:Int):Int
        {
            if (this._roomContentLoader != null)
            {
                return this._roomContentLoader.getWallItemColorIndex(k);
            }
            return 0;
        }

        public function getSelectionArrow(k:Int):IRoomObjectController
        {
            return this.getObject(this.getRoomIdentifier(k), OBJECT_ID_SELECTION_ARROW, RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR);
        }

        public function getTileCursor(k:Int):IRoomObjectController
        {
            return this.getObject(this.getRoomIdentifier(k), OBJECT_ID_ROOM_HIGHLIGHTER, RoomObjectCategoryEnum.OBJECT_CATEGORY_CURSOR);
        }

        public function setTileCursorState(k:Int, _arg_2:Int)
        {
            var _local_4:RoomObjectDataUpdateMessage = null;
            var _local_3= this.getTileCursor(k);
            if (((!(_local_3 == null)) && (!(_local_3.getEventHandler() == null))))
            {
                _local_4 = new RoomObjectDataUpdateMessage(_arg_2, null);
                _local_3.getEventHandler().processUpdateMessage(_local_4);
            }
        }

        public function toggleTileCursorVisibility(k:Int, _arg_2:Bool)
        {
            var _local_4:RoomObjectTileCursorUpdateMessage = null;
            var _local_3= this.getTileCursor(k);
            if (((!(_local_3 == null)) && (!(_local_3.getEventHandler() == null))))
            {
                _local_4 = new RoomObjectTileCursorUpdateMessage(null, 0, _arg_2, "", true);
                _local_3.getEventHandler().processUpdateMessage(_local_4);
            }
        }

        public function addObjectFurniture(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:IStuffData, _arg_8:Float=null, _arg_9:Int=-1, _arg_10:Int=0, _arg_11:Int=0, _arg_12:String="", _arg_13:Bool=true, _arg_14:Bool=true, _arg_15:Float=-1):Bool
{
            if (_arg_8 == null) _arg_8 = Math.NaN;
            var _local_17:FurnitureData = null;
            var _local_16= this.getRoomInstanceData(k);
            if (_local_16 != null)
            {
                _local_17 = new FurnitureData(_arg_2, _arg_3, null, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14, _arg_15);
                _local_16.addFurnitureData(_local_17);
            }
            return true;
        }

        public function addObjectFurnitureByName(k:Int, _arg_2:Int, _arg_3:String, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:IStuffData, _arg_8:Float=null):Bool
{
            if (_arg_8 == null) _arg_8 = Math.NaN;
            var _local_11:FurnitureData = null;
            var _local_9= this.getWorldType(k);
            var _local_10= this.getRoomInstanceData(k);
            var _local_12:String = null;
            if ((this.isPublicRoom(k) && (!(_local_9 == null)) && (!(_arg_3 == null))))
            {
                _local_12 = this.getPublicRoomContentType(_local_9);
                if (((!(_local_12 == null)) && (_local_12.length > 0) && (!(_arg_3.indexOf((_local_12 + "_")) == 0))))
                {
                    _arg_3 = ((_local_12 + "_") + _arg_3);
                }
            }
            if (_local_10 != null)
            {
                _local_11 = new FurnitureData(_arg_2, 0, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, 0);
                _local_10.addFurnitureData(_local_11);
            }
            return true;
        }

        function addObjectFurnitureFromData(k:Int, _arg_2:Int, _arg_3:FurnitureData):Bool
        {
            var _local_10:RoomInstanceData = null;
            if (_arg_3 == null)
            {
                _local_10 = this.getRoomInstanceData(k);
                if (_local_10 != null)
                {
                    _arg_3 = _local_10.getFurnitureDataWithId(_arg_2);
                }
            }
            if (_arg_3 == null)
            {
                return false;
            }
            var _local_4 = false;
            var _local_5= _arg_3.type;
            if (_local_5 == null)
            {
                _local_5 = this.getFurnitureType(_arg_3.typeId);
                _local_4 = true;
            }
            var _local_6= this.getFurnitureColorIndex(_arg_3.typeId);
            var _local_7= this.getRoomObjectAdURL(_local_5);
            if (_local_5 == null)
            {
                _local_5 = "";
            }
            var _local_8= this.createObjectFurniture(k, _arg_2, _local_5);
            if (_local_8 == null)
            {
                return false;
            }
            if ((((!(_local_8 == null)) && (!(_local_8.getModelController() == null))) && _local_4))
            {
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_COLOR, _local_6, true);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID, _arg_3.typeId, true);
                _local_8.getModelController().setString(RoomObjectVariableEnum.FURNITURE_AD_URL, _local_7, true);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT, (_arg_3.realRoomObject ? 1 : 0), false);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRY_TIME, _arg_3.expiryTime);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRTY_TIMESTAMP, flash.Lib.getTimer());
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_USAGE_POLICY, _arg_3.usagePolicy);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID, _arg_3.ownerId);
                _local_8.getModelController().setString(RoomObjectVariableEnum.FURNITURE_OWNER_NAME, _arg_3.ownerName);
            }
            this.applyCurrentInvisibleFurniState(k, _local_8);
            if (!this.updateObjectFurniture(k, _arg_2, _arg_3.loc, _arg_3.dir, _arg_3.state, _arg_3.data, _arg_3.extra))
            {
                return false;
            }
            if (_arg_3.sizeZ >= 0)
            {
                if (!this.updateObjectFurnitureHeight(k, _arg_2, _arg_3.sizeZ))
                {
                    return false;
                }
            }
            if (events != null)
            {
                events.dispatchEvent(new RoomEngineObjectEvent(RoomEngineObjectEvent.ADDED, k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE));
            }
            var _local_9= this.getPlacedObjectData(k);
            if ((((_local_9 != null) && (Math.abs(_local_9.id) == _arg_2)) && (_local_9.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)))
            {
                this.selectRoomObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            }
            if ((_local_8.isInitialized() && _arg_3.synchronized))
            {
                this.addObjectToTileMap(k, _local_8);
            }
            return true;
        }

        public function changeObjectState(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_5 = Math.NaN;
            var _local_6 = 0;
            var _local_7:IStuffData = null;
            var _local_8:RoomObjectDataUpdateMessage = null;
            var _local_4= this.getObject(this.getRoomIdentifier(k), _arg_2, _arg_3);
            if (((!(_local_4 == null)) && (!(_local_4.getModelController() == null))))
            {
                _local_5 = _local_4.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_AUTOMATIC_STATE_INDEX);
                if (Math.isNaN(_local_5))
                {
                    _local_5 = 1;
                }
                else
                {
                    _local_5 = (_local_5 + 1);
                }
                _local_4.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AUTOMATIC_STATE_INDEX, _local_5);
                _local_6 = Std.int(_local_4.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT));
                _local_7 = StuffDataFactory.getStuffDataWrapperForType(_local_6);
                _local_7.initializeFromRoomObjectModel(_local_4.getModel());
                _local_8 = new RoomObjectDataUpdateMessage(Std.int(_local_5), _local_7);
                if (_local_4.getEventHandler() != null)
                {
                    _local_4.getEventHandler().processUpdateMessage(_local_8);
                }
            }
        }

        public function changeObjectModelData(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Int):Bool
        {
            var _local_7:RoomObjectModelDataUpdateMessage = null;
            var _local_6= this.getObject(this.getRoomIdentifier(k), _arg_2, _arg_3);
            if (_local_6 == null)
            {
                return false;
            }
            if (((!(_local_6 == null)) && (!(_local_6.getEventHandler() == null))))
            {
                _local_7 = new RoomObjectModelDataUpdateMessage(_arg_4, _arg_5);
                _local_6.getEventHandler().processUpdateMessage(_local_7);
            }
            return true;
        }

        public function updateObjectFurniture(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Int, _arg_6:IStuffData, _arg_7:Float=null):Bool
{
            if (_arg_7 == null) _arg_7 = Math.NaN;
            var _local_8= this.getObjectFurniture(k, _arg_2);
            if (_local_8 == null)
            {
                return false;
            }
            var _local_9= new RoomObjectUpdateMessage(_arg_3, _arg_4);
            var _local_10= new RoomObjectDataUpdateMessage(_arg_5, _arg_6, _arg_7);
            if (((!(_local_8 == null)) && (!(_local_8.getEventHandler() == null))))
            {
                _local_8.getEventHandler().processUpdateMessage(_local_9);
                _local_8.getEventHandler().processUpdateMessage(_local_10);
                if (events != null)
                {
                    events.dispatchEvent(new RoomEngineObjectEvent(
                        RoomEngineObjectEvent.UPDATED, k, _arg_2,
                        RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE));
                }
            }
            return true;
        }

        public function updateObjectFurnitureHeight(k:Int, _arg_2:Int, _arg_3:Float):Bool
        {
            var _local_5:RoomObjectHeightUpdateMessage = null;
            var _local_4= this.getObjectFurniture(k, _arg_2);
            if (_local_4 == null)
            {
                return false;
            }
            if (((!(_local_4 == null)) && (!(_local_4.getEventHandler() == null))))
            {
                _local_5 = new RoomObjectHeightUpdateMessage(null, null, _arg_3);
                _local_4.getEventHandler().processUpdateMessage(_local_5);
            }
            return true;
        }

        public function updateObjectFurnitureLocation(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:IVector3d=null, _arg_6:Float=null, _arg_7:Float=null, _arg_8:Float=null):Bool
{
            if (_arg_6 == null) _arg_6 = Math.NaN;
            if (_arg_7 == null) _arg_7 = Math.NaN;
            if (_arg_8 == null) _arg_8 = Math.NaN;
            var _local_9:RoomObjectMoveUpdateMessage = null;
            var _local_10= this.getObjectFurniture(k, _arg_2);
            if (_local_10 == null)
            {
                return false;
            }
            if (((!(_local_10 == null)) && (!(_local_10.getEventHandler() == null))))
            {
                _local_9 = new RoomObjectMoveUpdateMessage(_arg_3, _arg_5, _arg_4, _arg_6, (!(_arg_5 == null)), false, _arg_7, _arg_8);
                _local_10.getEventHandler().processUpdateMessage(_local_9);
            }
            return true;
        }

        public function updateObjectFurnitureExpiryTime(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            var _local_4= this.getObjectFurniture(k, _arg_2);
            if (_local_4 == null)
            {
                return false;
            }
            _local_4.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRY_TIME, _arg_3);
            _local_4.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRTY_TIMESTAMP, flash.Lib.getTimer());
            return true;
        }

        function createObjectFurniture(k:Int, _arg_2:Int, _arg_3:String):IRoomObjectController
        {
            var _local_4= RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
            var _local_5= this.createObject(this.getRoomIdentifier(k), _arg_2, _arg_3, _local_4);
            return _local_5;
        }

        function getObjectFurniture(k:Int, _arg_2:Int):IRoomObjectController
        {
            return this.getObject(this.getRoomIdentifier(k), _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
        }

        public function disposeObjectFurniture(k:Int, _arg_2:Int, _arg_3:Int=-1, _arg_4:Bool=false)
        {
            var _local_6:IRoomObject = null;
            var _local_7:Point = null;
            var _local_8:IRoomObjectModel = null;
            var _local_9 = false;
            var _local_10 = 0;
            var _local_11:String = null;
            var _local_12 = 0;
            var _local_13:IStuffData = null;
            var _local_14:BitmapData = null;
            var _local_5= this.getRoomInstanceData(k);
            if (_local_5 != null)
            {
                _local_5.getFurnitureDataWithId(_arg_2);
            }
            if ((((this._sessionDataManager != null) && (_arg_3 == this._sessionDataManager.userId)) && (!_Str_6093._Str_7070(_arg_2))))
            {
                _local_6 = this.getRoomObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                if (_local_6 != null)
                {
                    _local_7 = this.getRoomObjectScreenLocation(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, this._activeRoomActiveCanvas);
                    if (_local_7 != null)
                    {
                        _local_8 = _local_6.getModel();
                        _local_9 = (_local_8.getNumber(RoomObjectVariableEnum.FURNITURE_DISABLE_PICKING_ANIMATION) == 1);
                        if (!_local_9)
                        {
                            _local_10 = Std.int(_local_8.getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                            _local_11 = _local_8.getString(RoomObjectVariableEnum.FURNITURE_EXTRAS);
                            _local_12 = Std.int(_local_8.getNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT));
                            _local_13 = StuffDataFactory.getStuffDataWrapperForType(_local_12);
                            _local_14 = this.getFurnitureIcon(_local_10, null, _local_11, _local_13).data;
                            if (_local_14 != null)
                            {
                                this._toolbar.createTransitionToIcon(HabboToolbarIconEnum.INVENTORY, _local_14, Std.int(_local_7.x), Std.int(_local_7.y));
                            }
                        }
                    }
                }
            }
            this.disposeObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            this.removeButtonMouseCursorOwner(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, _arg_2);
            if (_arg_4)
            {
                this.refreshTileObjectMap(k, "RoomEngine.disposeObjectFurniture()");
            }
        }

        public function addObjectWallItem(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:Int, _arg_7:String, _arg_8:Int=0, _arg_9:Int=0, _arg_10:String="", _arg_11:Int=-1, _arg_12:Bool=true):Bool
        {
            var _local_14:LegacyStuffData = null;
            var _local_15:FurnitureData = null;
            var _local_13= this.getRoomInstanceData(k);
            if (_local_13 != null)
            {
                _local_14 = new LegacyStuffData();
                _local_14.setString(_arg_7);
                _local_15 = new FurnitureData(_arg_2, _arg_3, null, _arg_4, _arg_5, _arg_6, _local_14, Math.NaN, _arg_11, _arg_8, _arg_9, _arg_10, true, _arg_12);
                _local_13.addWallItemData(_local_15);
            }
            return true;
        }

        function addObjectWallItemFromData(k:Int, _arg_2:Int, _arg_3:FurnitureData):Bool
        {
            var _local_10:RoomInstanceData = null;
            if (_arg_3 == null)
            {
                _local_10 = this.getRoomInstanceData(k);
                if (_local_10 != null)
                {
                    _arg_3 = _local_10.getWallItemDataWithId(_arg_2);
                }
            }
            if (_arg_3 == null)
            {
                return false;
            }
            var _local_4= "";
            if (_arg_3.data != null)
            {
                _local_4 = _arg_3.data.getLegacyString();
            }
            var _local_5= this.getWallItemType(_arg_3.typeId, _local_4);
            var _local_6= this.getWallItemColorIndex(_arg_3.typeId);
            var _local_7= this.getRoomObjectAdURL(_local_5);
            if (_local_5 == null)
            {
                _local_5 = "";
            }
            var _local_8= this.createObjectWallItem(k, _arg_2, _local_5);
            if (_local_8 == null)
            {
                return false;
            }
            if (((!(_local_8 == null)) && (!(_local_8.getModelController() == null))))
            {
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_COLOR, _local_6, false);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID, _arg_3.typeId, true);
                _local_8.getModelController().setString(RoomObjectVariableEnum.FURNITURE_AD_URL, _local_7, true);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT, (_arg_3.realRoomObject ? 1 : 0), false);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.OBJECT_ACCURATE_Z_VALUE, 1, true);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_USAGE_POLICY, _arg_3.usagePolicy);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRY_TIME, _arg_3.expiryTime);
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRTY_TIMESTAMP, flash.Lib.getTimer());
                _local_8.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID, _arg_3.ownerId);
                _local_8.getModelController().setString(RoomObjectVariableEnum.FURNITURE_OWNER_NAME, _arg_3.ownerName);
            }
            this.applyCurrentInvisibleFurniState(k, _local_8);
            _local_4 = "";
            if (_arg_3.data != null)
            {
                _local_4 = _arg_3.data.getLegacyString();
            }
            if (!this.updateObjectWallItem(k, _arg_2, _arg_3.loc, _arg_3.dir, _arg_3.state, _local_4))
            {
                return false;
            }
            if (events != null)
            {
                events.dispatchEvent(new RoomEngineObjectEvent(RoomEngineObjectEvent.ADDED, k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM));
            }
            var _local_9= this.getPlacedObjectData(k);
            if ((((_local_9 != null) && (_local_9.id == _arg_2)) && (_local_9.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)))
            {
                this.selectRoomObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            }
            return true;
        }

        public function updateObjectWallItem(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Int, _arg_6:String):Bool
        {
            var _local_7= this.getObjectWallItem(k, _arg_2);
            if (_local_7 == null)
            {
                return false;
            }
            var _local_8= new RoomObjectUpdateMessage(_arg_3, _arg_4);
            var _local_9= new LegacyStuffData();
            _local_9.setString(_arg_6);
            var _local_10= new RoomObjectDataUpdateMessage(_arg_5, _local_9);
            if (((!(_local_7 == null)) && (!(_local_7.getEventHandler() == null))))
            {
                _local_7.getEventHandler().processUpdateMessage(_local_8);
                _local_7.getEventHandler().processUpdateMessage(_local_10);
            }
            this.updateObjectRoomWindow(k, _arg_2);
            return true;
        }

        public function updateObjectRoomWindow(k:Int, _arg_2:Int, _arg_3:Bool=true)
        {
            var _local_8:String = null;
            var _local_9:IVector3d = null;
            var _local_4= ((Std.string(RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM) + "_") + Std.string(_arg_2));
            var _local_5:RoomObjectRoomMaskUpdateMessage = null;
            var _local_6= this.getObjectWallItem(k, _arg_2);
            if (_local_6 != null)
            {
                if (_local_6.getModel() != null)
                {
                    if (_local_6.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_USES_PLANE_MASK) > 0)
                    {
                        _local_8 = _local_6.getModel().getString(RoomObjectVariableEnum.FURNITURE_PLANE_MASK_TYPE);
                        _local_9 = _local_6.getLocation();
                        if (_arg_3)
                        {
                            _local_5 = new RoomObjectRoomMaskUpdateMessage(RoomObjectRoomMaskUpdateMessage.RORMUM_ADD_MASK, _local_4, _local_8, _local_9);
                        }
                        else
                        {
                            _local_5 = new RoomObjectRoomMaskUpdateMessage(RoomObjectRoomMaskUpdateMessage.REMOVE_MASK, _local_4);
                        }
                    }
                }
            }
            else
            {
                _local_5 = new RoomObjectRoomMaskUpdateMessage(RoomObjectRoomMaskUpdateMessage.REMOVE_MASK, _local_4);
            }
            var _local_7= this.getObjectRoom(k);
            if ((((!(_local_7 == null)) && (!(_local_7.getEventHandler() == null))) && (!(_local_5 == null))))
            {
                _local_7.getEventHandler().processUpdateMessage(_local_5);
            }
        }

        public function updateObjectWallItemData(k:Int, _arg_2:Int, _arg_3:String):Bool
        {
            var _local_4= this.getObjectWallItem(k, _arg_2);
            if (_local_4 == null)
            {
                return false;
            }
            var _local_5= new RoomObjectItemDataUpdateMessage(_arg_3);
            if (((!(_local_4 == null)) && (!(_local_4.getEventHandler() == null))))
            {
                _local_4.getEventHandler().processUpdateMessage(_local_5);
            }
            return true;
        }

        function createObjectWallItem(k:Int, _arg_2:Int, _arg_3:String):IRoomObjectController
        {
            var _local_4= RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
            var _local_5= this.createObject(this.getRoomIdentifier(k), _arg_2, _arg_3, _local_4);
            return _local_5;
        }

        function getObjectWallItem(k:Int, _arg_2:Int):IRoomObjectController
        {
            return this.getObject(this.getRoomIdentifier(k), _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
        }

        public function updateObjectWallItemLocation(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d=null, _arg_5:Float=null):Bool
{
            if (_arg_5 == null) _arg_5 = Math.NaN;
            var _local_6:RoomObjectMoveUpdateMessage = null;
            var _local_7= this.getObjectWallItem(k, _arg_2);
            if (_local_7 == null)
            {
                return false;
            }
            if (_local_7.getEventHandler() != null)
            {
                _local_6 = new RoomObjectMoveUpdateMessage(_arg_3, _arg_4, null, _arg_5, (!(_arg_4 == null)));
                _local_7.getEventHandler().processUpdateMessage(_local_6);
            }
            this.updateObjectRoomWindow(k, _arg_2);
            return true;
        }

        public function updateObjectWallItemExpiryTime(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            var _local_4= this.getObjectWallItem(k, _arg_2);
            if (_local_4 == null)
            {
                return false;
            }
            _local_4.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRY_TIME, _arg_3);
            _local_4.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_EXPIRTY_TIMESTAMP, flash.Lib.getTimer());
            return true;
        }

        public function disposeObjectWallItem(k:Int, _arg_2:Int, _arg_3:Int=-1)
        {
            var _local_5:IRoomObject = null;
            var _local_6:Point = null;
            var _local_7:IRoomObjectModel = null;
            var _local_8 = 0;
            var _local_9:String = null;
            var _local_10:BitmapData = null;
            var _local_4= this.getRoomInstanceData(k);
            if (_local_4 != null)
            {
                _local_4.getWallItemDataWithId(_arg_2);
            }
            if ((((this._sessionDataManager != null) && (_arg_3 == this._sessionDataManager.userId)) && (!_Str_6093._Str_7070(_arg_2))))
            {
                _local_5 = this.getRoomObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
                if ((((_local_5 != null) && (_local_5.getType().indexOf("post_it") == -1)) && (_local_5.getType().indexOf("external_image_wallitem") == -1)))
                {
                    _local_6 = this.getRoomObjectScreenLocation(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM, this._activeRoomActiveCanvas);
                    _local_7 = _local_5.getModel();
                    _local_8 = Std.int(_local_7.getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                    _local_9 = _local_7.getString(RoomObjectVariableEnum.FURNITURE_DATA);
                    _local_10 = this.getWallItemIcon(_local_8, null, _local_9).data;
                    if (((this._toolbar != null) && (_local_6 != null)))
                    {
                        this._toolbar.createTransitionToIcon(HabboToolbarIconEnum.INVENTORY, _local_10, Std.int(_local_6.x), Std.int(_local_6.y));
                    }
                }
            }
            this.disposeObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            this.updateObjectRoomWindow(k, _arg_2, false);
            this.removeButtonMouseCursorOwner(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM, _arg_2);
        }

        public function addObjectUser(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Float, _arg_6:Int, _arg_7:String=null):Bool
        {
            var _local_10:RoomObjectUpdateMessage = null;
            var _local_11:RoomObjectAvatarFigureUpdateMessage = null;
            if (this.getObjectUser(k, _arg_2) != null)
            {
                return false;
            }
            var _local_8= RoomObjectUserTypes.getName(_arg_6);
            if (_local_8 == RoomObjectUserTypes.PET)
            {
                _local_8 = this.getPetType(_arg_7);
            }
            var _local_9= this.createObjectUser(k, _arg_2, _local_8);
            if (_local_9 == null)
            {
                return false;
            }
            if (((!(_local_9 == null)) && (!(_local_9.getEventHandler() == null))))
            {
                _local_10 = new RoomObjectAvatarUpdateMessage(this.fixedUserLocation(k, _arg_3), null, _arg_4, Std.int(_arg_5), false, 0);
                _local_9.getEventHandler().processUpdateMessage(_local_10);
                if (_arg_7 != null)
                {
                    _local_11 = new RoomObjectAvatarFigureUpdateMessage(_arg_7);
                    _local_9.getEventHandler().processUpdateMessage(_local_11);
                }
            }
            if (events != null)
            {
                events.dispatchEvent(new RoomEngineObjectEvent(RoomEngineObjectEvent.ADDED, k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER));
            }
            return true;
        }

        public function updateObjectUser(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:Bool=false, _arg_6:Float=0, _arg_7:IVector3d=null, _arg_8:Float=null, _arg_9:Float=null, _arg_10:Bool=false, _arg_11:Float=null):Bool
{
            if (_arg_8 == null) _arg_8 = Math.NaN;
            if (_arg_9 == null) _arg_9 = Math.NaN;
            if (_arg_11 == null) _arg_11 = Math.NaN;
            var _local_9= this.getObjectUser(k, _arg_2);
            if ((((_local_9 == null) || (_local_9.getEventHandler() == null)) || (_local_9.getModel() == null)))
            {
                return false;
            }
            if (_arg_3 == null)
            {
                _arg_3 = _local_9.getLocation();
            }
            if (_arg_7 == null)
            {
                _arg_7 = _local_9.getDirection();
            }
            if (Math.isNaN(_arg_8))
            {
                _arg_8 = _local_9.getModel().getNumber(RoomObjectVariableEnum.HEAD_DIRECTION);
            }
            var _local_10:RoomObjectUpdateMessage = new RoomObjectAvatarUpdateMessage(this.fixedUserLocation(k, _arg_3), this.fixedUserLocation(k, _arg_4), _arg_7, Std.int(_arg_8), _arg_5, _arg_6, _arg_9, _arg_10, _arg_11);
            _local_9.getEventHandler().processUpdateMessage(_local_10);
            if ((((this.roomSessionManager != null) && (this.roomSessionManager.getSession(k) != null)) && (_arg_2 == this.roomSessionManager.getSession(k).ownUserRoomId)))
            {
                this._roomObjectFactory.events.dispatchEvent(new RoomToObjectOwnAvatarMoveEvent(RoomToObjectOwnAvatarMoveEvent.ROAME_MOVE_TO, _arg_4));
            }
            return true;
        }

        public function updateObjectUserDir(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:Float):Bool
        {
            var _local_5= this.getObjectUser(k, _arg_2);
            if ((((_local_5 == null) || (_local_5.getEventHandler() == null)) || (_local_5.getModel() == null)))
            {
                return false;
            }
            var _local_6:RoomObjectUpdateMessage = new RoomObjectAvatarDirectionUpdateMessage(null, _arg_3, Std.int(_arg_4));
            _local_5.getEventHandler().processUpdateMessage(_local_6);
            return true;
        }

        public function updateObjectUserFlatControl(k:Int, _arg_2:Int, _arg_3:String):Bool
        {
            var _local_4= this.getObjectUser(k, _arg_2);
            if (((_local_4 == null) || (_local_4.getEventHandler() == null)))
            {
                return false;
            }
            var _local_5:RoomObjectUpdateStateMessage = new RoomObjectAvatarFlatControlUpdateMessage(_arg_3);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            return true;
        }

        public function updateObjectUserOwnUserAvatar(k:Int, _arg_2:Int):Bool
        {
            var _local_3= this.getObjectUser(k, _arg_2);
            if (((_local_3 == null) || (_local_3.getEventHandler() == null)))
            {
                return false;
            }
            var _local_4:RoomObjectUpdateMessage = new RoomObjectAvatarOwnMessage();
            _local_3.getEventHandler().processUpdateMessage(_local_4);
            return true;
        }

        public function updateObjectUserFigure(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String=null, _arg_5:String=null, _arg_6:Bool=false):Bool
        {
            var _local_7= this.getObjectUser(k, _arg_2);
            if (((_local_7 == null) || (_local_7.getEventHandler() == null)))
            {
                return false;
            }
            var _local_8:RoomObjectUpdateStateMessage = new RoomObjectAvatarFigureUpdateMessage(_arg_3, _arg_4, _arg_5, _arg_6);
            _local_7.getEventHandler().processUpdateMessage(_local_8);
            return true;
        }

        public function updateObjectUserAction(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:String=null):Bool
        {
            var _local_6= this.getObjectUser(k, _arg_2);
            if (((_local_6 == null) || (_local_6.getEventHandler() == null)))
            {
                return false;
            }
            var _local_7:RoomObjectUpdateStateMessage = null;
            switch (_arg_3)
            {
                case RoomObjectVariableEnum.FIGURE_TALK:
                    _local_7 = new RoomObjectAvatarChatUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_SLEEP:
                    _local_7 = new RoomObjectAvatarSleepUpdateMessage((!(_arg_4 == 0)));
                    
                case RoomObjectVariableEnum.FIGURE_IS_TYPING:
                    _local_7 = new RoomObjectAvatarTypingUpdateMessage((!(_arg_4 == 0)));
                    
                case RoomObjectVariableEnum.FIGURE_IS_MUTED:
                    _local_7 = new RoomObjectAvatarMutedUpdateMessage((!(_arg_4 == 0)));
                    
                case RoomObjectVariableEnum.FIGURE_CARRY_OBJECT:
                    _local_7 = new RoomObjectAvatarCarryObjectUpdateMessage(_arg_4, _arg_5);
                    
                case RoomObjectVariableEnum.FIGURE_USE_OBJECT:
                    _local_7 = new RoomObjectAvatarUseObjectUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_DANCE:
                    _local_7 = new RoomObjectAvatarDanceUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_GAINED_EXPERIENCE:
                    _local_7 = new RoomObjectAvatarExperienceUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_NUMBER_VALUE:
                    _local_7 = new RoomObjectAvatarPlayerValueUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_SIGN:
                    _local_7 = new RoomObjectAvatarSignUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_EXPRESSION:
                    _local_7 = new RoomObjectAvatarExpressionUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME:
                    _local_7 = new RoomObjectAvatarPlayingGameMessage((!(_arg_4 == 0)));
                    
                case RoomObjectVariableEnum.FIGURE_GUIDE_STATUS:
                    _local_7 = new RoomObjectAvatarGuideStatusUpdateMessage(_arg_4);
                    
                case RoomObjectVariableEnum.FIGURE_HABBICON:
                    _local_7 = new RoomObjectAvatarHabbiconUpdateMessage(_arg_4);
                    
            }
            if (_local_7 == null)
            {
                return false;
            }
            _local_6.getEventHandler().processUpdateMessage(_local_7);
            return true;
        }

        /** Aggregates independent click-through owners (Wired, object-moving, etc.). */
        public function setClickSettings(k:String, _arg_2:Bool, _arg_3:Bool)
        {
            var _local_4= this.clickThroughUsers;
            var _local_5= this.clickThroughFurni;
            this.setClickSettingOwner(this._clickThroughUserOwners, k, _arg_2);
            this.setClickSettingOwner(this._clickThroughFurniOwners, k, _arg_3);
            if ((!_local_4) && _arg_2)
            {
                this.removeButtonMouseCursorOwners(
                    this._activeRoomId,
                    RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            }
            if ((!_local_5) && _arg_3)
            {
                this.removeButtonMouseCursorOwners(
                    this._activeRoomId,
                    RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                this.removeButtonMouseCursorOwners(
                    this._activeRoomId,
                    RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            }
        }

        public var clickThroughUsers(get,never):Bool;
public function  get_clickThroughUsers():Bool
        {
            return this._clickThroughUserOwners.length > 0;
        }

        public var clickThroughFurni(get,never):Bool;
public function  get_clickThroughFurni():Bool
        {
            return this._clickThroughFurniOwners.length > 0;
        }

        function setClickSettingOwner(k:Array<ASAny>, _arg_2:String, _arg_3:Bool)
        {
            var _local_4= k.indexOf(_arg_2);
            if (_arg_3)
            {
                if (_local_4 < 0)
                {
                    k.push(_arg_2);
                }
            }
            else if (_local_4 >= 0)
            {
                k.splice(_local_4, 1);
            }
        }

        function removeButtonMouseCursorOwners(k:Int, _arg_2:Int)
        {
            var _local_3= this.getRoomInstanceData(k);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4:Array<ASAny> = [];
            var _local_5:String = null;
            final _iter_ = _local_3.mouseButtonCursorOwners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (_local_5.indexOf((Std.string(_arg_2) + "_")) == 0)
                {
                    _local_4.push(_local_5);
                }
            }
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_5  = _tmp_;
                if (_local_3.removeButtonMouseCursorOwner(_local_5))
                {
                    this._mouseCursorUpdate = true;
                }
            }
        }

        public function updateObjectUserPosture(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String=""):Bool
        {
            var _local_5= this.getObjectUser(k, _arg_2);
            if (((_local_5 == null) || (_local_5.getEventHandler() == null)))
            {
                return false;
            }
            var _local_6:RoomObjectUpdateStateMessage = new RoomObjectAvatarPostureUpdateMessage(_arg_3, _arg_4);
            _local_5.getEventHandler().processUpdateMessage(_local_6);
            return true;
        }

        public function updateObjectUserGesture(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            var _local_4= this.getObjectUser(k, _arg_2);
            if (((_local_4 == null) || (_local_4.getEventHandler() == null)))
            {
                return false;
            }
            var _local_5:RoomObjectUpdateStateMessage = new RoomObjectAvatarGestureUpdateMessage(_arg_3);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            return true;
        }

        public function updateObjectPetGesture(k:Int, _arg_2:Int, _arg_3:String):Bool
        {
            var _local_4= this.getObjectUser(k, _arg_2);
            if (((_local_4 == null) || (_local_4.getEventHandler() == null)))
            {
                return false;
            }
            var _local_5:RoomObjectUpdateStateMessage = new RoomObjectAvatarPetGestureUpdateMessage(_arg_3);
            _local_4.getEventHandler().processUpdateMessage(_local_5);
            return true;
        }

        public function updateObjectUserEffect(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int=0):Bool
        {
            var _local_5= this.getObjectUser(k, _arg_2);
            if (((_local_5 == null) || (_local_5.getEventHandler() == null)))
            {
                return false;
            }
            _local_5.getEventHandler().processUpdateMessage(new RoomObjectAvatarEffectUpdateMessage(_arg_3, _arg_4));
            return true;
        }

        function createObjectUser(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int=RoomObjectCategoryEnum.OBJECT_CATEGORY_USER):IRoomObjectController
        {
            var _local_5= this.createObject(this.getRoomIdentifier(k), _arg_2, _arg_3, _arg_4);
            return _local_5;
        }

        function getObjectUser(k:Int, _arg_2:Int):IRoomObjectController
        {
            return this.getObject(this.getRoomIdentifier(k), _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
        }

        public function disposeObjectUser(k:Int, _arg_2:Int)
        {
            this.disposeObject(k, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
        }

        function createObject(k:String, _arg_2:Int, _arg_3:String, _arg_4:Int):IRoomObjectController
        {
            var _local_5= this._roomManager.getRoom(k);
            if (_local_5 == null)
            {
                return null;
            }
            var _local_6:IRoomObjectController = null;
            _local_6 = Std.downcast(_local_5.createRoomObject(_arg_2, _arg_3, _arg_4) , IRoomObjectController);
            return _local_6;
        }

        function getObject(k:String, _arg_2:Int, _arg_3:Int):IRoomObjectController
        {
            var _local_4:IRoomInstance = null;
            if (this._roomManager != null)
            {
                _local_4 = this._roomManager.getRoom(k);
            }
            if (_local_4 == null)
            {
                return null;
            }
            var _local_5:IRoomObjectController = null;
            _local_5 = Std.downcast(_local_4.getObject(_arg_2, _arg_3) , IRoomObjectController);
            if (_local_5 == null)
            {
                if (_arg_3 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
                {
                    this.addObjectFurnitureFromData(this.getRoomId(k), _arg_2, null);
                    _local_5 = Std.downcast(_local_4.getObject(_arg_2, _arg_3) , IRoomObjectController);
                }
                else
                {
                    if (_arg_3 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                    {
                        this.addObjectWallItemFromData(this.getRoomId(k), _arg_2, null);
                        _local_5 = Std.downcast(_local_4.getObject(_arg_2, _arg_3) , IRoomObjectController);
                    }
                }
            }
            return _local_5;
        }

        function disposeObject(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_4:IRoomInstance = null;
            if (this._roomManager != null)
            {
                _local_4 = this.getRoom(k);
                if (_local_4 == null)
                {
                    return;
                }
                if (_local_4.disposeObject(_arg_2, _arg_3))
                {
                    if (events != null)
                    {
                        events.dispatchEvent(new RoomEngineObjectEvent(RoomEngineObjectEvent.REMOVED, k, _arg_2, _arg_3));
                    }
                }
            }
        }

        function roomObjectEventHandler(k:RoomObjectEvent)
        {
            var _local_2:String = null;
            var _local_3 = 0;
            if (this._roomObjectEventHandler != null)
            {
                _local_2 = this.getRoomObjectRoomIdentifier(k.object);
                if (_local_2 != null)
                {
                    _local_3 = this.getRoomId(_local_2);
                    this._roomObjectEventHandler.handleRoomObjectEvent(k, _local_3);
                }
            }
        }

        function getRoomObjectRoomIdentifier(k:IRoomObject):String
        {
            if (((!(k == null)) && (!(k.getModel() == null))))
            {
                return k.getModel().getString(RoomObjectVariableEnum.OBJECT_ROOM_ID);
            }
            return null;
        }

        public function createScreenShot(roomId:Int, canvasId:Int, fileName:String)
        {
            var encoded:com.sulake.core.utils.ByteArray = null;
            var file:FileReference = null;
            var date:Date = null;
            var timeStamp:String = null;
            var p= new compat.RegExp("[:\\/\\\\\\*\\?\"<>\\|%]", "g");
            fileName = p.replace(fileName, "");
            var roomCanvas= this.getRoomCanvas(roomId, canvasId);
            if (roomCanvas == null)
            {
                return;
            }
            var bmp= roomCanvas.takeScreenShot();
            if (PlayerVersionCheck.isVersionAtLeast(11, 3))
            {
            }
            if (encoded == null)
            {
                encoded = PNGEncoder.encode(bmp);
            }
            try
            {
                file = new FileReference();
                file.save(encoded, fileName);
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                date = Date.now();
                timeStamp = ((([date.getFullYear(), date.getMonth(), date.getDate()] : Array<Dynamic>).join("-") + " ") + ([date.getHours(), date.getMinutes(), date.getSeconds()] : Array<Dynamic>).join("."));
                fileName = ("Habbo " + timeStamp);
                file = new FileReference();
                file.save(encoded, fileName);
            }
 }        }

        public function getFurnitureIconUrl(k:Int):String
        {
            var _local_2:String = null;
            var _local_3= "";
            if (this._roomContentLoader != null)
            {
                _local_2 = this._roomContentLoader.getActiveObjectType(k);
                _local_3 = Std.string(this._roomContentLoader.getActiveObjectColorIndex(k));
            }
            return this._roomContentLoader._Str_21771(_local_2, _local_3);
        }

        public function getFurnitureIcon(k:Int, _arg_2:IGetImageListener, _arg_3:String=null, _arg_4:IStuffData=null):ImageResult
        {
            return this.getFurnitureImage(k, new Vector3d(), 1, _arg_2, 0, _arg_3, -1, -1, _arg_4);
        }

        public function getWallItemIconUrl(k:Int, _arg_2:String=null):String
        {
            var _local_3:String = null;
            var _local_4= "";
            if (this._roomContentLoader != null)
            {
                _local_3 = this._roomContentLoader.getWallItemType(k, _arg_2);
                _local_4 = Std.string(this._roomContentLoader.getWallItemColorIndex(k));
            }
            return this._roomContentLoader._Str_21771(_local_3, _local_4);
        }

        public function getWallItemIcon(k:Int, _arg_2:IGetImageListener, _arg_3:String=null):ImageResult
        {
            return this.getWallItemImage(k, new Vector3d(), 1, _arg_2, 0, _arg_3);
        }

        public function getFurnitureImage(k:Int, _arg_2:IVector3d, _arg_3:Int, _arg_4:IGetImageListener, _arg_5:UInt=0, _arg_6:String=null, _arg_7:Int=-1, _arg_8:Int=-1, _arg_9:IStuffData=null):ImageResult
        {
            var _local_10:String = null;
            var _local_11= "";
            if (this._roomContentLoader != null)
            {
                _local_10 = this._roomContentLoader.getActiveObjectType(k);
                _local_11 = Std.string(this._roomContentLoader.getActiveObjectColorIndex(k));
            }
            if (((_arg_3 == 1) && (!(_arg_4 == null))))
            {
                return this.getGenericRoomObjectThumbnail(_local_10, _local_11, _arg_4, _arg_6, _arg_9);
            }
            return this.getGenericRoomObjectImage(_local_10, _local_11, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_9, _arg_7, _arg_8);
        }

        public function getPetImage(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:Int, _arg_6:IGetImageListener, _arg_7:Bool=true, _arg_8:UInt=0, _arg_9:Array<ASAny>=null, _arg_10:String=null):ImageResult
        {
            var _local_13:PetCustomPart = null;
            var _local_11:String = null;
            var _local_12= ((((Std.string(k) + " ") + Std.string(_arg_2)) + " ") + ASCompat.toRadix(_arg_3, 16));
            if (!_arg_7)
            {
                _local_12 = (_local_12 + (" " + "head"));
            }
            if (_arg_9 != null)
            {
                _local_12 = (_local_12 + (" " + Std.string(_arg_9.length)));
                if (checkNullIteratee(_arg_9)) for (_tmp_ in _arg_9)
                {
_local_13  = _tmp_;
                    _local_12 = (_local_12 + (((((" " + Std.string(_local_13._Str_11008)) + " ") + Std.string(_local_13.partId)) + " ") + Std.string(_local_13.paletteId)));
                }
            }
            if (this._roomContentLoader != null)
            {
                _local_11 = this._roomContentLoader.getPetType(k);
            }
            return this.getGenericRoomObjectImage(_local_11, _local_12, _arg_4, _arg_5, _arg_6, _arg_8, null, null, -1, -1, _arg_10);
        }

        public function getWallItemImage(k:Int, _arg_2:IVector3d, _arg_3:Int, _arg_4:IGetImageListener, _arg_5:UInt=0, _arg_6:String=null, _arg_7:Int=-1, _arg_8:Int=-1):ImageResult
        {
            var _local_9:String = null;
            var _local_10= "";
            if (this._roomContentLoader != null)
            {
                _local_9 = this._roomContentLoader.getWallItemType(k, _arg_6);
                _local_10 = Std.string(this._roomContentLoader.getWallItemColorIndex(k));
            }
            if (((_arg_3 == 1) && (!(_arg_4 == null))))
            {
                return this.getGenericRoomObjectThumbnail(_local_9, _local_10, _arg_4, _arg_6, null);
            }
            return this.getGenericRoomObjectImage(_local_9, _local_10, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, null, _arg_7, _arg_8);
        }

        public function getRoomImage(k:String, _arg_2:String, _arg_3:String, _arg_4:Int, _arg_5:IGetImageListener, _arg_6:String=null):ImageResult
        {
            if (k == null)
            {
                k = "";
            }
            if (_arg_2 == null)
            {
                _arg_2 = "";
            }
            if (_arg_3 == null)
            {
                _arg_3 = "";
            }
            var _local_7= ROOM;
            var _local_8:ASAny = (((((k + "\n") + _arg_2) + "\n") + _arg_3) + "\n");
            if (_arg_6 != null)
            {
                _local_8 = (_local_8 + _arg_6);
            }
            return this.getGenericRoomObjectImage(_local_7, _local_8, new Vector3d(), _arg_4, _arg_5);
        }

        public function getRoomObjectImage(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:IVector3d, _arg_5:Int, _arg_6:IGetImageListener, _arg_7:UInt=0):ImageResult
        {
            var _local_10:String = null;
            var _local_15:IRoomObject = null;
            var _local_16 = 0;
            var _local_8:String = null;
            var _local_9= "";
            var _local_11:IStuffData = null;
            var _local_12= -1;
            var _local_13= this.getRoomIdentifier(k);
            var _local_14= this._roomManager.getRoom(_local_13);
            if (_local_14 != null)
            {
                _local_15 = _local_14.getObject(_arg_2, _arg_3);
                if (((!(_local_15 == null)) && (!(_local_15.getModel() == null))))
                {
                    _local_8 = _local_15.getType();
                    _local_12 = _local_15.getId();
                    switch (_arg_3)
                    {
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                           | RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                            _local_9 = Std.string(_local_15.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_COLOR));
                            _local_10 = _local_15.getModel().getString(RoomObjectVariableEnum.FURNITURE_EXTRAS);
                            _local_16 = Std.int(_local_15.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT));
                            if (_local_16 != LegacyStuffData.FORMAT_KEY)
                            {
                                _local_11 = StuffDataFactory.getStuffDataWrapperForType(_local_16);
                                _local_11.initializeFromRoomObjectModel(_local_15.getModel());
                            }
                            
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_USER:
                            _local_9 = _local_15.getModel().getString(RoomObjectVariableEnum.FIGURE);
                            
                    }
                }
            }
            return this.getGenericRoomObjectImage(_local_8, _local_9, _arg_4, _arg_5, _arg_6, _arg_7, _local_10, _local_11, -1, -1, null, _local_12);
        }

        function initializeRoomForGettingImage(k:IRoomObjectController, _arg_2:String)
        {
            var _local_3:Array<ASAny> = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8 = 0;
            var _local_9:RoomPlaneParser = null;
            var _local_10 = 0;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12 = 0;
            var _local_13:RoomObjectRoomMaskUpdateMessage = null;
            var _local_14:String = null;
            if (_arg_2 != null)
            {
                _local_3 = (cast _arg_2.split("\n"));
                if (_local_3.length >= 3)
                {
                    _local_4 = _local_3[0];
                    _local_5 = _local_3[1];
                    _local_6 = _local_3[2];
                    _local_7 = _local_3[3];
                    _local_8 = 6;
                    _local_9 = new RoomPlaneParser();
                    _local_9.initializeTileMap((_local_8 + 2), (_local_8 + 2));
                    _local_10 = 1;
                    while (_local_10 < (1 + _local_8))
                    {
                        _local_12 = 1;
                        while (_local_12 < (1 + _local_8))
                        {
                            _local_9._Str_3982(_local_12, _local_10, 0);
                            _local_12++;
                        }
                        _local_10++;
                    }
                    _local_9.wallHeight = _local_8;
                    _local_9.initializeFromTileData();
                    _local_11 = _local_9.getXML();
                    k.getEventHandler().initialize(_local_11);
                    k.getModelController().setString(RoomObjectVariableEnum.ROOM_FLOOR_TYPE, _local_4);
                    k.getModelController().setString(RoomObjectVariableEnum.ROOM_WALL_TYPE, _local_5);
                    k.getModelController().setString(RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE, _local_6);
                    if (_local_7 != null)
                    {
                        _local_13 = null;
                        _local_14 = (Std.string(RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM) + "_1");
                        _local_13 = new RoomObjectRoomMaskUpdateMessage(RoomObjectRoomMaskUpdateMessage.RORMUM_ADD_MASK, _local_14, _local_7, new Vector3d(2.5, 0.5, 2));
                        k.getEventHandler().processUpdateMessage(_local_13);
                    }
                    _local_9.dispose();
                }
            }
        }

        public function getGenericRoomObjectThumbnail(type:String, param:String, listener:IGetImageListener, extraData:String=null, stuffData:IStuffData=null):ImageResult
        {
            var assetName:String = null;
            var imageListeners:Vector<IGetImageListener> = null;
            var asset:BitmapDataAsset = null;
            var bitmap:BitmapData = null;
            var result= new ImageResult();
            result.id = -1;
            if (((!this._roomManagerInitialized) || (type == null)))
            {
                return result;
            }
            var room= this._roomManager.getRoom(TEMPORARY_ROOM);
            if (room == null)
            {
                room = this._roomManager.createRoom(TEMPORARY_ROOM, null);
                if (room == null)
                {
                    return result;
                }
            }
            var id= this._Str_7020.reserveNumber();
            var category= this.getRoomObjectCategory(type);
            if (id < 0)
            {
                return result;
            }
            id = (id + 1);
            result.id = id;
            result.data = null;
            assetName = ([type, param] : Array<Dynamic>).join("_");
            if (((!assets.hasAsset(assetName)) && (!(listener == null))))
            {
                imageListeners = this._thumbnailCallbacks.getValue(assetName);
                if (imageListeners == null)
                {
                    imageListeners = new Vector<IGetImageListener>(0);
                    this._thumbnailCallbacks.add(assetName, imageListeners);
                    this._roomContentLoader.loadThumbnailContent(id, type, param, null);
                }
                imageListeners.push(listener);
            }
            else
            {
                asset = Std.downcast(assets.getAssetByName(assetName) , BitmapDataAsset);
                if (((asset != null) && (!asset.disposed)))
                {
                    bitmap = ASCompat.dynamicAs(asset.content , BitmapData);
                    try
                    {
                        if (((((!(bitmap == null)) && Std.is(bitmap , BitmapData)) && (bitmap.width > 0)) && (bitmap.height > 0)))
                        {
                            result.data = bitmap.clone();
                        }
                        else
                        {
                            Logger.log([("Could not process thumbnail for icon (disposed?): " + assetName)]);
                        }
                    }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                     {
                        Logger.log([("Could not process thumbnail for icon: " + assetName)]);
                    }
 }                }
                this._Str_7020.freeNumber((id - 1));
                result.id = 0;
            }
            return result;
        }

        public function getGenericRoomObjectImage(k:String, _arg_2:String, _arg_3:IVector3d, _arg_4:Int, _arg_5:IGetImageListener, _arg_6:UInt=0, _arg_7:String=null, _arg_8:IStuffData=null, _arg_9:Int=-1, _arg_10:Int=-1, _arg_11:String=null, _arg_12:Int=-1):ImageResult
        {
            var _local_22:PetFigureData = null;
            var _local_23:RoomObjectDataUpdateMessage = null;
            var _local_24 = 0;
            var _local_13= new ImageResult();
            _local_13.id = -1;
            if (((!this._roomManagerInitialized) || (k == null)))
            {
                return _local_13;
            }
            var _local_14= this._roomManager.getRoom(TEMPORARY_ROOM);
            if (_local_14 == null)
            {
                _local_14 = this._roomManager.createRoom(TEMPORARY_ROOM, null);
                if (_local_14 == null)
                {
                    return _local_13;
                }
            }
            var _local_15= this._imageObjectIdBank.reserveNumber();
            var _local_16= this.getRoomObjectCategory(k);
            if (_local_15 < 0)
            {
                return _local_13;
            }
            _local_15 = (_local_15 + 1);
            var _local_17= Std.downcast(_local_14.createRoomObject(_local_15, k, _local_16) , IRoomObjectController);
            if ((((_local_17 == null) || (_local_17.getModelController() == null)) || (_local_17.getEventHandler() == null)))
            {
                return _local_13;
            }
            var _local_18= _local_17.getModelController();
            switch (_local_16)
            {
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                   | RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                    _local_18.setNumber(RoomObjectVariableEnum.FURNITURE_COLOR, ASCompat.toInt(_arg_2));
                    _local_18.setString(RoomObjectVariableEnum.FURNITURE_EXTRAS, _arg_7);
                    
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_USER:
                    if (((((k == RoomObjectUserTypes.USER) || (k == RoomObjectUserTypes.BOT)) || (k == RoomObjectUserTypes.RENTABLE_BOT)) || (k == RoomObjectUserTypes.PET)))
                    {
                        _local_18.setString(RoomObjectVariableEnum.FIGURE, _arg_2);
                    }
                    else
                    {
                        _local_22 = new PetFigureData(_arg_2);
                        _local_18.setNumber(RoomObjectVariableEnum.PET_PALETTE_INDEX, _local_22.paletteId);
                        _local_18.setNumber(RoomObjectVariableEnum.PET_COLOR, _local_22.color);
                        if (_local_22.headOnly)
                        {
                            _local_18.setNumber(RoomObjectVariableEnum.PET_HEAD_ONLY, 1);
                        }
                        if (_local_22.hasCustomParts)
                        {
                            _local_18.setNumberArray(RoomObjectVariableEnum.PET_CUSTOM_LAYER_IDS, _local_22.customLayerIds);
                            _local_18.setNumberArray(RoomObjectVariableEnum.PET_CUSTOM_PARTS_IDS, _local_22.customPartIds);
                            _local_18.setNumberArray(RoomObjectVariableEnum.PET_CUSTOM_PALETTE_IDS, _local_22.customPaletteIds);
                        }
                        if (_arg_11 != null)
                        {
                            _local_18.setString(RoomObjectVariableEnum.FIGURE_POSTURE, _arg_11);
                        }
                    }
                    
                case RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM:
                    this.initializeRoomForGettingImage(_local_17, _arg_2);
                    
            }
            _local_17.setDirection(_arg_3);
            var _local_19:IRoomObjectSpriteVisualization = null;
            _local_19 = Std.downcast(_local_17.getVisualization() , IRoomObjectSpriteVisualization);
            if (_local_19 == null)
            {
                _local_14.disposeObject(_local_15, _local_16);
                return _local_13;
            }
            if (((_arg_9 > -1) || (_arg_8 != null)))
            {
                if (((!(_arg_8 == null)) && (!(_arg_8.getLegacyString() == ""))))
                {
                    _local_23 = new RoomObjectDataUpdateMessage(ASCompat.toInt(_arg_8.getLegacyString()), _arg_8);
                }
                else
                {
                    _local_23 = new RoomObjectDataUpdateMessage(_arg_9, _arg_8);
                }
                if (_local_17.getEventHandler() != null)
                {
                    _local_17.getEventHandler().processUpdateMessage(_local_23);
                }
            }
            var _local_20= new RoomGeometry(_arg_4, new Vector3d(-135, 30, 0), new Vector3d(11, 11, 5));
            _local_19.update(_local_20, 0, true, false);
            if (_arg_10 > 0)
            {
                _local_24 = 0;
                while (_local_24 < _arg_10)
                {
                    _local_19.update(_local_20, 0, true, false);
                    _local_24++;
                }
            }
            var _local_21= _local_19.getImage(ASCompat.toInt(_arg_6), _arg_12);
            _local_13.data = _local_21;
            _local_13.id = _local_15;
            if (((!this.isRoomObjectContentAvailable(k)) && (!(_arg_5 == null))))
            {
                this._imageCallbacks.add(Std.string(_local_15), _arg_5);
                _local_18.setNumber(RoomObjectVariableEnum.IMAGE_QUERY_SCALE, _arg_4, true);
            }
            else
            {
                _local_14.disposeObject(_local_15, _local_16);
                this._imageObjectIdBank.freeNumber((_local_15 - 1));
                _local_13.id = 0;
            }
            _local_20.dispose();
            return _local_13;
        }

        public function getRoomObjectBoundingRectangle(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):Rectangle
        {
            var _local_6:IRoomObject = null;
            var _local_7:IRoomObjectVisualization = null;
            var _local_8:Rectangle = null;
            var _local_9:IRoomRenderingCanvas = null;
            var _local_10 = Math.NaN;
            var _local_11:Point = null;
            var _local_5= this.getRoomCanvasGeometry(k, _arg_4);
            if (_local_5 != null)
            {
                _local_6 = this.getRoomObject(k, _arg_2, _arg_3);
                if (_local_6 != null)
                {
                    _local_7 = _local_6.getVisualization();
                    if (_local_7 != null)
                    {
                        _local_8 = _local_7.boundingRectangle;
                        _local_9 = this.getRoomCanvas(k, _arg_4);
                        _local_10 = ((_local_9 != null) ? _local_9.scale : 1);
                        _local_11 = _local_5.getScreenPoint(_local_6.getLocation());
                        if (_local_11 != null)
                        {
                            _local_8.left = (_local_8.left * _local_10);
                            _local_8.top = (_local_8.top * _local_10);
                            _local_8.width = (_local_8.width * _local_10);
                            _local_8.height = (_local_8.height * _local_10);
                            _local_11.x = (_local_11.x * _local_10);
                            _local_11.y = (_local_11.y * _local_10);
                            _local_8.offset(_local_11.x, _local_11.y);
                            if (_local_9 != null)
                            {
                                _local_8.offset(((_local_9.width / 2) + _local_9.screenOffsetX), ((_local_9.height / 2) + _local_9.screenOffsetY));
                                return _local_8;
                            }
                        }
                    }
                }
            }
            return null;
        }

        public function getRoomObjectScreenLocation(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int=-1):Point
        {
            var _local_6:IRoomObject = null;
            var _local_7:Point = null;
            var _local_8:IRoomRenderingCanvas = null;
            if (_arg_4 == -1)
            {
                _arg_4 = this._activeRoomActiveCanvas;
            }
            var _local_5= this.getRoomCanvasGeometry(k, _arg_4);
            if (_local_5 != null)
            {
                _local_6 = this.getRoomObject(k, _arg_2, _arg_3);
                if (_local_6 != null)
                {
                    _local_7 = _local_5.getScreenPoint(_local_6.getLocation());
                    if (_local_7 != null)
                    {
                        _local_8 = this.getRoomCanvas(k, _arg_4);
                        if (_local_8 != null)
                        {
                            _local_7.x = (_local_7.x * _local_8.scale);
                            _local_7.y = (_local_7.y * _local_8.scale);
                            _local_7.offset(((_local_8.width / 2) + _local_8.screenOffsetX), ((_local_8.height / 2) + _local_8.screenOffsetY));
                        }
                        return _local_7;
                    }
                }
            }
            return null;
        }

        public function getActiveRoomBoundingRectangle(k:Int):Rectangle
        {
            return this.getRoomObjectBoundingRectangle(this._activeRoomId, OBJECT_ID_ROOM, RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM, k);
        }

        public function getActiveRoomActiveCanvas():IRoomRenderingCanvas
        {
            var k= this.getRoomCanvas(this._activeRoomId, this._activeRoomActiveCanvas);
            return k;
        }

        public function isRoomObjectContentAvailable(k:String):Bool
        {
            return this._roomManager.isContentAvailable(k);
        }

        public function iconLoaded(id:Int, assetName:String, success:Bool)
        {
            var asset:BitmapDataAsset = null;
            var bitmap:BitmapData = null;
            var listener:IGetImageListener = null;
            if (this._roomContentLoader == null)
            {
                return;
            }
            if (id == -1)
            {
                return;
            }
            this._Str_7020.freeNumber((id - 1));
            var imageListeners:Vector<IGetImageListener> = this._thumbnailCallbacks.getValue(assetName);
            if (imageListeners != null)
            {
                this._thumbnailCallbacks.remove(assetName);
                asset = Std.downcast(assets.getAssetByName(assetName) , BitmapDataAsset);
                bitmap = ASCompat.dynamicAs(asset.content , BitmapData);
                if (((asset != null) && (!asset.disposed)))
                {
                    if (checkNullIteratee(imageListeners)) for (_tmp_ in imageListeners)
                    {
listener  = _tmp_;
                        if (listener != null)
                        {
                            try
                            {
                                if (((((!(bitmap == null)) && Std.is(bitmap , BitmapData)) && (bitmap.width > 0)) && (bitmap.height > 0)))
                                {
                                    listener.imageReady(id, bitmap.clone());
                                }
                                else
                                {
                                    Logger.log([("Could not load thumbnail for icon (disposed?): " + assetName)]);
                                }
                            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                             {
                                Logger.log([("Could not load thumbnail for icon: " + assetName)]);
                            }
 }                        }
                    }
                }
            }
        }

        public function contentLoaded(k:String, _arg_2:Bool)
        {
            var _local_9:IRoomObject = null;
            var _local_10 = 0;
            var _local_11:BitmapData = null;
            var _local_12:IRoomObjectSpriteVisualization = null;
            var _local_13:IGetImageListener = null;
            var _local_14 = Math.NaN;
            var _local_15:ASObject = null;
            if (((ASCompat.getDynamicProperty(this._pendingPublicRoomInit, k)!= null) && _arg_2))
            {
                _local_15 = ASCompat.getDynamicProperty(this._pendingPublicRoomInit, k);
                Reflect.deleteField(this._pendingPublicRoomInit, k);
                if (this.applyRoomObjectProperties(ASCompat.toInt(_local_15.roomId), ((_local_15.xml : com.sulake.core.utils.xml.XML) ), ASCompat.asString(_local_15.floor ), ASCompat.asString(_local_15.wall ), ASCompat.asString(_local_15.landscape )))
                {
                    if (events != null)
                    {
                        events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.INITIALIZED, ASCompat.toInt(_local_15.roomId)));
                    }
                }
            }
            var _local_3= this._roomManager.getRoom(TEMPORARY_ROOM);
            if (_local_3 == null)
            {
                Logger.log([((("No room instance for " + k) + " room: ") + TEMPORARY_ROOM)]);
                return;
            }
            if (this._roomContentLoader == null)
            {
                return;
            }
            var _local_4:RoomGeometry = null;
            var _local_5:Float = 0;
            var _local_6= this._roomContentLoader.getObjectCategory(k);
            var _local_7= _local_3.getObjectCount(_local_6);
            var _local_8= (_local_7 - 1);
            while (_local_8 >= 0)
            {
                _local_9 = _local_3.getObjectWithIndex(_local_8, _local_6);
                if ((((!(_local_9 == null)) && (!(_local_9.getModel() == null))) && (_local_9.getType() == k)))
                {
                    _local_10 = _local_9.getId();
                    _local_11 = null;
                    _local_12 = null;
                    _local_12 = Std.downcast(_local_9.getVisualization() , IRoomObjectSpriteVisualization);
                    if (_local_12 != null)
                    {
                        _local_14 = _local_9.getModel().getNumber(RoomObjectVariableEnum.IMAGE_QUERY_SCALE);
                        if (((!(_local_4 == null)) && (!(_local_5 == _local_14))))
                        {
                            _local_4.dispose();
                            _local_4 = null;
                        }
                        if (_local_4 == null)
                        {
                            _local_5 = _local_14;
                            _local_4 = new RoomGeometry(_local_14, new Vector3d(-135, 30, 0), new Vector3d(11, 11, 5));
                        }
                        _local_12.update(_local_4, 0, true, false);
                        _local_11 = _local_12.image;
                    }
                    _local_3.disposeObject(_local_10, _local_6);
                    this._imageObjectIdBank.freeNumber((_local_10 - 1));
                    _local_13 = ASCompat.dynamicAs(this._imageCallbacks.remove(Std.string(_local_10)) , IGetImageListener);
                    if (_local_13 != null)
                    {
                        if (_local_11 != null)
                        {
                            _local_13.imageReady(_local_10, _local_11);
                        }
                        else
                        {
                            _local_13.imageFailed(_local_10);
                        }
                    }
                    else
                    {
                        if (_local_11 != null)
                        {
                            _local_11.dispose();
                        }
                    }
                }
                _local_8--;
            }
            if (_local_4 != null)
            {
                _local_4.dispose();
            }
        }

        public function objectInitialized(k:String, _arg_2:Int, _arg_3:Int)
        {
            var _local_6 = 0;
            var _local_7:IStuffData = null;
            var _local_8 = 0;
            var _local_9:RoomObjectDataUpdateMessage = null;
            var _local_4= this.getRoomId(k);
            if (_arg_3 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
            {
                this.updateObjectRoomWindow(_local_4, _arg_2);
            }
            var _local_5= Std.downcast(this.getRoomObject(_local_4, _arg_2, _arg_3) , IRoomObjectController);
            if ((((!(_local_5 == null)) && (!(_local_5.getModel() == null))) && (!(_local_5.getEventHandler() == null))))
            {
                if (!Math.isNaN(_local_5.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT)))
                {
                    _local_6 = Std.int(_local_5.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT));
                    _local_7 = StuffDataFactory.getStuffDataWrapperForType(_local_6);
                    _local_7.initializeFromRoomObjectModel(_local_5.getModel());
                    _local_8 = _local_5.getState(0);
                    _local_9 = new RoomObjectDataUpdateMessage(_local_8, _local_7);
                    _local_5.getEventHandler().processUpdateMessage(_local_9);
                }
                if (events != null)
                {
                    events.dispatchEvent(new RoomEngineObjectEvent(RoomEngineObjectEvent.CONTENT_UPDATED, _local_4, _arg_2, _arg_3));
                }
            }
            if (k != TEMPORARY_ROOM)
            {
                this.addObjectToTileMap(_local_4, _local_5);
            }
        }

        public function objectsInitialized(k:String)
        {
            var _local_2 = 0;
            if (events != null)
            {
                _local_2 = this.getRoomId(k);
                events.dispatchEvent(new RoomEngineEvent(RoomEngineEvent.OBJECTS_INITIALIZED, _local_2));
            }
        }

        public function selectAvatar(k:Int, _arg_2:Int)
        {
            if (this._roomObjectEventHandler != null)
            {
                this._roomObjectEventHandler.setSelectedAvatar(k, _arg_2, true);
            }
        }

        public function getSelectedAvatarId():Int
        {
            if (this._roomObjectEventHandler != null)
            {
                return this._roomObjectEventHandler.getSelectedAvatarId();
            }
            return -1;
        }

        public function selectRoomObject(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (this._roomObjectEventHandler == null)
            {
                return;
            }
            this._roomObjectEventHandler.setSelectedObject(k, _arg_2, _arg_3);
        }

        function addObjectToTileMap(k:Int, _arg_2:IRoomObject)
        {
            var _local_3= this.getRoomInstanceData(k).tileObjectMap;
            if (_local_3 != null)
            {
                _local_3.addRoomObject(_arg_2);
            }
        }

        public function refreshTileObjectMap(k:Int, _arg_2:String)
        {
            var _local_3= this.getRoomInstanceData(k).tileObjectMap;
            if (_local_3 != null)
            {
                _local_3.populate(this.getRoomObjects(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE));
            }
        }

        function showRoomAd(k:AdEvent)
        {
            var _local_2:IRoomObjectController = null;
            var _local_3:RoomObjectRoomAdUpdateMessage = null;
            if (this._roomContentLoader != null)
            {
                _local_2 = this.getObjectRoom(k.roomId);
                if (_local_2 == null)
                {
                    return;
                }
                _local_3 = null;
                _local_3 = new RoomObjectRoomAdUpdateMessage(RoomObjectRoomAdUpdateMessage.RORUM_ROOM_AD_ACTIVATE, RoomObjectVariableEnum.ROOM_AD_IMAGE_ASSET, k.clickUrl);
                _local_2.getEventHandler().processUpdateMessage(_local_3);
            }
        }

        public function requestRoomAdImage(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:String)
        {
            if (this._adManager != null)
            {
                this._adManager.loadRoomAdImage(k, _arg_2, _arg_3, _arg_4, _arg_5);
            }
        }

        function onRoomAdImageLoaded(k:AdEvent)
        {
            var _local_4:RoomObjectRoomAdUpdateMessage = null;
            var _local_2= this.getObjectRoom(k.roomId);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this.getObjectFurniture(k.roomId, k.objectId);
            if (((_local_3 == null) || (_local_3.getEventHandler() == null)))
            {
                return;
            }
            if (k.image != null)
            {
                this._roomContentLoader._Str_16696(_local_3.getType(), k.imageUrl, k.image, true);
            }
            switch (k.type)
            {
                case AdEvent.ROOM_AD_IMAGE_LOADED:
                    _local_4 = new RoomObjectRoomAdUpdateMessage(RoomObjectRoomAdUpdateMessage.RORUM_ROOM_BILLBOARD_IMAGE_LOADED, k.imageUrl, k.clickUrl, k.objectId, k.image);
                    
                case AdEvent.ROOM_AD_IMAGE_LOADING_FAILED:
                    _local_4 = new RoomObjectRoomAdUpdateMessage(RoomObjectRoomAdUpdateMessage.RORUM_ROOM_BILLBOARD_IMAGE_LOADING_FAILED, k.imageUrl, k.clickUrl, k.objectId, k.image);
                    
            }
            if (_local_4 != null)
            {
                _local_3.getEventHandler().processUpdateMessage(_local_4);
            }
        }

        public function insertContentLibrary(k:Int, _arg_2:Int, _arg_3:IAssetLibrary):Bool
        {
            return this._roomContentLoader.insertObjectContent(k, _arg_2, _arg_3);
        }

        public function setActiveObjectType(k:Int, _arg_2:String)
        {
            this._roomContentLoader.setActiveObjectType(k, _arg_2);
        }

        override public function purge()
        {
            super.purge();
            if (this._roomContentLoader != null)
            {
                this._roomContentLoader.purge();
            }
        }

        public function requestBadgeImageAsset(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Bool=true)
        {
            var _local_10:IRoomInstance = null;
            var _local_11:Array<ASAny> = null;
            var _local_6:IRoomObjectController = null;
            if (k == 0)
            {
                _local_10 = this._roomManager.getRoom(TEMPORARY_ROOM);
                if (_local_10 != null)
                {
                    _local_6 = Std.downcast(_local_10.getObject(_arg_2, _arg_3) , IRoomObjectController);
                }
            }
            else
            {
                _local_6 = this.getObjectFurniture(k, _arg_2);
            }
            if (((_local_6 == null) || (_local_6.getEventHandler() == null)))
            {
                return;
            }
            var _local_7:ASFunction = (_arg_5 ? this._sessionDataManager.getGroupBadgeAssetName : this._sessionDataManager.getBadgeImageAssetName);
            var _local_8:String = _local_7(_arg_4);
            if (!ASCompat.stringAsBool(_local_8))
            {
                _local_8 = "loading_icon";
                if (this._badgeListenerObjects == null)
                {
                    this._badgeListenerObjects = new Map();
                }
                if (this._badgeListenerObjects.length == 0)
                {
                    this._sessionDataManager.events.addEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this.onBadgeLoaded);
                }
                _local_11 = this._badgeListenerObjects.getValue(_arg_4);
                if (_local_11 == null)
                {
                    _local_11 = new Array<ASAny>();
                }
                _local_11.push(new RoomObjectBadgeImageAssetListener(_local_6, _arg_5));
                this._badgeListenerObjects.setProperty(_arg_4, _local_11);
            }
            else
            {
                this.addBadgeGraphicAssets(_local_6, _arg_4, _arg_5);
            }
            var _local_9= new RoomObjectGroupBadgeUpdateMessage(_arg_4, _local_8);
            if (_local_9 != null)
            {
                _local_6.getEventHandler().processUpdateMessage(_local_9);
            }
        }

        function addBadgeGraphicAssets(k:IRoomObjectController, _arg_2:String, _arg_3:Bool=false)
        {
            var _local_4:ASFunction = (_arg_3 ? this._sessionDataManager.getGroupBadgeAssetName : this._sessionDataManager.getBadgeImageAssetName);
            var _local_5:ASFunction = (_arg_3 ? this._sessionDataManager.getGroupBadgeSmallAssetName : this._sessionDataManager.getBadgeImageSmallAssetName);
            var _local_6:ASFunction = (_arg_3 ? this._sessionDataManager.getGroupBadgeImage : this._sessionDataManager.getBadgeImage);
            var _local_7:ASFunction = (_arg_3 ? this._sessionDataManager.getGroupBadgeSmallImage : this._sessionDataManager.getBadgeSmallImage);
            var _local_8= ASCompat.toString(_local_4(_arg_2));
            var _local_9= cast(_local_6(_arg_2), BitmapData);
            this._roomContentLoader._Str_16696(k.getType(), _local_8, _local_9, false);
            var _local_10= ASCompat.toString(_local_5(_arg_2));
            var _local_11:BitmapData = _local_7(_arg_2);
            if (_local_11 != null)
            {
                this._roomContentLoader._Str_16696(k.getType(), _local_10, _local_11, false);
            }
        }

        function onBadgeLoaded(k:BadgeImageReadyEvent)
        {
            var _local_4:RoomObjectBadgeImageAssetListener = null;
            var _local_5:ASFunction = null;
            var _local_6:RoomObjectGroupBadgeUpdateMessage = null;
            var _local_2:Array<ASAny> = ASCompat.dynamicAs(this._badgeListenerObjects.getValue(k.badgeId) , Array);
            if (_local_2 == null)
            {
                Logger.log([("Could not find matching objects for group badge asset request " + k.badgeId)]);
                return;
            }
            var _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3];
                this.addBadgeGraphicAssets(_local_4.object, k.badgeId, _local_4._Str_14095);
                _local_5 = (_local_4._Str_14095 ? this._sessionDataManager.getGroupBadgeAssetName : this._sessionDataManager.getBadgeImageAssetName);
                _local_6 = new RoomObjectGroupBadgeUpdateMessage(k.badgeId, ASCompat.toString(_local_5(k.badgeId)));
                if (((!(_local_6 == null)) && (!(_local_4.object.getEventHandler() == null))))
                {
                    _local_4.object.getEventHandler().processUpdateMessage(_local_6);
                }
                _local_3++;
            }
            this._badgeListenerObjects.remove(k.badgeId);
            if (this._badgeListenerObjects.length == 0)
            {
                this._sessionDataManager.events.removeEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this.onBadgeLoaded);
            }
        }

        public function requestFurniIconAsset(roomId:Int, objectId:Int, category:Int, wallItem:Bool, typeId:Int, extra:String)
        {
var key:String  = null, listeners:Array<ASAny>  = null;            if (this._sessionDataManager == null)
            {
                return;
            }

            var roomObject= this.resolveFurniIconListenerObject(roomId, objectId, category);
            if (!this.isFurniIconListenerObjectValid(roomObject))
            {
                return;
            }

            extra = extra == null ? "" : extra;
            var assetName= this._sessionDataManager.getFurniIconImageAssetName(wallItem, typeId, extra);
            if (assetName == null)
            {
                assetName = FURNI_ICON_PLACEHOLDER;
key= furniIconListenerKey(wallItem, typeId, extra);
                if (this._furniIconListenerObjects == null)
                {
                    this._furniIconListenerObjects = new Map();
                }
listeners= ASCompat.dynamicAs(this._furniIconListenerObjects.getValue(key) , Array);
                if (listeners == null)
                {
                    listeners = [];
                    this._furniIconListenerObjects.add(key, listeners);
                }
                if (!this.hasFurniIconWaiter(listeners, roomId, objectId, category))
                {
                    listeners.push(new RoomObjectFurniIconAssetListener(roomId, objectId, category));
                }
                this.attachFurniIconListener();
            }
            else if (assetName != FURNI_ICON_PLACEHOLDER)
            {
                this.addFurniIconGraphicAsset(roomObject, assetName, wallItem, typeId, extra);
            }

            roomObject.getEventHandler().processUpdateMessage(new RoomObjectFurniIconUpdateMessage(assetName, wallItem, typeId, extra));
        }

        function hasFurniIconWaiter(listeners:Array<ASAny>, roomId:Int, objectId:Int, category:Int):Bool
        {
var listener:RoomObjectFurniIconAssetListener  = null;            if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
            {
listener = _tmp_;
                if (listener != null && listener.roomId == roomId && listener.objectId == objectId && listener.category == category)
                {
                    return true;
                }
            }
            return false;
        }

        function resolveFurniIconListenerObject(roomId:Int, objectId:Int, category:Int):IRoomObjectController
        {
var temporaryRoom:IRoomInstance  = null;            if (this._roomManager == null)
            {
                return null;
            }
            if (roomId == 0)
            {
temporaryRoom= this._roomManager.getRoom(TEMPORARY_ROOM);
                return temporaryRoom == null ? null : Std.downcast(temporaryRoom.getObject(objectId, category) , IRoomObjectController);
            }
            return Std.downcast(this.getRoomObject(roomId, objectId, category) , IRoomObjectController);
        }

        function isFurniIconListenerObjectValid(roomObject:IRoomObjectController):Bool
        {
            return roomObject != null && roomObject.isInitialized() && roomObject.getEventHandler() != null;
        }

        function addFurniIconGraphicAsset(roomObject:IRoomObjectController, assetName:String, wallItem:Bool, typeId:Int, extra:String)
        {
            if (this._roomContentLoader == null || this._sessionDataManager == null || assetName == null || assetName.length == 0)
            {
                return;
            }
            var image= this._sessionDataManager.getFurniIconImage(wallItem, typeId, extra);
            if (image == null)
            {
                return;
            }
            if (!this._roomContentLoader._Str_16696(roomObject.getType(), assetName, image, false))
            {
                image.dispose();
            }
        }

        function onFurniIconLoaded(event:FurniIconImageReadyEvent)
        {
var listener:RoomObjectFurniIconAssetListener  = null, roomObject:IRoomObjectController  = null, resolvedAssetName:String  = null;            if (this._furniIconListenerObjects == null || event == null)
            {
                return;
            }

            var key= furniIconListenerKey(event.wallItem, event.typeId, event.extra);
            var listeners:Array<ASAny> = ASCompat.dynamicAs(this._furniIconListenerObjects.remove(key) , Array);
            if (listeners == null)
            {
                if (this._furniIconListenerObjects.length == 0)
                {
                    this.detachFurniIconListener();
                }
                return;
            }

            if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
            {
listener = _tmp_;
roomObject= listener == null ? null : this.resolveFurniIconListenerObject(listener.roomId, listener.objectId, listener.category);
                if (!this.isFurniIconListenerObjectValid(roomObject))
                {
                    continue;
                }
resolvedAssetName= event.success ? event.assetName : FURNI_ICON_PLACEHOLDER;
                if (event.success && resolvedAssetName != null && resolvedAssetName.length > 0)
                {
                    this.addFurniIconGraphicAsset(roomObject, resolvedAssetName, event.wallItem, event.typeId, event.extra);
                }
                roomObject.getEventHandler().processUpdateMessage(new RoomObjectFurniIconUpdateMessage(resolvedAssetName, event.wallItem, event.typeId, event.extra));
            }

            if (this._furniIconListenerObjects.length == 0)
            {
                this.detachFurniIconListener();
            }
        }

        function attachFurniIconListener()
        {
            if (!this._furniIconListenerAttached && this._sessionDataManager != null && this._sessionDataManager.events != null)
            {
                this._sessionDataManager.events.addEventListener(FurniIconImageReadyEvent.ICON_READY, this.onFurniIconLoaded);
                this._furniIconListenerAttached = true;
            }
        }

        function detachFurniIconListener()
        {
            if (this._furniIconListenerAttached && this._sessionDataManager != null && this._sessionDataManager.events != null)
            {
                this._sessionDataManager.events.removeEventListener(FurniIconImageReadyEvent.ICON_READY, this.onFurniIconLoaded);
            }
            this._furniIconListenerAttached = false;
        }

        public var getIsSelectedObjectInValidPosition(get,never):Bool;
public function  get_getIsSelectedObjectInValidPosition():Bool
        {
            if (this._roomSessionManager == null)
            {
                return false;
            }
            var k= this._roomSessionManager.getSession(this._activeRoomId);
            return (k != null) && k.isUserDecorating;
        }

        
        public var setIsSelectedObjectInValidPosition(get,set):Bool;
public function  get_setIsSelectedObjectInValidPosition():Bool
        {
            return this._isSelectedObjectInValidPosition;
        }
public function  set_setIsSelectedObjectInValidPosition(k:Bool):Bool        {
            return this._isSelectedObjectInValidPosition = k;
        }

        public function showUseProductSelection(k:Int, _arg_2:Int, _arg_3:Int=-1)
        {
            var _local_5 = 0;
            var _local_4:String = null;
            if (this._roomContentLoader != null)
            {
                _local_4 = this._roomContentLoader.getActiveObjectType(_arg_2);
                _local_5 = this.getRoomObjectCategory(_local_4);
                events.dispatchEvent(new RoomEngineUseProductEvent(RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY, this._activeRoomId, _arg_3, _local_5, k, _arg_2));
            }
        }

        public function placeSelectedObject(k:Int)
        {
            if (((this._sessionDataManager == null) || (this._roomSessionManager == null)))
            {
                return;
            }
            var _local_2= this._roomSessionManager.getSession(this._activeRoomId);
            if (_local_2 == null)
            {
                return;
            }
            this.updateObjectUserEffect(this.activeRoomId, _local_2.ownUserRoomId, k);
        }

        public var playerUnderCursor(get,never):Int;
public function  get_playerUnderCursor():Int
        {
            return this._playerUnderCursor;
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        function fixedUserLocation(k:Int, _arg_2:IVector3d):IVector3d
        {
            if (_arg_2 == null)
            {
                return null;
            }
            var _local_3= this.getFurniStackingHeightMap(k);
            var _local_4= this.getLegacyGeometry(k);
            if (((_local_3 == null) || (_local_4 == null)))
            {
                return _arg_2;
            }
            var _local_5= _arg_2.z;
            var _local_6= _local_3.getTileHeight(Std.int(_arg_2.x), Std.int(_arg_2.y));
            var _local_7= _local_4.getTileHeight(Std.int(_arg_2.x), Std.int(_arg_2.y));
            if (((Math.abs((_local_5 - _local_6)) < 0.1) && (Math.abs((_local_6 - _local_7)) < 0.1)))
            {
                _local_5 = _local_4.getFloorAltitude(Std.int(_arg_2.x), Std.int(_arg_2.y));
            }
            return new Vector3d(_arg_2.x, _arg_2.y, _local_5);
        }

        var cameraFollowDuration(get,never):Int;
function  get_cameraFollowDuration():Int
        {
            return getBoolean("room.camera.follow_user") ? 1000 : 0;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public function getRenderRoomMessage(k:Rectangle, _arg_2:UInt, _arg_3:Bool=false, _arg_4:Bool=true, _arg_5:Bool=false, _arg_6:Int=-1):IMessageComposer
        {
            var _local_7:IRoomRenderingCanvas = null;
            if (_arg_6 > -1)
            {
                _local_7 = this.getRoomCanvas(this._activeRoomId, _arg_6);
            }
            else
            {
                _local_7 = this.getActiveRoomActiveCanvas();
            }
            if (_local_7 == null)
            {
                return null;
            }
            if (_arg_5)
            {
                _local_7.skipSpriteVisibilityChecking();
            }
            var _local_8= -1;
            if (((!_arg_4) && (!(this._roomSessionManager.getSession(this._activeRoomId) == null))))
            {
                _local_8 = this._roomSessionManager.getSession(this._activeRoomId).ownUserRoomId;
            }
            var _local_9= new SpriteDataCollector();
            var _local_10= _local_9.getFurniData(k, _local_7, this, _local_8);
            var _local_11= _local_9.getRoomRenderingModifiers(this);
            var _local_12= _local_9.getRoomPlanes(k, _local_7, this, _arg_2);
            if (_arg_5)
            {
                _local_7.resumeSpriteVisibilityChecking();
            }
            if (_arg_3)
            {
                return new RenderRoomThumbnailMessageComposer(_local_12, _local_10, _local_11, this._activeRoomId, this._sessionDataManager.topSecurityLevel);
            }
            return new RenderRoomMessageComposer(_local_12, _local_10, _local_11, this._activeRoomId, this._sessionDataManager.topSecurityLevel);
        }

        public var roomContentLoader(get,never):RoomContentLoader;
public function  get_roomContentLoader():RoomContentLoader
        {
            return this._roomContentLoader;
        }
		
		public function _SafeStr_7811(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:Int):Bool
        {
            var _local_5:String = null;
            var _local_7:RoomObjectUpdateMessage = null;
            if (_arg_4 == RoomObjectCategoryEnum.SNOWBALL)
            {
                _local_5 = RoomObjectLogicEnum.GAME_SNOWBALL;
            }
            else
            {
                if (_arg_4 == RoomObjectCategoryEnum.SNOW_SPLASH)
                {
                    _local_5 = RoomObjectLogicEnum.GAME_SNOWSPLASH;
                }
            }
            var _local_6= this.createObjectUser(k, _arg_2, _local_5, _arg_4);
            if (_local_6 == null)
            {
                return false;
            }
            if (_local_6.getEventHandler() != null)
            {
                _local_7 = new RoomObjectUpdateMessage(_arg_3, null);
                _local_6.getEventHandler().processUpdateMessage(_local_7);
            }
            return true;
        }
		
        public function _SafeStr_7817(k:Int, _arg_2:Int, _arg_3:IVector3d, _arg_4:Int):Bool
        {
            var _local_5= this.getObject(this.getRoomIdentifier(k), _arg_2, _arg_4);
            if (_local_5 == null || _local_5.getEventHandler() == null)
            {
                return false;
            }
            var _local_6= new RoomObjectUpdateMessage(_arg_3, null);
            _local_5.getEventHandler().processUpdateMessage(_local_6);
            return true;
        }

        /** Creates an r26 SnowStorm projectile without changing the later AIR SnowWar renderer. */
        public function createShockwaveSnowball(k:Int, objectId:Int, location:IVector3d):Bool
        {
            var object= this.createObjectUser(k, objectId,
                RoomObjectLogicEnum.GAME_SHOCKWAVE_SNOWBALL, RoomObjectCategoryEnum.SNOWBALL);
            if (object == null) return false;
            if (object.getEventHandler() != null)
                object.getEventHandler().processUpdateMessage(new RoomObjectUpdateMessage(location, null));
            return true;
        }

        /** Creates the exact r26 three-frame hit animation in the native depth-sorted room. */
        public function createShockwaveSnowSplash(k:Int, objectId:Int, location:IVector3d):Bool
        {
            var object= this.createObjectUser(k, objectId,
                RoomObjectLogicEnum.GAME_SHOCKWAVE_SNOWSPLASH, RoomObjectCategoryEnum.SNOW_SPLASH);
            if (object == null) return false;
            if (object.getEventHandler() != null)
                object.getEventHandler().processUpdateMessage(new RoomObjectUpdateMessage(location, null));
            return true;
        }

        /** Removes one transient game object from its native non-furniture room category. */
        public function disposeGameObject(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (_arg_3 != RoomObjectCategoryEnum.SNOWBALL &&
                _arg_3 != RoomObjectCategoryEnum.SNOW_SPLASH)
            {
                return;
            }
            this.disposeObject(k, _arg_2, _arg_3);
        }
		
		/*public function updateObjectWallItem(k:int, _arg_2:int, _arg_3:IVector3d, _arg_4:IVector3d, _arg_5:int, _arg_6:String):Boolean
        {
            var _local_7:IRoomObjectController = this.getObjectWallItem(k, _arg_2);
            if (_local_7 == null)
            {
                return false;
            }
            var _local_8:_Str_2359 = new _Str_2359(_arg_3, _arg_4);
            var _local_9:_Str_2664 = new _Str_2664();
            _local_9.setString(_arg_6);
            var _local_10:RoomObjectDataUpdateMessage = new RoomObjectDataUpdateMessage(_arg_5, _local_9);
            if (((!(_local_7 == null)) && (!(_local_7.getEventHandler() == null))))
            {
                _local_7.getEventHandler().processUpdateMessage(_local_8);
                _local_7.getEventHandler().processUpdateMessage(_local_10);
            }
            this.updateObjectRoomWindow(k, _arg_2);
            return true;
        }
		*/
    }

