package com.sulake.habbo.ui.widget.friendrequest
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events._Str_3549;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.events._Str_3174;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetGetObjectLocationMessage;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFriendRequestMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;

     class FriendRequestWidget extends RoomWidgetBase implements IUpdateReceiver
    {
        var _component:Component;
        var _requests:Map;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:Component)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._component = _arg_5;
            this._requests = new Map();
        }

        override public function dispose()
        {
            var k:FriendRequestDialog = null;
            if (disposed)
            {
                return;
            }
            if (this._component != null)
            {
                this._component.removeUpdateReceiver(this);
                this._component = null;
            }
            if (this._requests != null)
            {
                final _iter_ = this._requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                    k = null;
                }
                this._requests.dispose();
                this._requests = null;
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_3549.RWFRUE_SHOW_FRIEND_REQUEST, this.eventHandler);
            k.addEventListener(_Str_3549.RWFRUE_HIDE_FRIEND_REQUEST, this.eventHandler);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_3549.RWFRUE_SHOW_FRIEND_REQUEST, this.eventHandler);
            k.removeEventListener(_Str_3549.RWFRUE_HIDE_FRIEND_REQUEST, this.eventHandler);
        }

        function eventHandler(k:_Str_3549)
        {
            if (k == null)
            {
                return;
            }
            switch (k.type)
            {
                case _Str_3549.RWFRUE_SHOW_FRIEND_REQUEST:
                    this._Str_8472(k.requestId, new FriendRequestDialog(this, k.requestId, k.userId, k.userName));
                    
                case _Str_3549.RWFRUE_HIDE_FRIEND_REQUEST:
                    this._Str_7667(k.requestId);
                    
            }
            this.checkUpdateNeed();
        }

        public function checkUpdateNeed()
        {
            if (this._component == null)
            {
                return;
            }
            if (((this._requests != null) && (this._requests.length > 0)))
            {
                this._component.registerUpdateReceiver(this, 10);
            }
            else
            {
                this._component.removeUpdateReceiver(this);
            }
        }

        public function update(k:UInt)
        {
            var _local_2:FriendRequestDialog = null;
            var _local_3:_Str_3174 = null;
            if (this._requests == null)
            {
                return;
            }
            final _iter_ = this._requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (_local_2 == null)
                {
                }
                else
                {
                    _local_3 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, _local_2.userId, RoomObjectTypeEnum.HABBO)) , _Str_3174);
                    if (_local_3 == null)
                    {
                    }
                    else
                    {
                        _local_2._Str_23989 = _local_3.rectangle;
                    }
                }
            }
        }

        public function _Str_11273(k:Int)
        {
            if (messageListener == null)
            {
                return;
            }
            messageListener.processWidgetMessage(new RoomWidgetFriendRequestMessage(RoomWidgetFriendRequestMessage.RWFRM_ACCEPT, k));
            this._Str_7667(k);
        }

        public function _Str_12175(k:Int)
        {
            if (messageListener == null)
            {
                return;
            }
            messageListener.processWidgetMessage(new RoomWidgetFriendRequestMessage(RoomWidgetFriendRequestMessage.RWFRM_DECLINE, k));
            this._Str_7667(k);
        }

        public function _Str_22064(k:Int)
        {
            this._Str_7667(k);
        }

        function _Str_8472(k:Int, _arg_2:FriendRequestDialog)
        {
            if (((!(this._requests != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            this._requests.add(k, _arg_2);
        }

        function _Str_7667(k:Int)
        {
            if (this._requests == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._requests.getValue(k) , FriendRequestDialog);
            if (_local_2 == null)
            {
                return;
            }
            this._requests.remove(k);
            _local_2.dispose();
            this.checkUpdateNeed();
        }

        public function showProfile(k:Int, _arg_2:String)
        {
            messageListener.processWidgetMessage(new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, k, _arg_2));
        }
    }

