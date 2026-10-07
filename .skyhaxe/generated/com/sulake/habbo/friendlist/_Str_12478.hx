package com.sulake.habbo.friendlist
;
    import com.sulake.habbo.friendlist.domain.Friend;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.RemoveFriendMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class _Str_12478 extends AlertView 
    {
        var _Str_1007:Array<ASAny>;

        public function new(k:HabboFriendList)
        {
            super(k, "friend_remove_confirm");
            this._Str_1007 = k.categories._Str_8217();
        }

        override public function dispose()
        {
            this._Str_1007 = null;
            super.dispose();
        }
@:allow(com.sulake.habbo.friendlist) 
        override function setupContent(k:IWindowContainer)
        {
            var _local_3:Friend = null;
            var _local_4:String = null;
            var _local_5:ASDictionary<ASAny,ASAny> = null;
            k.findChildByName("cancel").procedure = onClose;
            k.findChildByName("ok").procedure = this._Str_22491;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._Str_1007; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_2.push(_local_3.name);
            }
            _local_4 = Util.arrayToString(_local_2);
            _local_5 = new ASDictionary<ASAny,ASAny>();
            friendList.registerParameter("friendlist.removefriendconfirm.userlist", "user_names", _local_4);
        }

        function _Str_22491(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:Friend = null;
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log(["Remove Ok clicked"]);
            var _local_3= new RemoveFriendMessageComposer();
            final _iter_ = this._Str_1007; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_3.addRemovedFriend(_local_4.id);
            }
            friendList.send(_local_3);
            this.dispose();
        }
    }

