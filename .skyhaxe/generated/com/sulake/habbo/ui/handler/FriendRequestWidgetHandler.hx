package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFriendRequestMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionFriendRequestEvent;
    import com.sulake.habbo.friendlist.events._Str_2948;
    import com.sulake.habbo.ui.widget.events._Str_3549;
    import flash.events.Event;

     class FriendRequestWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_POLL;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._disposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetFriendRequestMessage.RWFRM_ACCEPT);
            k.push(RoomWidgetFriendRequestMessage.RWFRM_DECLINE);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFriendRequestMessage = null;
            var _local_3:RoomWidgetFriendRequestMessage = null;
            if (((!(k != null)) || (!(this._container != null))))
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetFriendRequestMessage.RWFRM_ACCEPT:
                    _local_2 = Std.downcast(k , RoomWidgetFriendRequestMessage);
                    if (((!(_local_2 != null)) || (!(this._container.friendList != null))))
                    {
                        return null;
                    }
                    this._container.friendList.acceptFriendRequest(_local_2.requestId);
                    
                case RoomWidgetFriendRequestMessage.RWFRM_DECLINE:
                    _local_3 = Std.downcast(k , RoomWidgetFriendRequestMessage);
                    if (((!(_local_3 != null)) || (!(this._container.friendList != null))))
                    {
                        return null;
                    }
                    this._container.friendList.declineFriendRequest(_local_3.requestId);
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomSessionFriendRequestEvent.RSFRE_FRIEND_REQUEST);
            k.push(_Str_2948.FRE_ACCEPTED);
            k.push(_Str_2948.FRE_DECLINED);
            return k;
        }

        public function processEvent(k:Event)
        {
            var _local_2:_Str_3549 = null;
            var _local_3:String = null;
            var _local_4:RoomSessionFriendRequestEvent = null;
            var _local_5:_Str_2948 = null;
            if (((this._container == null) || (this._container.events == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionFriendRequestEvent.RSFRE_FRIEND_REQUEST:
                    _local_4 = Std.downcast(k , RoomSessionFriendRequestEvent);
                    if (_local_4 == null)
                    {
                        return;
                    }
                    _local_3 = _Str_3549.RWFRUE_SHOW_FRIEND_REQUEST;
                    _local_2 = new _Str_3549(_local_3, _local_4.requestId, _local_4.userId, _local_4.userName);
                    
                case _Str_2948.FRE_ACCEPTED
                   | _Str_2948.FRE_DECLINED:
                    _local_5 = Std.downcast(k , _Str_2948);
                    if (_local_5 == null)
                    {
                        return;
                    }
                    _local_3 = _Str_3549.RWFRUE_HIDE_FRIEND_REQUEST;
                    _local_2 = new _Str_3549(_local_3, _local_5.requestId);
                    
            }
            if (_local_2 != null)
            {
                this._container.events.dispatchEvent(_local_2);
            }
        }

        public function update()
        {
        }
public function new(){}
    }

