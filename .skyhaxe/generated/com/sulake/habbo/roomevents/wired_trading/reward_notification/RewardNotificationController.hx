package com.sulake.habbo.roomevents.wired_trading.reward_notification
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.WiredTransactionSuccessContents;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTransactionSuccessMessageEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.UbuntuPresetManager;

     class RewardNotificationController
        implements ILinkEventTracker implements  IDisposable
    {
        static inline final MAX_OPEN_REWARD_NOTIFICATIONS= 10;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _messageEvents:Vector<IMessageEvent>;
        var _contentsById:Map;
        var _views:Vector<RewardNotificationView>;
        var _presetManager:PresetManager;
        var _disposed:Bool = false;

        public function new(
            roomEvents:HabboUserDefinedRoomEvents)
        {
var event:IMessageEvent  = null;            this._roomEvents = roomEvents;
            this._messageEvents = new Vector<IMessageEvent>();
            this._messageEvents.push(new WiredTransactionSuccessMessageEvent(
                this.onTransactionSuccess));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{event = _tmp_;
                roomEvents.communication.addHabboConnectionMessageEvent(event);
};
            this._contentsById = new Map();
            this._views = new Vector<RewardNotificationView>();
            this._presetManager = new UbuntuPresetManager(roomEvents);
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String { return "wiredrewards/"; }

        public function linkReceived(link:String)
        {
            var parts:Array<ASAny> = (cast link.split("/"));
            if (parts.length >= 3 && parts[1] == "open")
                this.openRewardView(ASCompat.toInt(parts[2]));
        }

        function onTransactionSuccess(
            event:WiredTransactionSuccessMessageEvent)
        {
            var contents=
                event.getParser().contents;
            if (contents.rewardContents == null) return;
            this._contentsById.add(contents.internalId, contents);
            if (contents.openByDefault)
                this.openRewardView(contents.internalId);
        }

        public function openRewardView(internalId:Int)
        {
var existing:RewardNotificationView  = null, distance = 0, step = 0;            if (this._disposed) return;
            final _iter_ = this._views; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
existing = _tmp_;
                if (existing.contents != null &&
                    existing.contents.internalId == internalId)
                {
                    existing.window.activate();
                    return;
                }
            }
            var contents=
                ASCompat.dynamicAs(this._contentsById.getValue(internalId) ,                     WiredTransactionSuccessContents);
            if (contents == null) return;
            while (this._views.length >= MAX_OPEN_REWARD_NOTIFICATIONS)
                this.closeRewardView(this._views[0]);

            var viewIndex= this._views.length == 0 ? 0 :
                (this._views[this._views.length - 1].viewIndex + 1) %
                    MAX_OPEN_REWARD_NOTIFICATIONS;
            var xOffset= 0;
            var yOffset= 0;
            if (viewIndex > 0)
            {
distance= 25;
step= Std.int((viewIndex + 1) / 2);
                if ((viewIndex + 1) % 2 == 0)
                {
                    xOffset = distance * step;
                    yOffset = distance * step;
                }
                else
                {
                    xOffset = -distance * step;
                    yOffset = -distance * step;
                }
            }
            var view=
                new RewardNotificationView(this, this._presetManager);
            view.show(contents, xOffset, yOffset, viewIndex);
            this._views.push(view);
        }

        public function closeRewardView(view:RewardNotificationView)
        {
            var index= this._views.indexOf(view);
            if (index != -1) this._views.splice(index, 1);
            view.dispose();
        }

        public function closeAllViews()
        {
var view:RewardNotificationView  = null;            var views= this._views;
            this._views = new Vector<RewardNotificationView>();
            if (checkNullIteratee(views)) for (_tmp_ in views) {view = _tmp_;
view.dispose();
};
        }

        public function openLink(link:String)
        {
            this._roomEvents.context.createLinkEvent(link);
        }

        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed) return;
            this._disposed = true;
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{event = _tmp_;
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
};
            this._messageEvents = null;
            this.closeAllViews();
            this._views = null;
            this._contentsById.dispose();
            this._contentsById = null;
            this._presetManager = null;
            this._roomEvents = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

