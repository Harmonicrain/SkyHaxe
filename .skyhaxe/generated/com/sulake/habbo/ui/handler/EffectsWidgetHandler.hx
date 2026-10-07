package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.effects.EffectsWidget;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.inventory.events.HabboInventoryEffectsEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class EffectsWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:EffectsWidget;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.container = null;
                this._widget = null;
                this._disposed = true;
            }
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.EFFECTS;
        }

        public var widget(never,set):EffectsWidget;
public function  set_widget(k:EffectsWidget):EffectsWidget        {
            return this._widget = k;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            if (((this._container != null) && (this._container.inventory != null)))
            {
                this._container.inventory.events.removeEventListener(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED, this._Str_10320);
            }
            this._container = k;
            if (((this._container != null) && (this._container.inventory != null)))
            {
                this._container.inventory.events.addEventListener(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED, this._Str_10320);
            }
return k;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        function _Str_10320(k:HabboInventoryEffectsEvent)
        {
            if (this._widget != null)
            {
                this._widget.open();
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetRequestWidgetMessage.RWRWM_EFFECTS];
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            if (k == null)
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetRequestWidgetMessage.RWRWM_EFFECTS:
                    this._widget.open();
                    
            }
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

