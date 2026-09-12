package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.parser.groupforums.ExtendedForumData;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThread;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.parser.groupforums.MessageData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;

     class MessageListView 
    {
        static inline final _Str_13580= -1;
        static inline final _Str_13727= 20;
        public static final _Str_16051:compat.RegExp = new compat.RegExp("\\\\?(?:(?:\\*([^*]+)\\*)|(?:_([^_]+)_)|(?:@\\S+))");
        public static final _Str_13696:compat.RegExp = new compat.RegExp("^>(?: ?|$)");
        static inline final _Str_16110:UInt = 0xFFCCCCCC;

        var _controller:GroupForumController;
        var _mainView:GroupForumView;
        var _list:IScrollableListWindow;
        var _listItem:IWindowContainer;
        var _forumData:ExtendedForumData;
        var _threadData:GuildForumThread;
        var _messagesListData:MessagesListData;
        var _adding:Bool = true;

        public function new(k:GroupForumView, _arg_2:IScrollableListWindow, _arg_3:ExtendedForumData, _arg_4:GuildForumThread, _arg_5:MessagesListData)
        {
            this._mainView = k;
            this._controller = this._mainView.controller;
            this._list = _arg_2;
            this._listItem = Std.downcast(this._controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboFriendBarCom.groupforum_message_list_item_xml, []))) , IWindowContainer);
            this._forumData = _arg_3;
            this._threadData = _arg_4;
            this._messagesListData = _arg_5;
        }

        static function _Str_26463(k:Int):Array<ASAny>
        {
            switch (k)
            {
                case ForumModerationState._Str_5466:
                    return [4293519840, 4292335567];
                case ForumModerationState._Str_4415:
                    return [0xFFFFC6BA, 0xFFFFDFD2];
                case _Str_13580:
                    return [0xFFFFF4D9, 4291227641];
                default:
                    return [0xFFFFFFFF, 4291227641];
            }
        }

        static function _Str_19323(k:ITextWindow, _arg_2:String)
        {
            var _local_7:String = null;
            var _local_8 = 0;
            var _local_9:ASAny = null;
            var _local_3= cast(k.parent, IWindowContainer);
            _local_3.removeChild(k);
            var _local_4:Array<ASAny> = (cast _arg_2.split("\r"));
            var _local_5= new StringBuffer();
            var _local_6 = 0;
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_7  = _tmp_;
                _local_8 = 0;
                _local_9 = _Str_13696.exec(_local_7);
                if (_local_9 != null)
                {
                    _local_8 = 1;
                    _local_7 = _local_7.substr(ASCompat.toInt(_local_9[0].length));
                }
                if (_local_8 != _local_6)
                {
                    _Str_13482(_local_3, k, _local_5, _local_6);
                    _local_6 = _local_8;
                }
                else
                {
                    if (_local_5.length > 0)
                    {
                        _local_5.add("\r");
                    }
                }
                _Str_8248(_local_5, _local_7);
            }
            _Str_13482(_local_3, k, _local_5, _local_6);
        }

        static function _Str_8248(k:StringBuffer, _arg_2:String)
        {
            var _local_3:ASAny = null;
            var _local_4 = Math.NaN;
            var _local_5:String = null;

            while (true)
            {
                _local_3 = _Str_16051.exec(_arg_2);
                if (!_local_3)
                {
                    break;
                }
                if (_local_3.index > 0)
                {
                    k._Str_15932(_arg_2.substr(0, ASCompat.toInt(_local_3.index)));
                }
                _local_4 = ASCompat.toNumber(_local_3[0].length);
                switch (_arg_2.charAt(ASCompat.toInt(_local_3.index)))
                {
                    case "*":
                        k.add(" <b>");
                        _Str_8248(k, _arg_2.substr(ASCompat.toInt(_local_3.index + 1), Std.int(_local_4 - 2)));
                        k.add("</b> ");
                        
                    case "_":
                        k.add(" <i>");
                        _Str_8248(k, _arg_2.substr(ASCompat.toInt(_local_3.index + 1), Std.int(_local_4 - 2)));
                        k.add("</i> ");
                        
                    case "@":
                        if (((_local_3.index == 0) || ((_local_3.index > 0) && (_arg_2.substr(ASCompat.toInt(ASCompat.toNumber(_local_3.index) - 1), 1) == " "))))
                        {
                            _local_5 = _arg_2.substr(ASCompat.toInt(_local_3.index + 1), Std.int(_local_4 - 1));
                            k.add("<u>")._Str_15932(_local_5).add("</u>");
                        }
 else {                        k.add("@");
}                    default:
                        k.add(_arg_2.charAt(ASCompat.toInt(_local_3.index + 1)));
                        _arg_2 = _arg_2.substr(ASCompat.toInt(_local_3.index + 2));
                        continue;
                }
                _arg_2 = _arg_2.substr(ASCompat.toInt(_local_3.index + _local_4));
            }
            k._Str_15932(_arg_2);
        }

        static function _Str_13482(k:IWindowContainer, _arg_2:ITextWindow, _arg_3:StringBuffer, _arg_4:Int)
        {
            var _local_5= _arg_3.toString();
            var _local_6= cast(_arg_2.clone(), ITextWindow);
            k.addChild(_local_6);
            _local_6.htmlText = _local_5;
            if (_arg_4 > 0)
            {
                _local_6.x = (_local_6.x + (_arg_4 * _Str_13727));
                _local_6.width = (_local_6.width - ((_arg_4 + 1) * _Str_13727));
                _local_6.color = _Str_16110;
                _local_6.background = true;
            }
            _arg_3.reset();
        }


        public function update()
        {
            var _local_2:MessageData = null;
            var _local_3 = false;
            if (this._list.numListItems > 0)
            {
                this._list.destroyListItems();
            }
            this._list.invalidate();
            var k= this._controller._Str_16072(this._messagesListData.threadId);
            this._adding = true;
            this._list.autoArrangeItems = false;
            final _iter_ = this._messagesListData.messages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = (_local_2.messageIndex > k);
                this._list.addListItem(this._Str_6850(_local_2, _local_3));
            }
            this._adding = false;
            this._Str_18220();
        }

        public function _Str_18220()
        {
            if (this._adding)
            {
                return;
            }
            var k:Float = this._list.scrollableWindow.width;
            this._Str_19591();
            if (this._list.scrollableWindow.width != k)
            {
                this._Str_19591();
            }
        }

        function _Str_19591()
        {
            var _local_2:IWindowContainer = null;
            var _local_3:IWindowContainer = null;
            var _local_4:IWindowContainer = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:ITextWindow = null;
            this._list.autoArrangeItems = false;
            var k = 0;
            while (k < this._list.numListItems)
            {
                _local_2 = cast(this._list.getListItemAt(k), IWindowContainer);
                _local_3 = Std.downcast(_local_2.findChildByName("texts_container") , IWindowContainer);
                _local_4 = cast(_local_2.findChildByName("message_text_container"), IWindowContainer);
                _local_2.width = (this._list.scrollableWindow.width - 2);
                _local_5 = 2;
                _local_6 = 0;
                while (_local_6 < _local_4.numChildren)
                {
                    _local_7 = cast(_local_4.getChildAt(_local_6), ITextWindow);
                    _local_7.y = _local_5;
                    _local_5 = _local_7.bottom;
                    _local_6++;
                }
                _local_4.height = _local_5;
                _local_2.height = (_local_3.height + _local_4.bottom);
                k++;
            }
            this._list.autoArrangeItems = true;
        }

        function _Str_6850(k:MessageData, _arg_2:Bool=false):IWindowContainer
        {
            var _local_3= Std.downcast(this._listItem.clone() , IWindowContainer);
            _local_3.name = ("message_" + Std.string(k.messageId));
            var _local_4= k.state;
            var _local_5= this._forumData._Str_7246;
            var _local_6= this._forumData._Str_7449;
            var _local_7= Std.downcast(_local_3.findChildByName("texts_container") , IWindowContainer);
            _local_7.id = k.messageId;
            _local_7.findChildByName("date").caption = this._mainView._Str_11823(k._Str_6238);
            _local_7.findChildByName("reply_num").caption = ("#" + Std.string(k.messageIndex + 1));
            var _local_8= Std.downcast(_local_3.findChildByName("message_text") , ITextWindow);
            if (_arg_2)
            {
                _local_4 = _Str_13580;
            }
            if (((_local_4 == ForumModerationState._Str_4415) && (!_local_6)))
            {
                _local_8.text = this._Str_13405(k);
            }
            else
            {
                if (((_local_4 > ForumModerationState._Str_6076) && (!_local_5)))
                {
                    _local_8.text = this._Str_13405(k);
                }
                else
                {
                    _Str_19323(_local_8, k.messageText);
                }
            }
            var _local_9= Std.downcast(_local_3.findChildByName("msg_container") , IWindowContainer);
            var _local_10= _Str_26463(_local_4);
            _local_9.color = ASCompat.toUInt(_local_10[0]);
            var _local_11= Std.downcast(_local_3.findChildByName("avatar_image") , IWindowContainer);
            var _local_12= _Str_26463(_local_4);
            _local_11.color = ASCompat.toUInt(_local_12[1]);
            _local_11.id = k._Str_18036;
            _local_11.removeEventListener(WindowMouseEvent.CLICK, this._Str_19785);
            _local_11.addEventListener(WindowMouseEvent.CLICK, this._Str_19785);
            cast(cast(_local_11.findChildByName("avatar_widget"), IWidgetWindow).widget, IAvatarImageWidget).figure = k._Str_18957;
            _local_11.findChildByName("author").caption = k._Str_6415;
            _local_11.findChildByName("author_post_count").caption = ((Std.string(k._Str_17584) + " ") + this._controller.localizationManager.getLocalization("messageboard.messages", "posts"));
            this._Str_15972(_local_3, k, _local_4);
            return _local_3;
        }

        public function _Str_16935(k:MessageData)
        {
            var _local_2= k.messageId;
            var _local_3= Std.downcast(this._list.getListItemByName(("message_" + Std.string(_local_2))) , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= this._list.getListItemIndex(_local_3);
            this._adding = true;
            this._list.autoArrangeItems = false;
            this._list.removeListItemAt(_local_4);
            this._list.addListItemAt(this._Str_6850(k), _local_4);
            this._adding = false;
            this._Str_18220();
        }

        function _Str_15972(k:IWindowContainer, _arg_2:MessageData, _arg_3:Int)
        {
            var _local_4:IRegionWindow = null;
            var _local_9:IStaticBitmapWrapperWindow = null;
            var _local_5= this._forumData._Str_7246;
            var _local_6= this._forumData._Str_7449;
            var _local_7= this._forumData._Str_21331;
            var _local_8= this._forumData._Str_20636;
            _local_4 = Std.downcast(k.findChildByName("delete_message") , IRegionWindow);
            _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_10493);
            _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_7727);
            if (_local_5)
            {
                _local_4.id = _arg_2.messageId;
                _local_9 = Std.downcast(_local_4.getChildByName("icon") , IStaticBitmapWrapperWindow);
                switch (_arg_3)
                {
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
                        
                    default:
                        _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_10493);
                        _local_9.assetUri = "forum_forum_hide";
                }
            }
            else
            {
                _local_4.visible = false;
            }
            _local_4 = Std.downcast(k.findChildByName("report_message") , IRegionWindow);
            if (_local_7)
            {
                _local_4.id = _arg_2.messageId;
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_9877);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_9877);
            }
            else
            {
                _local_4.visible = false;
            }
            _local_4 = Std.downcast(k.findChildByName("reply_message") , IRegionWindow);
            if (_local_8)
            {
                _local_4.id = _arg_2.messageId;
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_20759);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_20759);
            }
            else
            {
                _local_4.visible = false;
            }
        }

        function _Str_13405(k:MessageData):String
        {
            switch (k.state)
            {
                case ForumModerationState._Str_5466:
                    return this._controller.localizationManager.getLocalizationWithParams("groupforum.view.message_hidden_by_admin", "", ["admin_name", k._Str_6110]);
                case ForumModerationState._Str_4415:
                    return this._controller.localizationManager.getLocalizationWithParams("groupforum.view.message_hidden_by_staff", "", ["admin_name", k._Str_6110]);
                default:
                    return null;
            }
        }

        public function _Str_23852(k:Int, _arg_2:Bool=false)
        {
            var _local_3:IWindowContainer = null;
            if (!_arg_2)
            {
                _local_3 = Std.downcast(this._list.getListItemByName(("message_" + Std.string(k))) , IWindowContainer);
            }
            else
            {
                _local_3 = Std.downcast(this._list.getListItemAt((k - 1)) , IWindowContainer);
            }
            if (_local_3 != null)
            {
                this._list.scrollV = (_local_3.bottom / this._list.maxScrollV);
            }
        }

        function _Str_9877(k:WindowMouseEvent)
        {
            this._controller.reportMessage(this._forumData, this._threadData.threadId, k.target.id);
        }

        function _Str_7727(k:WindowMouseEvent)
        {
            this._controller.unDeleteMessage(this._forumData, this._threadData.threadId, k.target.id);
        }

        function _Str_10493(k:WindowMouseEvent)
        {
            this._controller.deleteMessage(this._forumData, this._threadData.threadId, k.target.id);
        }

        function _Str_19785(k:WindowMouseEvent)
        {
            this._controller._Str_23450(k.target.id);
        }

        function _Str_20759(k:WindowMouseEvent)
        {
            var _local_2= k.target.id;
            var _local_3:MessageData = this._messagesListData._Str_22993[_local_2];
            if (_local_3 == null)
            {
                return;
            }
            this._mainView._Str_21538(this._threadData, _local_3);
        }
    }

