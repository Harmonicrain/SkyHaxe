package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetLetUserInMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionDoorbellEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetDoorbellEvent;
    import flash.events.Event;

     class DoorbellWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.DOORBELL;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetLetUserInMessage.RWLUIM_LET_USER_IN];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetLetUserInMessage = null;
            switch (k.type)
            {
                case RoomWidgetLetUserInMessage.RWLUIM_LET_USER_IN:
                    _local_2 = Std.downcast(k , RoomWidgetLetUserInMessage);
                    this._container.roomSession.letUserIn(_local_2.userName, _local_2._Str_23117);
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomSessionDoorbellEvent.RSDE_DOORBELL, RoomSessionDoorbellEvent.REJECTED, RoomSessionDoorbellEvent.RSDE_ACCEPTED];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionDoorbellEvent = null;
            switch (k.type)
            {
                case RoomSessionDoorbellEvent.RSDE_DOORBELL:
                    _local_2 = Std.downcast(k , RoomSessionDoorbellEvent);
                    if (_local_2 == null)
                    {
                        return;
                    }
                    this._container.events.dispatchEvent(new RoomWidgetDoorbellEvent(RoomWidgetDoorbellEvent.RWDE_RINGING, _local_2.userName));
                    return;
                case RoomSessionDoorbellEvent.REJECTED:
                    _local_2 = Std.downcast(k , RoomSessionDoorbellEvent);
                    if (_local_2 == null)
                    {
                        return;
                    }
                    this._container.events.dispatchEvent(new RoomWidgetDoorbellEvent(RoomWidgetDoorbellEvent.REJECTED, _local_2.userName));
                    return;
                case RoomSessionDoorbellEvent.RSDE_ACCEPTED:
                    _local_2 = Std.downcast(k , RoomSessionDoorbellEvent);
                    if (_local_2 == null)
                    {
                        return;
                    }
                    this._container.events.dispatchEvent(new RoomWidgetDoorbellEvent(RoomWidgetDoorbellEvent.RWDE_ACCEPTED, _local_2.userName));
                    return;
            }
        }

        public function update()
        {
        }
public function new(){}
    }

