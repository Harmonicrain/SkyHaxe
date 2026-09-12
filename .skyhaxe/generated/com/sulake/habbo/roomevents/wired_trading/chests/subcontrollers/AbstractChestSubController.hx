package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestWrapperView;

     class AbstractChestSubController implements IChestSubController
    {
        var _disposed:Bool = false;
        var _parent:WiredChestController;
        var _messageEvents:Vector<IMessageEvent> = new Vector();

        public function new(parent:WiredChestController)
        {
            this._parent = parent;
        }
        public var parentController(get,never):WiredChestController;
public function  get_parentController():WiredChestController { return this._parent; }
        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents { return this._parent.roomEvents; }
        public function localize(key:String):String
        {
            return this.localization.getLocalization(key, key);
        }
        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._parent.localization;
        }
        function addMessageEvent(event:IMessageEvent)
        {
            this._messageEvents.push(event);
            this._parent.addMessageEvent(event);
        }
        public var canEdit(get,never):Bool;
public function  get_canEdit():Bool { return this.wrapperView.canEdit; }
        public var canRead(get,never):Bool;
public function  get_canRead():Bool { return this.wrapperView.canRead; }
        public var canWithdraw(get,never):Bool;
public function  get_canWithdraw():Bool { return this.wrapperView.canWithdraw; }
        public var wrapperView(get,never):WiredChestWrapperView;
public function  get_wrapperView():WiredChestWrapperView { return this._parent.chestWrapperView; }
        public var viewingChestId(get,never):Int;
public function  get_viewingChestId():Int { return this.wrapperView.viewingChestId; }
        public var type(get,never):Int;
public function  get_type():Int { return -1; }
        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer { return null; }
        public var title(get,never):String;
public function  get_title():String { return ""; }
        public var isEmpty(get,never):Bool;
public function  get_isEmpty():Bool { return true; }
        public function clear() {}
        public var itemCount(get,never):Int;
public function  get_itemCount():Int { return 0; }
        public function updateUI() {}
        public var allowResizing(get,never):Bool;
public function  get_allowResizing():Bool { return true; }
        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed) { return; }
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
event = _tmp_;
                this._parent.removeMessageEvent(event);
                event.dispose();
            }
            this._messageEvents = null;
            this._parent = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

