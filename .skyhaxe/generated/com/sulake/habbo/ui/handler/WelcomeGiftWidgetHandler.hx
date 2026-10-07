package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.WelcomeGiftStatusEvent;
    import com.sulake.habbo.communication.messages.incoming.users.WelcomeGiftChangeEmailResultEvent;
    import com.sulake.habbo.ui.widget.events._Str_5438;
    import com.sulake.habbo.ui.widget.events._Str_6843;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChangeEmailMessage;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.OpenWelcomeGiftComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.WelcomeGiftChangeEmailComposer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class WelcomeGiftWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _messageEvents:Array<ASAny>;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._Str_15944();
                this._container = null;
                this._disposed = true;
            }
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.WELCOME_GIFT;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._Str_17717();
return k;
        }

        function _Str_17717()
        {
            var k:IMessageEvent = null;
            if (((!(this._container != null)) || (!(this._container.connection != null))))
            {
                return;
            }
            this._messageEvents = [];
            this._messageEvents.push(new WelcomeGiftStatusEvent(this._Str_23237));
            this._messageEvents.push(new WelcomeGiftChangeEmailResultEvent(this.onChangeEmailResult));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._container.connection.addMessageEvent(k);
            }
        }

        function _Str_15944()
        {
            var k:IMessageEvent = null;
            if ((((!(this._container != null)) || (!(this._container.connection != null))) || (!(this._messageEvents != null))))
            {
                return;
            }
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._container.connection.removeMessageEvent(k);
                k.dispose();
            }
            this._messageEvents = null;
        }

        function _Str_23237(k:WelcomeGiftStatusEvent)
        {
            var _local_2= k.getParser();
            var _local_3= new _Str_5438();
            _local_3.email = _local_2.email;
            _local_3.isVerified = _local_2.isVerified;
            _local_3._Str_17916 = _local_2.allowChange;
            _local_3.furniId = _local_2.furniId;
            _local_3._Str_10512 = _local_2._Str_10512;
            this._container.events.dispatchEvent(_local_3);
        }

        function onChangeEmailResult(k:WelcomeGiftChangeEmailResultEvent)
        {
            var _local_2= k.getParser();
            this._container.events.dispatchEvent(new _Str_6843(_local_2.result));
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetFurniActionMessage.RWFAM_OPEN_WELCOME_GIFT);
            k.push(RoomWidgetChangeEmailMessage.RWCEM_CHANGE_EMAIL);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFurniActionMessage = null;
            var _local_3:RoomWidgetChangeEmailMessage = null;
            if (k == null)
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetFurniActionMessage.RWFAM_OPEN_WELCOME_GIFT:
                    _local_2 = Std.downcast(k , RoomWidgetFurniActionMessage);
                    this._container.connection.send(new OpenWelcomeGiftComposer(_local_2.furniId));
                    
                case RoomWidgetChangeEmailMessage.RWCEM_CHANGE_EMAIL:
                    _local_3 = Std.downcast(k , RoomWidgetChangeEmailMessage);
                    this._container.connection.send(new WelcomeGiftChangeEmailComposer(_local_3._Str_22654));
                    
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

