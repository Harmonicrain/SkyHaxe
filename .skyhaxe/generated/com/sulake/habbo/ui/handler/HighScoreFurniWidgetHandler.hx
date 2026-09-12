package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.highscore.HighScoreDisplayWidget;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.data.HighScoreStuffData;
    import flash.events.Event;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.geom.Point;

     class HighScoreFurniWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:HighScoreDisplayWidget = null;
        var _cachedRequest:RoomEngineObjectEvent = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.HIGH_SCORE_DISPLAY;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var widget(never,set):HighScoreDisplayWidget;
public function  set_widget(k:HighScoreDisplayWidget):HighScoreDisplayWidget        {
            return this._widget = k;
        }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._container.addUpdateListener(this);
return k;
        }

        public function dispose()
        {
            if (this._container != null)
            {
                this._container.removeUpdateListener(this);
            }
            this._isDisposed = true;
            this._container = null;
            this._widget = null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIGH_SCORE_DISPLAY, RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIDE_HIGH_SCORE_DISPLAY];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineObjectEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:HighScoreStuffData = null;
            if ((this.disposed || (k == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIGH_SCORE_DISPLAY:
                    _local_2 = cast(k, RoomEngineObjectEvent);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_4 = _local_3.getModel();
                        if (_local_4 != null)
                        {
                            _local_5 = new HighScoreStuffData();
                            _local_5.initializeFromRoomObjectModel(_local_4);
                            this._widget.open(_local_2.objectId, _local_2.roomId, _local_5);
                        }
                        this._cachedRequest = _local_2;
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIDE_HIGH_SCORE_DISPLAY:
                    _local_2 = cast(k, RoomEngineObjectEvent);
                    if (((_local_2.roomId == this._widget.roomId) && (_local_2.objectId == this._widget._Str_21467)))
                    {
                        this._widget.close();
                    }
                    return;
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return null;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function update()
        {
            var k:IRoomObject = null;
            var _local_2:Point = null;
            if (((((this._cachedRequest != null) && this._widget.isOpen) && (this._widget.roomId == this._cachedRequest.roomId)) && (this._widget._Str_21467 == this._cachedRequest.objectId)))
            {
                k = this._container.roomEngine.getRoomObject(this._cachedRequest.roomId, this._cachedRequest.objectId, this._cachedRequest.category);
                if (k != null)
                {
                    _local_2 = this._container.roomEngine.getRoomObjectScreenLocation(this._cachedRequest.roomId, this._cachedRequest.objectId, this._cachedRequest.category);
                    if (_local_2 != null)
                    {
                        this._widget._Str_23957(Std.int(_local_2.x), Std.int(_local_2.y));
                    }
                }
            }
        }
public function new(){}
    }

