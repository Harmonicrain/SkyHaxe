package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.users.ExtendedProfileData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.friendlist.RelationshipStatusEnum;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetRelationshipStatusInfoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetSelectedBadgesMessageComposer;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window._enum._Str_4387;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.communication.messages.incoming.users.RelationshipStatusInfo;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.SelectFavouriteHabboGroupMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.DeselectFavouriteHabboGroupMessageComposer;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class ExtendedProfileWindowCtrl implements IDisposable 
    {
        var _manager:HabboGroupsManager;
        var _window:IWindowContainer;
        var _groupsList:IItemListWindow;
        var _groupsListEntryTemplate:IWindowContainer;
        var _selectedGroupId:Int = 0;
        var _groupDetailsCtrl:GroupDetailsCtrl;
        var _noGroupsContainer:IWindowContainer;
        var _data:ExtendedProfileData;
        var _updateExpected:Bool = false;
        var _badgeUpdateExpected:Bool = false;
        var _relationshipStatusMap:Map;
        var _relationshipUpdateExpected:Bool = false;

        public function new(k:HabboGroupsManager)
        {
            this._relationshipStatusMap = new Map();
            this._manager = k;
            this._groupDetailsCtrl = new GroupDetailsCtrl(k, false);
        }

        public function dispose()
        {
            this._manager = null;
            this._groupsList = null;
            this._data = null;
            if (this._relationshipStatusMap != null)
            {
                this._relationshipStatusMap.dispose();
                this._relationshipStatusMap = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._groupDetailsCtrl != null)
            {
                this._groupDetailsCtrl.dispose();
                this._groupDetailsCtrl = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        function prepareWindow()
        {
            var k = 0;
            if (this._window != null)
            {
                return;
            }
            if (this._groupsListEntryTemplate == null)
            {
                this._groupsListEntryTemplate = cast(this._manager.getXmlWindow("group_entry"), IWindowContainer);
            }
            if (this._noGroupsContainer == null)
            {
                this._noGroupsContainer = cast(this._manager.getXmlWindow("no_groups"), IWindowContainer);
                this._noGroupsContainer.findChildByName("view_groups_button").procedure = this._Str_24557;
            }
            this._window = cast(this._manager.getXmlWindow("new_extended_profile"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onClose;
            this._window.findChildByName("addasfriend_button").procedure = this._Str_23485;
            this._window.findChildByName("rooms_button").procedure = this._Str_23821;
            this._groupsList = cast(this._window.findChildByName("groups_list"), IItemListWindow);
            this._window.center();
            this._window.findChildByName("change_looks").procedure = this._Str_22609;
            this._window.findChildByName("change_badges").procedure = this._Str_24847;
            this._window.findChildByName("user_activity_points").visible = this._manager.isActivityDisplayEnabled;
            final _iter_ = RelationshipStatusEnum._Str_15184; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = ASCompat.toInt(_tmp_);
                this._window.findChildByName((RelationshipStatusEnum._Str_7401(k) + "_friend_name_link_region")).procedure = this._Str_24644;
            }
        }

        public function _Str_24312(k:Int)
        {
            if (((((!(this._data == null)) && (this._data.userId == k)) && (!(this._window == null))) && this._window.visible))
            {
                this._manager.send(new GetExtendedProfileMessageComposer(k));
                this._updateExpected = true;
            }
        }

        public function _Str_18339(k:ExtendedProfileData)
        {
            this._data = k;
            var _local_2= this._Str_23684();
            if (_local_2 == null)
            {
                if (this._data.guilds.length > 0)
                {
                    this._selectedGroupId = ASCompat.toInt(this._data.guilds[0].groupId);
                    _local_2 = this._data.guilds[0];
                }
                else
                {
                    this._selectedGroupId = 0;
                }
            }
            if (this._selectedGroupId > 0)
            {
                this._manager.send(new GetHabboGroupDetailsMessageComposer(this._selectedGroupId, false));
            }
            this.refresh();
            this._window.visible = true;
            if (!this._updateExpected)
            {
                this._window.activate();
            }
            this._updateExpected = false;
        }

        function _Str_23684():HabboGroupEntryData
        {
            var k:HabboGroupEntryData = null;
            final _iter_ = this._data.guilds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.groupId == this._selectedGroupId)
                {
                    return k;
                }
            }
            return null;
        }

        function refresh()
        {
            this._manager.send(new GetRelationshipStatusInfoMessageComposer(this._data.userId));
            this._manager.send(new GetSelectedBadgesMessageComposer(this._data.userId));
            this.prepareWindow();
            this._Str_11540();
            this._Str_25048();
        }

        function _Str_25048()
        {
            var _local_2:HabboGroupEntryData = null;
            var _local_3:IWindowContainer = null;
            var _local_4:IBadgeImageWidget = null;
            var _local_5:IWindowContainer = null;
            var k:ASAny = (this._data.userId == this._manager.avatarId);
            this._groupsList.visible = (this._data.guilds.length > 0);
            this._groupsList.destroyListItems();
            final _iter_ = this._data.guilds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = cast(this._groupsListEntryTemplate.clone(), IWindowContainer);
                _local_3.id = _local_2.groupId;
                _local_3.findChildByName("bg_region").procedure = this._Str_18701;
                _local_3.findChildByName("bg_region").id = _local_2.groupId;
                _local_3.findChildByName("clear_favourite").procedure = this.onClearFavourite;
                _local_3.findChildByName("clear_favourite").visible = (_local_2.favourite && ASCompat.toBool(k));
                _local_3.findChildByName("clear_favourite").id = _local_2.groupId;
                _local_3.findChildByName("make_favourite").procedure = this.onMakeFavourite;
                _local_3.findChildByName("make_favourite").visible = ((!_local_2.favourite) && ASCompat.toBool(k));
                _local_3.findChildByName("make_favourite").id = _local_2.groupId;
                _local_4 = cast(cast(_local_3.findChildByName("group_pic_bitmap"), IWidgetWindow).widget, IBadgeImageWidget);
                _local_4.type = _Str_4387.GROUP;
                _local_4.badgeId = _local_2.badgeCode;
                _local_4.groupId = _local_2.groupId;
                this._groupsList.addListItem(_local_3);
            }
            this._Str_20592();
            this._manager.localization.registerParameter("extendedprofile.groups.count", "count", Std.string(this._data.guilds.length));
            if (this._data.guilds.length < 1)
            {
                _local_5 = cast(this._window.findChildByName("group_cont"), IWindowContainer);
                _local_5.removeChildAt(0);
                _local_5.addChild(this._noGroupsContainer);
                this._noGroupsContainer.findChildByName("no_groups_caption").caption = this._manager.localization.getLocalization((k ? "extendedprofile.nogroups.me" : "extendedprofile.nogroups.user"));
                this._noGroupsContainer.findChildByName("view_groups_button").visible = true;
            }
        }

        function _Str_20592()
        {
            var _local_2:IWindowContainer = null;
            var k = 0;
            while (k < this._groupsList.numListItems)
            {
                _local_2 = cast(this._groupsList.getListItemAt(k), IWindowContainer);
                _local_2.findChildByName("bg_selected_bitmap").visible = (this._selectedGroupId == _local_2.id);
                _local_2.findChildByName("bg_unselected_bitmap").visible = (!(this._selectedGroupId == _local_2.id));
                k++;
            }
        }

        function _Str_11540()
        {
            var k:ASAny = (this._data.userId == this._manager.avatarId);
            this._window.findChildByName("motto_txt").caption = this._data.motto;
            this._window.findChildByName("status_txt").visible = (this._data.isFriend || ASCompat.toBool(k));
            this._window.findChildByName("friend_request_sent_txt").visible = this._data.isRequestFriend;
            this._window.findChildByName("offline_icon").visible = (!this._data.online);
            this._window.findChildByName("online_icon").visible = this._data.online;
            this._window.findChildByName("status").invalidate();
            this._manager.localization.registerParameter("extendedprofile.username", "username", this._data.userName);
            this._manager.localization.registerParameter("extendedprofile.created", "created", this._data.creationDate);
            this._manager.localization.registerParameter("extendedprofile.activitypoints", "activitypoints", new compat.RegExp("\\B(?=(\\d{3})+(?!\\d))", "g").replace(Std.string(this._data.activityPoints), " "));
            this._manager.localization.registerParameter("extendedprofile.last.login", "lastlogin", FriendlyTime.format(this._manager.localization, this._data.lastAccessSinceInSeconds, ".ago"));
            this._window.findChildByName("user_last_login").visible = (this._data.lastAccessSinceInSeconds > -1);
            this._Str_16592();
            var _local_2:ASAny = (this._data.friendCount > -1);
            var _local_3= ((this._data.isFriend && ASCompat.toBool(_local_2)) || ASCompat.toBool(k));
            this._window.findChildByName("addasfriend_button").visible = (((((!this._data.isFriend) && (!this._data.isRequestFriend)) && (!k)) && this._manager.friendlist.canBeAskedForAFriend(this._data.userId)) && ASCompat.toBool(_local_2));
            this._window.findChildByName("ok_icon").visible = _local_3;
            this._window.findChildByName("status_txt").visible = _local_3;
            this._window.findChildByName("top_right").visible = _local_2;
            this._window.findChildByName("status_txt").caption = this._manager.localization.getLocalization((this._data.isFriend ? "extendedprofile.friend" : "extendedprofile.me"));
            this._window.findChildByName("change_own_attributes").visible = k;
        }

        function _Str_22916()
        {
            var _local_2 = 0;
            var k= this._manager.getBoolean("relationship.status.enabled");
            if ((k && (this._window != null)))
            {
                this._window.findChildByName("rel_status_label_txt").visible = true;
                final _iter_ = RelationshipStatusEnum._Str_15184; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = ASCompat.toInt(_tmp_);
                    this._Str_24258(_local_2);
                }
            }
            this._manager.localization.registerParameter("extendedprofile.friends.count", "count", Std.string(this._data.friendCount));
        }

        function _Str_24258(k:Int)
        {
            var _local_2:RelationshipStatusInfo = this._relationshipStatusMap.getValue(k);
            var _local_3= RelationshipStatusEnum._Str_7401(k);
            var _local_4= this._window.findChildByName((_local_3 + "_txt"));
            var _local_5= this._window.findChildByName((_local_3 + "_friend_name_link_text"));
            var _local_6= cast(this._window.findChildByName((_local_3 + "_head")), IWidgetWindow);
            if (((_local_2 != null) && (_local_2.friendCount > 0)))
            {
                _local_5.caption = _local_2._Str_20359;
                _local_6.visible = true;
                cast(_local_6.widget, IAvatarImageWidget).figure = _local_2._Str_22960;
                if (_local_2.friendCount > 1)
                {
                    _local_4.visible = true;
                    _local_4.invalidate();
                    _local_4.caption = this._manager.localization.getLocalizationWithParams(("extendedprofile.relstatus.others." + _local_3), "", ["count", ("" + Std.string(_local_2.friendCount - 1))]);
                }
                else
                {
                    _local_4.visible = false;
                }
            }
            else
            {
                _local_6.visible = false;
                _local_5.caption = "${extendedprofile.add.friends}";
                _local_4.caption = "${extendedprofile.no.friends.in.this.category}";
                _local_4.visible = true;
            }
        }

        public function onGroupDetails(k:HabboGroupDetailsData)
        {
            var _local_2:IWindowContainer = null;
            if (this._selectedGroupId == k.groupId)
            {
                _local_2 = cast(this._window.findChildByName("group_cont"), IWindowContainer);
                _local_2.removeChildAt(0);
                _local_2.invalidate();
                this._groupDetailsCtrl.onGroupDetails(_local_2, k);
            }
        }

        public function onRelationshipStatusInfo(k:Int, _arg_2:Map)
        {
            if (((this._data != null) && this._Str_12870))
            {
                this._relationshipStatusMap = _arg_2.clone();
                this._Str_22916();
                this._Str_12870 = false;
            }
        }

        public function onUserBadges(k:Int, _arg_2:Array<ASAny>)
        {
            var _local_3 = 0;
            var _local_4:IBadgeImageWidget = null;
            if ((((this._data != null) && this._Str_12511) && (!(this._window == null))))
            {
                _local_3 = 0;
                while (_local_3 < 5)
                {
                    _local_4 = cast(cast(this._window.findChildByName(("badge_" + Std.string(_local_3))), IWidgetWindow).widget, IBadgeImageWidget);
                    _local_4.type = _Str_4387.NORMAL;
                    _local_4.badgeId = ((_local_3 < _arg_2.length) ? _arg_2[_local_3] : "");
                    _local_3++;
                }
                this._Str_12511 = false;
            }
        }

        function setProc(k:String, _arg_2:ASFunction)
        {
            var _local_3= this._window.findChildByName(k);
            _local_3.mouseThreshold = 0;
            _local_3.procedure = _arg_2;
        }

        function _Str_23485(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.friendlist.askForAFriend(this._data.userId, this._data.userName);
            this._data.isRequestFriend = true;
            this.refresh();
        }

        function _Str_23821(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this._manager.sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                this._manager.newNavigator.performSearch("hotel_view", ("owner:" + this._data.userName));
                return;
            }
            cast(this._manager.navigator, IHabboTransitionalNavigator).mainViewCtrl.startSearch(Tabs.TAB_SEARCH, Tabs.SEARCHTYPE_BY_OWNER, this._data.userName);
        }

        function _Str_24644(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            var _local_4:RelationshipStatusInfo = null;
            var _local_5 = 0;
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if ((((!(k.target == null)) && (!(_arg_2.name == null))) && (!(this._relationshipStatusMap == null))))
            {
                _local_3 = _arg_2.name.substr(0, _arg_2.name.indexOf("_"));
                _local_4 = this._relationshipStatusMap.getValue(RelationshipStatusEnum._Str_25054(_local_3));
                if (_local_4 != null)
                {
                    _local_5 = _local_4._Str_21077;
                    if (_local_5 != 0)
                    {
                        this._manager.showExtendedProfile(_local_5);
                    }
                }
                else
                {
                    this._manager.windowManager.alert("${extendedprofile.add.friends.alert.title}", "${extendedprofile.add.friends.alert.body}", 0, this._Str_24203);
                }
            }
        }

        function _Str_24557(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.navigator.performGuildBaseSearch();
        }

        function _Str_18701(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._selectedGroupId = _arg_2.id;
            this._manager.send(new GetHabboGroupDetailsMessageComposer(this._selectedGroupId, false));
            this._manager.send(new EventLogMessageComposer(HabboGroupsManager.HABBOGROUPS, ("" + Std.string(_arg_2.id)), "select"));
            this._Str_20592();
        }

        function onMakeFavourite(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.send(new SelectFavouriteHabboGroupMessageComposer(_arg_2.id));
            this._manager.send(new EventLogMessageComposer(HabboGroupsManager.HABBOGROUPS, ("" + Std.string(_arg_2.parent.id)), "make favourite"));
            this._selectedGroupId = _arg_2.id;
        }

        function onClearFavourite(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.send(new DeselectFavouriteHabboGroupMessageComposer(_arg_2.id));
            this._manager.send(new EventLogMessageComposer(HabboGroupsManager.HABBOGROUPS, ("" + Std.string(_arg_2.parent.id)), "clear favourite"));
            this._selectedGroupId = _arg_2.id;
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.close();
        }

        function _Str_22609(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.context.createLinkEvent("avatareditor/open");
        }

        function _Str_24847(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.context.createLinkEvent("inventory/open/badges");
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function _Str_16592(k:Bool=false)
        {
            var _local_2= cast(this._window.findChildByName("avatar_image"), IWidgetWindow);
            var _local_3= cast(_local_2.widget, IAvatarImageWidget);
            _local_3.figure = this._data.figure;
        }

        public function updateVisibleExtendedProfile(k:Int)
        {
            if (((((!(this._window == null)) && this._window.visible) && (!(this._data == null))) && (!(this._data.userId == k))))
            {
                this._manager.send(new GetExtendedProfileMessageComposer(k));
            }
        }

        
        public var _Str_12511(get,set):Bool;
public function  get__Str_12511():Bool
        {
            return this._badgeUpdateExpected;
        }
public function  set__Str_12511(k:Bool):Bool        {
            return this._badgeUpdateExpected = k;
        }

        
        public var _Str_12870(get,set):Bool;
public function  set__Str_12870(k:Bool):Bool        {
            return this._relationshipUpdateExpected = k;
        }
public function  get__Str_12870():Bool
        {
            return this._relationshipUpdateExpected;
        }

        function _Str_24203(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this._manager.context.createLinkEvent("friendbar/findfriends");
                this.close();
            }
            k.dispose();
        }
    }

