package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.ui.widget.events._Str_5099;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class FurnitureTrophyWidgetHandler implements IRoomWidgetHandler 
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
            return RoomWidgetEnum.FURNI_TROPHY_WIDGET;
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
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_TROPHY];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFurniToWidgetMessage = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5 = Math.NaN;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11:_Str_5099 = null;
            if ((this.disposed || (k == null)))
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_TROPHY:
                    _local_2 = Std.downcast(k , RoomWidgetFurniToWidgetMessage);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.id, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_4 = _local_3.getModel();
                        if (_local_4 != null)
                        {
                            _local_5 = _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_COLOR);
                            _local_6 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_DATA);
                            _local_7 = ASCompat.parseInt(_local_4.getString(RoomObjectVariableEnum.FURNITURE_EXTRAS));
                            _local_8 = _local_6.substring(0, _local_6.indexOf("\t"));
                            _local_6 = _local_6.substring((_local_8.length + 1), _local_6.length);
                            _local_9 = _local_6.substring(0, _local_6.indexOf("\t"));
                            _local_10 = _local_6.substring((_local_9.length + 1), _local_6.length);
                            _local_11 = new _Str_5099(_Str_5099.RWTDUE_TROPHY_DATA, _local_5, _local_8, _local_9, _local_10, _local_7);
                            this._container.events.dispatchEvent(_local_11);
                        }
                    }
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processEvent(k:Event)
        {
            var _local_2:Event = null;
        }

        public function update()
        {
        }
public function new(){}
    }

