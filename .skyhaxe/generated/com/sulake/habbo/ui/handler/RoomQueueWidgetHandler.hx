package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomQueueMessage;
    import com.sulake.habbo.session.events.RoomSessionQueueEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomQueueUpdateEvent;
    import flash.events.Event;

     class RoomQueueWidgetHandler implements IRoomWidgetHandler 
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
            return RoomWidgetEnum.CHAT_WIDGET;
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
            var k:Array<ASAny> = [];
            k.push(RoomWidgetRoomQueueMessage.RWRQM_EXIT_QUEUE);
            k.push(RoomWidgetRoomQueueMessage.RWRQM_CHANGE_TO_SPECTATOR_QUEUE);
            k.push(RoomWidgetRoomQueueMessage.RWRQM_CHANGE_TO_VISITOR_QUEUE);
            k.push(RoomWidgetRoomQueueMessage.RWRQM_CLUB_LINK);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            if (((this._container == null) || (this._container.roomSession == null)))
            {
                return null;
            }
            var _local_2= Std.downcast(k , RoomWidgetRoomQueueMessage);
            if (_local_2 == null)
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetRoomQueueMessage.RWRQM_EXIT_QUEUE:
                    this._container.roomSession.quit();
                    
                case RoomWidgetRoomQueueMessage.RWRQM_CHANGE_TO_SPECTATOR_QUEUE:
                    this._container.roomSession.changeQueue(RoomSessionQueueEvent.QUEUE_TARGET_SPECTATOR);
                    
                case RoomWidgetRoomQueueMessage.RWRQM_CHANGE_TO_VISITOR_QUEUE:
                    this._container.roomSession.changeQueue(RoomSessionQueueEvent.QUEUE_TARGET_VISITOR);
                    
                case RoomWidgetRoomQueueMessage.RWRQM_CLUB_LINK:
                    if (this._container.catalog != null)
                    {
                        this._container.catalog.openClubCenter();
                    }
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomSessionQueueEvent.RSQE_QUEUE_STATUS];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionQueueEvent = null;
            var _local_3:String = null;
            var _local_4 = false;
            var _local_5:Array<ASAny> = null;
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8:RoomWidgetRoomQueueUpdateEvent = null;
            if (((this._container == null) || (this._container.events == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionQueueEvent.RSQE_QUEUE_STATUS:
                    _local_2 = Std.downcast(k , RoomSessionQueueEvent);
                    if (_local_2 == null)
                    {
                        return;
                    }
                    switch (_local_2.queueSetTarget)
                    {
                        case RoomSessionQueueEvent.QUEUE_TARGET_VISITOR:
                            _local_3 = RoomWidgetRoomQueueUpdateEvent.RWRQUE_VISITOR_QUEUE_STATUS;
                            
                        case RoomSessionQueueEvent.QUEUE_TARGET_SPECTATOR:
                            _local_3 = RoomWidgetRoomQueueUpdateEvent.RWRQUE_SPECTATOR_QUEUE_STATUS;
                            
                    }
                    if (_local_3 == null)
                    {
                        return;
                    }
                    _local_4 = true;
                    if (this._container.inventory != null)
                    {
                        _local_4 = (this._container.inventory.clubDays > 0);
                    }
                    _local_5 = _local_2.queueTypes;
                    _local_7 = false;
                    if (_local_5.length > 1)
                    {
                        if ((_local_4 && (!(_local_2.queueTypes.indexOf(RoomSessionQueueEvent.C) == -1))))
                        {
                            _local_6 = (_local_2.getQueueSize(RoomSessionQueueEvent.C) + 1);
                            _local_7 = true;
                        }
                        else
                        {
                            _local_6 = (_local_2.getQueueSize(RoomSessionQueueEvent.D) + 1);
                        }
                    }
                    else
                    {
                        _local_6 = (_local_2.getQueueSize(_local_5[0]) + 1);
                    }
                    _local_8 = new RoomWidgetRoomQueueUpdateEvent(_local_3, _local_6, _local_4, _local_2.isActive, _local_7);
                    this._container.events.dispatchEvent(_local_8);
                    return;
            }
        }

        public function update()
        {
        }
public function new(){}
    }

