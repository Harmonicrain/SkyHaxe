package com.sulake.habbo.roomevents.wired_trading.chests
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestOpenInstructionMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.CloseChestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.OpenChestMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.CoinChestSubController;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.FurniChestSubController;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.IChestSubController;
    import com.sulake.habbo.session.ISessionDataManager;

    /**
     * July AIR chest coordinator. It owns one active/requested chest and drops
     * stale fragments, room-object updates and close acknowledgements.
     */
     class WiredChestController implements IDisposable
    {
        public static inline final STATUS_CLOSED= 0;
        public static inline final STATUS_OPENING= 1;
        public static inline final STATUS_OPEN= 2;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _disposed:Bool = false;
        var _status:Int = STATUS_CLOSED;
        var _wrapper:WiredChestWrapperView;
        var _subControllers:Vector<IChestSubController>;
        var _requestedChestId:Int = 0;
        var _activeChestId:Int = 0;
        var _messageEvents:Vector<IMessageEvent>;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector<IMessageEvent>();
            this.addMessageEvent(new ChestOpenInstructionMessageEvent(this.onOpenInstruction));
            this._wrapper = new WiredChestWrapperView(this, roomEvents.windowManager);
            this._subControllers = new Vector<IChestSubController>();
            this._subControllers.push(new FurniChestSubController(this));
            this._subControllers.push(new CoinChestSubController(this));
            roomEvents.roomEngine.events.addEventListener(RoomEngineObjectEvent.REMOVED,
                this.onRoomObjectRemoved);
            roomEvents.roomEngine.events.addEventListener(RoomEngineObjectEvent.UPDATED,
                this.onRoomObjectUpdated);
        }

        function onOpenInstruction(event:ChestOpenInstructionMessageEvent)
        {
            this.open(event.getParser().chestId);
        }
        public function open(chestId:Int)
        {
            if (chestId <= 0 || !this._roomEvents.isWiredFeatureEnabled(
                WiredCapabilityCodes.CHESTS))
            {
                return;
            }
            if (this._activeChestId != 0 && this._activeChestId != chestId)
            {
                this.setClosedStatus();
            }
            this._requestedChestId = chestId;
            this.send(new OpenChestMessageComposer(chestId));
        }
        public function close()
        {
            if (this._wrapper != null) { this._wrapper.hide(); }
            else { this.setClosedStatus(); }
        }
        public function setClosedStatus()
        {
            if (this._activeChestId != 0)
            {
                this.send(new CloseChestMessageComposer(this._activeChestId));
            }
            this._requestedChestId = 0;
            this._activeChestId = 0;
            this._status = STATUS_CLOSED;
        }
        public function setOpeningStatus(chestId:Int)
        {
            this._requestedChestId = 0;
            this._activeChestId = chestId;
            this._status = STATUS_OPENING;
        }
        public function setOpenStatus(chestId:Int, subController:IChestSubController)
        {
            this._requestedChestId = 0;
            this._activeChestId = chestId;
            this._status = STATUS_OPEN;
            var object= this._roomEvents.roomEngine.getRoomObject(
                this._roomEvents.roomEngine.activeRoomId, chestId,
                RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (object == null || object.getModel() == null)
            {
                this._wrapper.hide();
                return;
            }
            var owner= object.getModel().getNumber("furniture_owner_id")
                == this._roomEvents.sessionDataManager.userId;
            var roomOwner= this._roomEvents.roomSession != null
                && this._roomEvents.roomSession.isRoomOwner;
            this._wrapper.show(subController, object, chestId, owner, roomOwner);
        }
        function onRoomObjectRemoved(event:RoomEngineObjectEvent)
        {
            if (event.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                && event.objectId == this._activeChestId && this._status == STATUS_OPEN)
            {
                this._wrapper.hide();
            }
        }
        function onRoomObjectUpdated(event:RoomEngineObjectEvent)
        {
            if (event.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                && event.objectId == this._activeChestId && this._status == STATUS_OPEN)
            {
                this._wrapper.viewingChestUpdated();
            }
        }
        public function onPermissionsChanged()
        {
            if (this._wrapper != null) { this._wrapper.onPermissionsChanged(); }
        }
        public function resetRoom()
        {
            if (this._wrapper != null) { this._wrapper.hide(); }
            else { this.setClosedStatus(); }
        }
        public function addMessageEvent(event:IMessageEvent)
        {
            if (event == null || this._roomEvents.communication == null) { return; }
            this._messageEvents.push(event);
            this._roomEvents.communication.addHabboConnectionMessageEvent(event);
        }
        public function removeMessageEvent(event:IMessageEvent)
        {
            if (event == null || this._roomEvents.communication == null) { return; }
            this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            var index= this._messageEvents.indexOf(event);
            if (index >= 0) { this._messageEvents.splice(index, 1); }
        }
        public function send(composer:IMessageComposer) { this._roomEvents.send(composer); }
        public var status(get,never):Int;
public function  get_status():Int { return this._status; }
        public var chestWrapperView(get,never):WiredChestWrapperView;
public function  get_chestWrapperView():WiredChestWrapperView { return this._wrapper; }
        public var activeChestId(get,never):Int;
public function  get_activeChestId():Int { return this._activeChestId; }
        public var requestedChestId(get,never):Int;
public function  get_requestedChestId():Int { return this._requestedChestId; }
        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }
        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager { return this._roomEvents.localization; }
        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._roomEvents.sessionDataManager;
        }
        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog { return this._roomEvents.catalog; }
        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine { return this._roomEvents.roomEngine; }
        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._roomEvents.windowManager;
        }
        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary { return this._roomEvents.assets; }
        public function getProperty(key:String, fallback:String = ""):String
        {
            var value= this._roomEvents.getProperty(key);
            return value == null ? fallback : value;
        }
        public function getInteger(key:String, fallback:Int = 0):Int
        {
            var value= this.getProperty(key, Std.string(fallback));
            var parsed:Float = ASCompat.parseInt(value);
            return Math.isNaN(parsed) ? fallback : Std.int(parsed);
        }
        public function dispose()
        {
var sub:IChestSubController  = null, event:IMessageEvent  = null;            if (this._disposed) { return; }
            this._roomEvents.roomEngine.events.removeEventListener(RoomEngineObjectEvent.REMOVED,
                this.onRoomObjectRemoved);
            this._roomEvents.roomEngine.events.removeEventListener(RoomEngineObjectEvent.UPDATED,
                this.onRoomObjectUpdated);
            // The wrapper still owns the active sub-controller view. Detach it
            // before disposing the sub-controllers so hide() cannot call into an
            // already-disposed view during component shutdown.
            if (this._wrapper != null) { this._wrapper.hide(); }
            final _iter_ = this._subControllers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { sub = _tmp_;
sub.dispose(); }
            this._subControllers = null;
            while (this._messageEvents.length > 0)
            {
event= this._messageEvents.pop();
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
                event.dispose();
            }
            this._messageEvents = null;
            if (this._wrapper != null) { this._wrapper.dispose(); }
            this._wrapper = null;
            this._roomEvents = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

