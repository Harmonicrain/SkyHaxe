package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.ui.widget.events._Str_4984;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class PlaceholderWidgetHandler implements IRoomWidgetHandler 
    {
        var _container:IRoomWidgetHandlerContainer = null;


        public function dispose()
        {
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
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
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_PLACEHOLDER];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:_Str_4984 = null;
            switch (k.type)
            {
                default:
                    _local_2 = new _Str_4984(_Str_4984.RWSPE_SHOW_PLACEHOLDER);
                    this._container.events.dispatchEvent(_local_2);
            }
            return null;
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

