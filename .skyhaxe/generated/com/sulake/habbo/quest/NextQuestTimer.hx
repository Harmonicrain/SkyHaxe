package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class NextQuestTimer implements IDisposable 
    {
        public static inline final _Str_10934= 1000;
        static inline final NEXT_QUEST= "next_quest";

        var _questEngine:HabboQuestEngine;
        var _quest:QuestMessageData;
        var _window:IWindowContainer;
        var _expanded:Bool = false;
        var _msecsToRefresh:Int = 0;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
        }

        public function dispose()
        {
            if (this._questEngine != null)
            {
                this._questEngine.toolbar.extensionView.detachExtension(NEXT_QUEST);
            }
            this._questEngine = null;
            this._quest = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function _Str_5242()
        {
            this._quest = null;
            this.close();
        }

        public function onRoomExit()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this._window.findChildByName("more_info_region").visible = false;
                this._window.findChildByName("more_info_txt").visible = false;
            }
        }

        public function _Str_4750(k:QuestMessageData)
        {
            if (k._Str_3935 < 1)
            {
                this.close();
                return;
            }
            this._quest = k;
            this.prepareWindow();
            this._Str_18138();
            this._window.visible = true;
            this._questEngine.toolbar.extensionView.attachExtension(NEXT_QUEST, this._window);
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._questEngine.getXmlWindow("NextQuestTimer"), IWindowContainer);
            this._window.x = 0;
            this._window.y = 0;
            this._window.findChildByName("more_info_region").procedure = this._Str_16870;
            this._window.findChildByName("quest_timer_expanded").procedure = this._Str_22120;
            this._window.findChildByName("quest_timer_contracted").procedure = this._Str_22120;
            this._Str_18138();
        }

        function refresh()
        {
            var k= this._quest._Str_3935;
            if (k < 1)
            {
                this.close();
                this._quest._Str_3935 = 0;
                this._questEngine._Str_3398._Str_4750(this._quest);
            }
            var _local_2= FriendlyTime.format(this._questEngine.localization, k);
            var _local_3:ASAny = (this._quest._Str_9246() + ".delayedmsg");
            this._questEngine.localization.registerParameter("quests.nextquesttimer.caption.contracted", "time", _local_2);
            this._questEngine.localization.registerParameter(_local_3, "time", _local_2);
            this._window.findChildByName("quest_header_txt").caption = this._questEngine.localization.getLocalization(("quests.nextquesttimer.caption." + (this._expanded ? "expanded" : "contracted")));
            this._window.findChildByName("desc_txt").caption = this._questEngine.localization.getLocalization(_local_3, _local_3);
        }

        function _Str_18138()
        {
            this._window.findChildByName("quest_timer_expanded").visible = this._expanded;
            this._window.findChildByName("quest_timer_contracted").visible = (!this._expanded);
            this._window.findChildByName("more_info_txt").visible = (this._expanded && this._questEngine._Str_6927);
            this._window.findChildByName("more_info_region").visible = (this._expanded && this._questEngine._Str_6927);
            this._window.findChildByName("quest_pic_bitmap").visible = this._expanded;
            this._window.findChildByName("desc_txt").visible = this._expanded;
            this.refresh();
        }

        function _Str_16870(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine._Str_3398._Str_11417._Str_5386(this._quest);
            }
        }

        function _Str_22120(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._expanded = (!this._expanded);
                this._Str_18138();
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
            this._msecsToRefresh = _Str_10934;
            this.refresh();
        }

        function _Str_14043():Int
        {
            return 0;
        }

        public function isVisible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        public function close()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this._window.visible = false;
                this._questEngine.toolbar.extensionView.detachExtension(NEXT_QUEST);
            }
        }

        function _Str_17891(k:Bool)
        {
            this._window.findChildByName("quest_pic_bitmap").visible = k;
        }
    }

