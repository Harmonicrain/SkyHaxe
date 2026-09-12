package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.parser.groupforums.ExtendedForumData;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThread;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemListWindow;

     class ThreadListView 
    {
        var _controller:GroupForumController;
        var _mainView:GroupForumView;
        var _list:IScrollableListWindow;
        var _listItem:IWindowContainer;
        var _forumData:ExtendedForumData;
        var _threadsListData:ThreadsListData;

        public function new(k:GroupForumView, _arg_2:IScrollableListWindow, _arg_3:ExtendedForumData, _arg_4:ThreadsListData)
        {
            this._mainView = k;
            this._controller = this._mainView.controller;
            this._list = _arg_2;
            this._listItem = Std.downcast(this._controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboFriendBarCom.groupforum_thread_list_item_xml, []))) , IWindowContainer);
            this._forumData = _arg_3;
            this._threadsListData = _arg_4;
        }

        static function _Str_26453(k:Int, _arg_2:Int):UInt
        {
            switch (k)
            {
                case ForumModerationState._Str_5466:
                    return 0xFFAAAAAA;
                case ForumModerationState._Str_4415:
                    return 0xFFFFB0A5;
                default:
                    return ((_arg_2 + 1) % 2 != 0) ? 0xFFEEFEFF : 0xFFB2E6FA;
            }
        }


        public function update()
        {
            var k = 0;
            var _local_2:IWindowContainer = null;
            var _local_3:GuildForumThread = null;
            this._list.invalidate();
            k = 0;
            while (k < this._threadsListData.size)
            {
                _local_3 = this._threadsListData._Str_8372[k];
                _local_2 = Std.downcast(this._listItem.clone() , IWindowContainer);
                _local_2.name = ("thread_" + Std.string(_local_3.threadId));
                this._Str_10311(_local_2, _local_3, k);
                this._list.addListItem(_local_2);
                k++;
            }
            this._Str_11755();
        }

        function _Str_10311(k:IWindowContainer, _arg_2:GuildForumThread, _arg_3:Int)
        {
            var _local_5:IWindow = null;
            var _local_13:String = null;
            var _local_4= k ;
            var _local_6= _arg_2.state;
            var _local_7= this._forumData._Str_7246;
            var _local_8= this._forumData._Str_7449;
            var _local_9= _arg_2.isPinned;
            var _local_10= _arg_2.isLocked;
            var _local_11= ((_arg_2.totalMessages - this._controller._Str_16072(_arg_2.threadId)) - 1);
            _local_5 = _local_4.findChildByName("texts_container");
            if (_local_5 != null)
            {
                _local_5.id = _arg_2.threadId;
                _local_5.color = _Str_26453(_local_6, _arg_3);
            }
            var _local_12= Std.downcast(_local_4.findChildByName("header") , ITextWindow);
            if (_local_12 != null)
            {
                _local_12.bold = (_local_11 > 0);
                _local_13 = _arg_2.header;
                if (_arg_2.header == "")
                {
                    _local_13 = "(No Subject)";
                }
                if ((((_local_6 > ForumModerationState._Str_6076) && (!_local_7)) && (!_local_8)))
                {
                    _local_13 = this._Str_13405(_arg_2);
                }
                _local_12.text = _local_13;
            }
            _local_5 = _local_4.findChildByName("header_region");
            if (_local_5 != null)
            {
                _local_5.id = _arg_2.threadId;
                _local_5.removeEventListener(WindowMouseEvent.CLICK, this._Str_15365);
                _local_5.addEventListener(WindowMouseEvent.CLICK, this._Str_15365);
            }
            _local_5 = _local_4.findChildByName("details");
            if (_local_5 != null)
            {
                _local_5.caption = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_details", "", ["thread_author_id", _arg_2.authorId, "thread_author_name", _arg_2.authorName, "last_author_id", _arg_2.lastUserId, "last_author_name", _arg_2.lastUserName, "creation_time", this._mainView._Str_11823(_arg_2.creationTime), "update_time", this._mainView._Str_11823(_arg_2.lastCommentTime)]);
            }
            _local_5 = _local_4.findChildByName("unread_texts_container");
            if (_local_5 != null)
            {
                _local_5.id = _arg_2.threadId;
                _local_5.color = _Str_26453(_local_6, _arg_3);
            }
            _local_5 = _local_4.findChildByName("unread_region");
            if (_local_5 != null)
            {
                _local_5.id = _arg_2.threadId;
                _local_5.removeEventListener(WindowMouseEvent.CLICK, this._Str_15365);
                _local_5.addEventListener(WindowMouseEvent.CLICK, this._Str_15365);
            }
            _local_12 = Std.downcast(_local_4.findChildByName("messages1") , ITextWindow);
            if (_local_12 != null)
            {
                _local_12.bold = (_local_11 > 0);
                _local_12.text = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_details1", "", ["total_messages", _arg_2.totalMessages, "new_messages", _local_11]);
            }
            _local_12 = Std.downcast(_local_4.findChildByName("messages2") , ITextWindow);
            if (_local_12 != null)
            {
                _local_12.bold = (_local_11 > 0);
                _local_12.text = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_details2", "", ["total_messages", _arg_2.totalMessages, "new_messages", _local_11]);
            }
            _local_5 = _local_4.findChildByName("button_container");
            if (_local_5 != null)
            {
                _local_5.id = _arg_2.threadId;
                _local_5.color = _Str_26453(_local_6, _arg_3);
                this._Str_15972(Std.downcast(_local_5 , IWindowContainer), _arg_2, _local_6);
                _local_5.color = _Str_26453(_local_6, _arg_3);
            }
            _local_5 = _local_4.findChildByName("left_button_container");
            if (_local_5 != null)
            {
                _local_5.id = _arg_2.threadId;
                _local_5.color = _Str_26453(_local_6, _arg_3);
                this._Str_23179(Std.downcast(_local_5 , IWindowContainer), _arg_2, _local_10, _local_9);
                _local_5.color = _Str_26453(_local_6, _arg_3);
            }
        }

        public function _Str_11755()
        {
            var k = 0;
            while (k < this._list.numListItems)
            {
                this._list.getListItemAt(k).width = (this._list.scrollableWindow.width - 2);
                k++;
            }
        }

        function _Str_15972(k:IWindowContainer, _arg_2:GuildForumThread, _arg_3:Int)
        {
            var _local_4:IRegionWindow = null;
            var _local_9:IStaticBitmapWrapperWindow = null;
            var _local_5= this._forumData._Str_7246;
            var _local_6= this._forumData._Str_7449;
            var _local_7= this._forumData._Str_21331;
            var _local_8= Std.downcast(k.findChildByName("mod_buttons") , IItemListWindow);
            _local_4 = Std.downcast(_local_8.getListItemAt(0) , IRegionWindow);
            if (_local_4 != null)
            {
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_10493);
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_7727);
                if ((_local_5 || _local_6))
                {
                    _local_4.id = _arg_2.threadId;
                    _local_9 = Std.downcast(_local_4.getChildByName("icon") , IStaticBitmapWrapperWindow);
                    switch (_arg_3)
                    {
                        case ForumModerationState._Str_8046
                           | ForumModerationState._Str_6076:
                            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_10493);
                            _local_9.assetUri = "forum_forum_hide";
                            
                        case ForumModerationState._Str_5466:
                            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_7727);
                            _local_9.assetUri = "forum_forum_unhide";
                            
                        case ForumModerationState._Str_4415:
                            if (_local_6)
                            {
                                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_7727);
                                _local_9.assetUri = "forum_forum_unhide";
                            }
                            else
                            {
                                _local_4.visible = false;
                            }
                            
                    }
                }
                else
                {
                    _local_4.visible = false;
                }
            }
            _local_4 = Std.downcast(_local_8.getListItemAt(1) , IRegionWindow);
            if (_local_4 != null)
            {
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_9877);
                if (((_local_5 || _local_6) || _local_7))
                {
                    _local_4.id = _arg_2.threadId;
                    _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_9877);
                }
                else
                {
                    _local_4.visible = false;
                }
            }
        }

        function _Str_23179(k:IWindowContainer, _arg_2:GuildForumThread, _arg_3:Bool, _arg_4:Bool)
        {
            var _local_10:IStaticBitmapWrapperWindow = null;
            var _local_11:IStaticBitmapWrapperWindow = null;
            var _local_5= this._forumData._Str_7246;
            var _local_6= this._forumData._Str_7449;
            var _local_7= Std.downcast(k.findChildByName("info_buttons") , IItemListWindow);
            var _local_8= Std.downcast(_local_7.getListItemByName("thread_lock") , IRegionWindow);
            if (_local_8 != null)
            {
                _local_8.removeEventListener(WindowMouseEvent.CLICK, this._Str_21587);
                _local_10 = Std.downcast(_local_8.getChildByName("icon") , IStaticBitmapWrapperWindow);
                if ((_local_5 || _local_6))
                {
                    _local_8.id = _arg_2.threadId;
                    _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_21587);
                    if (_arg_3)
                    {
                        _local_10.assetUri = "forum_forum_locked";
                    }
                    else
                    {
                        _local_10.assetUri = "forum_forum_unlocked";
                    }
                    _local_8.visible = true;
                }
                else
                {
                    if (_arg_3)
                    {
                        _local_10.assetUri = "forum_forum_locked";
                    }
                    _local_8.visible = _arg_3;
                    _local_8.disable();
                }
            }
            var _local_9= Std.downcast(_local_7.getListItemByName("thread_pin") , IRegionWindow);
            if (_local_9 != null)
            {
                _local_9.removeEventListener(WindowMouseEvent.CLICK, this._Str_22040);
                _local_11 = Std.downcast(_local_9.getChildByName("icon") , IStaticBitmapWrapperWindow);
                if ((_local_5 || _local_6))
                {
                    _local_9.id = _arg_2.threadId;
                    _local_9.addEventListener(WindowMouseEvent.CLICK, this._Str_22040);
                    if (_arg_4)
                    {
                        _local_11.assetUri = "forum_forum_pinned";
                    }
                    else
                    {
                        _local_11.assetUri = "forum_forum_unpinned";
                    }
                    _local_9.visible = true;
                }
                else
                {
                    if (_arg_4)
                    {
                        _local_11.assetUri = "forum_forum_pinned";
                    }
                    _local_9.visible = _arg_4;
                    _local_9.disable();
                }
            }
        }

        function _Str_13405(k:GuildForumThread):String
        {
            var _local_2:String = null;
            switch (k.state)
            {
                case ForumModerationState._Str_8046:
                    
                case ForumModerationState._Str_6076:
                    
                case ForumModerationState._Str_5466:
                    _local_2 = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_hidden_by_admin", "", ["admin_name", k.adminName]);
                    
                case ForumModerationState._Str_4415:
                    _local_2 = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_hidden_by_staff", "", ["admin_name", k.adminName]);
                    
            }
            return _local_2;
        }

        public function _Str_16935(k:GuildForumThread)
        {
            var _local_2= k.threadId;
            var _local_3= Std.downcast(this._list.getListItemByName(("thread_" + Std.string(_local_2))) , IWindowContainer);
            var _local_4= this._list.getListItemIndex(_local_3);
            if (_local_3 != null)
            {
                this._Str_10311(_local_3, k, _local_4);
            }
        }

        function _Str_21587(k:WindowMouseEvent)
        {
            var _local_2= k.target.id;
            var _local_3:GuildForumThread = this._threadsListData._Str_6700[_local_2];
            if (_local_3 == null)
            {
                return;
            }
            this._controller._Str_24793(this._forumData, _local_2, (!_local_3.isLocked), _local_3.isPinned);
        }

        function _Str_22040(k:WindowMouseEvent)
        {
            var _local_2= k.target.id;
            var _local_3:GuildForumThread = this._threadsListData._Str_6700[_local_2];
            if (_local_3 == null)
            {
                return;
            }
            this._controller._Str_22439(this._forumData, _local_2, _local_3.isLocked, (!_local_3.isPinned));
        }

        function _Str_9877(k:WindowMouseEvent)
        {
            this._controller.reportThread(this._forumData, k.target.id);
        }

        function _Str_10493(k:WindowMouseEvent)
        {
            this._controller._Str_24351(this._forumData, k.target.id);
        }

        function _Str_7727(k:WindowMouseEvent)
        {
            this._controller.unDeleteThread(this._forumData, k.target.id);
        }

        function _Str_15365(k:WindowMouseEvent)
        {
            var _local_4 = 0;
            var _local_2= k.target.id;
            var _local_3:GuildForumThread = this._threadsListData._Str_6700[_local_2];
            if (_local_3 != null)
            {
                _local_4 = Std.int(Math.min((this._controller._Str_16072(_local_2) + 1), (_local_3.totalMessages - 1)));
                this._controller._Str_20033(this._forumData.groupId, _local_2, _local_4);
            }
        }
    }

