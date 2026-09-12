package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.ui.widget.events._Str_5117;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class FurnitureAchievementResolutionEngraving implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FURNI_ACHIEVEMENT_RESOLUTION_ENGRAVING;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._disposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING, RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED, RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_BADGE_DISPLAY_ENGRAVING];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFurniToWidgetMessage = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:StringArrayStuffData = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11:String = null;
            var _local_12:_Str_5117 = null;
            if ((this.disposed || (k == null)))
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_BADGE_DISPLAY_ENGRAVING
                   | RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING:
                    _local_2 = Std.downcast(k , RoomWidgetFurniToWidgetMessage);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.id, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_4 = _local_3.getModel();
                        if (_local_4 != null)
                        {
                            _local_5 = new StringArrayStuffData();
                            _local_5.initializeFromRoomObjectModel(_local_4);
                            _local_6 = this._container.localization.getBadgeName(_local_5.getValue(1));
                            _local_7 = ("\r\n" + this._container.localization.getBadgeDesc(_local_5.getValue(1)));
                            _local_8 = _local_5.getValue(2);
                            _local_9 = _local_5.getValue(3);
                            _local_10 = ((k.type == RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING) ? "resolution.engraving.text" : "badge.display.engraving.text");
                            _local_11 = this._container.localization.getLocalizationWithParams(_local_10, "%badgename%", ["badgename", _local_6, "badgedesc", _local_7]);
                            if (_local_11 == null)
                            {
                                _local_11 = _local_6;
                            }
                            _local_12 = new _Str_5117(_Str_5117.RWARTDUE_TROPHY_DATA, 0, _local_8, _local_9, _local_11, 0);
                            this._container.events.dispatchEvent(_local_12);
                        }
                    }
                    
                case RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED:
                    this._container.windowManager.simpleAlert("${resolution.failed.title}", "${resolution.failed.subtitle}", "${resolution.failed.text}", null, null, null, "help_error_state");
                    
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

