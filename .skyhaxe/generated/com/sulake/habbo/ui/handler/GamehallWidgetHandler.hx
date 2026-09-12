package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.room.events.RoomEngineGamehallEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.furniture.gamehall.GamehallGameWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import flash.events.Event;

     class GamehallWidgetHandler implements IRoomWidgetHandler
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer;
        var _widget:GamehallGameWidget;

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.GAMEHALL_BOARD;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(value:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = value;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var widget(never,set):GamehallGameWidget;
public function  set_widget(value:GamehallGameWidget):GamehallGameWidget        {
            return this._widget = value;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [
                RoomEngineGamehallEvent.OPEN,
                RoomEngineGamehallEvent.UPDATE,
                RoomEngineGamehallEvent.CLOSE
            ];
        }

        public function processEvent(event:Event)
        {
            if (this._disposed || this._widget == null)
            {
                return;
            }

            var gameEvent= Std.downcast(event , RoomEngineGamehallEvent);
            if (gameEvent == null)
            {
                return;
            }

            switch (gameEvent.type)
            {
                case RoomEngineGamehallEvent.OPEN:
                    this._widget.open(
                        gameEvent.stationId,
                        gameEvent.gameType,
                        gameEvent.localSeat,
                        gameEvent.seatCount,
                        gameEvent.verb,
                        gameEvent.args,
                        gameEvent.reason);
                    
                case RoomEngineGamehallEvent.UPDATE:
                    this._widget.applyUpdate(gameEvent.stationId, gameEvent.verb, gameEvent.args, gameEvent.reason);
                    
                case RoomEngineGamehallEvent.CLOSE:
                    this._widget.close(gameEvent.stationId, gameEvent.reason);
                    
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [];
        }

        public function processWidgetMessage(message:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._widget = null;
            this._container = null;
            this._disposed = true;
        }
public function new(){}
    }

