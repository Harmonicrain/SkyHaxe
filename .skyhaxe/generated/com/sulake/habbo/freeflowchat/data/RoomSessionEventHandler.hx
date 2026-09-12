package com.sulake.habbo.freeflowchat.data
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.session.events.RoomSessionEvent;

     class RoomSessionEventHandler implements IDisposable 
    {
        var _component:HabboFreeFlowChat;

        public function new(k:HabboFreeFlowChat)
        {
            this._component = k;
            this._component.roomSessionManager.events.addEventListener(RoomSessionEvent.CREATED, this._Str_19700);
            this._component.roomSessionManager.events.addEventListener(RoomSessionEvent.ENDED, this._Str_21581);
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._component != null)
                {
                    this._component.roomSessionManager.events.removeEventListener(RoomSessionEvent.CREATED, this._Str_19700);
                    this._component.roomSessionManager.events.removeEventListener(RoomSessionEvent.ENDED, this._Str_21581);
                    this._component = null;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }

        function _Str_19700(k:RoomSessionEvent)
        {
            this._component.roomEntered();
        }

        function _Str_21581(k:RoomSessionEvent)
        {
            this._component.roomLeft();
        }
    }

