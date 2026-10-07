package com.sulake.habbo.help.cfh.registry.instantmessage
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.habbo.communication.messages.incoming.friendlist.NewConsoleMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.RoomInviteEvent;

     class InstantMessageEventHandler implements IDisposable 
    {
        var _component:HabboHelp;

        public function new(k:HabboHelp)
        {
            this._component = k;
            this._component.addMessageEvent(new NewConsoleMessageEvent(this._Str_24521));
            this._component.addMessageEvent(new RoomInviteEvent(this.onRoomInvite));
        }

        public function _Str_24521(k:NewConsoleMessageEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_2= k.getParser();
            if (((_local_2.senderId < 0) && (!(_local_2.extraData == null))))
            {
                _local_3 = _local_2.extraData.split("/")[2];
                _local_4 = _local_2.extraData.split("/")[0];
                this._component.instantMessageRegistry.addItem(_local_2.senderId, ((_local_3 + ":") + _local_4), _local_2.messageText);
            }
            else
            {
                this._component.instantMessageRegistry.addItem(_local_2.senderId, "", _local_2.messageText);
            }
        }

        public function onRoomInvite(k:RoomInviteEvent)
        {
            var _local_2= k.getParser();
            this._component.instantMessageRegistry.addItem(_local_2.senderId, "", _local_2.messageText);
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._component != null)
                {
                    this._component = null;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }
    }

