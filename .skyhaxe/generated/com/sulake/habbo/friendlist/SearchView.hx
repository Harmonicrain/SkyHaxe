package com.sulake.habbo.friendlist
;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.friendlist.HabboSearchResultData;
    import com.sulake.habbo.utils._Str_3521;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import flash.ui.Keyboard;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.HabboSearchMessageComposer;
    import com.sulake.core.window.events.*;

     class SearchView implements _Str_6180 implements  _Str_7814 
    {
        var _friendList:HabboFriendList;
        var _searchStr:ITextFieldWindow;
        var _list:IItemListWindow;


        public function init(k:HabboFriendList)
        {
            this._friendList = k;
        }

        public function _Str_14366():Int
        {
            if (this._friendList.searchResults.friends == null)
            {
                return 0;
            }
            return this._friendList.searchResults.friends.length + this._friendList.searchResults.others.length;
        }

        public function _Str_13719(k:IItemListWindow)
        {
            this._list = k;
        }

        public function _Str_15797(k:IWindowContainer)
        {
            this._searchStr = cast(k.findChildByName("search_str"), ITextFieldWindow);
            this._searchStr.procedure = this._Str_24321;
            this._searchStr.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this._Str_23556);
            k.findChildByName("search_but").procedure = this._Str_17805;
            this._friendList.refreshButton(k, "search", true, null, 0);
        }

        public function _Str_14179(k:Int)
        {
        }

        public function _Str_3836()
        {
            var _local_3 = false;
            var _local_4:HabboSearchResultData = null;
            var _local_5:HabboSearchResultData = null;
            var _local_6 = false;
            this._list.autoArrangeItems = false;
            var k= this._friendList.searchResults;
            var _local_2 = 0;
            while (true)
            {
                _local_3 = this._friendList._Str_21131();
                if (_local_2 == 0)
                {
                    this.refreshEntry(true, _local_2, null, null, this._Str_22898(), false, false, 0);
                }
                else
                {
                    if (_local_2 <= k.friends.length)
                    {
                        _local_4 = k.friends[(_local_2 - 1)];
                        this.refreshEntry(true, _local_2, _local_4._Str_17102, _local_4._Str_8751, null, (_local_4._Str_25717 || _local_3), false, _local_4.avatarId);
                    }
                    else
                    {
                        if (_local_2 == (k.friends.length + 1))
                        {
                            this.refreshEntry(true, _local_2, null, null, this._Str_25692(), false, false, 0);
                        }
                        else
                        {
                            if (_local_2 <= ((k.friends.length + k.others.length) + 1))
                            {
                                _local_5 = k.others[((_local_2 - 2) - k.friends.length)];
                                this.refreshEntry(true, _local_2, _local_5._Str_17102, _local_5._Str_8751, null, false, ((!(_local_5.avatarId == this._friendList.avatarId)) && (!this._friendList.searchResults.isRequestFriend(_local_5.avatarId))), _local_5.avatarId);
                            }
                            else
                            {
                                _local_6 = this.refreshEntry(false, _local_2, null, null, null, false, false, 0);
                                if (_local_6)
                                {
                                    break;
                                }
                            }
                        }
                    }
                }
                _local_2++;
            }
            this._Str_6988();
            this._list.autoArrangeItems = true;
        }

        function _Str_6988()
        {
            var k = 0;
            while (k < this._list.numListItems)
            {
                this._list.getListItemAt(k).color = this._friendList._Str_4930._Str_9273(_Str_2777._Str_5722, ((k % 2) == 1));
                k++;
            }
        }

        public function _Str_24265(k:String)
        {
            this._searchStr.text = k;
        }

        public function focus()
        {
            this._searchStr.focus();
        }

        function _Str_22898():String
        {
            if (this._friendList.searchResults.friends.length == 0)
            {
                return "${friendlist.search.nofriendsfound}";
            }
            this._friendList.registerParameter("friendlist.search.friendscaption", "cnt", ("" + Std.string(this._friendList.searchResults.friends.length)));
            return "${friendlist.search.friendscaption}";
        }

        function _Str_25692():String
        {
            if (this._friendList.searchResults.others.length == 0)
            {
                return "${friendlist.search.noothersfound}";
            }
            this._friendList.registerParameter("friendlist.search.otherscaption", "cnt", ("" + Std.string(this._friendList.searchResults.others.length)));
            return "${friendlist.search.otherscaption}";
        }

        function refreshEntry(k:Bool, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Bool, _arg_7:Bool, _arg_8:Int):Bool
        {
            var _local_9= Std.downcast(this._list.getListItemAt(_arg_2) , IWindowContainer);
            if (_local_9 == null)
            {
                if (!k)
                {
                    return true;
                }
                _local_9 = cast(this._friendList.getXmlWindow("search_entry"), IWindowContainer);
                _local_9.findChildByName("bg_region").procedure = this._Str_23827;
                this._list.addListItem(_local_9);
            }
            if (k)
            {
                _local_9.height = 20;
                _local_9.visible = true;
            }
            else
            {
                _local_9.height = 0;
                _local_9.visible = false;
            }
            _local_9.id = _arg_8;
            _local_9.findChildByName("bg_region").id = _arg_8;
            this._Str_16823(_local_9, _arg_3, (_arg_8 < 0));
            this._friendList._Str_6498(_local_9, "name", (!(_arg_4 == null)), _arg_4);
            this._friendList._Str_6498(_local_9, "caption", (!(_arg_5 == null)), _arg_5);
            this._friendList.refreshButton(_local_9, "start_chat", _arg_6, this._Str_18658, _arg_8);
            this._friendList.refreshButton(_local_9, "ask_for_friend", _arg_7, this._Str_25796, _arg_8);
            _Str_3521._Str_3927(false, _local_9);
            _local_9.findChildByName("user_info_region").visible = (_arg_8 > 0);
            return false;
        }

        function _Str_16823(k:IWindowContainer, _arg_2:String, _arg_3:Bool=false)
        {
            var _local_4= Std.downcast(k.getChildByName(HabboFriendList.FACE) , IBitmapWrapperWindow);
            if (((_arg_2 == null) || (_arg_2 == "")))
            {
                _local_4.visible = false;
            }
            else
            {
                if (_arg_3)
                {
                    _local_4.bitmap = this._friendList._Str_17617(_arg_2);
                }
                else
                {
                    _local_4.bitmap = this._friendList.getAvatarFaceBitmap(_arg_2);
                }
                _local_4.width = _local_4.bitmap.width;
                _local_4.height = _local_4.bitmap.height;
                _local_4.visible = true;
            }
        }

        function _Str_23827(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2.id < 1)
            {
                return;
            }
            this._friendList.view.showInfo(k, "${infostand.profile.link.tooltip}");
            if (k.type == WindowMouseEvent.OVER)
            {
                _Str_3521._Str_3927(true, cast(_arg_2.parent, IWindowContainer));
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    _Str_3521._Str_3927(false, cast(_arg_2.parent, IWindowContainer));
                }
                else
                {
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        this._friendList.trackGoogle("extendedProfile", "friendList_friendsSearch");
                        this._friendList.send(new GetExtendedProfileMessageComposer(_arg_2.id));
                    }
                }
            }
        }

        function _Str_17805(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.search}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log([("Search clicked: " + _arg_2.name)]);
            this._Str_21962();
        }

        function _Str_25796(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.addfriend}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log([("Ask for friend clicked: " + Std.string(_arg_2.id))]);
            var _local_3= this._friendList.searchResults._Str_21135(_arg_2.id);
            if (_local_3 == null)
            {
                Logger.log([("No search result found with id: " + Std.string(_arg_2.id))]);
                return;
            }
            Logger.log([("Search result found: " + _local_3._Str_8751)]);
            var _local_4= this._friendList.askForAFriend(_local_3.avatarId, _local_3._Str_8751);
            if (!_local_4)
            {
                this._friendList._Str_18624();
            }
            else
            {
                this._friendList._Str_23469(_local_3._Str_8751);
                this.refreshEntry(true, this._Str_22578(_local_3.avatarId), _local_3._Str_17102, _local_3._Str_8751, null, false, false, _local_3.avatarId);
            }
        }

        function _Str_22578(k:Int):Int
        {
            var _local_2 = 0;
            while (_local_2 < this._list.numListItems)
            {
                if (this._list.getListItemAt(_local_2).id == k)
                {
                    return _local_2;
                }
                _local_2++;
            }
            return -1;
        }

        function _Str_18658(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.im}");
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= this._friendList.searchResults._Str_21135(_arg_2.id);
            if (_local_3 == null)
            {
                Logger.log([("No search result found with id: " + Std.string(_arg_2.id))]);
                return;
            }
            this._friendList.messenger.startConversation(_local_3.avatarId);
        }

        function _Str_24321(k:WindowEvent, _arg_2:IWindow)
        {
            this._friendList.view.showInfo(k, "${friendlist.tip.searchstr}");
        }

        function _Str_23556(k:WindowKeyboardEvent)
        {
            var _local_3:Keyboard = null;
            var _local_4 = 0;
            var _local_5:String = null;
            var _local_2= k.target;
            Logger.log([((((("Test key event " + k) + ", ") + k.type) + " ") + _local_2.name)]);
            if (k.charCode == Keyboard.ENTER)
            {
                this._Str_21962();
            }
            else
            {
                _local_4 = 25;
                _local_5 = this._searchStr.text;
                if (_local_5.length > _local_4)
                {
                    this._searchStr.text = _local_5.substring(0, _local_4);
                }
            }
        }

        function _Str_21962()
        {
            var k= this._searchStr.text;
            Logger.log([("Search avatar: " + k)]);
            if (k == "")
            {
                Logger.log(["No text..."]);
                return;
            }
            this._friendList.send(new HabboSearchMessageComposer(k));
        }
public function new(){}
    }



