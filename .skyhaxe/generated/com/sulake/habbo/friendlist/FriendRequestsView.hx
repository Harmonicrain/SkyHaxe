package com.sulake.habbo.friendlist
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendlist.domain.FriendRequest;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.utils._Str_3521;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.AcceptFriendMessageComposer;
    import com.sulake.habbo.friendlist.events._Str_2948;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.DeclineFriendMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;

     class FriendRequestsView implements _Str_6180 implements  _Str_4097
    {
        static inline final NO_REQS_INFO= "no_reqs_info";

        var _habboFriendList:HabboFriendList;
        var _list:IItemListWindow;
        var _Str_17060:IContainerButtonWindow;
        var _Str_18246:IContainerButtonWindow;


        public function init(k:HabboFriendList)
        {
            this._habboFriendList = k;
        }

        public function _Str_14366():Int
        {
            return this._habboFriendList.friendRequests._Str_19367();
        }

        public function _Str_15797(k:IWindowContainer)
        {
            this._Str_17060 = cast(k.findChildByName("accept_all_but"), IContainerButtonWindow);
            this._Str_18246 = cast(k.findChildByName("reject_all_but"), IContainerButtonWindow);
            this._Str_18246.procedure = this._Str_23039;
            this._Str_17060.procedure = this._Str_22777;
            this.refreshButtons();
        }

        public function _Str_13719(k:IItemListWindow)
        {
            var _local_2:FriendRequest = null;
            this._list = k;
            final _iter_ = this._habboFriendList.friendRequests.requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._Str_21250(_local_2);
                this._Str_6657(_local_2);
                k.addListItem(_local_2.view);
            }
            this._habboFriendList.friendRequests._Str_6988();
        }

        public function _Str_14179(k:Int)
        {
            if (this._list == null)
            {
                return;
            }
            this._habboFriendList.friendRequests._Str_20199(true);
        }

        public function _Str_6988(k:FriendRequest, _arg_2:Bool)
        {
            if (this._list == null)
            {
                return;
            }
            k.view.color = this._habboFriendList._Str_4930._Str_9273(_Str_2777._Str_3798, _arg_2);
            this._Str_20803(k.view, "reject");
            this._Str_20803(k.view, "accept");
        }

        public function _Str_6657(k:FriendRequest)
        {
            if (this._list == null)
            {
                return;
            }
            var _local_2= k.view;
            Util.hideChildren(_local_2);
            var _local_3= _local_2.findChildByName("bg_region");
            _local_3.visible = true;
            _local_3.procedure = this._Str_6514;
            _local_3.id = k.requesterUserId;
            _local_2.findChildByName("user_info_region").visible = true;
            _Str_3521._Str_3927(false, _local_2);
            this._habboFriendList._Str_6498(_local_2, "requester_name_text", true, k.requesterName);
            if (k.state == FriendRequest._Str_5035)
            {
                this._habboFriendList._Str_17821(_local_2, "accept", true, this._Str_22888, k.requestId);
                this._habboFriendList._Str_17821(_local_2, "reject", true, this._Str_23925, k.requestId);
            }
            else
            {
                if (k.state == FriendRequest._Str_7320)
                {
                    this._habboFriendList._Str_6498(_local_2, "info_text", true, "${friendlist.request.accepted}");
                }
                else
                {
                    if (k.state == FriendRequest._Str_7073)
                    {
                        this._habboFriendList._Str_6498(_local_2, "info_text", true, "${friendlist.request.declined}");
                    }
                    else
                    {
                        if (k.state == FriendRequest._Str_15312)
                        {
                            this._habboFriendList._Str_6498(_local_2, "info_text", true, "${friendlist.request.failed}");
                        }
                    }
                }
            }
        }

        function _Str_20803(k:IWindowContainer, _arg_2:String)
        {
            var _local_3= k.findChildByName(_arg_2);
            if (_local_3 != null)
            {
                _local_3.color = k.color;
            }
        }

        public function _Str_8472(k:FriendRequest)
        {
            if (this._list == null)
            {
                return;
            }
            this._Str_21250(k);
            this._Str_6657(k);
            this._list.addListItem(k.view);
            this._habboFriendList.friendRequests._Str_6988();
            this.refreshButtons();
        }

        public function _Str_7667(k:FriendRequest)
        {
            if (this._list == null)
            {
                return;
            }
            this._list.removeListItem(k.view);
            this.refreshButtons();
        }

        function _Str_21250(k:FriendRequest)
        {
            var _local_2= cast(this._habboFriendList.getXmlWindow("friend_request_entry"), IWindowContainer);
            k.view = _local_2;
        }

        function _Str_22888(k:WindowEvent, _arg_2:IWindow)
        {
            this._habboFriendList.view.showInfo(k, "${friendlist.tip.accept}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= _arg_2.id;
            Logger.log([("accept clicked: " + Std.string(_local_3))]);
            this._Str_11273(_local_3);
        }

        public function _Str_11273(k:Int)
        {
            var _local_2= this._habboFriendList.friendRequests._Str_19101(k);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.state = FriendRequest._Str_7320;
            if (this._habboFriendList.categories.getFriendCount(false) >= this._habboFriendList.friendRequests.limit)
            {
                this._habboFriendList._Str_18624();
                return;
            }
            var _local_3= new AcceptFriendMessageComposer();
            _local_3.addAcceptedRequest(_local_2.requestId);
            this._habboFriendList.send(_local_3);
            this._Str_6657(_local_2);
            this.refresh();
            if (((this._habboFriendList != null) && (this._habboFriendList.events != null)))
            {
                this._habboFriendList.events.dispatchEvent(new _Str_2948(_Str_2948.FRE_ACCEPTED, k));
            }
        }

        public function _Str_17684()
        {
            var _local_2:FriendRequest = null;
            if ((this._habboFriendList.categories.getFriendCount(false) + this._habboFriendList.friendRequests.requests.length) > this._habboFriendList.friendRequests.limit)
            {
                this._habboFriendList._Str_18624();
                return;
            }
            var k= new AcceptFriendMessageComposer();
            final _iter_ = this._habboFriendList.friendRequests.requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((!(_local_2.state == FriendRequest._Str_7320)) && (!(_local_2.state == FriendRequest._Str_7073))))
                {
                    k.addAcceptedRequest(_local_2.requestId);
                    _local_2.state = FriendRequest._Str_7320;
                    this._Str_6657(_local_2);
                    if (((this._habboFriendList != null) && (this._habboFriendList.events != null)))
                    {
                        this._habboFriendList.events.dispatchEvent(new _Str_2948(_Str_2948.FRE_ACCEPTED, _local_2.requestId));
                    }
                }
            }
            this._habboFriendList.send(k);
            this.refresh();
        }

        function _Str_23925(k:WindowEvent, _arg_2:IWindow)
        {
            this._habboFriendList.view.showInfo(k, "${friendlist.tip.decline}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= _arg_2.id;
            Logger.log([("decline clicked: " + Std.string(_local_3))]);
            this._Str_12175(_local_3);
        }

        public function _Str_12175(k:Int)
        {
            var _local_2= this._habboFriendList.friendRequests._Str_19101(k);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.state = FriendRequest._Str_7073;
            var _local_3= new DeclineFriendMessageComposer();
            _local_3.addDeclinedRequest(k);
            this._habboFriendList.send(_local_3);
            this._Str_6657(_local_2);
            this.refresh();
            if (((this._habboFriendList != null) && (this._habboFriendList.events != null)))
            {
                this._habboFriendList.events.dispatchEvent(new _Str_2948(_Str_2948.FRE_DECLINED, k));
            }
        }

        public function _Str_17225()
        {
            var _local_2:FriendRequest = null;
            var k= new DeclineFriendMessageComposer();
            this._habboFriendList.send(k);
            final _iter_ = this._habboFriendList.friendRequests.requests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((!(_local_2.state == FriendRequest._Str_7320)) && (!(_local_2.state == FriendRequest._Str_7073))))
                {
                    _local_2.state = FriendRequest._Str_7073;
                    this._Str_6657(_local_2);
                    if (((this._habboFriendList != null) && (this._habboFriendList.events != null)))
                    {
                        this._habboFriendList.events.dispatchEvent(new _Str_2948(_Str_2948.FRE_DECLINED, _local_2.requestId));
                    }
                }
            }
            this.refresh();
        }

        function _Str_6514(k:WindowEvent, _arg_2:IWindow)
        {
            this._habboFriendList.view.showInfo(k, "${infostand.profile.link.tooltip}");
            _Str_3521._Str_6514(k, _arg_2);
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._habboFriendList.trackGoogle("extendedProfile", "friendList_friendRequests");
                this._habboFriendList.send(new GetExtendedProfileMessageComposer(_arg_2.id));
            }
        }

        function _Str_23039(k:WindowEvent, _arg_2:IWindow)
        {
            this._habboFriendList.view.showInfo(k, "${friendlist.tip.declineall}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log(["Dismiss all clicked"]);
            this._Str_17225();
        }

        function _Str_22777(k:WindowEvent, _arg_2:IWindow)
        {
            this._habboFriendList.view.showInfo(k, "${friendlist.tip.acceptall}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log(["Accept all clicked"]);
            this._Str_17684();
        }

        function refresh()
        {
            this.refreshButtons();
        }

        function refreshButtons()
        {
            var k:ASAny = (this._habboFriendList.friendRequests._Str_19367() > 0);
            this.setEnabled(this._Str_17060, k);
            this.setEnabled(this._Str_18246, k);
        }

        function setEnabled(k:IContainerButtonWindow, _arg_2:Bool)
        {
            if (k == null)
            {
                return;
            }
            if (_arg_2)
            {
                k.enable();
            }
            else
            {
                k.disable();
            }
        }
public function new(){}
    }

