package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.friendfurni.FriendFurniConfirmWidget;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendfurni.FriendFurniStartConfirmationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendfurni.FriendFurniOtherLockConfirmedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendfurni.FriendFurniCancelLockMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendfurni.FriendFurniConfirmLockMessageComposer;
    import flash.events.Event;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;

     class FriendFurniConfirmWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:FriendFurniConfirmWidget;
        var _connection:IConnection;
        var _friendFurniConfirmListener:IMessageEvent = null;
        var _friendFurniOtherLockConfirmListener:IMessageEvent = null;
        var _friendFurniCancelLockListener:IMessageEvent = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public var widget(never,set):FriendFurniConfirmWidget;
public function  set_widget(k:FriendFurniConfirmWidget):FriendFurniConfirmWidget        {
            return this._widget = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (((this._connection != null) && (this._friendFurniConfirmListener != null)))
                {
                    this._connection.removeMessageEvent(this._friendFurniConfirmListener);
                    this._connection.removeMessageEvent(this._friendFurniOtherLockConfirmListener);
                    this._connection.removeMessageEvent(this._friendFurniCancelLockListener);
                    this._connection = null;
                }
                this._widget = null;
                this._container = null;
                this._disposed = true;
            }
        }

        public var connection(never,set):IConnection;
public function  set_connection(k:IConnection):IConnection        {
            this._connection = k;
            if (this._friendFurniConfirmListener == null)
            {
                this._friendFurniConfirmListener = new FriendFurniStartConfirmationMessageEvent(this.onStartConfirmation);
                this._friendFurniOtherLockConfirmListener = new FriendFurniOtherLockConfirmedMessageEvent(this.onOtherLockConfirmed);
                this._friendFurniCancelLockListener = new FriendFurniCancelLockMessageEvent(this.onCancelLock);
                this._connection.addMessageEvent(this._friendFurniConfirmListener);
                this._connection.addMessageEvent(this._friendFurniOtherLockConfirmListener);
                this._connection.addMessageEvent(this._friendFurniCancelLockListener);
            }
return k;
        }

        public function sendLockConfirm(k:Int, _arg_2:Bool)
        {
            this._connection.send(new FriendFurniConfirmLockMessageComposer(k, _arg_2));
        }

        function onStartConfirmation(k:FriendFurniStartConfirmationMessageEvent)
        {
            this._widget.open(k.getParser().stuffId, k.getParser().isOwner);
        }

        function onOtherLockConfirmed(k:FriendFurniOtherLockConfirmedMessageEvent)
        {
            this._widget._Str_25728(k.getParser().stuffId);
        }

        function onCancelLock(k:FriendFurniCancelLockMessageEvent)
        {
            this._widget.close(k.getParser().stuffId);
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return "";
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return null;
        }

        public function processEvent(k:Event)
        {
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function update()
        {
        }
public function new(){}
    }

