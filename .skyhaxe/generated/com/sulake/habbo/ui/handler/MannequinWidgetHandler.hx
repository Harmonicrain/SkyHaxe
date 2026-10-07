package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.widget.furniture.mannequin.MannequinWidget;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.events.Event;

     class MannequinWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _widget:MannequinWidget;
        var _container:IRoomWidgetHandlerContainer;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            if (!this._isDisposed)
            {
                this.container = null;
                this._isDisposed = true;
            }
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.MANNEQUIN;
        }

        public var widget(never,set):MannequinWidget;
public function  set_widget(k:MannequinWidget):MannequinWidget        {
            return this._widget = k;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
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
            var k:Array<ASAny> = [];
            k.push(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MANNEQUIN);
            return k;
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineObjectEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MANNEQUIN:
                    _local_2 = Std.downcast(k , RoomEngineObjectEvent);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                    _local_4 = _local_3.getModel();
                    _local_5 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_FIGURE);
                    _local_6 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_GENDER);
                    _local_7 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_NAME);
                    if (((!(_local_5 == null)) && (!(_local_6 == null))))
                    {
                        this._widget.open(_local_3.getId(), _local_5, _local_6, _local_7);
                    }
                    return;
            }
        }

        public function update()
        {
        }
public function new(){}
    }

