package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomObjectMessage;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.habbo.ui.widget.events._Str_4178;
    import flash.events.Event;

     class FurniChooserWidgetHandler implements IRoomWidgetHandler 
    {
        var _container:IRoomWidgetHandlerContainer = null;
        var _isDisposed:Bool = false;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FURNI_CHOOSER;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER);
            k.push(RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER_ADD);
            k.push(RoomWidgetRoomObjectMessage.RWROM_SELECT_OBJECT);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetRoomObjectMessage = null;
            if (k == null)
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER:
                    this._Str_23467();
                    
                case RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER_ADD:
                    this._Str_24503(Std.downcast(k , RoomWidgetRequestWidgetMessage));
                    
                case RoomWidgetRoomObjectMessage.RWROM_SELECT_OBJECT:
                    _local_2 = Std.downcast(k , RoomWidgetRoomObjectMessage);
                    if (_local_2 == null)
                    {
                        return null;
                    }
                    if (((_local_2.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) || (_local_2.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)))
                    {
                        this._container.roomEngine.selectRoomObject(this._container.roomSession.roomId, _local_2.id, _local_2.category);
                    }
                    
            }
            return null;
        }

        function _Str_23467()
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:IFurnitureData = null;
            var _local_6:String = null;
            var _local_7:IRoomObject = null;
            var _local_9:String = null;
            var _local_10 = 0;
            if ((((this._container == null) || (this._container.roomSession == null)) || (this._container.roomEngine == null)))
            {
                return;
            }
            if (this._container.roomSession.userDataManager == null)
            {
                return;
            }
            var k= this._container.roomSession.roomId;
            var _local_2:Array<ASAny> = [];
            var _local_8= this._container.roomEngine.getRoomObjectCount(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            _local_3 = 0;
            while (_local_3 < _local_8)
            {
                _local_7 = this._container.roomEngine.getRoomObjectWithIndex(k, _local_3, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                if (_local_7 != null)
                {
                    _local_4 = Std.int(_local_7.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                    _local_5 = this._container.sessionDataManager.getFloorItemData(_local_4);
                    if (_local_5 != null)
                    {
                        _local_6 = _local_5.localizedName;
                    }
                    else
                    {
                        _local_6 = _local_7.getType();
                    }
                    _local_2.push(new _Str_3405(_local_7.getId(), RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, _local_6, _local_7.getModel().getString(RoomObjectVariableEnum.FURNITURE_OWNER_NAME)));
                }
                _local_3++;
            }
            _local_8 = this._container.roomEngine.getRoomObjectCount(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            _local_3 = 0;
            while (_local_3 < _local_8)
            {
                _local_7 = this._container.roomEngine.getRoomObjectWithIndex(k, _local_3, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
                if (_local_7 != null)
                {
                    _local_9 = _local_7.getType();
                    if (_local_9.indexOf("poster") == 0)
                    {
                        _local_10 = ASCompat.toInt(ASCompat.stringReplace(_local_9, "poster", ""));
                        _local_6 = this._container.localization.getLocalization((("poster_" + Std.string(_local_10)) + "_name"), (("poster_" + Std.string(_local_10)) + "_name"));
                    }
                    else
                    {
                        _local_4 = Std.int(_local_7.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                        _local_5 = this._container.sessionDataManager.getWallItemData(_local_4);
                        if (((!(_local_5 == null)) && (_local_5.localizedName.length > 0)))
                        {
                            _local_6 = _local_5.localizedName;
                        }
                        else
                        {
                            _local_6 = _local_9;
                        }
                    }
                    _local_2.push(new _Str_3405(_local_7.getId(), RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM, _local_6, _local_7.getModel().getString(RoomObjectVariableEnum.FURNITURE_OWNER_NAME)));
                }
                _local_3++;
            }
            ASCompat.ASArray.sort(_local_2, this._Str_16552);
            this._container.events.dispatchEvent(new _Str_4178(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT, _local_2, this._container.sessionDataManager.isAnyRoomController));
        }

        function _Str_24503(k:RoomWidgetRequestWidgetMessage)
        {
            var _local_2:IRoomObject = null;
            var _local_3:_Str_3405 = null;
            if ((((k == null) || (this._container == null)) || (this._container.roomSession == null)) || (this._container.roomEngine == null))
            {
                return;
            }
            _local_2 = this._container.roomEngine.getRoomObject(this._container.roomSession.roomId, k.id, k.category);
            if (_local_2 == null)
            {
                return;
            }
            _local_3 = this._Str_24886(_local_2, k.category);
            if (_local_3 == null)
            {
                return;
            }
            this._container.events.dispatchEvent(new _Str_4178(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT_ADD, [_local_3], this._container.sessionDataManager.isAnyRoomController));
        }

        function _Str_24886(k:IRoomObject, _arg_2:Int):_Str_3405
        {
            var _local_3 = 0;
            var _local_4:IFurnitureData = null;
            var _local_5:String = null;
            var _local_6 = 0;
            _local_5 = "";
            if (k == null)
            {
                return null;
            }
            if (_arg_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
            {
                _local_3 = Std.int(k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                _local_4 = this._container.sessionDataManager.getFloorItemData(_local_3);
                _local_5 = ((_local_4 != null) ? _local_4.localizedName : k.getType());
            }
            else
            {
                if (_arg_2 != RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                {
                    return null;
                }
                _local_5 = k.getType();
                if (_local_5.indexOf("poster") == 0)
                {
                    _local_6 = ASCompat.toInt(ASCompat.stringReplace(_local_5, "poster", ""));
                    _local_5 = this._container.localization.getLocalization((("poster_" + Std.string(_local_6)) + "_name"), (("poster_" + Std.string(_local_6)) + "_name"));
                }
                else
                {
                    _local_3 = Std.int(k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                    _local_4 = this._container.sessionDataManager.getWallItemData(_local_3);
                    if (((!(_local_4 == null)) && (_local_4.localizedName.length > 0)))
                    {
                        _local_5 = _local_4.localizedName;
                    }
                }
            }
            return new _Str_3405(k.getId(), _arg_2, _local_5, k.getModel().getString(RoomObjectVariableEnum.FURNITURE_OWNER_NAME));
        }

        function _Str_16552(k:_Str_3405, _arg_2:_Str_3405):Int
        {
            if ((((((k == null) || (_arg_2 == null)) || (k.name == _arg_2.name)) || (k.name.length == 0)) || (_arg_2.name.length == 0)))
            {
                return 1;
            }
            var _local_3= ASCompat.ASArray.sort(([k.name.toUpperCase(), _arg_2.name.toUpperCase()] : Array<Dynamic>), Reflect.compare);
            if (_local_3.indexOf(k.name.toUpperCase()) == 0)
            {
                return -1;
            }
            return 1;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return null;
        }

        public function processEvent(k:Event)
        {
        }

        public function update()
        {
        }
public function new(){}
    }

