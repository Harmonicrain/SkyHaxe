package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.parser.groupforums.ExtendedForumData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.window._enum._Str_4387;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication.messages.parser.groupforums.ForumData;
    import flash.events.MouseEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThread;
    import com.sulake.habbo.communication.messages.parser.groupforums.MessageData;
    import com.sulake.habbo.utils.FriendlyTime;

     class GroupForumView 
    {
        static inline final _Str_17065= 100;

        var _controller:GroupForumController;
        var _forumsListView:ForumsListView;
        var _threadListView:ThreadListView;
        var _messageListView:MessageListView;
        var _window:IFrameWindow;
        var _listWindow:IScrollableListWindow;
        var _showPrev:IWindow;
        var _showNext:IWindow;
        var _showFirst:IWindow;
        var _showLast:IWindow;
        var _txtElement:IWindow;
        var _backButton:IContainerButtonWindow;
        var _postButton:IContainerButtonWindow;
        var _closeBtn:IWindow;
        var _listHeader:IWindow;
        var _myForumsLink:ITextWindow;
        var _forumsListData:ForumsListData;
        var _forumData:ExtendedForumData;
        var _threadsListData:ThreadsListData;
        var _messagesListData:MessagesListData;
        var _currentPage:Int = 1;
        var _numOfPages:Int = 1;
        var _pageSize:Int = 0;

        public function new(k:GroupForumController)
        {
            this._controller = k;
            this._pageSize = ThreadsListData.PAGE_SIZE;
        }

        static function enable(k:IWindow, _arg_2:Bool)
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

        @:allow(com.sulake.habbo.friendbar.groupforums) static function _Str_14926(k:IFrameWindow, _arg_2:ForumData):IRegionWindow
        {
            var _local_3= Std.downcast(k.findChildByName("top_part") , IWindowContainer);
            var _local_4= cast(_local_3.findChildByName("group_icon"), IWidgetWindow);
            _local_4.visible = true;
            var _local_5= Std.downcast(_local_4.widget , IBadgeImageWidget);
            _local_5.badgeId = _arg_2.icon;
            _local_5.groupId = _arg_2.groupId;
            _local_5.type = _Str_4387.GROUP;
            var _local_6= Std.downcast(_local_3.findChildByName("header_icon") , IStaticBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_6.visible = false;
            }
            var _local_7= Std.downcast(_local_3.findChildByName("top_header_text") , ITextWindow);
            _local_7.text = _arg_2.name;
            var _local_8= Std.downcast(_local_3.findChildByName("top_text") , ITextWindow);
            _local_8.text = _arg_2.description;
            return Std.downcast(_local_3.findChildByName("top_click_area") , IRegionWindow);
        }


        public function dispose()
        {
            if (this._controller != null)
            {
                this._controller._Str_24639();
            }
            if (this._window != null)
            {
                this._window.removeEventListener(MouseEvent.CLICK, this._Str_6266);
                this._window.dispose();
                this._window = null;
                this._controller = null;
            }
        }

        function _Str_18407()
        {
            var k= this._window.findChildByName("settings_button");
            if (((!(this._forumData == null)) && this._forumData._Str_25616))
            {
                k.removeEventListener(WindowMouseEvent.CLICK, this._Str_19665);
                k.addEventListener(WindowMouseEvent.CLICK, this._Str_19665);
                k.visible = true;
            }
            else
            {
                k.visible = false;
            }
            var _local_2= Std.downcast(this._backButton.findChildByName("back_button_label") , ILabelWindow);
            if (this._threadListView != null)
            {
                this._backButton.visible = true;
                _local_2.text = this._controller.localizationManager.getLocalization("groupforum.view.mark_read");
            }
            else
            {
                if (this._messageListView != null)
                {
                    this._backButton.visible = true;
                    _local_2.text = this._controller.localizationManager.getLocalization("groupforum.view.back");
                }
                else
                {
                    if (this._forumsListView != null)
                    {
                        this._backButton.visible = true;
                        _local_2.text = this._controller.localizationManager.getLocalization("groupforum.view.mark_read");
                    }
                    else
                    {
                        this._backButton.visible = false;
                    }
                }
            }
            var _local_3= Std.downcast(this._postButton.findChildByName("post_button_label") , ILabelWindow);
            if (this._threadListView != null)
            {
                this._postButton.visible = true;
                _local_3.text = this._controller.localizationManager.getLocalization("groupforum.view.start_thread");
            }
            else
            {
                if (this._messageListView != null)
                {
                    this._postButton.visible = true;
                    _local_3.text = this._controller.localizationManager.getLocalization("groupforum.view.reply");
                }
                else
                {
                    this._postButton.visible = false;
                }
            }
            var _local_4= (this._currentPage + 1);
            this._txtElement.caption = ((Std.string(_local_4) + " / ") + Std.string(this._numOfPages));
            this._window.scaler.enable();
            this._window.scaler.visible = true;
            enable(this._showFirst, (this._currentPage > 0));
            enable(this._showPrev, (this._currentPage > 0));
            enable(this._showNext, (this._currentPage < (this._numOfPages - 1)));
            enable(this._showLast, (this._currentPage < (this._numOfPages - 1)));
            this._Str_7256(this._controller._Str_9052);
        }

        function _Str_18232()
        {
            if (this._window != null)
            {
                this._listWindow.destroyListItems();
                this._forumsListView = null;
                this._threadListView = null;
                this._messageListView = null;
            }
            else
            {
                this._window = Std.downcast(this._controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboFriendBarCom.groupforum_main_view_xml, []))) , IFrameWindow);
                this._listWindow = Std.downcast(this._window.findChildByName("scrollable_message_list") , IScrollableListWindow);
                this._listWindow.scrollableWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_25680, 100);
                this._window.center();
                this._window.y = _Str_17065;
                this._txtElement = this._window.findChildByName("page_info");
                this._showPrev = this._window.findChildByName("show_previous");
                this._showPrev.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._showNext = this._window.findChildByName("show_next");
                this._showNext.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._showLast = this._window.findChildByName("show_last");
                this._showLast.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._showFirst = this._window.findChildByName("show_first");
                this._showFirst.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._backButton = cast(this._window.findChildByName("back_button"), IContainerButtonWindow);
                this._backButton.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._postButton = cast(this._window.findChildByName("post_button"), IContainerButtonWindow);
                this._postButton.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._closeBtn = this._window.findChildByTag("close");
                this._closeBtn.addEventListener(WindowMouseEvent.CLICK, this._Str_6266);
                this._listHeader = this._window.findChildByName("list_header");
                this._myForumsLink = cast(cast(this._window.findChildByName("shortcuts"), IItemListWindow).getListItemByName("my"), ITextWindow);
            }
        }

        function _Str_11501(k:String, _arg_2:String)
        {
            var _local_3= cast(this._window.findChildByName("status"), ITextWindow);
            if (((_arg_2 == null) || (_arg_2.length == 0)))
            {
                _local_3.caption = "";
            }
            else
            {
                k = this._controller.localizationManager.getLocalization(("groupforum.view.error.operation_" + k));
                _local_3.text = this._controller.localizationManager.getLocalizationWithParams(("groupforum.view.error." + _arg_2), "", ["operation", k]);
            }
        }

        function _Str_19665(k:WindowMouseEvent)
        {
            this._window5();
        }

        function _Str_4912(k:WindowMouseEvent)
        {
            if (this._forumData != null)
            {
                this._controller.context.createLinkEvent(("group/" + Std.string(this._forumData.groupId)));
            }
        }

        public function _Str_12395(k:ForumsListData)
        {
            this._Str_18232();
            this._forumsListData = k;
            this._forumData = null;
            this._threadsListData = null;
            this._messagesListData = null;
            this._numOfPages = this._Str_18295(this._forumsListData.totalAmount);
            this._currentPage = Std.int(Math.fceil((this._forumsListData.startIndex / ThreadsListData.PAGE_SIZE)));
            this._forumsListView = new ForumsListView(this, this._listWindow, this._forumsListData.forums);
            this._forumsListView.update();
            this._listHeader.caption = this._controller.localizationManager.getLocalization(("groupforum.view.forums_list." + Std.string(this._forumsListData._Str_5154)));
            var _local_2= Std.downcast(this._window.findChildByName("top_part") , IWindowContainer);
            var _local_3= cast(_local_2.findChildByName("group_icon"), IWidgetWindow);
            _local_3.visible = false;
            var _local_4= Std.downcast(_local_2.findChildByName("header_icon") , IStaticBitmapWrapperWindow);
            _local_4.visible = true;
            _local_4.assetUri = ("forum_forum_list" + Std.string(this._forumsListData._Str_5154));
            var _local_5= Std.downcast(_local_2.findChildByName("top_header_text") , ITextWindow);
            _local_5.text = this._controller.localizationManager.getLocalization(("groupforum.view.forums_header." + Std.string(this._forumsListData._Str_5154)));
            var _local_6= Std.downcast(_local_2.findChildByName("top_text") , ITextWindow);
            _local_6.text = this._controller.localizationManager.getLocalization(("groupforum.view.forums_description." + Std.string(this._forumsListData._Str_5154)));
            var _local_7= Std.downcast(_local_2.findChildByName("top_click_area") , IRegionWindow);
            _local_7.removeEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            _local_7.disable();
            this._Str_18407();
            var _local_8= cast(this._window.findChildByName("status"), ITextWindow);
            _local_8.text = this._controller.localizationManager.getLocalization("groupforum.view.forums_list.status");
        }

        public var _Str_25944(get,never):Bool;
