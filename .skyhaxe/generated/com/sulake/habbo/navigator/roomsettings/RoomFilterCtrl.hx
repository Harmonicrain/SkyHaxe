package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.communication.messages.outgoing.roomsettings.GetCustomRoomFilterMessageComposer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.roomsettings.UpdateRoomFilterMessageComposer;
    import com.sulake.core.window.components.IRegionWindow;

     class RoomFilterCtrl implements IDisposable 
    {
        var _flatId:Int = 0;
        var _navigator:IHabboTransitionalNavigator;
        var _selectedRow:Int = -1;
        var _window:IWindowContainer;
        var _badWords:Array<ASAny>;
        var _badWordList:IItemListWindow;
        var _badWordField:ITextFieldWindow;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
            this._badWords = new Array<ASAny>();
        }

        public function startRoomFilterEdit(k:Int)
        {
            this._flatId = k;
            this._navigator.send(new GetCustomRoomFilterMessageComposer(this._flatId));
            this._Str_24741();
        }

        function _Str_24741()
        {
            if (this._navigator.data.enteredGuestRoom == null)
            {
                return;
            }
            this.prepareWindow();
            this._window.visible = true;
            this._window.invalidate();
            this._window.activate();
            this._navigator.tracking.trackEventLogOncePerSession("InterfaceExplorer", "open", "room.filter.seen");
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._navigator.getXmlWindow("iro_room_filter_framed"), IFrameWindow);
            this._window.findChildByName("badword_remove_btn").addEventListener(WindowMouseEvent.CLICK, this._Str_24328);
            this._window.findChildByName("badword_add_btn").addEventListener(WindowMouseEvent.CLICK, this._Str_24260);
            this._window.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onCloseButtonClick);
            this._badWordField = Std.downcast(this._window.findChildByName("roomfilter_addword_txt") , ITextFieldWindow);
            this._badWordList = cast(this._window.findChildByName("badwords_itemlist"), IItemListWindow);
            this._Str_20699();
            this._window.center();
        }

        public function _Str_9592(k:Array<ASAny>)
        {
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                if (this._badWords.indexOf(k[_local_2]) == -1)
                {
                    this._badWords.push(k[_local_2]);
                }
                _local_2++;
            }
            if (this._badWordList != null)
            {
                this._badWordList.removeListItems();
                this._Str_20699();
            }
        }

        function _Str_20699()
        {
            var _local_2:IWindowContainer = null;
            this._badWordList.autoArrangeItems = false;
            var k = 0;
            while (true)
            {
                _local_2 = cast(this._badWordList.getListItemAt(k), IWindowContainer);
                if (_local_2 == null)
                {
                    if (this._badWords[k] == null)
                    {
                        break;
                    }
                    _local_2 = this.getListEntry(k);
                    this._badWordList.addListItem(_local_2);
                }
                if (this._badWords[k] != null)
                {
                    _local_2.color = this.getBgColor(k, false);
                    this.refreshEntryDetails(_local_2, this._badWords[k]);
                    _local_2.visible = true;
                    _local_2.height = 20;
                }
                else
                {
                    _local_2.height = 0;
                    _local_2.visible = false;
                }
                k++;
            }
            this._badWordList.autoArrangeItems = true;
            this._badWordList.invalidate();
        }

        function refreshEntryDetails(k:IWindowContainer, _arg_2:String)
        {
            k.findChildByName("badword_txt").caption = _arg_2;
        }

        function onCloseButtonClick(k:WindowEvent)
        {
            this.disposeWindow();
        }

        function _Str_24260(k:WindowMouseEvent)
        {
            this.addBadWord(this._badWordField.text);
        }

        function addBadWord(k:String)
        {
            if (((!(this._badWordField == null)) && (this._badWordField.text.length > 0)))
            {
                this._navigator.send(new UpdateRoomFilterMessageComposer(this._flatId, UpdateRoomFilterMessageComposer._Str_16408, k));
                this._navigator.send(new GetCustomRoomFilterMessageComposer(this._flatId));
                this._badWordField.text = "bobba";
            }
        }

        function _Str_24328(k:WindowMouseEvent)
        {
            if (this._selectedRow < 0)
            {
                return;
            }
            var _local_2= cast(this._badWordList.getListItemAt(this._selectedRow), IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.findChildByName("badword_txt").caption;
            _local_2.height = 0;
            _local_2.visible = false;
            _local_2 = null;
            if (this._badWords.indexOf(_local_3) >= 0)
            {
                this._badWords.splice(this._badWords.indexOf(_local_3), 1);
            }
            this._navigator.send(new UpdateRoomFilterMessageComposer(this._flatId, UpdateRoomFilterMessageComposer._Str_16962, _local_3));
        }

        function _Str_17449(k:IItemListWindow)
        {
            var _local_3:IWindowContainer = null;
            var _local_2 = 0;
            while (_local_2 < this._badWords.length)
            {
                _local_3 = cast(k.getListItemAt(_local_2), IWindowContainer);
                _local_3.color = this.getBgColor(_local_2, false);
                _local_2++;
            }
        }

        function getListEntry(k:Int):IWindowContainer
        {
            if (this._navigator == null)
            {
                return null;
            }
            var _local_2= cast(this._navigator.getXmlWindow("ros_badword"), IWindowContainer);
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= cast(_local_2.findChildByName("bg_region"), IRegionWindow);
            _local_3.addEventListener(WindowMouseEvent.CLICK, this.onBgMouseClick);
            _local_3.addEventListener(WindowMouseEvent.OVER, this._Str_18088);
            _local_3.addEventListener(WindowMouseEvent.OUT, this._Str_17027);
            _local_2.id = k;
            return _local_2;
        }

        function getBgColor(k:Int, _arg_2:Bool):UInt
        {
            if (k == this._selectedRow)
            {
                return 0xFF9AB8D9;
            }
            return _arg_2 ? 0xFFB6D9FF : (((k % 2) != 0) ? 0xFFFFFFFF : 0xFFE9E9E1);
        }

        function onBgMouseClick(k:WindowEvent)
        {
            this._selectedRow = k.target.parent.id;
            this._Str_17449(Std.downcast(k.target.findParentByName("badwords_itemlist") , IItemListWindow));
        }

        function _Str_18088(k:WindowEvent)
        {
            var _local_2= cast(k.target.parent, IWindowContainer);
            _local_2.color = this.getBgColor(-1, true);
        }

        function _Str_17027(k:WindowEvent)
        {
            var _local_2= cast(k.target.parent, IWindowContainer);
            _local_2.color = this.getBgColor(_local_2.id, false);
        }

        public function close()
        {
            this._flatId = 0;
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function disposeWindow()
        {
            if (this._window != null)
            {
                this._window.visible = false;
                this._window.dispose();
                this._window = null;
            }
            if (this._badWordList != null)
            {
                this._badWordList.removeListItems();
                this._badWordList.dispose();
                this._badWordList = null;
            }
            if (this._badWordField != null)
            {
                this._badWordField.dispose();
                this._badWordField = null;
            }
            if (this._badWords != null)
            {
                this._badWords.resize(0);
            }
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this.disposeWindow();
            this._navigator = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._navigator == null;
        }
    }

