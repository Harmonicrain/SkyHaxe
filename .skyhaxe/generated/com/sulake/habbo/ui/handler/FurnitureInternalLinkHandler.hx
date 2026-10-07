package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.core.runtime.Component;
    import flash.events.Event;

     class FurnitureInternalLinkHandler implements IRoomWidgetHandler 
    {
        static inline final INTERNALLINK= "internalLink";

        var _container:IRoomWidgetHandlerContainer;


        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.INTERNAL_LINK;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return null;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_REQUEST_INTERNAL_LINK];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineTriggerWidgetEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:String = null;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_INTERNAL_LINK:
                    _local_2 = Std.downcast(k , RoomEngineTriggerWidgetEvent);
                    if (((!(k == null)) && (!(this._container.roomEngine == null))))
                    {
                        _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                        if (_local_3 != null)
                        {
                            _local_4 = _local_3.getModel();
                            _local_5 = _local_4.getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA).getValue(INTERNALLINK);
                            if (((_local_5 == null) || (_local_5.length == 0)))
                            {
                                _local_5 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_INTERNAL_LINK);
                            }
                            if (((!(_local_5 == null)) && (_local_5.length > 0)))
                            {
                                ASCompat.reinterpretAs(this._container.roomEngine , Component).context.createLinkEvent(_local_5);
                            }
                        }
                    }
                    return;
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }
public function new(){}
    }

