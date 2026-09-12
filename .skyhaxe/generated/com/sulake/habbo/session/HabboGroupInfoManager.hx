package com.sulake.habbo.session
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupBadgesMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupBadgesMessageComposer;

     class HabboGroupInfoManager implements IDisposable 
    {
        var _sessionDataManager:SessionDataManager;
        var _badges:Map;
        var _roomReadyMessageEvent:IMessageEvent;
        var _habboGroupBadgesMessageEvent:IMessageEvent;

        public function new(k:SessionDataManager)
        {
            this._sessionDataManager = k;
            this._badges = new Map();
            if (this._sessionDataManager.communication != null)
            {
                this._roomReadyMessageEvent = this._sessionDataManager.communication.addHabboConnectionMessageEvent(new RoomReadyMessageEvent(this.onRoomReady));
                this._habboGroupBadgesMessageEvent = this._sessionDataManager.communication.addHabboConnectionMessageEvent(new HabboGroupBadgesMessageEvent(this._Str_18218));
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._sessionDataManager == null;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._sessionDataManager.communication != null)
            {
                this._sessionDataManager.communication.removeHabboConnectionMessageEvent(this._roomReadyMessageEvent);
                this._sessionDataManager.communication.removeHabboConnectionMessageEvent(this._habboGroupBadgesMessageEvent);
            }
            this._badges = null;
            this._sessionDataManager = null;
        }

        function onRoomReady(k:IMessageEvent)
        {
            this._sessionDataManager.send(new GetHabboGroupBadgesMessageComposer());
        }

        function _Str_18218(k:HabboGroupBadgesMessageEvent)
        {
            var _local_3 = 0;
            var _local_2= k.badges;
            var _local_4 = 0;
            while ((_local_4 : UInt) < _local_2.length)
            {
                _local_3 = ASCompat.toInt(_local_2.getKey(_local_4));
                this._badges.remove(_local_3);
                this._badges.add(_local_3, _local_2.getWithIndex(_local_4));
                _local_4++;
            }
        }

        public function getBadgeId(k:Int):String
        {
            return this._badges.getValue(k);
        }
    }

