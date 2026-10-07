package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetLoadingBarUpdateEvent;
    import flash.events.Event;

     class LoadingBarWidgetHandler implements IRoomWidgetHandler 
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
            return RoomWidgetEnum.LOADINGBAR;
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
            return [];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetLoadingBarUpdateEvent.RWLBUE_SHOW_LOADING_BAR);
            k.push(RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR);
            return k;
        }

        public function processEvent(k:Event)
        {
            if (((this._container == null) || (this._container.events == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomWidgetLoadingBarUpdateEvent.RWLBUE_SHOW_LOADING_BAR:
                    this._container.events.dispatchEvent(k);
                    return;
                case RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR:
                    this._container.events.dispatchEvent(k);
                    return;
            }
        }

        public function update()
        {
        }
public function new(){}
    }

