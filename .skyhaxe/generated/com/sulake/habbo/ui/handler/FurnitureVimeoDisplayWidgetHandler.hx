package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.video.VimeoDisplayWidget;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.events.Event;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.SetObjectDataMessageComposer;

     class FurnitureVimeoDisplayWidgetHandler implements IRoomWidgetHandler 
    {
        static inline final VIDEOID= "videoId";

        var _container:IRoomWidgetHandlerContainer;
        var _widget:VimeoDisplayWidget;


        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.VIMEO;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public var widget(never,set):VimeoDisplayWidget;
public function  set_widget(k:VimeoDisplayWidget):VimeoDisplayWidget        {
            return this._widget = k;
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
            return [];
        }

        public function processEvent(k:Event)
        {
            var _local_4 = false;
            var _local_5:String = null;
            if (this._container.roomEngine == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomEngineTriggerWidgetEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.OPEN_WIDGET:
                    if (_local_3 != null)
                    {
                        _local_4 = this._container.sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR);
                        _local_5 = _local_3.getModel().getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA).getValue(VIDEOID);
                        this._widget.show(_local_3, _local_4, ASCompat.toInt(_local_5));
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.CLOSE_WIDGET:
                    this._widget.hide(_local_3);
                    return;
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }

        public function _Str_18970(k:IRoomObject, _arg_2:Int)
        {
            var _local_3= new Map();
            _local_3.add(VIDEOID, Std.string(_arg_2));
            this._container.connection.send(new SetObjectDataMessageComposer(k.getId(), _local_3));
        }
public function new(){}
    }

