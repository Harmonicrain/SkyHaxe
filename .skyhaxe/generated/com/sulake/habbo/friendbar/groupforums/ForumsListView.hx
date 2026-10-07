package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.parser.groupforums.ForumData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.window._enum._Str_4387;

     class ForumsListView 
    {
        var _controller:GroupForumController;
        var _mainView:GroupForumView;
        var _list:IScrollableListWindow;
        var _listItem:IWindowContainer;
        var _forums:Array<ASAny>;

        public function new(k:GroupForumView, _arg_2:IScrollableListWindow, _arg_3:Array<ASAny>)
        {
            this._mainView = k;
            this._controller = this._mainView.controller;
            this._list = _arg_2;
            this._listItem = Std.downcast(this._controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboFriendBarCom.groupforum_forum_list_item_xml, []))) , IWindowContainer);
            this._forums = _arg_3;
        }

        public function update()
        {
            var k = 0;
            var _local_2:IWindowContainer = null;
            var _local_3:ForumData = null;
            this._list.invalidate();
            k = 0;
            while (k < this._forums.length)
            {
                _local_3 = this._forums[k];
                _local_2 = Std.downcast(this._listItem.clone() , IWindowContainer);
                _local_2.name = ("forum_" + Std.string(_local_3.groupId));
                this._Str_10311(_local_2, _local_3, k);
                this._list.addListItem(_local_2);
                k++;
            }
            this._Str_11755();
        }

        function _Str_10311(k:IWindowContainer, _arg_2:ForumData, _arg_3:Int)
        {
            var _local_4= k ;
            _local_4.color = (((_arg_3 + 1) % 2 != 0) ? 0xFFEEFEFF : 0xFFB2E6FA);
            var _local_5= _arg_2._Str_18237;
            var _local_6= _local_4.findChildByName("texts_container");
            _local_6.id = _arg_2.groupId;
            var _local_7= Std.downcast(_local_4.findChildByName("header") , ITextWindow);
            _local_7.bold = (_local_5 > 0);
            _local_7.text = _arg_2.name;
            _local_6 = _local_4.findChildByName("header_region");
            _local_6.id = _arg_2.groupId;
            _local_6.removeEventListener(WindowMouseEvent.CLICK, this._Str_13188);
            _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_13188);
            _local_6 = _local_4.findChildByName("details");
            _local_6.caption = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.forum_details", "", ["rating", _arg_2._Str_25067, "last_author_id", _arg_2._Str_8317, "last_author_name", _arg_2._Str_9601, "update_time", this._mainView._Str_11823(_arg_2._Str_8950)]);
            _local_6 = _local_4.findChildByName("unread_texts_container");
            _local_6.id = _arg_2.groupId;
            _local_6 = _local_4.findChildByName("unread_region");
            _local_6.id = _arg_2.groupId;
            _local_6.removeEventListener(WindowMouseEvent.CLICK, this._Str_13188);
            _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_13188);
            _local_7 = Std.downcast(_local_4.findChildByName("messages1") , ITextWindow);
            _local_7.bold = (_local_5 > 0);
            _local_7.text = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_details1", "", ["total_messages", _arg_2._Str_8598, "new_messages", _local_5]);
            _local_7 = Std.downcast(_local_4.findChildByName("messages2") , ITextWindow);
            _local_7.bold = (_local_5 > 0);
            _local_7.text = this._controller.localizationManager.getLocalizationWithParams("groupforum.view.thread_details2", "", ["total_messages", _arg_2._Str_8598, "new_messages", _local_5]);
            var _local_8= cast(_local_4.findChildByName("group_icon"), IWidgetWindow);
            var _local_9= Std.downcast(_local_8.widget , IBadgeImageWidget);
            _local_9.badgeId = _arg_2.icon;
            _local_9.groupId = _arg_2.groupId;
            _local_9.type = _Str_4387.GROUP;
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

        function _Str_13188(k:WindowMouseEvent)
        {
            this._controller.openGroupForum(k.target.id);
        }
    }




