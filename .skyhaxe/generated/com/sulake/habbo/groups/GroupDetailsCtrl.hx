package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.JoinHabboGroupMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildEditInfoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.DeactivateGuildMessageComposer;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildMembersMessageComposer;
    import com.sulake.habbo.catalog._enum.CatalogPageName;

     class GroupDetailsCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _window:IWindowContainer;
        var _selectedGroup:HabboGroupDetailsData;

        public function new(k:HabboGroupsManager, _arg_2:Bool)
        {
            this._manager = k;
        }

        public function dispose()
        {
            this._manager = null;
            this._selectedGroup = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        function prepareWindow(k:IWindowContainer)
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("group"), IWindowContainer);
            this.setProc("group_room_link_region", this.onRoomLink);
            this.setProc("manage_guild_region", this.onManageGuild);
            this.setProc("delete_guild_region", this.onDeleteGuild);
            this.setProc("members_region", this.onMembers);
            this.setProc("pending_members_region", this.onPendingMembers);
            this.setProc("show_groups_link_region", this.onShowGroups);
            this.setProc("buy_furni_link_region", this.onBuyFurni);
            this._window.findChildByName("leave_button").procedure = this.onLeave;
            this._window.findChildByName("join_button").procedure = this.onJoin;
            this._window.findChildByName("request_membership_button").procedure = this.onJoin;
        }

        function attachWindow(k:IWindowContainer)
        {
            if (k.getChildIndex(this._window) == -1)
            {
                k.addChild(this._window);
            }
        }

        public function onGroupDetails(k:IWindowContainer, _arg_2:HabboGroupDetailsData)
        {
            this._selectedGroup = _arg_2;
            this.prepareWindow(k);
            this.attachWindow(k);
            var _local_3= this._window.findChildByName("group_decorate_icon_region");
            var _local_4= this._window.findChildByName("group_name");
            _local_4.caption = _arg_2.groupName;
            _local_3.visible = _arg_2._Str_17307;
            _local_4.x = (_arg_2._Str_17307 ? (_local_3.x + _local_3.width) : _local_3.x);
            var _local_5= cast(this._window.findChildByName("group_description"), ITextWindow);
            _local_5.caption = _arg_2.description;
            _local_5.height = Std.int(_local_5.textHeight + 5);
            this._window.findChildByName("group_description_scrollbar").visible = (_local_5.height > this._window.findChildByName("group_description_item_list").height);
            var _local_6= this._selectedGroup._Str_25156;
            this._window.findChildByName("show_forum_link_region").visible = _local_6;
            this._window.findChildByName("show_forum_link").visible = _local_6;
            if (_local_6)
            {
                this.setProc("show_forum_link_region", this.onForumLink);
            }
            this._manager.windowManager.registerLocalizationParameter("group.created", "date", ("" + _arg_2.creationDate));
            this._manager.windowManager.registerLocalizationParameter("group.created", "owner", ("" + _arg_2.ownerName));
            this._window.findChildByName("created_txt").caption = this._manager.localization.getLocalization("group.created");
            this._manager.windowManager.registerLocalizationParameter("group.membercount", "totalMembers", ("" + Std.string(_arg_2.totalMembers)));
            this._window.findChildByName("members_txt").caption = this._manager.localization.getLocalization("group.membercount");
            this._window.findChildByName("group_room_link_region").visible = (_arg_2.roomId > -1);
            this._manager.windowManager.registerLocalizationParameter("group.linktobase", "room_name", _arg_2.roomName);
            this._window.findChildByName("group_room_link").caption = this._manager.localization.getLocalization("group.linktobase");
            var _local_7= Std.downcast(cast(this._window.findChildByName("group_logo"), IWidgetWindow).widget , IBadgeImageWidget);
            _local_7.badgeId = this._selectedGroup.badgeCode;
            _local_7.groupId = this._selectedGroup.groupId;
            this._window.findChildByName("join_button").visible = _arg_2._Str_19430;
            this._window.findChildByName("join_button").enable();
            this._window.findChildByName("request_membership_button").visible = _arg_2._Str_21531;
            this._window.findChildByName("leave_button").visible = _arg_2._Str_24358;
            this._window.findChildByName("membership_pending_txt").visible = (_arg_2.status == HabboGroupDetailsData.STATUS_PENDING);
            this._window.findChildByName("youaremember_txt").visible = ((!this._selectedGroup._Str_6444) && (_arg_2.status == HabboGroupDetailsData.STATUS_MEMBER));
            this._window.findChildByName("youaremember_icon").visible = ((!this._selectedGroup._Str_6444) && (_arg_2.status == HabboGroupDetailsData.STATUS_MEMBER));
            var _local_8= this._window.findChildByName("pending_members_region");
            _local_8.visible = (this._selectedGroup._Str_18324 > 0);
            if (this._selectedGroup._Str_18324 > 0)
            {
                this._manager.windowManager.registerLocalizationParameter("group.pendingmembercount", "amount", ("" + Std.string(_arg_2._Str_18324)));
                this._window.findChildByName("pending_members_txt").caption = this._manager.localization.getLocalization("group.pendingmembercount");
            }
            var _local_9= this._window.findChildByName("manage_guild_region");
            _local_9.visible = (this._selectedGroup.isOwner && this._selectedGroup._Str_6444);
            _local_9.y = (_local_8.visible ? (_local_8.y + 16) : _local_8.y);
            var _local_10= this._window.findChildByName("delete_guild_region");
            _local_10.visible = ((this._selectedGroup._Str_6444 && this._manager.groupDeletionEnabled) && (this._selectedGroup.isOwner || this._manager.sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR)));
            _local_10.y = (_local_9.visible ? (_local_9.y + 16) : _local_8.y);
            this._window.findChildByName("you_are_owner_region").visible = (this._selectedGroup._Str_6444 && this._selectedGroup.isOwner);
            this._window.findChildByName("you_are_admin_region").visible = ((this._selectedGroup._Str_6444 && this._selectedGroup.isAdmin) && (!this._selectedGroup.isOwner));
            this._window.findChildByName("you_are_member_region").visible = (this._selectedGroup._Str_6444 && ((this._selectedGroup.status == HabboGroupDetailsData.STATUS_MEMBER) && (!(this._selectedGroup.isAdmin || this._selectedGroup.isOwner))));
            this.getGroupTypeRegion(0).visible = false;
            this.getGroupTypeRegion(1).visible = false;
            this.getGroupTypeRegion(2).visible = false;
            if (this.getGroupTypeRegion(_arg_2.type) != null)
            {
                this.getGroupTypeRegion(_arg_2.type).visible = true;
            }
        }

        function getGroupTypeRegion(k:Int):IWindow
        {
            return this._window.findChildByName(("grouptype_region_" + Std.string(k)));
        }

        function getGroupTypeIcon(k:Int):IWindow
        {
            return this._window.findChildByName(("grouptype_icon_" + Std.string(k)));
        }

        function setProc(k:String, _arg_2:ASFunction)
        {
            var _local_3= this._window.findChildByName(k);
            _local_3.mouseThreshold = 0;
            _local_3.procedure = _arg_2;
        }

        function onLeave(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "leaveGroup");
            this._manager.handleUserKick(this._manager.avatarId, this._selectedGroup.groupId);
        }

        function onJoin(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "joinGroup");
            this._window.findChildByName("join_button").disable();
            this._manager.send(new JoinHabboGroupMessageComposer(this._selectedGroup.groupId));
            this._manager.send(new EventLogMessageComposer(HabboGroupsManager.HABBOGROUPS, ("" + Std.string(this._selectedGroup.groupId)), "join"));
        }

        function onRoomLink(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "groupBaseRoom");
            this._manager.navigator.goToPrivateRoom(this._selectedGroup.roomId);
            this._manager.send(new EventLogMessageComposer(HabboGroupsManager.HABBOGROUPS, ("" + Std.string(this._selectedGroup.groupId)), "base"));
        }

        function onForumLink(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.openGroupForum(this._selectedGroup.groupId);
        }

        function openExternalLink(k:String)
        {
            if (k != "")
            {
                this._manager.windowManager.alert("${catalog.alert.external.link.title}", "${catalog.alert.external.link.desc}", 0, this.onExternalLink);
                HabboWebTools.navigateToURL(k, "_empty");
            }
        }

        function onExternalLink(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function onManageGuild(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "groupManage");
            this._manager.send(new GetGuildEditInfoMessageComposer(this._selectedGroup.groupId));
        }

        function onDeleteGuild(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.windowManager.confirm("${group.deleteconfirm.title}", "${group.deleteconfirm.desc}", 0, this.onDeleteGuildConfirmation);
        }

        function onDeleteGuildConfirmation(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this._manager.trackGoogle("groupDetails", "groupDelete");
                this._manager.send(new DeactivateGuildMessageComposer(this._selectedGroup.groupId));
            }
        }

        function onMembers(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "groupMembers");
            this._manager.guildMembersWindowCtrl.onMembersClick(this._selectedGroup.groupId, GetGuildMembersMessageComposer._Str_13464);
        }

        function onPendingMembers(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "groupPendingMembers");
            this._manager.guildMembersWindowCtrl.onMembersClick(this._selectedGroup.groupId, GetGuildMembersMessageComposer._Str_17798);
        }

        function onShowGroups(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "hottestGroups");
            this._manager.navigator.performGuildBaseSearch();
        }

        function onBuyFurni(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.trackGoogle("groupDetails", "groupFurni");
            this._manager.openCatalog(CatalogPageName.GUILD_CUSTOM_FURNI);
        }
    }

