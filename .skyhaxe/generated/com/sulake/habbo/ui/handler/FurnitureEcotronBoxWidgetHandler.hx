package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetEcotronBoxOpenMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetEcotronBoxOpenedMessage;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.ui.widget.events._Str_3072;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.display.BitmapData;
    import com.sulake.habbo.session.events.RoomSessionPresentEvent;
    import com.sulake.habbo.room.ImageResult;
    import flash.events.Event;

     class FurnitureEcotronBoxWidgetHandler implements IRoomWidgetHandler implements  IGetImageListener 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _objectId:Int = -1;
        var _name:String = "";


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FURNI_ECOTRONBOX_WIDGET;
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
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_ECOTRONBOX, RoomWidgetEcotronBoxOpenMessage.RWEBOM_OPEN_ECOTRONBOX, RoomWidgetEcotronBoxOpenedMessage.RWEBOM_ECOTRONBOX_OPENED];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFurniToWidgetMessage = null;
            var _local_3:IRoomObject = null;
            var _local_4:RoomWidgetEcotronBoxOpenMessage = null;
            var _local_5:IRoomObjectModel = null;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8:IFurnitureData = null;
            var _local_9:String = null;
            var _local_10 = false;
            var _local_11:_Str_3072 = null;
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_ECOTRONBOX:
                    _local_2 = Std.downcast(k , RoomWidgetFurniToWidgetMessage);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.id, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_5 = _local_3.getModel();
                        if (_local_5 != null)
                        {
                            this._objectId = _local_2.id;
                            _local_6 = _local_5.getString(RoomObjectVariableEnum.FURNITURE_DATA);
                            if (_local_6 == null)
                            {
                                return null;
                            }
                            _local_7 = Std.int(_local_5.getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                            _local_8 = this._container.sessionDataManager.getFloorItemData(_local_7);
                            _local_9 = ((_local_8 != null) ? _local_8.className : "");
                            _local_10 = (this._container.roomSession.isRoomOwner || this._container.sessionDataManager.isAnyRoomController);
                            _local_11 = new _Str_3072(_Str_3072.RWEBDUE_PACKAGEINFO, _local_2.id, _local_6, _local_9, _local_10);
                            this._container.events.dispatchEvent(_local_11);
                        }
                    }
                    
                case RoomWidgetEcotronBoxOpenMessage.RWEBOM_OPEN_ECOTRONBOX:
                    _local_4 = Std.downcast(k , RoomWidgetEcotronBoxOpenMessage);
                    if (_local_4.objectId != this._objectId)
                    {
                        return null;
                    }
                    if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                    {
                        this._container.roomSession.sendPresentOpenMessage(_local_4.objectId);
                    }
                    
            }
            return null;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this.disposed)
            {
                return;
            }
            var _local_3= new _Str_3072(_Str_3072.RWEBDUE_CONTENTS, 0, this._name, "", false, _arg_2);
            this._container.events.dispatchEvent(_local_3);
        }

        public function imageFailed(k:Int)
        {
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomSessionPresentEvent.RSPE_PRESENT_OPENED];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionPresentEvent = null;
            var _local_3:ImageResult = null;
            var _local_4:IFurnitureData = null;
            var _local_5:_Str_3072 = null;
            if (k == null)
            {
                return;
            }
            if ((((!(this._container == null)) && (!(this._container.events == null))) && (!(k == null))))
            {
                switch (k.type)
                {
                    case RoomSessionPresentEvent.RSPE_PRESENT_OPENED:
                        _local_2 = Std.downcast(k , RoomSessionPresentEvent);
                        if (_local_2 != null)
                        {
                            _local_3 = null;
                            this._name = "";
                            if (_local_2.itemType == "s")
                            {
                                _local_3 = this._container.roomEngine.getFurnitureIcon(_local_2.classId, this);
                                _local_4 = this._container.sessionDataManager.getFloorItemData(_local_2.classId);
                            }
                            else
                            {
                                if (_local_2.itemType == "i")
                                {
                                    _local_3 = this._container.roomEngine.getWallItemIcon(_local_2.classId, this);
                                    _local_4 = this._container.sessionDataManager.getWallItemData(_local_2.classId);
                                }
                            }
                            if (_local_4 != null)
                            {
                                this._name = _local_4.localizedName;
                            }
                            if (_local_3 != null)
                            {
                                _local_5 = new _Str_3072(_Str_3072.RWEBDUE_CONTENTS, 0, this._name, "", false, _local_3.data);
                                this._container.events.dispatchEvent(_local_5);
                            }
                        }
                }
            }
        }

        public function update()
        {
        }
public function new(){}
    }

