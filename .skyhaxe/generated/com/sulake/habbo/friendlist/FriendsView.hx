package com.sulake.habbo.friendlist
;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendlist.domain.FriendCategory;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.friendlist.domain.Friend;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.habbo.utils._Str_3521;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.VisitUserMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.components.ITextWindow;

     class FriendsView implements _Str_6180 implements  _Str_6567 
    {
        public static inline final BG= "bg";
        static inline final _Str_20579= 14;
        public static inline final _Str_13372= 60000;

        var _friendList:HabboFriendList;
        var _minimailButton:IContainerButtonWindow;
        var _homeButton:IContainerButtonWindow;
        var _inviteButton:IContainerButtonWindow;
        var _removeButton:IContainerButtonWindow;
        var _list:IItemListWindow;
        var _relationshipStatusSelector:_Str_9231;


        public function init(k:HabboFriendList)
        {
            this._friendList = k;
        }

        public function _Str_14366():Int
        {
            return this._friendList.categories.getFriendCount(true);
        }

        public function _Str_15797(k:IWindowContainer)
        {
            this._minimailButton = this._Str_14329("open_minimail", this._Str_24605, k);
            this._homeButton = this._Str_14329("open_homepage", this._Str_25436, k);
            this._inviteButton = this._Str_14329("room_invite", this._Str_25558, k);
            this._removeButton = this._Str_14329("remove_friend", this._Str_23409, k);
            this.refreshButtons();
        }

        public function _Str_13719(k:IItemListWindow)
        {
            this._list = k;
            this._Str_3836();
        }

        public function _Str_14179(k:Int)
        {
            if (this._relationshipStatusSelector != null)
            {
                this._relationshipStatusSelector._Str_17733();
            }
        }

        public function _Str_9276()
        {
            this._friendList.tabs._Str_4403(_Str_2777._Str_4113)._Str_9276(true);
        }

        public function _Str_3836()
        {
            var _local_2:FriendCategory = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = false;
            if (this._list == null)
            {
                return;
            }
            if (this._relationshipStatusSelector == null)
            {
                this._relationshipStatusSelector = new _Str_9231(this._friendList);
            }
            this._relationshipStatusSelector._Str_17733();
            this._list.autoArrangeItems = false;
            var k = 0;
            final _iter_ = this._friendList.categories._Str_17858(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this.refreshEntry(true, k, _local_2, null);
                k++;
                if (_local_2.open)
                {
                    _local_3 = _local_2._Str_23845();
                    _local_4 = _local_2._Str_25646();
                    _local_5 = _local_3;
                    while (_local_5 < _local_4)
                    {
                        this.refreshEntry(true, k, _local_2, _local_2.friends[_local_5]);
                        k++;
                        _local_5++;
                    }
                }
            }
            while (true)
            {
                _local_6 = this.refreshEntry(false, k, null, null);
                if (_local_6)
                {
                    break;
                }
                k++;
            }
            this._list.autoArrangeItems = true;
            this.refreshButtons();
        }

        public function _Str_18123()
        {
            if (this._relationshipStatusSelector != null)
            {
                this._relationshipStatusSelector._Str_17733();
            }
        }

        function _Str_14329(k:String, _arg_2:ASFunction, _arg_3:IWindowContainer):IContainerButtonWindow
        {
            var _local_4= cast(_arg_3.findChildByName(("button_" + k)), IContainerButtonWindow);
            _local_4.procedure = _arg_2;
            var _local_5= cast(_local_4.findChildByName("icon"), IBitmapWrapperWindow);
            _local_5.bitmap = this._friendList.getButtonImage(k);
            _local_5.width = _local_5.bitmap.width;
            _local_5.height = _local_5.bitmap.height;
            return _local_4;
        }

        function refreshEntry(k:Bool, _arg_2:Int, _arg_3:FriendCategory, _arg_4:Friend):Bool
        {
            var _local_5:ASAny = ((_arg_2 % 2) == 1);
            var _local_6= Std.downcast(this._list.getListItemAt(_arg_2) , IWindowContainer);
            if (_local_6 == null)
            {
                if (!k)
                {
                    return true;
                }
                _local_6 = cast(this._friendList.getXmlWindow("friend_entry"), IWindowContainer);
                _local_6.findChildByName("user_info_region").procedure = this.onUserInfo;
                this._list.addListItem(_local_6);
            }
            Util.hideChildren(_local_6);
            if (!k)
            {
                _local_6.height = 0;
                _local_6.visible = false;
                return false;
            }
            _local_6.height = 20;
            _local_6.visible = true;
            _local_6.color = this._friendList._Str_4930._Str_9273(_Str_2777._Str_4113, _local_5);
            if (_arg_4 == null)
            {
                _arg_3.view = _local_6;
                this._Str_12989(_arg_3, _local_5);
            }
            else
            {
                _arg_4.view = _local_6;
                this._Str_22942(_arg_3, _arg_4, _local_5);
            }
            return false;
        }

        public function _Str_12989(k:FriendCategory, _arg_2:Bool)
        {
            if (this._list == null)
            {
                return;
            }
            var _local_3= k.view;
            _local_3.tags.splice(0, _local_3.tags.length);
            _local_3.tags.push(k.id);
            this._friendList._Str_6498(_local_3, "caption", true, (((k.name + " (") + Std.string(k.friends.length)) + ")"));
            this._Str_19990(_local_3, "arrow_down_black", k.open, k.id, 6);
            this._Str_19990(_local_3, "arrow_right_black", (!k.open), k.id, 9);
            _local_3.procedure = this._Str_20246;
            _local_3.visible = false;
            this._Str_22394(k, _arg_2);
            _local_3.height = Std.int(Math.max(Util.getLowestPoint(_local_3), 20));
            _local_3.visible = true;
        }

        function _Str_22942(k:FriendCategory, _arg_2:Friend, _arg_3:Bool=false)
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            var _local_4= _arg_2.view;
            if (_local_4 == null)
            {
                return;
            }
            _local_4.id = _arg_2.id;
            _local_4.procedure = this._Str_23153;
            _local_4.visible = true;
            if (_arg_2.selected)
            {
                _local_4.color = this._friendList._Str_4930._Str_22500();
            }
            else
            {
                if (_arg_3)
                {
                    _local_4.color = this._friendList._Str_4930._Str_9273(_Str_2777._Str_4113, true);
                }
            }
            cast(_arg_2.view.findChildByName("name"), ILabelWindow).textColor = this._friendList._Str_4930._Str_25579(_arg_2.selected);
            var _local_5= _arg_2.name;
            if (((!(_arg_2.realName == null)) && (!(_arg_2.realName == ""))))
            {
                _local_5 = (((_local_5 + " (") + _arg_2.realName) + ")");
            }
            this._friendList._Str_6498(_local_4, "name", true, _local_5);
            var _local_6= (this._friendList._Str_21131() && (_arg_2.persistedMessageUser || _arg_2.pocketHabboUser));
            this._friendList.refreshButton(_local_4, "start_chat", (_arg_2.online || _local_6), this._Str_18658, _arg_2.id);
            this._friendList.refreshButton(_local_4, "follow_friend", _arg_2.followingAllowed, this._Str_23763, _arg_2.id);
            this._friendList._Str_25274(_local_4, "relationship_status", _arg_2.relationshipStatus, this._Str_24109, _arg_2.id);
            this._Str_16823(_local_4, _arg_2);
            _local_4.findChildByName("user_info_region").visible = true;
            _local_4.findChildByName("user_info_region").id = _arg_2.id;
            _Str_3521._Str_3927(false, _local_4);
        }

        function _Str_19990(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:Int, _arg_5:Int)
        {
            var _local_6:ILabelWindow = null;
            var _local_7:IWindow = null;
            this._friendList.refreshButton(k, _arg_2, _arg_3, this._Str_20246, _arg_4);
            if (_arg_3)
            {
                _local_6 = cast(k.findChildByName("caption"), ILabelWindow);
                _local_7 = k.findChildByName(_arg_2);
                _local_7.x = Std.int(_local_6.textWidth + _arg_5);
            }
        }

        function _Str_16823(k:IWindowContainer, _arg_2:Friend)
        {
            var _local_4:BitmapData = null;
            if (k == null)
            {
                ErrorReportStorage.addDebugData("FriendsView", "refreshFigure: e is null!");
            }
            if (_arg_2 == null)
            {
                ErrorReportStorage.addDebugData("FriendsView", "refreshFigure: f is null!");
            }
            var _local_3= Std.downcast(k.getChildByName(HabboFriendList.FACE) , IBitmapWrapperWindow);
            if (_local_3 == null)
            {
                ErrorReportStorage.addDebugData("FriendsView", "refreshFigure: child is null!");
            }
            if (this._friendList == null)
            {
                ErrorReportStorage.addDebugData("FriendsView", "refreshFigure: _friendList is null!");
            }
            if (((_arg_2.figure == null) || (_arg_2.figure == "")))
            {
                _local_3.visible = false;
            }
            else
            {
                if (_arg_2.face == null)
                {
                    if (_arg_2._Str_19416())
                    {
                        _arg_2.face = this._friendList._Str_17617(_arg_2.figure);
                    }
                    else
                    {
                        _arg_2.face = this._friendList.getAvatarFaceBitmap(_arg_2.figure);
                    }
                }
                if (_local_3.bitmap == null)
                {
                    _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height);
                }
                if (_local_3.tags[0] != _arg_2.figure)
                {
                    _local_3.tags.splice(0, _local_3.tags.length);
                    _local_3.tags.push(_arg_2.figure);
                    _local_3.bitmap.fillRect(_local_3.bitmap.rect, 0);
                    _local_4 = _arg_2.face;
                    if (_local_4 != null)
                    {
                        _local_3.bitmap.copyPixels(_local_4, _local_4.rect, new Point(0, 0), null, null, true);
                    }
                }
                else
                {
                    Logger.log([("Figure unchanged: " + _local_3.tags[0])]);
                }
                _local_3.visible = true;
            }
        }

        function getBgColor(k:Bool):UInt
        {
            return this._friendList._Str_4930._Str_9273(_Str_2777._Str_4113, k);
        }

        function refreshButtons()
        {
            var k= this._friendList.categories._Str_8217();
            this.setEnabled(this._minimailButton, this._Str_23891(k));
            this.setEnabled(this._homeButton, this._Str_25087(k));
            this.setEnabled(this._inviteButton, this._Str_25613(k));
            this.setEnabled(this._removeButton, this._Str_22478(k));
        }

        function setEnabled(k:IContainerButtonWindow, _arg_2:Bool)
        {
            if (_arg_2)
            {
                k.enable();
            }
            else
            {
                k.disable();
            }
        }

        function _Str_23891(k:Array<ASAny>):Bool
        {
            return this._friendList._Str_17007() || (k.length == 1);
        }

        function _Str_25087(k:Array<ASAny>):Bool
        {
            return k.length == 1;
        }

        function _Str_25613(k:Array<ASAny>):Bool
        {
            var _local_2:Friend = null;
            if (k.length < 1)
            {
                return false;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (_local_2.online)
                {
                    return true;
                }
            }
            return true;
        }

        function _Str_22478(k:Array<ASAny>):Bool
        {
            return k.length > 0;
        }

        function _Str_20246(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log([((("Category clicked: " + _arg_2.name) + ", ") + _arg_2.tags[0])]);
            if (_arg_2.tags.length == 0)
            {
                _arg_2 = _arg_2.parent;
            }
            Logger.log([((("Category id: " + _arg_2.name) + ", ") + _arg_2.tags[0])]);
            var _local_3= ASCompat.toInt(_arg_2.tags[0]);
            Logger.log([("Cat id: " + Std.string(_local_3))]);
            var _local_4= this._friendList.categories._Str_5067(_local_3);
            _local_4._Str_22255((!_local_4.open));
            this._Str_3836();
            this._friendList.view.refresh("Cat open/closed");
        }

        function _Str_23153(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:Friend = null;
            if (_arg_2 == null)
            {
                return;
            }
            if (_arg_2.id == 0)
            {
                _arg_2 = _arg_2.parent;
                if (_arg_2 == null)
                {
                    return;
                }
            }
            if (((k.type == WindowMouseEvent.CLICK) || (k.type == WindowMouseEvent.DOUBLE_CLICK)))
            {
                _local_3 = this._friendList.categories._Str_13534(_arg_2.id);
                _local_3.selected = ((!(_local_3 == null)) && (!_local_3.selected));
                this.refreshButtons();
                this._Str_3836();
                if ((((k.type == WindowMouseEvent.DOUBLE_CLICK) && (!(_local_3 == null))) && _local_3.online))
                {
                    this._friendList.messenger.startConversation(_local_3.id);
                }
            }
        }

        function _Str_18658(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.im}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log([((("chat clicked: " + _arg_2.name) + ", ") + Std.string(_arg_2.id))]);
            this._friendList.messenger.startConversation(_arg_2.id);
        }

        function _Str_23763(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.follow}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._friendList.send(new VisitUserMessageComposer(_arg_2.id));
            this._friendList.send(new EventLogMessageComposer("Navigation", "Friend List", "go.friendlist"));
        }

        function _Str_24109(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2 == null)
            {
                return;
            }
            if (_arg_2.id == 0)
            {
                _arg_2 = _arg_2.parent;
                if (_arg_2 == null)
                {
                    return;
                }
            }
            this._friendList.view.showInfo(k, "${friendlist.tip.relationship}");
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._relationshipStatusSelector._Str_9566 = _arg_2.id;
                this._relationshipStatusSelector._Str_24722(_arg_2, this._friendList.view.mainWindow);
            }
        }

        function onUserInfo(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${infostand.profile.link.tooltip}");
            if (k.type == WindowMouseEvent.OVER)
            {
                _Str_3521._Str_3927(true, cast(_arg_2, IWindowContainer));
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    _Str_3521._Str_3927(false, cast(_arg_2, IWindowContainer));
                }
                else
                {
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        this._friendList.trackGoogle("extendedProfile", "friendList_friendsView");
                        this._friendList.send(new GetExtendedProfileMessageComposer(_arg_2.parent.id));
                    }
                }
            }
        }

        function _Str_24605(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.compose}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= this._friendList.categories._Str_8217();
            if (_local_3.length == 0)
            {
                Logger.log(["No friend found when minimail clicked"]);
                if (this._friendList._Str_17007())
                {
                    HabboWebTools.openMinimail("#mail/inbox/");
                }
                return;
            }
            var _local_4= new ASDictionary<ASAny,ASAny>();
            var _local_5= new Array<ASAny>();
            var _local_6 = 0;
            while (((_local_6 < _local_3.length) && (_local_6 < 50)))
            {
                _local_5.push(_local_3[_local_6].id);
                _local_6++;
            }
            _local_4["recipientid"] = _local_5.join(",");
            _local_4["random"] = ("" + Std.string(Math.fround((Math.random() * 100000000))));
            var _local_7= Std.downcast(k , WindowMouseEvent);
            if (this._friendList._Str_17007())
            {
                HabboWebTools.openMinimail((((("#mail/compose/" + _local_4["recipientid"]) + "/") + _local_4["random"]) + "/"));
            }
            else
            {
                this._friendList.openHabboWebPage("link.format.mail.compose", _local_4, Std.int(_local_7.stageX), Std.int(_local_7.stageY));
            }
        }

        function _Str_25436(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.home}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= this._friendList.categories._Str_23393();
            if (_local_3 == null)
            {
                Logger.log(["No friend found when home clicked"]);
                return;
            }
            var _local_4= new ASDictionary<ASAny,ASAny>();
            _local_4["ID"] = ("" + Std.string(_local_3.id));
            _local_4["username"] = _local_3.name;
            var _local_5= Std.downcast(k , WindowMouseEvent);
            this._friendList.openHabboWebPage("link.format.userpage", _local_4, Std.int(_local_5.stageX), Std.int(_local_5.stageY));
        }

        function _Str_25558(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.invite}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if ((flash.Lib.getTimer() - ASCompat.toNumber(this._friendList._Str_23875)) < _Str_13372)
            {
                this._friendList.simpleAlert("${friendlist.invite.frequentalert.title}", "${friendlist.invite.frequentalert.text}");
                return;
            }
            new _Str_11876(this._friendList).show();
        }

        function _Str_23409(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.remove}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            new _Str_12478(this._friendList).show();
        }

        function _Str_22394(k:FriendCategory, _arg_2:Bool)
        {
            var _local_3= cast(k.view.findChildByName("pager"), IWindowContainer);
            if (((k._Str_11426() < 2) || (!k.open)))
            {
                Logger.log([((("PAGER NOT VISIBLE: " + Std.string(k.open)) + ", ") + Std.string(k._Str_11426()))]);
                _local_3.visible = false;
                return;
            }
            _local_3.visible = true;
            Util.hideChildren(_local_3);
            var _local_4 = 0;
            while (_local_4 < k._Str_11426())
            {
                this._Str_22539(_local_3, _local_4, k.pageIndex, _arg_2);
                _local_4++;
            }
            Util._Str_7173(_local_3, _local_3.width, 15);
            _local_3.height = Util.getLowestPoint(_local_3);
        }

        function _Str_22539(k:IWindowContainer, _arg_2:Int, _arg_3:Int, _arg_4:Bool)
        {
            var _local_5= ("page." + Std.string(_arg_2));
            var _local_6= cast(k.getChildByName(_local_5), ITextWindow);
            if (_local_6 == null)
            {
                _local_6 = cast(this._friendList.getXmlWindow("pagelink"), ITextWindow);
                _local_6.name = _local_5;
                k.addChild(_local_6);
            }
            _local_6.underline = (!(_arg_2 == _arg_3));
            _local_6.text = ((("" + Std.string((_arg_2 * FriendCategory.PAGE_SIZE) + 1)) + "-") + ("" + Std.string((_arg_2 + 1) * FriendCategory.PAGE_SIZE)));
            _local_6.id = _arg_2;
            _local_6.procedure = this._Str_23254;
            _local_6.width = Std.int(_local_6.textWidth + 5);
            _local_6.color = this._friendList._Str_4930._Str_9273(_Str_2777._Str_4113, _arg_4);
            _local_6.visible = true;
        }

        function _Str_23254(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= cast(_arg_2, ITextWindow);
            var _local_4= ASCompat.toInt(_local_3.parent.parent.tags[0]);
            var _local_5= _local_3.id;
            Logger.log([((("Page link clicked: " + Std.string(_local_4)) + ", ") + Std.string(_local_5))]);
            var _local_6= this._friendList.categories._Str_5067(_local_4);
            _local_6.pageIndex = _local_5;
            this._Str_3836();
        }
public function new(){}
    }



