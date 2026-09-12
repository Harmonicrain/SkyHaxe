package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.AchievementEvent;
    import com.sulake.habbo.communication.messages.incoming.quest.SeasonalQuestsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.competition.CompetitionEntrySubmitResultEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectRemoveMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.AchievementResolutionProgressMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.competition.CompetitionVotingInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.AchievementResolutionsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.AchievementsScoreEvent;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ScrSendUserInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsSavedEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.AchievementResolutionCompletedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboAchievementNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboActivityPointNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectAddMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.IsFirstLoginOfDayEvent;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestCompletedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.ActivityPointsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.AchievementsEvent;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestCancelledMessageEvent;
    import com.sulake.habbo.quest.events.QuestCompletedEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.quest.events.QuestsListEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.parser.users.ScrSendUserInfoMessageParser;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;

     class IncomingMessages implements IDisposable 
    {
        var _questEngine:HabboQuestEngine;
        var _alertDialog:IAlertDialog;
        var _isDisposed:Bool = false;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
            var _local_2= this._questEngine.communication;
            _local_2.addHabboConnectionMessageEvent(new QuestMessageEvent(this._Str_4750));
            _local_2.addHabboConnectionMessageEvent(new AchievementEvent(this._Str_12011));
            _local_2.addHabboConnectionMessageEvent(new SeasonalQuestsMessageEvent(this._Str_12986));
            _local_2.addHabboConnectionMessageEvent(new CloseConnectionMessageEvent(this.onRoomExit));
            _local_2.addHabboConnectionMessageEvent(new CompetitionEntrySubmitResultEvent(this._Str_17737));
            _local_2.addHabboConnectionMessageEvent(new ObjectRemoveMessageEvent(this._Str_19159));
            _local_2.addHabboConnectionMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            _local_2.addHabboConnectionMessageEvent(new AchievementResolutionProgressMessageEvent(this._Str_23911));
            _local_2.addHabboConnectionMessageEvent(new CompetitionVotingInfoMessageEvent(this._Str_16392));
            _local_2.addHabboConnectionMessageEvent(new AchievementResolutionsMessageEvent(this._Str_23908));
            _local_2.addHabboConnectionMessageEvent(new AchievementsScoreEvent(this._Str_18065));
            _local_2.addHabboConnectionMessageEvent(new QuestsMessageEvent(this._Str_8212));
            _local_2.addHabboConnectionMessageEvent(new ScrSendUserInfoEvent(this.onSubscriptionUserInfoEvent));
            _local_2.addHabboConnectionMessageEvent(new RoomSettingsSavedEvent(this.onRoomSettingsSaved));
            _local_2.addHabboConnectionMessageEvent(new AchievementResolutionCompletedMessageEvent(this._Str_24464));
            _local_2.addHabboConnectionMessageEvent(new HabboAchievementNotificationMessageEvent(this.onLevelUp));
            _local_2.addHabboConnectionMessageEvent(new HabboActivityPointNotificationMessageEvent(this._Str_24427));
            _local_2.addHabboConnectionMessageEvent(new ObjectAddMessageEvent(this._Str_19159));
            _local_2.addHabboConnectionMessageEvent(new IsFirstLoginOfDayEvent(this._Str_22814));
            _local_2.addHabboConnectionMessageEvent(new QuestCompletedMessageEvent(this._Str_5657));
            _local_2.addHabboConnectionMessageEvent(new ActivityPointsMessageEvent(this.onActivityPoints));
            _local_2.addHabboConnectionMessageEvent(new AchievementsEvent(this._Str_17329));
            _local_2.addHabboConnectionMessageEvent(new QuestCancelledMessageEvent(this._Str_5242));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        function _Str_5657(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , QuestCompletedMessageEvent).getParser();
            Logger.log([((("Quest Completed: " + _local_2._Str_8257._Str_6549) + " quest: ") + Std.string(_local_2._Str_8257.id))]);
            this._questEngine._Str_3398._Str_5657(_local_2._Str_8257, _local_2._Str_23243);
            if (this._questEngine._Str_7575(_local_2._Str_8257))
            {
                this._questEngine.events.dispatchEvent(new QuestCompletedEvent(QuestCompletedEvent.QCE_SEASONAL, _local_2._Str_8257));
            }
        }

        function _Str_5242(k:IMessageEvent)
        {
            Logger.log(["Quest Cancelled: "]);
            this._questEngine._Str_3398._Str_5242();
            if (cast(k, QuestCancelledMessageEvent).getParser().expired)
            {
                this._questEngine.windowManager.alert("${quests.expired.title}", "${quests.expired.body}", 0, null);
            }
        }

        function _Str_8212(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , QuestsMessageEvent).getParser();
            Logger.log([((("Got Quests: " + ASCompat.toString(_local_2.quests)) + ", ") + Std.string(_local_2.openWindow))]);
            this._questEngine.events.dispatchEvent(new QuestsListEvent(QuestsListEvent.QUESTS, _local_2.quests, _local_2.openWindow));
        }

        function _Str_12986(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , SeasonalQuestsMessageEvent).getParser();
            Logger.log([("Got seasonal Quests: " + ASCompat.toString(_local_2.quests))]);
            this._questEngine.events.dispatchEvent(new QuestsListEvent(QuestsListEvent.QE_QUESTS_SEASONAL, _local_2.quests, true));
        }

        function _Str_4750(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , QuestMessageEvent).getParser();
            Logger.log([("Got Quest: " + _local_2.quest)]);
            this._questEngine._Str_3398._Str_4750(_local_2.quest);
        }

        public function dispose()
        {
            if (this._alertDialog != null)
            {
                this._alertDialog.dispose();
                this._alertDialog = null;
            }
            this._isDisposed = true;
        }

        function onRoomEnter(k:RoomEntryInfoMessageEvent)
        {
            this._questEngine._Str_8189.onRoomEnter(k);
            this._questEngine._Str_6927 = true;
        }

        function onRoomExit(k:IMessageEvent)
        {
            this._questEngine._Str_3398.onRoomExit();
            this._questEngine._Str_17659.onRoomExit();
            this._questEngine._Str_8189.onRoomExit();
            this._questEngine._Str_6927 = false;
        }

        function _Str_19159(k:IMessageEvent)
        {
            this._questEngine._Str_8189._Str_21523();
        }

        function onRoomSettingsSaved(k:IMessageEvent)
        {
            this._questEngine._Str_8189._Str_21523();
        }

        function _Str_17329(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AchievementsEvent);
            var _local_3= _local_2.getParser() ;
            this._questEngine._Str_17659._Str_17329(_local_3.achievements, _local_3.defaultCategory);
        }

        function _Str_23908(k:AchievementResolutionsMessageEvent)
        {
            var _local_2= k.getParser();
            this._questEngine._Str_10255._Str_23538(_local_2.stuffId, _local_2.achievements, _local_2._Str_17028);
        }

        function _Str_23911(k:AchievementResolutionProgressMessageEvent)
        {
            var _local_2= k.getParser();
            this._questEngine._Str_10255._Str_24205(_local_2.stuffId, _local_2.achievementId, _local_2.requiredLevelBadgeCode, _local_2.userProgress, _local_2._Str_18600, _local_2._Str_17028);
        }

        function _Str_24464(k:AchievementResolutionCompletedMessageEvent)
        {
            var _local_2= k.getParser();
            this._questEngine._Str_10255._Str_25733(_local_2.badgeCode, _local_2.stuffCode);
        }

        function _Str_12011(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AchievementEvent);
            var _local_3= _local_2.getParser() ;
            this._questEngine._Str_17659._Str_12011(_local_3.achievement);
            this._questEngine._Str_10255._Str_12011(_local_3.achievement);
        }

        function _Str_18065(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AchievementsScoreEvent);
            var _local_3= _local_2.getParser() ;

            this._questEngine.localization.registerParameter("achievements.categories.score", "score", new compat.RegExp("\\B(?=(\\d{3})+(?!\\d))", "g").replace(Std.string(_local_3.score), " "));
        }

        function formattingNumber(number: String): String
        {
var i = Math.NaN, char: String  = null;            var result= "";
            for(_tmp_ in (1...number.length + 1).reverse())
            {
i= _tmp_;
char= number.charAt(Std.int(number.length - i));

                if(i % 3 == 0 && i != number.length) result += " " + char;
                
                else result += char;
            }

            return result;
        }

        function onLevelUp(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HabboAchievementNotificationMessageEvent);
            var _local_3= _local_2.getParser();
            var _local_4= this._questEngine.localization.getBadgeBaseName(_local_3.data.badgeCode);
            this._questEngine.send(new EventLogMessageComposer("Achievements", _local_4, "Leveled", "", _local_3.data.level));
            this._questEngine._Str_10255.onLevelUp(_local_3.data);
        }

        function _Str_22814(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , IsFirstLoginOfDayEvent).getParser();
            this._questEngine._Str_25830(_local_2._Str_18128);
        }

        function _Str_17737(k:CompetitionEntrySubmitResultEvent)
        {
            this._questEngine._Str_8189._Str_17737(k);
        }

        function _Str_16392(k:CompetitionVotingInfoMessageEvent)
        {
            this._questEngine._Str_8189._Str_16392(k);
        }

        function onSubscriptionUserInfoEvent(k:ScrSendUserInfoEvent)
        {
            if ((k.getParser().isVIP && (k.getParser().responseType == ScrSendUserInfoMessageParser.RESPONSE_TYPE_PURCHASE)))
            {
                this._questEngine._Str_8189.sendRoomCompetitionInit();
            }
        }

        function onActivityPoints(k:IMessageEvent)
        {
var _local_4:ASObject  = null;            var _local_3 = 0;
            var _local_4:ASObject = null;
            var _local_2= cast(k, ActivityPointsMessageEvent).points;
            final _iter_ = ActivityPointTypeEnum.values(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = ASCompat.toInt(_tmp_);
                this._questEngine._Str_3398.onActivityPoints(_local_3, 0);
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2.keys())
            {
_local_4 = _tmp_;
                this._questEngine._Str_3398.onActivityPoints(ASCompat.toInt(_local_4), ASCompat.toInt(_local_2[_local_4]));
            }
        }

        function _Str_24427(k:HabboActivityPointNotificationMessageEvent)
        {
            this._questEngine._Str_3398.onActivityPoints(k.type, k.amount);
        }
    }

