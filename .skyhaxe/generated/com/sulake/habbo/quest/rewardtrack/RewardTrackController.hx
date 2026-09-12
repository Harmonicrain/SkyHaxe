package com.sulake.habbo.quest.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTrackClaimResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTrackPremiumResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTrackProgressMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTracksMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.rewardtrack.ClaimRewardTrackRewardMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.rewardtrack.PurchaseRewardTrackPremiumMessageComposer;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackClaimResultMessageParser;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackPremiumResultMessageParser;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import com.sulake.habbo.quest.events.UnseenRewardTrackRewardsCountUpdateEvent;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackPrize;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackTask;
    import com.sulake.habbo.quest.rewardtrack.view.RewardTrackView;
    import com.sulake.habbo.quest.rewardtrack.view.premium.RewardTrackPremiumPurchaseConfirmationView;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.runtime.IHabboConfigurationManager;

     class RewardTrackController implements IRewardTrackController implements  ILinkEventTracker
    {
        var _questEngine:HabboQuestEngine;
        var _tracks:ASDictionary<ASAny,ASAny>;
        var _trackList:Array<ASAny>;
        var _enabled:Bool = true;
        var _disposed:Bool = false;
        var _messagesRegistered:Bool = false;
        var _lastClaimableCount:Int = -1;
        var _view:RewardTrackView;
        var _premiumPurchaseView:RewardTrackPremiumPurchaseConfirmationView;

        public function new(questEngine:HabboQuestEngine)
        {
            this._questEngine = questEngine;
            this._tracks = new ASDictionary<ASAny,ASAny>();
            this._trackList = [];
        }

        public function registerMessages()
        {
            if (this._messagesRegistered || this._questEngine == null || this._questEngine.communication == null)
            {
                return;
            }
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTracksMessageEvent(this.onRewardTracks));
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTrackProgressMessageEvent(this.onRewardTrackProgress));
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTrackClaimResultMessageEvent(this.onRewardTrackClaimResult));
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTrackPremiumResultMessageEvent(this.onRewardTrackPremiumResult));
            this._messagesRegistered = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this._disposed = true;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this.closePremiumPurchaseConfirmation();
            this._tracks = null;
            this._trackList = null;
            this._questEngine = null;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "reward_track/";
        }

        public function linkReceived(link:String)
        {
            var parts:Array<ASAny> = (cast link.split("/"));
            if (parts.length >= 3 && parts[1] == "open")
            {
                this.open(parts[2]);
            }
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._enabled;
        }

        public var tracks(get,never):Array<ASAny>;
