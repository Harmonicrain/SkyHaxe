package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMemberData;
    import com.sulake.habbo.utils.InfoText;
    import com.sulake.habbo.utils.LoadingIcon;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembersEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipUpdatedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMemberMgmtFailedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipRejectedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GroupMembershipRequestedMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildMembersMessageComposer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.users.MemberData;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.communication.messages.outgoing.users.RejectMembershipRequestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.UnblockGroupMemberMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.RemoveAdminRightsFromMemberMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.AddAdminRightsToMemberMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.ApproveMembershipRequestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.ApproveAllMembershipRequestsMessageComposer;
    import com.sulake.core.window.components.IDropMenuWindow;
    import flash.events.Event;

     class GuildMembersWindowCtrl implements IDisposable 
    {
        static final MEMBER_SPACING:Point = new Point(5, 5);

        var _manager:HabboGroupsManager;
        var _window:IFrameWindow;
        var _groupId:Int = 0;
        var _searchTimer:Timer;
        var _data:GuildMemberData;
        var _userNameFilter:InfoText;
        var _loadingIcon:LoadingIcon;

        public function new(k:HabboGroupsManager)
        {
            this._searchTimer = new Timer(1000, 1);
            this._manager = k;
            this._searchTimer.addEventListener(TimerEvent.TIMER, (this.onSearchTimer : ASAny));
            this._loadingIcon = new LoadingIcon();
        }

        public function dispose()
        {
            this._manager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._userNameFilter != null)
            {
                this._userNameFilter.dispose();
                this._userNameFilter = null;
            }
            if (this._searchTimer != null)
            {
                this._searchTimer.removeEventListener(TimerEvent.TIMER, (this.onSearchTimer : ASAny));
                this._searchTimer.stop();
                this._searchTimer = null;
            }
            if (this._loadingIcon != null)
            {
                this._loadingIcon.dispose();
                this._loadingIcon = null;
            }
        }

        function setSearchingIcon(k:Bool)
        {
            if (this._window != null)
            {
                this._loadingIcon.setVisible(cast(this._window.findChildByName("searching_icon"), IIconWindow), k);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        public function onGuildMembers(k:IMessageEvent)
        {
            this._data = cast(k, GuildMembersEvent).data;
            this.show();
            this.populateSearchTypes();
            this.populateUserNameFilter();
        }

        public function onGuildMembershipUpdated(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildMembershipUpdatedMessageEvent);
            if (((!(this._data == null)) && (this._data.groupId == _local_2.guildId)))
            {
                this._data.update(_local_2.data);
                this.reload();
            }
        }

        public function onGuildMemberMgmtFailed(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildMemberMgmtFailedMessageEvent);
            var _local_3= _local_2.reason;
            var _local_4= ("group.membermgmt.fail." + Std.string(_local_3));
            var _local_5= this._manager.localization.getLocalization(_local_4, _local_4);
            this._manager.windowManager.alert("${group.membermgmt.fail.title}", _local_5, 0, null);
            if (((((!(this._data == null)) && (this._data.groupId == _local_2.guildId)) && (!(this._window == null))) && this._window.visible))
            {
                this.doSearch(this._data.pageIndex);
            }
        }

        public function onGuildMembershipRejected(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildMembershipRejectedMessageEvent);
            if (((((this._window != null) && this._window.visible) && (!(this._data == null))) && (this._data.groupId == _local_2.getParser().guildId)))
            {
                this.doSearch(this._data.pageIndex);
            }
        }

        public function onMembershipRequested(k:IMessageEvent)
        {
            var _local_2= cast(k, GroupMembershipRequestedMessageEvent).getParser();
            if (((((this._window != null) && this._window.visible) && (!(this._data == null))) && (this._data.groupId == _local_2.groupId)))
            {
                this.doSearch(this._data.pageIndex);
            }
        }

        public function onMembersClick(k:Int, _arg_2:Int)
        {
            if (!this._manager.getBoolean("groupMembers.enabled"))
            {
                return;
            }
            if ((((!(this._window == null)) && this._window.visible) && (this._groupId == k)))
            {
                this.close();
            }
            else
            {
                if (this._userNameFilter != null)
                {
                    this._userNameFilter.goBackToInitialState();
                }
                this._groupId = k;
                this._manager.send(new GetGuildMembersMessageComposer(k, 0, "", _arg_2));
            }
        }

        public function show()
        {
            this.prepareWindow();
            this.refresh();
            this._window.visible = true;
            this._window.activate();
        }

        public function reload()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this.refresh();
            }
        }

        function refresh()
        {
            this._manager.localization.registerParameter("group.members.title", "groupName", this._data.groupName);
            var k= cast(this._window.findChildByName("members_cont"), IWindowContainer);
            var _local_2= this._data.entries;
            var _local_3 = 0;
            while (_local_3 < this._data.pageSize)
            {
                this.refreshEntry(k, _local_3, _local_2[_local_3]);
                _local_3++;
            }
            var _local_4= Std.downcast(cast(this._window.findChildByName("group_logo"), IWidgetWindow).widget , IBadgeImageWidget);
            _local_4.badgeId = this._data.badgeCode;
            _local_4.groupId = this._data.groupId;
            this._manager.localization.registerParameter("group.members.pageinfo", "amount", ("" + Std.string(this._data.totalEntries)));
            this._manager.localization.registerParameter("group.members.pageinfo", "page", ("" + Std.string(this._data.pageIndex + 1)));
            this._manager.localization.registerParameter("group.members.pageinfo", "totalPages", ("" + Std.string(this._data.totalPages)));
            this._window.findChildByName("previous_page_button").visible = this.hasPreviousPage();
            this._window.findChildByName("next_page_button").visible = this.hasNextPage();
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("guild_members_window"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onClose;
            this._window.findChildByName("previous_page_button").procedure = this.onPreviousPage;
            this._window.findChildByName("next_page_button").procedure = this.onNextPage;
            this._userNameFilter = new InfoText(cast(this._window.findChildByName("filter_members_input"), ITextFieldWindow), this._manager.localization.getLocalization("group.members.searchinfo"));
            this._window.center();
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.close();
        }

        public function close()
        {
            if (this._window != null)
            {
                this._groupId = 0;
                this._window.visible = false;
            }
        }

        function refreshEntry(k:IWindowContainer, _arg_2:Int, _arg_3:MemberData)
        {
            var _local_4= cast(k.getChildAt(_arg_2), IWindowContainer);
            if (_local_4 == null)
            {
                if (_arg_3 == null)
                {
                    return;
                }
                _local_4 = this.getListEntry();
                _local_4.tags[0] = ("" + Std.string(_arg_2));
                k.addChild(_local_4);
                _local_4.x = Std.int(((_arg_2 % 2) == 0) ? 0 : Std.int(_local_4.width + MEMBER_SPACING.x));
                _local_4.y = Std.int(Math.ffloor((_arg_2 / 2)) * (_local_4.height + MEMBER_SPACING.y));
            }
            if (_arg_3 != null)
            {
                this.refreshUserEntry(_local_4, _arg_3);
                _local_4.visible = true;
            }
            else
            {
                _local_4.visible = false;
            }
        }

        public function refreshUserEntry(k:IWindowContainer, _arg_2:MemberData)
        {
            var _local_5 = false;
            k.findChildByName("user_name_txt").caption = _arg_2.userName;
            k.findChildByName("icon_owner").visible = _arg_2.owner;
            this.setAdminState(_arg_2.member, _arg_2.admin, k);
            var _local_3= k.findChildByName("admin_container");
            _local_3.visible = ((!_local_5) && (_arg_2.admin || this._data.allowedToManage));
            var _local_4= cast(k.findChildByName("bg_region"), IRegionWindow);
            _local_4.id = _arg_2.userId;
            this.setRemoveState(false, k);
            this.setActionLinkState(false, k);
            _local_5 = (_arg_2.userId == this._manager.avatarId);
            var _local_6= cast(k.findChildByName("remove_region"), IRegionWindow);
            _local_6.toolTipCaption = this._manager.localization.getLocalization((_arg_2.member ? "group.members.kick" : "group.members.reject"));
            _local_6.visible = ((((!_arg_2.owner) && (!_local_5)) && this._data.allowedToManage) && (!_arg_2.blocked));
            _local_6.id = _arg_2.userId;
            var _local_7= (((((_arg_2.member && (!_arg_2.owner)) && (!_local_5)) && this._data.allowedToManage) && this._manager.getBoolean("group.blocking.enabled")) && (!_arg_2.blocked));
            var _local_8= cast(k.findChildByName("block_region"), IRegionWindow);
            _local_8.toolTipCaption = this._manager.localization.getLocalization("group.members.block");
            _local_8.visible = _local_7;
            _local_8.id = _arg_2.userId;
            var _local_9= ((!_local_5) && this._data.allowedToManage);
            var _local_10= cast(k.findChildByName("action_link_region"), IRegionWindow);
            _local_10.visible = _local_9;
            _local_10.id = _arg_2.userId;
            var _local_11= cast(k.findChildByName("member_since_txt"), ITextWindow);
            _local_11.visible = ((!_local_9) && (!(_arg_2._Str_20842 == "")));
            this._manager.localization.registerParameter("group.members.since", "date", _arg_2._Str_20842);
            _local_11.caption = this._manager.localization.getLocalization("group.members.since");
            cast(cast(k.findChildByName("avatar_image"), IWidgetWindow).widget, IAvatarImageWidget).figure = _arg_2.figure;
            if (_arg_2.blocked)
            {
                this.setActionLink(k, "group.members.unblock", false);
            }
            else
            {
                if (_arg_2.owner)
                {
                    this.setActionLink(k, "group.members.owner", false);
                }
                else
                {
                    if (_arg_2.admin)
                    {
                        this.setActionLink(k, "group.members.removerights", true);
                    }
                    else
                    {
                        if (_arg_2.member)
                        {
                            this.setActionLink(k, "group.members.giverights", true);
                        }
                        else
                        {
                            this.setActionLink(k, "group.members.accept", true);
                        }
                    }
                }
            }
        }

        public function getListEntry():IWindowContainer
        {
            var k= cast(this._manager.getXmlWindow("member_entry"), IWindowContainer);
            var _local_2= cast(k.findChildByName("bg_region"), IRegionWindow);
            _local_2.procedure = this.onBg;
            var _local_3= cast(k.findChildByName("block_region"), IRegionWindow);
            _local_3.addEventListener(WindowMouseEvent.OVER, this.onRemoveMouseOver);
            _local_3.addEventListener(WindowMouseEvent.OUT, this.onRemoveMouseOut);
            _local_3.addEventListener(WindowMouseEvent.CLICK, this.onBlockMouseClick);
            var _local_4= cast(k.findChildByName("remove_region"), IRegionWindow);
            _local_4.addEventListener(WindowMouseEvent.OVER, this.onRemoveMouseOver);
            _local_4.addEventListener(WindowMouseEvent.OUT, this.onRemoveMouseOut);
            _local_4.addEventListener(WindowMouseEvent.CLICK, this.onRemoveMouseClick);
            var _local_5= cast(k.findChildByName("action_link_region"), IRegionWindow);
            _local_5.addEventListener(WindowMouseEvent.OVER, this.onActionLinkMouseOver);
            _local_5.addEventListener(WindowMouseEvent.OUT, this.onActionLinkMouseOut);
            _local_5.addEventListener(WindowMouseEvent.CLICK, this.onActionLinkClick);
            return k;
        }

        function onRemoveMouseOver(k:WindowEvent)
        {
            var _local_2= cast(k.target, IRegionWindow);
            this.setRemoveState(true, _local_2);
        }

        function onRemoveMouseOut(k:WindowEvent)
        {
            var _local_2= cast(k.target, IRegionWindow);
            this.setRemoveState(false, _local_2);
        }

        function onRemoveMouseClick(k:WindowEvent)
        {
            var _local_2= k.target;
            var _local_3= this._data.getUser(_local_2.id);
            if (((_local_3 == null) || _local_3.owner))
            {
                return;
            }
            if (_local_3.member)
            {
                this._manager.handleUserKick(_local_2.id, this._data.groupId);
            }
            else
            {
                this._manager.send(new RejectMembershipRequestMessageComposer(this._data.groupId, _local_3.userId));
            }
        }

        function onBlockMouseClick(k:WindowEvent)
        {
            var _local_2= k.target;
            var _local_3= this._data.getUser(_local_2.id);
            if (((_local_3 == null) || _local_3.owner))
            {
                return;
            }
            if (_local_3.member)
            {
                this._manager.handleUserBlock(_local_2.id, this._data.groupId);
            }
        }

        function setActionLink(k:IWindowContainer, _arg_2:String, _arg_3:Bool)
        {
            var _local_4= cast(k.findChildByName("action_link"), ITextWindow);
            _local_4.text = this._manager.localization.getLocalization(_arg_2, _arg_2);
            _local_4.underline = _arg_3;
        }

        function setRemoveState(k:Bool, _arg_2:IWindowContainer)
        {
            _arg_2.findChildByName("icon_close_off").visible = (!k);
            _arg_2.findChildByName("icon_close_over").visible = k;
            _arg_2.findChildByName("icon_close_down").visible = false;
        }

        function setActionLinkState(k:Bool, _arg_2:IWindowContainer)
        {
            var _local_3= cast(_arg_2.findChildByName("action_link"), ITextWindow);
            _local_3.textColor = (k ? 0xFF2AA1FC : 0xFF6F6E65);
        }

        function onActionLinkMouseOver(k:WindowEvent)
        {
            var _local_2= cast(k.target, IRegionWindow);
            var _local_3= this._data.getUser(k.target.id);
            if (((_local_3 == null) || _local_3.owner))
            {
                return;
            }
            this.setActionLinkState(true, _local_2);
            this.setAdminState(_local_3.member, (!_local_3.admin), cast(_local_2.parent, IWindowContainer));
        }

        function onActionLinkMouseOut(k:WindowEvent)
        {
            var _local_2= cast(k.target, IRegionWindow);
            this.setActionLinkState(false, _local_2);
            var _local_3= this._data.getUser(k.target.id);
            if (_local_3 != null)
            {
                this.setAdminState(_local_3.member, _local_3.admin, cast(_local_2.parent, IWindowContainer));
            }
        }

        function onActionLinkClick(k:WindowEvent)
        {
            var _local_2= this._data.getUser(k.target.id);
            if (((_local_2 == null) || _local_2.owner))
            {
                return;
            }
            if (_local_2.blocked)
            {
                this._manager.send(new UnblockGroupMemberMessageComposer(this._data.groupId, _local_2.userId));
            }
            else
            {
                if (_local_2.admin)
                {
                    this._manager.send(new RemoveAdminRightsFromMemberMessageComposer(this._data.groupId, _local_2.userId));
                }
                else
                {
                    if (_local_2.member)
                    {
                        this._manager.send(new AddAdminRightsToMemberMessageComposer(this._data.groupId, _local_2.userId));
                    }
                    else
                    {
                        this._manager.send(new ApproveMembershipRequestMessageComposer(this._data.groupId, _local_2.userId));
                    }
                }
            }
        }

        function setAdminState(k:Bool, _arg_2:Bool, _arg_3:IWindowContainer)
        {
            _arg_3.findChildByName("icon_admin_off").visible = (k && _arg_2);
            _arg_3.findChildByName("icon_admin_over").visible = (k && (!_arg_2));
        }

        function onBg(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._manager.send(new GetExtendedProfileMessageComposer(_arg_2.id));
            }
        }

        function onFilterMembers(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_CHANGE)
            {
                this._searchTimer.reset();
                this._searchTimer.start();
                this.setSearchingIcon(true);
            }
        }

        function onTypeDropmenu(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                this.doSearch(0);
            }
        }

        function doSearch(k:Int)
        {
            this._searchTimer.stop();
            this._searchTimer.reset();
            this.setSearchingIcon(true);
            var _local_2= this._data;
            var _local_3= this._userNameFilter.getText();
            var _local_4= this.getTypeDropMenu().selection;
            this._manager.send(new GetGuildMembersMessageComposer(_local_2.groupId, k, _local_3, _local_4));
        }

        function onAcceptAll(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.send(new ApproveAllMembershipRequestsMessageComposer(this._data.groupId));
        }

        function getTypeDropMenu():IDropMenuWindow
        {
            return cast(this._window.findChildByName("type_drop_menu"), IDropMenuWindow);
        }

        function onSearchTimer(k:Event)
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this.doSearch(0);
            }
        }

        function onNextPage(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.doSearch(this.limitPageIndex((this._data.pageIndex + 1)));
        }

        function onPreviousPage(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.doSearch(this.limitPageIndex((this._data.pageIndex - 1)));
        }

        function hasPreviousPage():Bool
        {
            return !(this._data.pageIndex == this.limitPageIndex((this._data.pageIndex - 1)));
        }

        function hasNextPage():Bool
        {
            return !(this._data.pageIndex == this.limitPageIndex((this._data.pageIndex + 1)));
        }

        function limitPageIndex(k:Int):Int
        {
            var _local_2= Std.int(Math.fceil((this._data.totalEntries / this._data.pageSize)));
            return Std.int(Math.max(0, Math.min(k, (_local_2 - 1))));
        }

        public var data(get,never):GuildMemberData;
public function  get_data():GuildMemberData
        {
            return this._data;
        }

        function populateSearchTypes()
        {
            var k= new Array<ASAny>();
            k.push("${group.members.search.all}");
            k.push("${group.members.search.admins}");
            if (this._data.allowedToManage)
            {
                k.push("${group.members.search.pending}");
                if (this._manager.getBoolean("group.blocking.enabled"))
                {
                    k.push("${group.members.search.blocked}");
                }
            }
            var _local_2= this.getTypeDropMenu();
            _local_2.procedure = null;
            _local_2.populate(k);
            _local_2.selection = Std.int(this._data.allowedToManage ? this._data.searchType : Std.int(Math.min(this._data.searchType, 1)));
            _local_2.procedure = this.onTypeDropmenu;
        }

        function populateUserNameFilter()
        {
            var k= this._userNameFilter.input;
            k.procedure = null;
            if (this._userNameFilter.getText() != this._data.userNameFilter)
            {
                this._userNameFilter.setText(this._data.userNameFilter);
            }
            k.procedure = this.onFilterMembers;
            this._searchTimer.stop();
            this.setSearchingIcon(false);
        }
    }

