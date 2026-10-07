package com.sulake.habbo.help.cfh.registry.chat
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;

     class ChatEventHandler implements IDisposable 
    {
        var _component:HabboHelp;

        public function new(k:HabboHelp)
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
            var _local_2= this._component.roomSessionManager.getSession(k.session.roomId).userDataManager.getUserDataByIndex(k.userId);
            var _local_3= this._component.navigator.enteredGuestRoomData;
            if ((((!(_local_2 != null)) || (!(_local_2.type == RoomObjectTypeEnum.HABBO))) || (!(_local_3 != null))))
            {
                return;
            }
            var _local_4= ((_local_3 != null) ? _local_3.roomName : "Unknown Room");
            this._component.chatRegistry.addItem(k.session.roomId, _local_4, _local_2.id, _local_2.name, k.text);
        }
    }

