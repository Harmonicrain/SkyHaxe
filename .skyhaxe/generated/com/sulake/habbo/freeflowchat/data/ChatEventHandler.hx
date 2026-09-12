package com.sulake.habbo.freeflowchat.data
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.room.utils.IVector3d;

     class ChatEventHandler implements IDisposable 
    {
        var _component:HabboFreeFlowChat;
        var _lastAddedChatMs:UInt = 0;
        var _chatFakeMsIncrementor:UInt = 0;

        public function new(k:HabboFreeFlowChat)
        {
            this._component = k;
            this._component.roomSessionManager.events.addEventListener(RoomSessionChatEvent.RSCE_CHAT_EVENT, this.onRoomChat);
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._component != null)
                {
                    this._component.roomSessionManager.events.removeEventListener(RoomSessionChatEvent.RSCE_CHAT_EVENT, this.onRoomChat);
                    this._component = null;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }

        function onRoomChat(k:RoomSessionChatEvent)
        {
            var _local_2= this._component.roomEngine.getRoomObject(k.session.roomId, k.userId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var _local_3:IVector3d = null;
            if (_local_2 != null)
            {
                _local_3 = _local_2.getLocation();
            }
            var _local_4:UInt = flash.Lib.getTimer();
            if (_local_4 == this._lastAddedChatMs)
            {
                this._chatFakeMsIncrementor++;
            }
            else
            {
                this._chatFakeMsIncrementor = 0;
            }
            this._component.insertChat(new ChatItem(k, ASCompat.toInt(_local_4 + this._chatFakeMsIncrementor), _local_3, k.extraParam));
            this._lastAddedChatMs = _local_4;
        }
    }

