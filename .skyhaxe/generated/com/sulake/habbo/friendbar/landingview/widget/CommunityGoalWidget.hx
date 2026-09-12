package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalProgressMessageEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetCommunityGoalProgressMessageComposer;
    import com.sulake.habbo.communication.messages.parser.quest.CommunityGoalProgressParser;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.habbo.friendbar.landingview.*;

     class CommunityGoalWidget implements IUpdateReceiver implements  ILandingViewWidget implements  ISettingsAwareWidget 
    {
        static final CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES:Array<ASAny> = [0, 8, 16, 23];
        static inline final METER_INITIAL_DELAY_MS= 1500;
        static inline final METER_BUILDUP_TIME_MS= 1000;

        var _landingView:HabboLandingView;
        var _communityGoalContainer:IWindowContainer;
        var _meterNeedle:IStaticBitmapWrapperWindow;
        var _communityProgress:CommunityGoalData;
        var _communityProgressRequested:Bool = false;
        var _buildupDelay:Float = 0;
        var _buildupProgress:Float = 0;
        var _isInitialized:Bool = false;
        var _isInteractive:Bool = true;
        var _withVoting:Bool = false;

        public function new(k:HabboLandingView, _arg_2:Bool=false)
        {
            this._landingView = k;
            this._withVoting = _arg_2;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._communityGoalContainer;
        }

        public function dispose()
        {
            if (((!(this._landingView == null)) && (this._landingView.windowManager != null)))
            {
                cast(this._landingView.windowManager, Component).removeUpdateReceiver(this);
            }
            this._landingView = null;
            this._communityGoalContainer = null;
            this._communityProgress = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public function initialize()
        {
            var k:IWindow = null;
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new CommunityGoalProgressMessageEvent(this.onCommunityGoalProgress));
            this._communityGoalContainer = cast((this._withVoting ? this._landingView.getXmlWindow("community_goal_voting") : this._landingView.getXmlWindow("community_goal")), IWindowContainer);
            this._meterNeedle = cast(this._communityGoalContainer.findChildByName("meter_needle"), IStaticBitmapWrapperWindow);
            if (!this._withVoting)
            {
                k = this._communityGoalContainer.findChildByName("community_catalog_button");
                this._isInteractive = this._landingView.getBoolean("landing.view.community.interactive");
                k.visible = this._isInteractive;
                k.procedure = this.onCommunityCatalogButtonClick;
            }
            HabboLandingView._Str_9079(this._communityGoalContainer, "community_title", "hdr_line");
        }

        function campaignizeMeterElementAssetUri(k:IWindow)
        {
            var _local_2= cast(k, IStaticBitmapWrapperWindow);
            var _local_3= _local_2.assetUri.indexOf(".png");
            _local_2.assetUri = (((_local_2.assetUri.substr(0, _local_3) + "_") + this._communityProgress.goalCode) + ".png");
        }

        function setCampaignLocalization(k:String, _arg_2:String)
        {
            var _local_3= this._communityGoalContainer.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.caption = (((("${" + _arg_2) + ".") + this._communityProgress.goalCode) + "}");
            }
        }

        function getCurrentNeedleFrame():Int
        {
            if (this._communityProgress.communityHighestAchievedLevel >= (CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES.length - 1))
            {
                return ASCompat.toInt(CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES[(CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES.length - 1)]);
            }
            var k= ASCompat.toInt(CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES[this._communityProgress.communityHighestAchievedLevel]);
            var _local_2= ASCompat.toInt(ASCompat.toNumber(CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES[(this._communityProgress.communityHighestAchievedLevel + 1)]) - k);
            return Std.int(k + Math.ffloor(((this._communityProgress.percentCompletionTowardsNextLevel * (_local_2 + 0.001)) / 100)));
        }

        function initializeLocalizations()
        {
            var k = 0;
            if (((!(this._communityProgress == null)) && (!(this._communityProgress.goalCode == null))))
            {
                k = 0;
                while (k < CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES.length)
                {
                    this.campaignizeMeterElementAssetUri(this._communityGoalContainer.findChildByName(("meter_level_" + Std.string(k))));
                    if (k > 0)
                    {
                        this.campaignizeMeterElementAssetUri(this._communityGoalContainer.findChildByName((("meter_level_" + Std.string(k)) + "_icon")));
                        this.campaignizeMeterElementAssetUri(this._communityGoalContainer.findChildByName((("meter_level_" + Std.string(k)) + "_icon_locked")));
                    }
                    k++;
                }
                this.setCampaignLocalization("community_title", "landing.view.community.headline");
                this.setCampaignLocalization("goal_caption", "landing.view.community.caption");
                this.setCampaignLocalization("goal_info", "landing.view.community.info");
                this.setCampaignLocalization("community_catalog_button", "landing.view.community_catalog_button.text");
                this._isInitialized = true;
            }
        }

        function refreshContent()
        {
            if (this._communityProgress == null)
            {
                this._communityGoalContainer.visible = false;
                return;
            }
            if (!this._isInitialized)
            {
                this.initializeLocalizations();
            }
            var k= 1;
            while (k < CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES.length)
            {
                this._communityGoalContainer.findChildByName(("meter_level_" + Std.string(k))).visible = false;
                this._communityGoalContainer.findChildByName((("meter_level_" + Std.string(k)) + "_icon")).visible = false;
                this._communityGoalContainer.findChildByName((("meter_level_" + Std.string(k)) + "_icon_locked")).visible = false;
                k++;
            }
            var _local_2= "landing.view.community.meter";
            this._landingView.localizationManager.registerParameter(_local_2, "userRank", Std.string(this._communityProgress._Str_10549));
            this._landingView.localizationManager.registerParameter(_local_2, "userAmount", Std.string(this._communityProgress.personalContributionScore));
            this._landingView.localizationManager.registerParameter(_local_2, "totalAmount", Std.string(this._communityProgress._Str_12030));
            if (((!(this._communityProgress == null)) && (!(this._communityProgress.goalCode == null))))
            {
                this._landingView.localizationManager.registerParameter(("landing.view.community.meter." + this._communityProgress.goalCode), "totalAmount", Std.string(this._communityProgress._Str_12030));
                this.setCampaignLocalization("community_total_status", "landing.view.community.meter");
                if (this._withVoting)
                {
                    this.setCampaignLocalization("community_vote_one_button", "landing.view.vote_one_button.text");
                    this.setCampaignLocalization("community_vote_two_button", "landing.view.vote_two_button.text");
                }
            }
            var _local_3= cast(this._communityGoalContainer.findChildByName("goal_info"), ITextWindow);
            _local_3.height = Std.int(_local_3.textHeight + 6);
            if (!this._withVoting)
            {
                this._communityGoalContainer.findChildByName("community_catalog_button").visible = this._isInteractive;
            }
            this._communityGoalContainer.visible = true;
            this._communityGoalContainer.invalidate();
        }

        function updateMeter(k:Int, _arg_2:Bool=true)
        {
            var _local_4 = false;
            var _local_3= 1;
            while (_local_3 < CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES.length)
            {
                _local_4 = (_arg_2 && (k >= CHALLENGE_LEVEL_NEEDLE_BASE_FRAMES[_local_3]));
                this._communityGoalContainer.findChildByName(("meter_level_" + Std.string(_local_3))).visible = _local_4;
                this._communityGoalContainer.findChildByName((("meter_level_" + Std.string(_local_3)) + "_icon")).visible = _local_4;
                this._communityGoalContainer.findChildByName((("meter_level_" + Std.string(_local_3)) + "_icon_locked")).visible = (!_local_4);
                _local_3++;
            }
            this._meterNeedle.assetUri = ("landing_view_needle_meter_needle" + Std.string(k));
        }

        public function refresh()
        {
            this.requestCommunityGoalProgress();
            this.refreshContent();
        }

        function requestCommunityGoalProgress()
        {
            if (!this._communityProgressRequested)
            {
                this._landingView.send(new GetCommunityGoalProgressMessageComposer());
                this._communityProgressRequested = true;
            }
        }

        public function update(k:UInt)
        {
            this._buildupDelay = (this._buildupDelay + k);
            if (this._buildupDelay > METER_INITIAL_DELAY_MS)
            {
                this._buildupProgress = (this._buildupProgress + (k / METER_BUILDUP_TIME_MS));
                if (this._buildupProgress > 1)
                {
                    this._buildupProgress = 1;
                    cast(this._landingView.windowManager, Component).removeUpdateReceiver(this);
                }
                this.updateMeter(Std.int(Math.ffloor((this.getCurrentNeedleFrame() * this._buildupProgress))));
            }
        }

        function onCommunityGoalProgress(k:IMessageEvent)
        {
            this._communityProgress = cast(k.parser, CommunityGoalProgressParser).data;
            this._communityProgressRequested = false;
            this.refreshContent();
            cast(this._landingView.windowManager, Component).registerUpdateReceiver(this, 10);
        }

        function onCommunityCatalogButtonClick(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._landingView.getProperty("landing.view.community.catalog.target");
                this._landingView.catalog.openCatalogPage(_local_3);
                this._landingView.tracking.trackGoogle("landingView", "click_communityCatalogTarget");
            }
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._communityGoalContainer, k);
return k;
        }

        var communityProgress(get,never):CommunityGoalData;
function  get_communityProgress():CommunityGoalData
        {
            return this._communityProgress;
        }
    }

