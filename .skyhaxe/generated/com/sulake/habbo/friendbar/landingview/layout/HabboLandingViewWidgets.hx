package com.sulake.habbo.friendbar.landingview.layout
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.widget.CommunityGoalHallOfFameWidget;
    import com.sulake.habbo.friendbar.landingview.widget.CommunityGoalPrizesWidget;
    import com.sulake.habbo.friendbar.landingview.widget.AvatarImageWidget;
    import com.sulake.habbo.friendbar.landingview.widget.CommunityGoalWidget;
    import com.sulake.habbo.friendbar.landingview.widget.CommunityGoalVsModeWidget;
    import com.sulake.habbo.friendbar.landingview.widget.CommunityGoalVsModeWidgetWithVoting;
    import com.sulake.habbo.friendbar.landingview.widget.CatalogPromoWidget;
    import com.sulake.habbo.friendbar.landingview.widget.CatalogPromoSmallWidget;
    import com.sulake.habbo.friendbar.landingview.widget.DailyQuestWidget;
    import com.sulake.habbo.friendbar.landingview.widget.ExpiringCatalogPageWidget;
    import com.sulake.habbo.friendbar.landingview.widget.ExpiringCatalogPageSmallWidget;
    import com.sulake.habbo.friendbar.landingview.widget.NextLimitedRareCountdownWidget;
    import com.sulake.habbo.friendbar.landingview.widget.HabboModerationPromoWidget;
    import com.sulake.habbo.friendbar.landingview.widget.HabboTalentsPromoWidget;
    import com.sulake.habbo.friendbar.landingview.widget.HabboWayPromoWidget;
    import com.sulake.habbo.friendbar.landingview.widget.FastFoodGamePromoWidget;
    import com.sulake.habbo.friendbar.landingview.widget.RoomHopperNetworkWidget;
    import com.sulake.habbo.friendbar.landingview.widget.SafetyQuizPromoWidget;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.friendbar.landingview.widget.WidgetContainerWidget;
    import com.sulake.habbo.friendbar.landingview.widget.PromoArticleWidget;
    import com.sulake.habbo.friendbar.landingview.widget.BonusRareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;

     class HabboLandingViewWidgets 
    {
        public static inline final AVATAR_IMAGE= "avatarimage";
        public static inline final EXPIRING_CATALOG_PAGE= "expiringcatalogpage";
        public static inline final EXPIRING_CATALOG_PAGE_SMALL= "expiringcatalogpagesmall";
        public static inline final COMMUNITY_GOAL= "communitygoal";
        public static inline final COMMUNITY_GOAL_VS_MODE= "communitygoalvsmode";
        public static inline final COMMUNITY_GOAL_VS_MODE_VOTE= "communitygoalvsmodevote";
        public static inline final CATALOG_PROMO= "catalogpromo";
        public static inline final CATALOG_PROMO_SMALL= "catalogpromosmall";
        public static inline final ACHIEVEMENT_COMPETITION_HALL_OF_FAME= "achievementcompetition_hall_of_fame";
        public static inline final ACHIEVEMENT_COMPETITION_PRIZES= "achievementcompetition_prizes";
        public static inline final DAILYQUEST= "dailyquest";
        public static inline final NEXT_LIMITED_RARE_COUNTDOWN= "nextlimitedrarecountdown";
        public static inline final HABBO_MODERATION_PROMO= "habbomoderationpromo";
        public static inline final HABBO_TALENTS_PROMO= "habbotalentspromo";
        public static inline final HABBO_WAY_PROMO= "habbowaypromo";
        public static inline final FASTFOOD_GAME_PROMO= "fastfoodgamepromo";
        public static inline final ROOMHOPPER_NETWORK= "roomhoppernetwork";
        public static inline final SAFETY_QUIZ_PROMO= "safetyquizpromo";
        public static inline final GENERIC= "generic";
        public static inline final WIDGET_CONTAINER= "widgetcontainer";
        public static inline final PROMO_ARTICLE= "promoarticle";
        public static inline final BONUS_RARE= "bonusrare";


        public static function createWidget(widgetCode:String, landingView:HabboLandingView):ILandingViewWidget
        {
            var widget:ILandingViewWidget = null;
            switch (widgetCode)
            {
                case HabboLandingViewWidgets.ACHIEVEMENT_COMPETITION_HALL_OF_FAME:
                    widget = new CommunityGoalHallOfFameWidget(landingView);
                    
                case HabboLandingViewWidgets.ACHIEVEMENT_COMPETITION_PRIZES:
                    widget = new CommunityGoalPrizesWidget(landingView);
                    
                case HabboLandingViewWidgets.AVATAR_IMAGE:
                    widget = new AvatarImageWidget(landingView);
                    
                case HabboLandingViewWidgets.COMMUNITY_GOAL:
                    widget = new CommunityGoalWidget(landingView);
                    
                case HabboLandingViewWidgets.COMMUNITY_GOAL_VS_MODE:
                    widget = new CommunityGoalVsModeWidget(landingView);
                    
                case HabboLandingViewWidgets.COMMUNITY_GOAL_VS_MODE_VOTE:
                    widget = new CommunityGoalVsModeWidgetWithVoting(landingView);
                    
                case HabboLandingViewWidgets.CATALOG_PROMO:
                    widget = new CatalogPromoWidget(landingView);
                    
                case HabboLandingViewWidgets.CATALOG_PROMO_SMALL:
                    widget = new CatalogPromoSmallWidget(landingView);
                    
                case HabboLandingViewWidgets.DAILYQUEST:
                    widget = new DailyQuestWidget(landingView);
                    
                case HabboLandingViewWidgets.EXPIRING_CATALOG_PAGE:
                    widget = new ExpiringCatalogPageWidget(landingView);
                    
                case HabboLandingViewWidgets.EXPIRING_CATALOG_PAGE_SMALL:
                    widget = new ExpiringCatalogPageSmallWidget(landingView);
                    
                case HabboLandingViewWidgets.NEXT_LIMITED_RARE_COUNTDOWN:
                    widget = new NextLimitedRareCountdownWidget(landingView);
                    
                case HabboLandingViewWidgets.HABBO_MODERATION_PROMO:
                    widget = new HabboModerationPromoWidget(landingView);
                    
                case HabboLandingViewWidgets.HABBO_TALENTS_PROMO:
                    widget = new HabboTalentsPromoWidget(landingView);
                    
                case HabboLandingViewWidgets.HABBO_WAY_PROMO:
                    widget = new HabboWayPromoWidget(landingView);
                    
                case HabboLandingViewWidgets.FASTFOOD_GAME_PROMO:
                    widget = new FastFoodGamePromoWidget(landingView);
                    
                case HabboLandingViewWidgets.ROOMHOPPER_NETWORK:
                    widget = new RoomHopperNetworkWidget(landingView);
                    
                case HabboLandingViewWidgets.SAFETY_QUIZ_PROMO:
                    widget = new SafetyQuizPromoWidget(landingView);
                    
                case HabboLandingViewWidgets.GENERIC:
                    widget = new GenericWidget(landingView);
                    
                case HabboLandingViewWidgets.WIDGET_CONTAINER:
                    widget = new WidgetContainerWidget(landingView);
                    
                case HabboLandingViewWidgets.PROMO_ARTICLE:
                    widget = new PromoArticleWidget(landingView);
                    
                case HabboLandingViewWidgets.BONUS_RARE:
                    widget = new BonusRareWidget(landingView);
                    
            }
            return widget;
        }

	public function new() {}
    }

