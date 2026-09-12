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
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.ui.widget.events._Str_4178;
    import flash.events.Event;

     class UserChooserWidgetHandler implements IRoomWidgetHandler 
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
            return RoomWidgetEnum.USER_CHOOSER;
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
            k.push(RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER);
            k.push(RoomWidgetRoomObjectMessage.RWROM_SELECT_OBJECT);
            return k;
        }

        public function isChooserDisabled():Bool
        {
            return this._container != null
                && this._container.roomEngine != null
                && this._container.roomEngine.activeRoomHasChooserDisabled;
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
                case RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER:
                    this._Str_24315();
                    
                case RoomWidgetRoomObjectMessage.RWROM_SELECT_OBJECT:
                    _local_2 = Std.downcast(k , RoomWidgetRoomObjectMessage);
                    if (_local_2 == null)
                    {
                        return null;
                    }
                    if (_local_2.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                    {
                        this._container.roomEngine.selectRoomObject(this._container.roomSession.roomId, _local_2.id, _local_2.category);
                    }
                    
            }
            return null;
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

        function _Str_24315()
        {
            var _local_3:IRoomObject = null;
            var _local_6:RoomUserData = null;
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
            var _local_4= this._container.roomEngine.getRoomObjectCount(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_3 = this._container.roomEngine.getRoomObjectWithIndex(k, _local_5, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                _local_6 = this._container.roomSession.userDataManager.getUserDataByIndex(_local_3.getId());
                if (_local_6 != null)
                {
                    _local_2.push(new _Str_3405(_local_6.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, _local_6.name, null, _local_6.type));
                }
                _local_5++;
            }
            ASCompat.ASArray.sort(_local_2, this._Str_16552);
            this._container.events.dispatchEvent(new _Str_4178(_Str_4178.RWCCE_USER_CHOOSER_CONTENT, _local_2));
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