public function  get__Str_25944():Bool
        {
            return !(this._forumsListView == null);
        }

        public function _Str_25219(k:ForumsListData, _arg_2:ExtendedForumData, _arg_3:ThreadsListData)
        {
            this._Str_18232();
            this._forumsListData = k;
            this._forumData = _arg_2;
            this._threadsListData = _arg_3;
            this._messagesListData = null;
            this._numOfPages = this._Str_18295(this._threadsListData._Str_18760);
            this._currentPage = Std.int(Math.fceil((this._threadsListData.startIndex / ThreadsListData.PAGE_SIZE)));
            this._threadListView = new ThreadListView(this, this._listWindow, this._forumData, this._threadsListData);
            this._threadListView.update();
            this._listHeader.caption = this._controller.localizationManager.getLocalization("groupforum.view.all_threads");
            if (this._forumData._Str_23163)
            {
                this._postButton.enable();
                this._Str_11501("post_thread", null);
            }
            else
            {
                this._postButton.disable();
                this._Str_11501("post_thread", this._forumData._Str_22973);
            }
            var _local_4= GroupForumView._Str_14926(this._window, this._forumData);
            _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            _local_4.enable();
            this._Str_18407();
        }

        public function _Str_16120(k:GuildForumThread)
        {
            if (this._threadListView != null)
            {
                this._threadListView._Str_16935(k);
            }
        }

        public function _Str_25031(k:MessageData)
        {
            if (this._messageListView != null)
            {
                this._messageListView._Str_16935(k);
            }
        }

        public function _Str_24648(k:ForumsListData, _arg_2:ExtendedForumData, _arg_3:ThreadsListData, _arg_4:MessagesListData)
        {
            this._Str_18232();
            this._forumsListData = k;
            this._forumData = _arg_2;
            this._threadsListData = _arg_3;
            this._messagesListData = _arg_4;
            var _local_5= _arg_4.threadId;
            var _local_6:GuildForumThread = this._threadsListData._Str_6700[_local_5];
            this._numOfPages = this._Str_18295(_arg_4._Str_8598);
            var _local_7= _arg_4.startIndex;
            this._currentPage = Std.int(Math.fceil((_local_7 / ThreadsListData.PAGE_SIZE)));
            this._listHeader.caption = _local_6.header;
            this._messageListView = new MessageListView(this, this._listWindow, this._forumData, _local_6, _arg_4);
            this._messageListView.update();
            if (((this._controller._Str_20049() > 0) && (this._controller._Str_25071() == _local_5)))
            {
                this._messageListView._Str_23852(this._controller._Str_20049(), true);
                this._controller._Str_23416();
            }
            if (this._forumData._Str_20636)
            {
                if ((this._forumData._Str_7246 || (!_local_6.isLocked)))
                {
                    this._postButton.enable();
                    this._Str_11501("post_message", null);
                }
                else
                {
                    this._postButton.disable();
                    this._Str_11501("post_in_locked", this._forumData._Str_25440);
                }
            }
            else
            {
                this._postButton.disable();
                this._Str_11501("post_message", this._forumData._Str_23527);
            }
            var _local_8= GroupForumView._Str_14926(this._window, this._forumData);
            _local_8.removeEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            _local_8.enable();
            this._Str_18407();
        }

        public var controller(get,never):GroupForumController;
