package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.WithdrawChestFurniMessageComposer;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.FurniChestView;

     class FurniChestSubController extends AbstractChestSubController
    {
        var _view:FurniChestView;
        var _storages:Vector<ChestStorage> = new Vector();
        var _receivedFragments:ASDictionary<ASAny,ASAny>;
        var _expectedFragments:Int = 0;

        public function new(parent:WiredChestController)
        {
            super(parent);
            this.addMessageEvent(new ChestFurniContentsUpdateMessageEvent(this.onItemsUpdated));
            this.addMessageEvent(new ChestFurniContentsMessageEvent(this.onItemsChunk));
            this._view = new FurniChestView(this);
        }
        function onItemsUpdated(event:ChestFurniContentsUpdateMessageEvent)
        {
var removedId = 0, existing:ChestStorage  = null, incoming:ChestStorage  = null;            var parser= event.getParser();
            if (parentController.activeChestId != parser.chestId
                || parentController.status != WiredChestController.STATUS_OPEN)
            {
                return;
            }
            var removedById= new ASDictionary<ASAny,ASAny>();
            final _iter_ = parser.removedIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { removedId = _tmp_;
removedById[removedId] = true; }
            var retained= new Vector<ChestStorage>();
            var removed= new Vector<ChestStorage>();
            var known= new ASDictionary<ASAny,ASAny>();
            final _iter_ = this._storages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
existing = _tmp_;
                if (removedById[existing.inventoryId]) { removed.push(existing); }
                else
                {
                    retained.push(existing);
                    known[existing.inventoryId] = true;
                }
            }
            var added= new Vector<ChestStorage>();
            final _iter_ = parser.addedStorage; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
incoming = _tmp_;
                if (!known[incoming.inventoryId])
                {
                    retained.push(incoming);
                    added.push(incoming);
                    known[incoming.inventoryId] = true;
                }
            }
            this._storages = retained;
            this._view.itemsUpdated(removed, added);
        }
        function onItemsChunk(event:ChestFurniContentsMessageEvent)
        {
var storage:ChestStorage  = null;            var parser= event.getParser();
            if (parser.fragmentNo == 0)
            {
                if (parentController.requestedChestId != parser.chestId) { return; }
                this._view.clear();
                this._storages = new Vector<ChestStorage>();
                this._receivedFragments = new ASDictionary<ASAny,ASAny>();
                this._expectedFragments = parser.totalFragments;
                parentController.setOpeningStatus(parser.chestId);
            }
            if (parentController.activeChestId != parser.chestId
                || parentController.status != WiredChestController.STATUS_OPENING
                || parser.totalFragments != this._expectedFragments
                || ASCompat.toBool(this._receivedFragments[parser.fragmentNo]))
            {
                return;
            }
            /*
             * July sends ordered fragments. Reject a gap rather than opening a
             * silently incomplete chest when packets are malformed/replayed.
             */
            if (parser.fragmentNo > 0 && !this._receivedFragments[parser.fragmentNo - 1])
            {
                parentController.close();
                return;
            }
            this._receivedFragments[parser.fragmentNo] = true;
            final _iter_ = parser.storageChunk; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
storage = _tmp_;
                this._storages.push(storage);
            }
            if (parser.fragmentNo == parser.totalFragments - 1)
            {
                parentController.setOpenStatus(parser.chestId, this);
                this._view.itemsInitialize(this._storages);
                this._receivedFragments = null;
            }
        }
        public function withdrawItemsWithType(type:ChestItemType, amount:Int)
        {
            parentController.send(new WithdrawChestFurniMessageComposer(
                viewingChestId, type, amount));
        }
        public function viewLogsWithType(type:ChestItemType)
        {
            /* Activated when the July chest-log packet family is registered. */
        }
        override public function  get_type():Int { return ChestType.FURNI; }
        override public function  get_title():String { return localize("wiredchests.furni_chest"); }
        override public function  get_view():IWindowContainer { return this._view.container; }
        override public function  get_isEmpty():Bool { return this._storages.length == 0; }
        override public function  get_itemCount():Int { return this._storages.length; }
        override public function clear()
        {
            this._storages = new Vector<ChestStorage>();
            this._receivedFragments = null;
            this._expectedFragments = 0;
            this._view.clear();
        }
        override public function updateUI() { this._view.updateUI(); }
        override public function dispose()
        {
            if (disposed) { return; }
            this._view.dispose();
            this._view = null;
            super.dispose();
        }
    }

