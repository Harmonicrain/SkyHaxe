package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.habbo.utils._Str_3942;
    import com.sulake.habbo.quest.events.QuestsListEvent;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.help._enum.WelcomeNotificationAlignment;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.AcceptQuestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.RejectQuestMessageComposer;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class QuestsList implements IDisposable 
    {
        static inline final _Str_18107= 5;
        static inline final _Str_17206= 10;
        static inline final _Str_16045= 10;
        static inline final _Str_18653= 30;

        var _questEngine:HabboQuestEngine;
        var _window:IFrameWindow;
        var _list:IItemListWindow;
        var _scrollV:IScrollbarWindow;
        var _showToolbarNotification:Bool = true;
        var _hasActiveQuest:Bool = false;
        var _toggle:_Str_3942;
        var _quests:Array<ASAny>;
        var _msecsToRefresh:Int = 1000;

        public function new(k:HabboQuestEngine)
        {
            this._quests = new Array<ASAny>();
            this._questEngine = k;
            this._questEngine.events.addEventListener(QuestsListEvent.QUESTS, this._Str_20007);
        }

        public function dispose()
        {
            if (this._questEngine != null)
            {
                this._questEngine.events.removeEventListener(QuestsListEvent.QUESTS, this._Str_20007);
                this._questEngine = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._toggle != null)
            {
                this._toggle.dispose();
                this._toggle = null;
            }
            this._list = null;
            this._scrollV = null;
            this._quests = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function isVisible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function onRoomExit()
        {
            this.close();
        }

        public function onToolbarClick()
        {
            if (this._window == null)
            {
                this._questEngine.requestQuests();
                return;
            }
            if (((!(this._toggle != null)) || this._toggle.disposed))
            {
                this._toggle = new _Str_3942(this._window, this._window.desktop, this._questEngine.requestQuests, this.close);
            }
            this._toggle.toggle();
            this._showToolbarNotification = false;
        }

        function _Str_20007(k:QuestsListEvent)
        {
            this._Str_8212(k.quests, true);
        }

        function _Str_8212(k:Array<ASAny>, _arg_2:Bool)
        {
            this._quests = [];
            var _local_3:QuestMessageData = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (!this._questEngine._Str_7575(_local_3))
                {
                    this._quests.push(_local_3);
                }
            }
            if (((!this.isVisible()) && (!_arg_2)))
            {
                return;
            }
            this.refresh(false);
            this._window.visible = true;
            this._window.activate();
            this._hasActiveQuest = false;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (_local_3.accepted)
                {
                    this._hasActiveQuest = true;
                }
            }
        }

        function refresh(k:Bool)
        {
            var _local_3 = false;
            this.prepareWindow();
            this._list.autoArrangeItems = false;
            var _local_2 = 0;
            while (true)
            {
                if (_local_2 < this._quests.length)
                {
                    this.refreshEntry(true, _local_2, this._quests[_local_2], k);
                }
                else
                {
                    _local_3 = this.refreshEntry(false, _local_2, null, k);
                    if (_local_3)
                    {
                        break;
                    }
                }
                _local_2++;
            }
            this._list.autoArrangeItems = true;
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._questEngine.getXmlWindow("Quests"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onWindowClose;
            this._list = cast(this._window.findChildByName("quest_list"), IItemListWindow);
            this._scrollV = cast(this._window.findChildByName("scroller"), IScrollbarWindow);
            this._window.center();
            this._list.spacing = _Str_17206;
        }

        function refreshEntry(k:Bool, _arg_2:Int, _arg_3:QuestMessageData, _arg_4:Bool):Bool
        {
            var _local_5= cast(this._list.getListItemAt(_arg_2), IWindowContainer);
            var _local_6 = false;
            if (_local_5 == null)
            {
                if (!k)
                {
                    return true;
                }
                _local_5 = this._Str_19203(this._Str_17443, this.onCancelQuest);
                this._list.addListItem(_local_5);
                _local_6 = true;
            }
            if (k)
            {
                if (_arg_4)
                {
                    this._Str_17692(_local_5, _arg_3);
                }
                else
                {
                    this.refreshEntryDetails(_local_5, _arg_3);
                }
                _local_5.visible = true;
            }
            else
            {
                _local_5.visible = false;
            }
            return false;
        }

        public function _Str_19203(k:ASFunction, _arg_2:ASFunction):IWindowContainer
        {
            var _local_3= cast(this._questEngine.getXmlWindow("QuestEntry"), IWindowContainer);
            var _local_4= cast(this._questEngine.getXmlWindow("Campaign"), IWindowContainer);
            var _local_5= cast(this._questEngine.getXmlWindow("Quest"), IWindowContainer);
            var _local_6= cast(this._questEngine.getXmlWindow("EntryArrows"), IWindowContainer);
            var _local_7= cast(this._questEngine.getXmlWindow("CampaignCompleted"), IWindowContainer);
            _local_3.addChild(_local_4);
            _local_3.addChild(_local_5);
            _local_3.addChild(_local_7);
            _local_3.addChild(_local_6);
            _local_5.findChildByName("accept_button").procedure = k;
            _local_5.findChildByName("cancel_region").procedure = _arg_2;
            _local_3.findChildByName("hint_txt").visible = false;
            _local_3.findChildByName("link_region").visible = false;
            var _local_8= _local_3.findChildByName("cancel_region");
            var _local_9= _local_3.findChildByName("cancel_txt");
            _local_8.width = _local_9.width;
            _local_8.x = ((_local_5.width - _local_8.width) - _Str_16045);
            _local_5.x = ((_local_4.x + _local_4.width) + _Str_18107);
            _local_3.width = (_local_5.x + _local_5.width);
            _local_7.x = _local_5.x;
            this._Str_19570(_local_3);
            return _local_3;
        }

        public function _Str_19570(k:IWindowContainer)
        {
            var _local_2= cast(k.findChildByName("campaign_container"), IWindowContainer);
            var _local_3= cast(k.findChildByName("quest_container"), IWindowContainer);
            var _local_4= cast(k.findChildByName("entry_arrows_cont"), IWindowContainer);
            _local_2.height = _local_3.height;
            k.height = _local_3.height;
            _local_4.x = ((_local_2.x + _local_2.width) - 2);
            _local_4.y = Std.int(Math.ffloor(((_local_2.height - _local_4.height) / 2)) + 1);
            _local_2.findChildByName("completion_txt").y = (_local_2.height - _Str_18653);
            var _local_5= 2;
            var _local_6= _local_2.findChildByName("bg_bottom");
            _local_6.height = Std.int(Math.ffloor(((_local_2.height - (2 * _local_5)) / 2)));
            _local_6.y = (_local_5 + _local_6.height);
        }

        public function refreshEntryDetails(k:IWindowContainer, _arg_2:QuestMessageData)
        {
            k.findChildByName("campaign_header_txt").caption = this._questEngine._Str_15926(_arg_2);
            k.findChildByName("completion_txt").caption = ((Std.string(_arg_2._Str_18579) + "/") + Std.string(_arg_2._Str_25129));
            this._questEngine._Str_19396(k, _arg_2, true);
            this.setColor(k, "bg", _arg_2.accepted, 0xFFC29D3B, 0xFF646464);
            this.setColor(k, "bg_top", _arg_2.accepted, 0xFFFFD788, 0xFFBABABA);
            this.setColor(k, "bg_bottom", _arg_2.accepted, 0xFFFFC758, 0xFFABABAB);
            k.findChildByName("completion_bg_red_bitmap").visible = ((!_arg_2._Str_6695) && (_arg_2._Str_18579 < 1));
            k.findChildByName("completion_bg_blue_bitmap").visible = ((!_arg_2._Str_6695) && (_arg_2._Str_18579 > 0));
            k.findChildByName("completion_bg_green_bitmap").visible = _arg_2._Str_6695;
            k.findChildByName("arrow_0").visible = (!_arg_2.accepted);
            k.findChildByName("arrow_1").visible = _arg_2.accepted;
            k.findChildByName("quest_container").visible = (!_arg_2._Str_6695);
            k.findChildByName("campaign_completed_container").visible = _arg_2._Str_6695;
            if (!_arg_2._Str_6695)
            {
                this._Str_19824(cast(k.findChildByName("quest_container"), IWindowContainer), _arg_2);
                this._Str_17692(k, _arg_2);
            }
        }

        function _Str_19824(k:IWindowContainer, _arg_2:QuestMessageData)
        {
            k.findChildByName("quest_header_txt").caption = this._questEngine._Str_23055(_arg_2);
            k.findChildByName("desc_txt").caption = this._questEngine._Str_20120(_arg_2);
            k.findChildByName("cancel_txt").visible = _arg_2.accepted;
            k.findChildByName("cancel_region").visible = _arg_2.accepted;
            k.findChildByName("accept_button").visible = (!_arg_2.accepted);
            k.findChildByName("accept_button").id = _arg_2.id;
            this.setColor(k, null, _arg_2.accepted, 15982264, 0xC8C8C8);
            this.setColor(k, "quest_header", _arg_2.accepted, 15577658, 0x8D8D8D);
            cast(k.findChildByName("quest_header_txt"), ITextWindow).textColor = (_arg_2.accepted ? 0xFFFFFFFF : 0xFF373737);
            this._questEngine._Str_19955(k, _arg_2);
            this._questEngine._Str_19816((_arg_2._Str_3935 < 1), k, _arg_2.activityPointType, _arg_2._Str_12939);
            k.findChildByName("delay_desc_txt").visible = (_arg_2._Str_3935 > 0);
            k.findChildByName("delay_txt").visible = (_arg_2._Str_3935 > 0);
            k.findChildByName("desc_txt").visible = (_arg_2._Str_3935 < 1);
        }

        public function _Str_17692(k:IWindowContainer, _arg_2:QuestMessageData):Bool
        {
            var _local_3 = 0;
            var _local_4:String = null;
            if (k.findChildByName("delay_desc_txt").visible)
            {
                _local_3 = _arg_2._Str_3935;
                if (_local_3 > 0)
                {
                    _local_4 = FriendlyTime.format(this._questEngine.localization, _local_3);
                    k.findChildByName("delay_txt").caption = _local_4;
                }
                else
                {
                    this._Str_19824(k, _arg_2);
                    return true;
                }
            }
            return false;
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
                _local_3 = (this._questEngine.getInteger("new.identity", 0) > 0);
                if (((_local_3 && this._showToolbarNotification) && (!this._hasActiveQuest)))
                {
                    this._showToolbarNotification = false;
                    this._questEngine.habboHelp.showWelcomeScreen(HabboToolbarIconEnum.QUESTS, "quests.rejectnotification", WelcomeNotificationAlignment.LEFT);
                }
            }
        }

        function _Str_17443(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            var _local_3= _arg_2.id;
            Logger.log([("Accept quest: " + Std.string(_local_3))]);
            this._questEngine.send(new AcceptQuestMessageComposer(_local_3));
            this._window.visible = false;
        }

        function onCancelQuest(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            Logger.log(["Reject quest"]);
            this._questEngine.send(new RejectQuestMessageComposer());
        }

        function setColor(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:UInt, _arg_5:UInt)
        {
            ((_arg_2 == null) ? k : k.findChildByName(_arg_2)).color = (_arg_3 ? _arg_4 : _arg_5);
        }

        public function onAlert(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (((_arg_2.type == WindowEvent.WINDOW_EVENT_OK) || (_arg_2.type == WindowEvent.WINDOW_EVENT_CANCEL)))
            {
                k.dispose();
            }
        }

        public function update(k:UInt)
        {
            if (((this._window == null) || (!this._window.visible)))
            {
                return;
            }
            this._msecsToRefresh = ASCompat.toInt(this._msecsToRefresh - k);
            if (this._msecsToRefresh > 0)
            {
                return;
            }
            this._msecsToRefresh = NextQuestTimer._Str_10934;
            this.refresh(true);
        }
    }

