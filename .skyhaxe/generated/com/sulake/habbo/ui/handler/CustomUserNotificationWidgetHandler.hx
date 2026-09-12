package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.requirementsmissing.CustomUserNotificationWidget;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.CustomUserNotificationMessageEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class CustomUserNotificationWidgetHandler implements IRoomWidgetHandler 
    {
        var _container:IRoomWidgetHandlerContainer = null;
        var _isDisposed:Bool = false;
        var _widget:CustomUserNotificationWidget;
        var _customUserNotificationListener:IMessageEvent;


        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.CUSTOM_USER_NOTIFICATION;
        }

        public var widget(never,set):CustomUserNotificationWidget;
public function  set_widget(k:CustomUserNotificationWidget):CustomUserNotificationWidget        {
            return this._widget = k;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            if (this._customUserNotificationListener == null)
            {
                this._customUserNotificationListener = new CustomUserNotificationMessageEvent(this._Str_23893);
                this._container.connection.addMessageEvent(this._customUserNotificationListener);
            }
return k;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
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
            return null;
        }

        public function processEvent(k:Event)
        {
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (((this._container.connection != null) && (this._customUserNotificationListener != null)))
                {
                    this._container.connection.removeMessageEvent(this._customUserNotificationListener);
                }
                this._customUserNotificationListener = null;
                this._widget = null;
                this._container = null;
                this._isDisposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function _Str_23893(k:CustomUserNotificationMessageEvent)
        {
            var _local_2= k.getParser().code;
            if (this._widget != null)
            {
                switch (_local_2)
                {
                    case 1:
                        this._widget.open(CustomUserNotificationWidget.COSTUMEHOPPER);
                        return;
                    case 2:
                        this._widget.open(CustomUserNotificationWidget.VIPHOPPER);
                        return;
                    case 3:
                        this._widget.open(CustomUserNotificationWidget.VIPGATE);
                        return;
                    case 4:
                        this._widget.open(CustomUserNotificationWidget.RESPECTFAILEDSTAGE);
                        return;
                    case 5:
                        this._widget.open(CustomUserNotificationWidget.RESPECTFAILEDAUDIENCE);
                        return;
                }
            }
        }
public function new(){}
    }