public function  get_controller():GroupForumController
        {
            return this._controller;
        }

        function _Str_18295(k:Int):Int
        {
            return Std.int(Math.fceil((k / this._pageSize)));
        }

        function _Str_25233()
        {
            var k= (this._currentPage - 1);
            if (k >= 0)
            {
                this._Str_14886(k);
            }
        }

        function _Str_25577()
        {
            var k= (this._currentPage + 1);
            if (k <= this._numOfPages)
            {
                this._Str_14886(k);
            }
        }

        function _Str_24217()
        {
            if (this._currentPage == 0)
            {
                return;
            }
            this._Str_14886(0);
        }

        function _Str_25297()
        {
            if (this._currentPage >= this._numOfPages)
            {
                return;
            }
            this._Str_14886((this._numOfPages - 1));
        }

        function _Str_14886(k:Int)
        {
            var _local_2= (k * this._pageSize);
            if (this._forumsListView != null)
            {
                this._controller._Str_12395(this._forumsListData._Str_5154, _local_2);
            }
            else
            {
                if (this._threadListView != null)
                {
                    this._controller.requestThreadList(this._forumData.groupId, _local_2);
                }
                else
                {
                    if (this._messageListView != null)
                    {
                        this._controller.requestThreadMessageList(this._forumData.groupId, this._messagesListData.threadId, _local_2);
                    }
                }
            }
            this._currentPage = k;
        }

        public function _Str_11823(k:Int):String
        {
            return FriendlyTime.format(this._controller.localizationManager, k, ".ago", 1);
        }

        function _Str_25680(k:WindowEvent=null)
        {
            if (this._forumsListView != null)
            {
                this._forumsListView._Str_11755();
            }
            if (this._threadListView != null)
            {
                this._threadListView._Str_11755();
            }
            if (this._messageListView != null)
            {
                this._messageListView._Str_18220();
            }
        }

        function _Str_6266(k:WindowMouseEvent)
        {
            switch (k.target.name)
            {
                case "back_button":
                    if (this._messageListView != null)
                    {
                        this._controller.requestThreadList(this._forumData.groupId, this._threadsListData.startIndex);
                    }
                    else
                    {
                        if (this._threadListView != null)
                        {
                            this._controller._Str_13365(true);
                            if (this._forumsListData != null)
                            {
                                this._controller._Str_12395(this._forumsListData._Str_5154, this._forumsListData.startIndex);
                            }
                            else
                            {
                                this.dispose();
                            }
                        }
                        else
                        {
                            if (this._forumsListView != null)
                            {
                                this._controller._Str_23963();
                                this.dispose();
                            }
                        }
                    }
                    return;
                case "show_previous":
                    this._Str_25233();
                    return;
                case "show_next":
                    this._Str_25577();
                    return;
                case "show_last":
                    this._Str_25297();
                    return;
                case "show_first":
                    this._Str_24217();
                    return;
                case "header_button_close":
                    this._window.visible = false;
                    this.dispose();
                    return;
                case "post_button":
                    this._Str_21538(((this._messagesListData != null) ? this._threadsListData._Str_6700[this._messagesListData.threadId] : null));
                    return;
            }
        }

        public function _Str_21538(k:GuildForumThread, _arg_2:MessageData=null)
        {
            if (this._controller._Str_10252 != null)
            {
                this._controller._Str_10252.focus(this._forumData, k, _arg_2);
            }
            else
            {
                this._controller._Str_10252 = new ComposeMessageView(this, (this._window.x + this._window.width), this._window.y, this._forumData, k, _arg_2);
            }
        }

        public function _window5()
        {
            if (this._controller._Str_11338 != null)
            {
                this._controller._Str_11338.focus(this._forumData);
            }
            else
            {
                this._controller._Str_11338 = new GroupForumViewController(this, (this._window.x + this._window.width), this._window.y, this._forumData);
            }
        }

        public function _Str_7256(k:Int)
        {
            if (k > 0)
            {
                this._myForumsLink.htmlText = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.shortcuts.my.unread", "", ["unread_count", k]);
            }
            else
            {
                this._myForumsLink.htmlText = this._controller.localizationManager.getLocalization("groupforum.view.shortcuts.my", "");
            }
        }
    }

