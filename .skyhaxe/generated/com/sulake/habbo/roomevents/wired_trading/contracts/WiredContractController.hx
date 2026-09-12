package com.sulake.habbo.roomevents.wired_trading.contracts
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts.ChestContractOpenMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts.ChestContractUpdateResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts.RequestChestContractContentsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts.SaveChestContractMessageComposer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.UbuntuPresetManager;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.AddEditContractElement;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.IContractView;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.PaymentContract;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.RewardContract;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.TradeContract;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util.AbstractContract;

     class WiredContractController implements IDisposable
    {
        static final UNSET_LOCATION:Int = ASCompat.MAX_INT;

        var _disposed:Bool = false;
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _presetManager:PresetManager;
        var _messageEvents:Vector<IMessageEvent>;
        var _pendingContractId:Int = -1;
        var _addEdit:AddEditContractElement;
        var _payment:PaymentContract;
        var _reward:RewardContract;
        var _trade:TradeContract;
        var _xCache:Int = UNSET_LOCATION;
        var _yCache:Int = UNSET_LOCATION;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
var event:IMessageEvent  = null;            this._roomEvents = roomEvents;
            this._presetManager = new UbuntuPresetManager(roomEvents);
            this._messageEvents = new Vector<IMessageEvent>();
            this._messageEvents.push(new ChestContractOpenMessageEvent(
                this.onOpenContract));
            this._messageEvents.push(new ChestContractContentsMessageEvent(
                this.onContractContents));
            this._messageEvents.push(new ChestContractUpdateResultMessageEvent(
                this.onContractUpdateResult));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{event = _tmp_;
                this.addMessageEvent(event);
};
        }

        function onOpenContract(event:ChestContractOpenMessageEvent)
        {
            this._pendingContractId = event.getParser().contractId;
            this.communicationManager.connection.send(
                new RequestChestContractContentsMessageComposer(
                    this._pendingContractId));
        }

        function onContractContents(
            event:ChestContractContentsMessageEvent)
        {
            var contents= event.getParser();
            if (contents.contractId != this._pendingContractId) return;
            this._pendingContractId = -1;
            this.closeAllOpenFrames();
            var view:IContractView = null;
            if (contents.contractType == 0)
            {
                if (this._payment == null)
                    this._payment = new PaymentContract(this, this._presetManager);
                this._payment.show(contents);
                view = this._payment;
            }
            else if (contents.contractType == 1)
            {
                if (this._trade == null)
                    this._trade = new TradeContract(this, this._presetManager);
                this._trade.show(contents);
                view = this._trade;
            }
            else if (contents.contractType == 2)
            {
                if (this._reward == null)
                    this._reward = new RewardContract(this, this._presetManager);
                this._reward.show(contents);
                view = this._reward;
            }
            if (view != null && this._xCache != UNSET_LOCATION &&
                this._yCache != UNSET_LOCATION)
            {
                view.window.x = this._xCache;
                view.window.y = this._yCache;
            }
        }

        public function saveContract(contract:AbstractContract)
        {
            var validationError= contract.validate();
            if (validationError != null)
            {
                this._roomEvents.windowManager.alert(
                    "${wiredfurni.error.title}", validationError, 0, null);
                return;
            }
            var data:Array<ASAny> = [];
            contract.addContentsToComposer(data);
            this.communicationManager.connection.send(
                new SaveChestContractMessageComposer(data));
        }

        function onContractUpdateResult(
            event:ChestContractUpdateResultMessageEvent)
        {
            var result= event.getParser();
            if (result.isSuccess)
            {
                this.closeAllOpenFrames();
                return;
            }
            var key= "wiredcontracts.error." + result.failCode;
            var message=
                this._roomEvents.localization.getLocalizationWithParams(key, key);
            this._roomEvents.windowManager.alert(
                "${wiredfurni.error.title}", message, 0, null);
        }

        public function clear()
        {
            this._pendingContractId = -1;
            this.closeAllOpenFrames();
            this._xCache = UNSET_LOCATION;
            this._yCache = UNSET_LOCATION;
            if (this._addEdit != null) this._addEdit.forgetLocation();
        }

        public function closeAllOpenFrames()
        {
            if (this._addEdit != null) this._addEdit.hide();
            if (this._payment != null && this._payment.isShowing())
                this._payment.hide();
            else if (this._reward != null && this._reward.isShowing())
                this._reward.hide();
            else if (this._trade != null && this._trade.isShowing())
                this._trade.hide();
        }

        public function cacheWindowLocation(window:IWindow)
        {
            this._xCache = window.x;
            this._yCache = window.y;
        }

        public var addEditContractElement(get,never):AddEditContractElement;
public function  get_addEditContractElement():AddEditContractElement
        {
            if (this._addEdit == null)
                this._addEdit = new AddEditContractElement(
                    this, this._presetManager);
            return this._addEdit;
        }

        public var communicationManager(get,never):IHabboCommunicationManager;
public function  get_communicationManager():IHabboCommunicationManager
        {
            return this._roomEvents.communication;
        }
        public function addMessageEvent(event:IMessageEvent)
        {
            if (this.communicationManager != null)
                this.communicationManager.addHabboConnectionMessageEvent(event);
        }
        public function removeMessageEvent(event:IMessageEvent)
        {
            if (this.communicationManager != null)
                this.communicationManager.removeHabboConnectionMessageEvent(event);
        }
        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed) return;
            if (this._addEdit != null) this._addEdit.dispose();
            if (this._trade != null) this._trade.dispose();
            if (this._reward != null) this._reward.dispose();
            if (this._payment != null) this._payment.dispose();
            this._addEdit = null;
            this._trade = null;
            this._reward = null;
            this._payment = null;
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{event = _tmp_;
                this.removeMessageEvent(event);
};
            this._messageEvents = null;
            this._presetManager = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

