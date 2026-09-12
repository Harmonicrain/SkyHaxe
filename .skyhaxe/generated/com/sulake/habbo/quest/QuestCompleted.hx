package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.OpenQuestTrackerMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetQuestsMessageComposer;
    import com.sulake.core.window.components.ITextWindow;

     class QuestCompleted implements IDisposable 
    {
        static inline final _Str_17233= 2000;
        static inline final _Str_8154= 5;
        static inline final _Str_15956= 31;

        var _window:IFrameWindow;
        var _questEngine:HabboQuestEngine;
        var _quest:QuestMessageData;
        var _twinkleAnimation:Animation;
        var _openQuestCompletedIn:Int = 0;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
        }

        public function dispose()
        {
            this._questEngine = null;
            this._quest = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._twinkleAnimation != null)
            {
                this._twinkleAnimation.dispose();
                this._twinkleAnimation = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }

        public function _Str_4750(k:QuestMessageData)
        {
            this.close();
        }

        public function _Str_5242()
        {
            this.close();
        }

        public function _Str_5657(k:QuestMessageData, _arg_2:Bool)
        {
            if (_arg_2)
            {
                this.prepare(k);
                this._openQuestCompletedIn = _Str_17233;
            }
        }

        function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function onNextQuest(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._window.visible = false;
            this._questEngine._Str_3398._Str_11417._Str_19749 = this._questEngine.getBoolean("questing.showDetailsForNextQuest");
            this._questEngine.send(new OpenQuestTrackerMessageComposer());
        }

        function _Str_22793(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._window.visible = false;
                this._questEngine.send(new GetQuestsMessageComposer());
            }
        }

        public function prepare(k:QuestMessageData)
        {
            this._quest = k;
            if (this._window == null)
            {
                this._window = cast(this._questEngine.getXmlWindow("QuestCompletedDialog"), IFrameWindow);
                this._window.findChildByTag("close").procedure = this.onNextQuest;
                this._window.findChildByName("next_quest_button").procedure = this.onNextQuest;
                this._window.findChildByName("more_quests_button").procedure = this._Str_22793;
                this._window.findChildByName("catalog_link_region").procedure = this._Str_17730;
                this._twinkleAnimation = this._questEngine._Str_22854(this._window);
            }
            this._window.findChildByName("catalog_link_txt").caption = this._questEngine.localization.getLocalization(("quests.completed.cataloglink." + Std.string(this._quest.activityPointType)));
            var _local_2= ("quests.completed.reward." + Std.string(this._quest.activityPointType));
            this._questEngine.localization.registerParameter(_local_2, "amount", Std.string(this._quest._Str_12939));
            this._window.findChildByName("reward_txt").caption = this._questEngine.localization.getLocalization(_local_2, _local_2);
            this._window.findChildByName("reward_txt").visible = ((this._quest.activityPointType >= 0) && (this._quest._Str_12939 > 0));
            this._window.visible = false;
            this._window.findChildByName("congrats_txt").caption = this._questEngine.localization.getLocalization((this._quest._Str_5132 ? "quests.completed.campaign.caption" : "quests.completed.quest.caption"));
            this._window.findChildByName("more_quests_button").visible = this._quest._Str_5132;
            this._window.findChildByName("campaign_reward_icon").visible = this._quest._Str_5132;
            this._window.findChildByName("catalog_link_region").visible = ((!this._quest._Str_5132) && (this._quest._Str_12939 > 0));
            this._window.findChildByName("next_quest_button").visible = (!this._quest._Str_5132);
            this._window.findChildByName("reward_icon").visible = (!this._quest._Str_5132);
            this._window.findChildByName("campaign_reward_icon").visible = this._quest._Str_5132;
            this._window.findChildByName("campaign_pic_bitmap").visible = this._quest._Str_5132;
            this._Str_25382((this._quest._Str_5132 ? "quests.completed.campaign.title" : "quests.completed.quest.title"));
            this._questEngine._Str_19396(this._window, k, this._quest._Str_5132);
            var _local_3= cast(this._window.findChildByName("desc_txt"), ITextWindow);
            var _local_4= _local_3.height;
            this._Str_24356((this._quest._Str_5688() + ".completed"));
            _local_3.height = Std.int(Math.max(_Str_15956, (_local_3.textHeight + _Str_8154)));
            var _local_5= (_local_3.height - _local_4);
            this._window.height = (this._window.height + _local_5);
        }

        function _Str_25382(k:String)
        {
            this._questEngine.localization.registerParameter(k, "category", this._questEngine._Str_15926(this._quest));
            this._window.caption = this._questEngine.localization.getLocalization(k, k);
        }

        function _Str_24356(k:String)
        {
            this._window.findChildByName("desc_txt").caption = this._questEngine.localization.getLocalization(k, k);
        }

        function _Str_17730(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.openCatalog(this._quest);
            }
        }

        public function update(k:UInt)
        {
            if (this._openQuestCompletedIn > 0)
            {
                this._openQuestCompletedIn = ASCompat.toInt(this._openQuestCompletedIn - k);
                if (this._openQuestCompletedIn < 1)
                {
                    this._window.center();
                    this._window.visible = true;
                    this._window.activate();
                    if (this._quest._Str_5132)
                    {
                        this._twinkleAnimation._Str_24676();
                    }
                    else
                    {
                        this._twinkleAnimation.stop();
                    }
                }
            }
            if (this._twinkleAnimation != null)
            {
                this._twinkleAnimation.update(k);
            }
        }
    }

