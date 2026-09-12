package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetGetObjectLocationMessage;
    import com.sulake.habbo.session.IRoomSession;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.ui.widget.events._Str_3174;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class ObjectLocationRequestHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;


        public function dispose()
        {
            this._disposed = true;
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return null;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION);
            k.push(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_GAME_OBJECT_LOCATION);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetGetObjectLocationMessage = null;
            var _local_3:IRoomSession = null;
            var _local_4:Rectangle = null;
            var _local_5:Point = null;
            var _local_6:Rectangle = null;
            var _local_7:RoomUserData = null;
            if (((!(k != null)) || (!(this._container != null))))
            {
                return null;
            }
            _local_2 = Std.downcast(k , RoomWidgetGetObjectLocationMessage);
            if (_local_2 == null)
            {
                return null;
            }
            _local_3 = this._container.roomSession;
            switch (k.type)
            {
                case RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION:
                    if (((!(_local_3 != null)) || (!(_local_3.userDataManager != null))))
                    {
                        return null;
                    }
                    _local_7 = _local_3.userDataManager.getUserDataByType(_local_2.objectId, _local_2.objectType);
                    if (_local_7 == null)
                    {
                        return null;
                    }
                    _local_4 = this._container.roomEngine.getRoomObjectBoundingRectangle(_local_3.roomId, _local_7.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, this._container.getFirstCanvasId());
                    _local_5 = this._container.roomEngine.getRoomObjectScreenLocation(_local_3.roomId, _local_7.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, this._container.getFirstCanvasId());
                    _local_6 = this._container.getRoomViewRect();
                    // No location means the room is still assembling: the user object, the canvas or
                    // its geometry is not ready, and RoomEngine returns nothing rather than a stale
                    // point. Answering with a half-filled result made callers place their window at
                    // the origin, which is why a name tag could appear in the corner of the room on
                    // entry instead of above the avatar. Say "not yet" and let them try next frame.
                    if (_local_4 == null || _local_5 == null || _local_6 == null)
                    {
                        return null;
                    }
                    _local_4.offset(_local_6.x, _local_6.y);
                    _local_5.offset(_local_6.x, _local_6.y);
                    return new _Str_3174(_local_2.objectId, _local_4, _local_5);
                case RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_GAME_OBJECT_LOCATION:
                    _local_4 = this._container.roomEngine.getRoomObjectBoundingRectangle(_local_3.roomId, _local_2.objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, this._container.getFirstCanvasId());
                    _local_5 = this._container.roomEngine.getRoomObjectScreenLocation(_local_3.roomId, _local_2.objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, this._container.getFirstCanvasId());
                    _local_6 = this._container.getRoomViewRect();
                    if (_local_4 == null || _local_5 == null || _local_6 == null)
                    {
                        return null;
                    }
                    _local_4.offset(_local_6.x, _local_6.y);
                    _local_5.offset(_local_6.x, _local_6.y);
                    return new _Str_3174(_local_2.objectId, _local_4, _local_5);
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processEvent(k:Event)
        {
        }

        public function update()
        {
        }
public function new(){}
    }