public function  get_tracks():Array<ASAny>
        {
            return this._trackList;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._questEngine != null ? this._questEngine.windowManager : null;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._questEngine != null ? this._questEngine.assets : null;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._questEngine != null ? this._questEngine.localization : null;
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return this._questEngine != null ? this._questEngine.configuration : null;
        }

        public function getTrack(trackId:String):RewardTrack
        {
            return this._tracks != null ? ASCompat.dynamicAs(this._tracks[trackId] , RewardTrack) : null;
        }

        public function open(trackId:String)
        {
            var track= this.getTrack(trackId);
            if (!this._enabled)
            {
                return;
            }
            if (track == null)
            {
                return;
            }
            if (this._questEngine != null && this._questEngine.windowManager != null)
            {
                if (this._view == null || this._view.disposed)
                {
                    this._view = new RewardTrackView(this._questEngine.windowManager, this._questEngine.localization, this._questEngine.assets, this, this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.figure : null, this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.userId : 0);
                }
                else
                {
                    this._view.setOwnUser(this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.figure : null, this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.userId : 0);
                }
                this._view.show(track);
            }
        }

        public function claimReward(trackId:String, rewardId:String)
        {
            if (this._questEngine != null)
            {
                this._questEngine.send(new ClaimRewardTrackRewardMessageComposer(trackId, rewardId));
            }
        }

        public function purchasePremium(trackId:String)
        {
            if (this._questEngine != null)
            {
                this._questEngine.send(new PurchaseRewardTrackPremiumMessageComposer(trackId));
            }
        }

        public function openPremiumPurchaseConfirmation(track:RewardTrack)
        {
            if (track == null || !track.hasPremiumConfig || track.premium)
            {
                return;
            }
            this.closePremiumPurchaseConfirmation();
            this._premiumPurchaseView = new RewardTrackPremiumPurchaseConfirmationView(this, track);
            this._premiumPurchaseView.show();
        }

        public function openTaskHintLink(link:String)
        {
            if (link == null || link == "" || this._questEngine == null)
            {
                return;
            }
            this._questEngine.context.createLinkEvent(link);
        }

        public function closePremiumPurchaseConfirmation()
        {
            if (this._premiumPurchaseView != null)
            {
                this._premiumPurchaseView.dispose();
                this._premiumPurchaseView = null;
            }
        }

        function onRewardTracks(event:IMessageEvent)
        {
            var parser= cast(event, RewardTracksMessageEvent).getParser();
            var track:RewardTrack = null;
            this._enabled = !parser.disabled;
            this._tracks = new ASDictionary<ASAny,ASAny>();
            this._trackList = [];
            this.closePremiumPurchaseConfirmation();
            final _iter_ = parser.tracks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
track  = _tmp_;
                this._tracks[track.id] = track;
                this._trackList.push(track);
            }
            this.broadcastClaimableCount();
        }

        function onRewardTrackProgress(event:IMessageEvent)
        {
            var parser= cast(event, RewardTrackProgressMessageEvent).getParser();
            var track= this.getTrack(parser.trackId);
            var task:RewardTrackTask = track != null ? track.getTask(parser.taskId) : null;
            var hadProgress = false;
            var wasComplete = false;
            if (track == null || task == null)
            {
                return;
            }
            hadProgress = task.progressCount > 0;
            wasComplete = this.isTaskComplete(task);
            track.points = parser.points;
            task.progressCount = parser.progressCount;
            this.updateProgressView(task, hadProgress, wasComplete);
            this.broadcastClaimableCount();
        }

        function onRewardTrackClaimResult(event:IMessageEvent)
        {
            var parser= cast(event, RewardTrackClaimResultMessageEvent).getParser();
            var track= this.getTrack(parser.trackId);
            var prize:RewardTrackPrize = track != null ? track.getPrize(parser.rewardId) : null;
            if (parser.resultCode == RewardTrackClaimResultMessageParser.SUCCESS && prize != null)
            {
                prize.claimed = true;
                this.updatePrizeClaimView(prize);
                this.broadcastClaimableCount();
            }
        }

        function onRewardTrackPremiumResult(event:IMessageEvent)
        {
            var parser= cast(event, RewardTrackPremiumResultMessageEvent).getParser();
            var track= this.getTrack(parser.trackId);
            if (parser.resultCode == RewardTrackPremiumResultMessageParser.SUCCESS && track != null)
            {
                track.premium = true;
                track.points = parser.points;
                this.closePremiumPurchaseConfirmation();
                this.updatePremiumPurchaseView();
                this.broadcastClaimableCount();
            }
            else if (this._premiumPurchaseView != null && !this._premiumPurchaseView.disposed)
            {
                this._premiumPurchaseView.purchaseFailed();
            }
        }

        function updateProgressView(task:RewardTrackTask, hadProgress:Bool, wasComplete:Bool)
        {
            if (this._view != null && !this._view.disposed)
            {
                this._view.taskProgressUpdated(task, hadProgress, wasComplete);
            }
        }

        function updatePrizeClaimView(prize:RewardTrackPrize)
        {
            if (this._view != null && !this._view.disposed)
            {
                this._view.prizeClaimed(prize);
            }
        }

        function updatePremiumPurchaseView()
        {
            if (this._view != null && !this._view.disposed)
            {
                this._view.premiumPurchased();
            }
        }

        function isTaskComplete(task:RewardTrackTask):Bool
        {
            var level:ASObject = null;
            var required= 0;
            if (task == null)
            {
                return false;
            }
            final _iter_ = task.levels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
level  = _tmp_;
                if (level != null && level.requiredCount > required)
                {
                    required = ASCompat.toInt(level.requiredCount);
                }
            }
            return required > 0 && task.progressCount >= required;
        }

        function broadcastClaimableCount()
        {
            var track:RewardTrack = null;
            var prize:RewardTrackPrize = null;
            var count= 0;
            if (this._trackList == null)
            {
                return;
            }
            final _iter_ = this._trackList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
track  = _tmp_;
                final _iter_ = track.prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
prize  = _tmp_;
                    if (prize.isClaimable(track))
                    {
                        count++;
                    }
                }
            }
            if (count != this._lastClaimableCount && this._questEngine != null)
            {
                this._lastClaimableCount = count;
                this._questEngine.events.dispatchEvent(new UnseenRewardTrackRewardsCountUpdateEvent(count));
            }
        }
    }

