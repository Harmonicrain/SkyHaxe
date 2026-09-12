package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RequestSpamWallPostItMessageEvent;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.habbo.ui.widget.events.RoomWidgetSpamWallPostItEditEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetSpamWallPostItFinishEditingMessage;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.AddSpamWallPostItMessageComposer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class SpamWallPostItWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer;
        var _connection:IConnection = null;
        var _spamWallPostItEditRequestListener:IMessageEvent;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.SPAMWALL_POSTIT_WIDGET;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public var connection(never,set):IConnection;
public function  set_connection(k:IConnection):IConnection        {
            this._spamWallPostItEditRequestListener = new RequestSpamWallPostItMessageEvent(this.onSpamWallPostItRequest);
            this._connection = k;
            this._connection.addMessageEvent(this._spamWallPostItEditRequestListener);
return k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._disposed = true;
                this._connection.removeMessageEvent(this._spamWallPostItEditRequestListener);
                this._connection = null;
            }
        }

        function onSpamWallPostItRequest(k:RequestSpamWallPostItMessageEvent)
        {
            var _local_7:String = null;
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            var _local_3= _local_2.itemId;
            var _local_4= _local_2.location;
            var _local_5= "post_it";
            var _local_6:IFurnitureItem = null;
            if (this._container.inventory != null)
            {
                _local_6 = this._container.inventory.getWallItemById(_local_3);
            }
            if (((!(_local_6 == null)) && (!(this._container.roomEngine == null))))
            {
                _local_7 = this._container.roomEngine.getWallItemType(_local_6.type);
                if (ASCompat.stringMatch(_local_7, "post_it_") != null)
                {
                    _local_5 = _local_7;
                }
            }
            if (this._container != null)
            {
                if (this._container.events != null)
                {
                    this._container.events.dispatchEvent(new RoomWidgetSpamWallPostItEditEvent(RoomWidgetSpamWallPostItEditEvent.RWSWPUE_OPEN_EDITOR, _local_3, _local_4, _local_5));
                }
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetSpamWallPostItEditEvent.RWSWPUE_OPEN_EDITOR, RoomWidgetSpamWallPostItFinishEditingMessage.RWSWPFEE_SEND_POSTIT_DATA];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetSpamWallPostItFinishEditingMessage = null;
            var _local_3:AddSpamWallPostItMessageComposer = null;
            switch (k.type)
            {
                case RoomWidgetSpamWallPostItFinishEditingMessage.RWSWPFEE_SEND_POSTIT_DATA:
                    _local_2 = Std.downcast(k , RoomWidgetSpamWallPostItFinishEditingMessage);
                    if (_local_2 != null)
                    {
                        if (this._connection != null)
                        {
                            _local_3 = new AddSpamWallPostItMessageComposer(_local_2.objectId, _local_2.location, _local_2.colorHex, _local_2.text);
                            this._connection.send(_local_3);
                        }
                    }
                    
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

