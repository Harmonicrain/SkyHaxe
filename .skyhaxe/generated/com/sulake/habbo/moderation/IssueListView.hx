package com.sulake.habbo.moderation
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

     class IssueListView 
    {
        var _issueManager:IssueManager;
        var _issueBrowser:IssueBrowser;
        var _list:IItemListWindow;
        var _listItem:IWindowContainer;
        var _userIcon:BitmapData;
        var _roomIcon:BitmapData;
        var _issueListLimit:Int = 200;

        public function new(k:IssueManager, _arg_2:IssueBrowser, _arg_3:IItemListWindow)
        {
            this._issueManager = k;
            this._issueBrowser = _arg_2;
            this._list = _arg_3;
            this._listItem = Std.downcast(_arg_3.getListItemAt(0) , IWindowContainer);
            _arg_3.removeListItems();
            this._issueListLimit = k.issueListLimit;
        }

        public function update(k:Array<ASAny>)
        {
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            var _local_6:IWindow = null;
            var _local_7:IssueBundle = null;
            var _local_9:IWindow = null;
            var _local_10:IssueMessageData = null;
            var _local_11:IBitmapWrapperWindow = null;
            var _local_12:String = null;
            var _local_13:BitmapDataAsset = null;
            var _local_14:BitmapData = null;
            if (this._list == null)
            {
                return;
            }
            if (((k == null) || (k.length == 0)))
            {
                this._list.destroyListItems();
                return;
            }
            ASCompat.ASArray.sortOn(k, ["highestPriority", "issueAgeInMilliseconds"], [ASCompat.ASArray.NUMERIC, ASCompat.ASArray.NUMERIC]);
            var _local_4= this._list.numListItems;
            var _local_5= k.length;
            if (_local_5 > this._issueListLimit)
            {
                _local_5 = this._issueListLimit;
            }
            if (_local_4 < _local_5)
            {
                _local_2 = 0;
                while (_local_2 < (_local_5 - _local_4))
                {
                    _local_3 = Std.downcast(this._listItem.clone() , IWindowContainer);
                    this._list.addListItem(_local_3);
                    _local_2++;
                }
            }
            else
            {
                if (_local_4 > _local_5)
                {
                    _local_2 = 0;
                    while (_local_2 < (_local_4 - _local_5))
                    {
                        _local_9 = this._list.removeListItemAt(0);
                        _local_9.dispose();
                        _local_2++;
                    }
                }
            }
            _local_2 = 1;
            var _local_8= flash.Lib.getTimer();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_7  = _tmp_;
                if (_local_2 > this._issueListLimit) break;
                if (((_local_7 == null) || (this._listItem == null)))
                {
                    return;
                }
                _local_3 = Std.downcast(this._list.getListItemAt((_local_2 - 1)) , IWindowContainer);
                if (_local_3 == null)
                {
                    return;
                }
                _local_3.width = this._list.width;
                _local_3.color = ((_local_2++ % 2 != 0) ? 0xFFB2E6FA : 0xFFFFFFFF);
                _local_6 = _local_3.findChildByName("score");
                if (_local_6 != null)
                {
                    _local_6.caption = Std.string(_local_7.highestPriority);
                }
                _local_10 = _local_7._Str_5216();
                if (_local_10 == null)
                {
                    return;
                }
                _local_6 = _local_3.findChildByName("source");
                if (_local_6 != null)
                {
                    _local_6.caption = IssueCategoryNames._Str_21676(_local_10.categoryId);
                }
                _local_6 = _local_3.findChildByName("category");
                if (_local_6 != null)
                {
                    _local_6.caption = IssueCategoryNames._Str_21569(_local_10._Str_7437);
                }
                _local_6 = _local_3.findChildByName("target_name");
                if (_local_6 != null)
                {
                    if (_local_10.reportedUserId != 0)
                    {
                        _local_6.caption = _local_10.reportedUserName;
                    }
                    else
                    {
                        _local_6.caption = "";
                    }
                }
                _local_11 = Std.downcast(_local_3.findChildByName("target_icon") , IBitmapWrapperWindow);
                if (_local_11 != null)
                {
                    _local_12 = ((_local_10.reportedUserId != 0) ? "user_icon_png" : "room_icon_png");
                    _local_13 = Std.downcast(this._issueBrowser.assets.getAssetByName(_local_12) , BitmapDataAsset);
                    if (((!(_local_13 == null)) && (!(ASCompat.dynamicAs(_local_13.content , BitmapData) == null))))
                    {
                        _local_14 = ASCompat.dynamicAs(_local_13.content , BitmapData);
                        if (_local_14 != null)
                        {
                            _local_11.bitmap = _local_14.clone();
                        }
                    }
                }
                _local_6 = _local_3.findChildByName("time");
                if (_local_6 != null)
                {
                    _local_6.caption = _local_7._Str_15885(_local_8);
                }
                _local_6 = _local_3.findChildByName("msgs");
                if (_local_6 != null)
                {
                    _local_6.caption = Std.string(_local_7._Str_23420());
                }
                _local_6 = _local_3.findChildByName("picker");
                if (_local_6 != null)
                {
                    _local_6.caption = _local_7._Str_25343;
                }
                _local_6 = _local_3.findChildByName("pick_button");
                if (_local_6 != null)
                {
                    _local_6.id = _local_7.id;
                    _local_6.removeEventListener(WindowMouseEvent.CLICK, this._Str_19129);
                    _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_19129);
                }
                _local_6 = _local_3.findChildByName("handle_button");
                if (_local_6 != null)
                {
                    _local_6.id = _local_7.id;
                    _local_6.removeEventListener(WindowMouseEvent.CLICK, this._Str_20641);
                    _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_20641);
                }
                _local_6 = _local_3.findChildByName("release_button");
                if (_local_6 != null)
                {
                    _local_6.id = _local_7.id;
                    _local_6.removeEventListener(WindowMouseEvent.CLICK, this._Str_15257);
                    _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_15257);
                }
            }
        }

        function _Str_19129(k:WindowMouseEvent)
        {
            if (this._issueManager == null)
            {
                return;
            }
            this._issueManager.pickBundle(k.window.id, "pick button");
        }

        function _Str_20641(k:WindowMouseEvent)
        {
            if (this._issueBrowser == null)
            {
                return;
            }
            this._issueManager.handleBundle(k.window.id);
        }

        function _Str_15257(k:WindowMouseEvent)
        {
            if (this._issueManager == null)
            {
                return;
            }
            this._issueManager.releaseBundle(k.window.id);
        }
    }


