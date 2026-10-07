package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalProgressMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserChangeMessageEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.habbo.friendbar.landingview.*;

     class CommunityGoalPrizesWidget implements ILandingViewWidget implements  ISettingsAwareWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _data:CommunityGoalData;
        var _figure:String;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            this._landingView = null;
            this._container = null;
            this._data = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("achievement_competition_prizes"), IWindowContainer);
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new CommunityGoalProgressMessageEvent(this.onCommunityGoalProgress));
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new UserObjectEvent(this.onUserObject));
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new UserChangeMessageEvent(this.onUserChange));
        }

        public function refresh()
        {
            this.refreshContent();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        function refreshContent()
        {
            if (this._data == null)
            {
                this._container.visible = false;
                return;
            }
            this._container.visible = true;
            this._Str_15938(1);
            this._Str_15938(2);
            this._Str_15938(3);
            this._landingView.localizationManager.registerParameter(this._Str_20594("yourrankinfo"), "points", ("" + Std.string(this._data.personalContributionScore)));
            this._container.findChildByName("caption_txt").caption = this._Str_6273("caption");
            this._container.findChildByName("info_txt").caption = this._Str_6273("info");
            this._container.findChildByName("reward_name_txt").caption = this._Str_6273("rewardname");
            this._container.findChildByName("reward_info_txt").caption = this._Str_6273("rewardinfo");
            this._container.findChildByName("rank_1_txt").caption = this._Str_6273("rank1");
            this._container.findChildByName("rank_2_txt").caption = this._Str_6273("rank2");
            this._container.findChildByName("rank_3_txt").caption = this._Str_6273("rank3");
            this._container.findChildByName("user_rank_border").visible = ((!this._data._Str_13028) || (this._data._Str_10549 > 0));
            var k= (this._data._Str_13028 ? "yourfinalrank" : ((this._data._Str_10549 > 0) ? "yourrank" : "youarenotranked"));
            this._landingView.localizationManager.registerParameter(this._Str_1196(k), "rank", ("" + Std.string(this._data._Str_10549)));
            this._container.findChildByName("user_rank_txt").caption = this.getText(k);
            this._container.findChildByName("user_rank_info_txt").visible = (!this._data._Str_13028);
            this._container.findChildByName("user_rank_info_txt").caption = this._Str_6273(((this._data._Str_10549 > 0) ? "yourrankinfo" : "youarenotrankedinfo"));
            cast(this._container.findChildByName("reward_image"), IStaticBitmapWrapperWindow).assetUri = (("${image.library.url}reception/" + this._data.goalCode) + "Reward.png");
        }

        function _Str_15938(k:Int)
        {
            var _local_2= this._Str_24483(k);
            var _local_3= this._Str_24585(k);
            var _local_4= ((_local_2 == _local_3) ? this._Str_1196("rank") : this._Str_1196("ranks"));
            this._landingView.localizationManager.registerParameter(_local_4, "start", ("" + Std.string(_local_2)));
            this._landingView.localizationManager.registerParameter(_local_4, "end", ("" + Std.string(_local_3)));
            this._container.findChildByName((("rank_" + Std.string(k)) + "_info_txt")).caption = (("${" + _local_4) + "}");
        }

        function _Str_24483(k:Int):Int
        {
            var _local_2= ASCompat.toInt(this._data._Str_20155[(k - 2)]);
            return _local_2 + 1;
        }

        function _Str_24585(k:Int):Int
        {
            return ASCompat.toInt(this._data._Str_20155[(k - 1)]);
        }

        function onCommunityGoalProgress(k:CommunityGoalProgressMessageEvent)
        {
            this._data = k.getParser().data;
            this.refreshContent();
        }

        function _Str_1196(k:String):String
        {
            return "landing.view.competition.prizes." + k;
        }

        function _Str_20594(k:String):String
        {
            return this._Str_1196(((this._data.goalCode + ".") + k));
        }

        function _Str_6273(k:String):String
        {
            var _local_2= this._Str_20594(k);
            return ("${" + _local_2) + "}";
        }

        function getText(k:String):String
        {
            var _local_2= this._Str_1196(k);
            return ("${" + _local_2) + "}";
        }

        function onUserObject(k:UserObjectEvent)
        {
            this._figure = k.getParser().figure;
            this._Str_7815();
        }

        function onUserChange(k:UserChangeMessageEvent)
        {
            if (((!(k == null)) && (k.id == -1)))
            {
                this._figure = k.figure;
                this._Str_7815();
            }
        }

        function _Str_7815()
        {
            var k= cast(this._container.findChildByName("avatar_image"), IWidgetWindow);
            var _local_2= cast(k.widget, IAvatarImageWidget);
            _local_2.figure = this._figure;
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }
    }



