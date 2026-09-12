package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.help.cfh.registry.instantmessage.InstantMessageRegistryItem;
    import com.sulake.habbo.help.cfh.registry.chat.ChatRegistryItem;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class ChatReportController implements IDisposable 
    {
        static inline final _Str_9415:UInt = 0xFF3CB8FF;
        static inline final _Str_6492:UInt = 0xFFEEEEEE;

        var _habboHelp:HabboHelp;
        var _window:IWindowContainer;
        var _submitFunction:ASFunction;
        var _reportedRoomId:Int = 0;
        var _reportedUserId:Int = 0;
        var _disposed:Bool = false;

        public function new(k:HabboHelp, _arg_2:ASFunction)
        {
            this._habboHelp = k;
            this._submitFunction = _arg_2;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_3469(get,never):Int;
public function  get__Str_3469():Int
        {
            return this._reportedRoomId;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.closeWindow();
                this._habboHelp = null;
                this._disposed = true;
            }
        }

        public function show(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._window = Std.downcast(this._habboHelp.getXmlWindow("chat_report") , IWindowContainer);
            this._window.procedure = this._submitFunction;
            this._window.center();
            this._reportedUserId = _arg_2;
            this._reportedRoomId = -1;
            if (_arg_3 == HabboHelp.REPORT_TYPE_IM)
            {
                this._Str_25143();
                this._Str_25723(k, _arg_2);
            }
            else
            {
                this._Str_14598();
                this._Str_23828(k, _arg_2);
            }
        }

        public function closeWindow()
        {
            if (((this._habboHelp != null) && (this._habboHelp.chatRegistry != null)))
            {
                this._habboHelp.chatRegistry._Str_7724 = false;
            }
            if (((this._habboHelp != null) && (this._habboHelp.instantMessageRegistry != null)))
            {
                this._habboHelp.instantMessageRegistry._Str_7724 = false;
            }
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
        }

        public function collectSelectedEntries(k:Int, _arg_2:Int):Array<ASAny>
        {
            var _local_4 = 0;
            var _local_5:Vector<InstantMessageRegistryItem> = null;
            var _local_6:InstantMessageRegistryItem = null;
            var _local_7:ChatRegistryItem = null;
            var _local_3= new Array<ASAny>();
            if (k == HabboHelp.REPORT_TYPE_IM)
            {
                _local_4 = ((_arg_2 > 0) ? _arg_2 : this._reportedUserId);
                _local_5 = this._habboHelp.instantMessageRegistry.getItemsByUser(_local_4);
                if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                {
_local_6  = _tmp_;
                    if (_local_6.selected)
                    {
                        if (_local_6.userId < 0)
                        {
                            _local_3.push(ASCompat.toNumber(_local_6.userName.split(":")[0]));
                            _local_3.push(_local_6.text);
                        }
                        else
                        {
                            _local_3.push(_local_6.userId);
                            _local_3.push(_local_6.text);
                        }
                    }
                }
            }
            else
            {
                final _iter_ = this._habboHelp.chatRegistry._Str_6828(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7  = _tmp_;
                    if (_local_7.selected)
                    {
                        _local_3.push(_local_7.userId);
                        _local_3.push(_local_7.text);
                    }
                }
            }
            return _local_3;
        }

        function _Str_25723(k:Int, _arg_2:Int)
        {
            var _local_9:InstantMessageRegistryItem = null;
            var _local_10:IWindowContainer = null;
            var _local_11:ITextWindow = null;
            var _local_3= Std.downcast(this._window.findChildByName("room_items") , IItemListWindow);
            var _local_4= Std.downcast(_local_3.getListItemAt(0) , IWindowContainer);
            var _local_5= Std.downcast(this._habboHelp.getXmlWindow("chat_report_item") , IWindowContainer);
            _local_3.removeListItems();
            var _local_6= Std.downcast(_local_4.clone() , IWindowContainer);
            _local_3.addListItemAt(_local_6, 0);
            var _local_7= Std.downcast(_local_6.findChildByName("chat_items") , IItemListWindow);
            _local_7.removeListItems();
            this._habboHelp.instantMessageRegistry._Str_7724 = true;
            var _local_8= this._habboHelp.instantMessageRegistry.getItemsByUser(_arg_2);
            if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
            {
_local_9  = _tmp_;
                _local_10 = Std.downcast(_local_5.clone() , IWindowContainer);
                _local_11 = Std.downcast(_local_10.getChildByName("text") , ITextWindow);
                if (_local_9.userId < 0)
                {
                    _local_11.caption = ((_local_9.userName.split(":")[1] + ": ") + _local_9.text);
                }
                else
                {
                    _local_11.caption = ((_local_9.userName + ": ") + _local_9.text);
                }
                _local_10.id = _local_9.index;
                _local_10.procedure = this._Str_17227;
                _local_10.color = _Str_6492;
                _local_7.addListItem(_local_10);
            }
        }

        function _Str_23828(k:Int, _arg_2:Int)
        {
            var _local_6 = 0;
            var _local_7:IWindowContainer = null;
            var _local_8:IItemListWindow = null;
            var _local_10:ChatRegistryItem = null;
            var _local_11:IWindowContainer = null;
            var _local_12:ITextWindow = null;
            var _local_3= Std.downcast(this._window.findChildByName("room_items") , IItemListWindow);
            var _local_4= Std.downcast(_local_3.getListItemAt(0) , IWindowContainer);
            var _local_5= Std.downcast(this._habboHelp.getXmlWindow("chat_report_item") , IWindowContainer);
            _local_3.removeListItems();
            this._habboHelp.chatRegistry._Str_7724 = true;
            var _local_9= ((_arg_2 > 0) ? this._habboHelp.chatRegistry.getItemsByUser(_arg_2) : this._habboHelp.chatRegistry._Str_6828());
            if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
            {
_local_10  = _tmp_;
                if (_local_10.userId == k)
                {
                }
                else
                {
                    if (_local_10.roomId != _local_6)
                    {
                        _local_6 = _local_10.roomId;
                        _local_7 = Std.downcast(_local_4.clone() , IWindowContainer);
                        _local_7.findChildByName("room_name").caption = ("Room: " + _local_10.roomName);
                        _local_3.addListItemAt(_local_7, 0);
                        _local_8 = Std.downcast(_local_7.findChildByName("chat_items") , IItemListWindow);
                        _local_8.removeListItems();
                    }
                    _local_11 = Std.downcast(_local_5.clone() , IWindowContainer);
                    _local_12 = Std.downcast(_local_11.getChildByName("text") , ITextWindow);
                    _local_12.caption = ((_local_10.userName + ": ") + _local_10.text);
                    _local_11.id = _local_10.index;
                    _local_11.procedure = this._Str_18834;
                    _local_11.color = _Str_6492;
                    _local_8.addListItem(_local_11);
                }
            }
        }

        function _Str_18834(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ChatRegistryItem = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._habboHelp.chatRegistry.getItem(_arg_2.id);
                if (_local_3 == null)
                {
                    return;
                }
                if (((!_local_3.selected) && (!(_local_3.roomId == this._reportedRoomId))))
                {
                    this._reportedRoomId = _local_3.roomId;
                    this._Str_14598();
                }
                _local_3.selected = (!_local_3.selected);
                _arg_2.color = (_local_3.selected ? _Str_9415 : _Str_6492);
            }
        }

        function _Str_17227(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:InstantMessageRegistryItem = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._habboHelp.instantMessageRegistry.getItem(this._reportedUserId, _arg_2.id);
                if (_local_3 == null)
                {
                    return;
                }
                _local_3.selected = (!_local_3.selected);
                _arg_2.color = (_local_3.selected ? _Str_9415 : _Str_6492);
            }
        }

        function _Str_25143()
        {
            this._Str_19667();
            this._Str_25110();
        }

        function _Str_14598()
        {
            this._Str_19667();
            this._Str_23459();
        }

        function _Str_19667()
        {
            var k:Vector<InstantMessageRegistryItem> = null;
            var _local_2:ChatRegistryItem = null;
            var _local_3:InstantMessageRegistryItem = null;
            final _iter_ = this._habboHelp.instantMessageRegistry._Str_6828(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_3  = _tmp_;
                    _local_3.selected = false;
                }
            }
            final _iter_ = this._habboHelp.chatRegistry._Str_6828(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.selected = false;
            }
        }

        function _Str_23459()
        {
            var _local_3:IWindowContainer = null;
            var _local_4:IItemListWindow = null;
            var _local_5 = 0;
            var _local_6:IWindow = null;
            var _local_7:ChatRegistryItem = null;
            var k= Std.downcast(this._window.findChildByName("room_items") , IItemListWindow);
            var _local_2 = 0;
            while (_local_2 < k.numListItems)
            {
                _local_3 = Std.downcast(k.getListItemAt(_local_2) , IWindowContainer);
                _local_4 = Std.downcast(_local_3.findChildByName("chat_items") , IItemListWindow);
                _local_5 = 0;
                while (_local_5 < _local_4.numListItems)
                {
                    _local_6 = _local_4.getListItemAt(_local_5) ;
                    _local_7 = this._habboHelp.chatRegistry.getItem(_local_6.id);
                    if (_local_7 != null)
                    {
                        _local_6.color = (_local_7.selected ? _Str_9415 : _Str_6492);
                    }
                    _local_5++;
                }
                _local_2++;
            }
        }

        public function _Str_25110()
        {
            var _local_3:IWindowContainer = null;
            var _local_4:IItemListWindow = null;
            var _local_5 = 0;
            var _local_6:IWindow = null;
            var _local_7:InstantMessageRegistryItem = null;
            var k= Std.downcast(this._window.findChildByName("room_items") , IItemListWindow);
            var _local_2 = 0;
            while (_local_2 < k.numListItems)
            {
                _local_3 = Std.downcast(k.getListItemAt(_local_2) , IWindowContainer);
                _local_4 = Std.downcast(_local_3.findChildByName("chat_items") , IItemListWindow);
                _local_5 = 0;
                while (_local_5 < _local_4.numListItems)
                {
                    _local_6 = _local_4.getListItemAt(_local_5) ;
                    _local_7 = this._habboHelp.instantMessageRegistry.getItem(this._reportedUserId, _local_6.id);
                    if (_local_7 != null)
                    {
                        _local_6.color = (_local_7.selected ? _Str_9415 : _Str_6492);
                    }
                    _local_5++;
                }
                _local_2++;
            }
        }
    }

