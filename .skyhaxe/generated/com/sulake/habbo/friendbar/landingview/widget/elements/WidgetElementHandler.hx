package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;

     class WidgetElementHandler 
    {
        public static inline final CAPTION= "caption";
        public static inline final TITLE= "title";
        public static inline final SUBCAPTION= "subcaption";
        public static inline final BODYTEXT= "bodytext";
        public static inline final SPACING= "spacing";
        public static inline final CATALOGBUTTON= "catalogbutton";
        public static inline final PROMOTEDROOMBUTTON= "promotedroombutton";
        public static inline final LINK= "link";
        public static inline final GOTOROOMBUTTON= "gotoroombutton";
        public static inline final REQUESTBADGEBUTTON= "requestbadgebutton";
        public static inline final REQUESTBADGEBUTTONSECOND= "requestbadgebuttonsecond";
        public static inline final REQUESTBADGEBUTTONTHIRD= "requestbadgebuttonthird";
        public static inline final REQUESTBADGEBUTTONFOURTH= "requestbadgebuttonfourth";
        public static inline final REQUESTBADGEBUTTONFIFTH= "requestbadgebuttonfifth";
        public static inline final CREDITHABBLETBUTTON= "credithabbletbutton";
        public static inline final COMMUNITYGOALTIMER= "communitygoaltimer";
        public static inline final CUSTOMTIMER= "customtimer";
        public static inline final GOTOHOMEROOMBUTTON= "gotohomeroombutton";
        public static inline final GOTOCOMPETITIONROOMBUTTON= "gotocompetitionroombutton";
        public static inline final REWARDBADGE= "rewardbadge";
        public static inline final IMAGE= "image";
        public static inline final SUBMITCOMPETITIONROOM= "submitcompetitionroom";
        public static inline final CONCURRENTUSERSMETER= "concurrentusersmeter";
        public static inline final CONCURRENTUSERSINFO= "concurrentusersinfo";
        public static inline final DAILYQUEST= "dailyquest";
        public static inline final BUYVIPBUTTON= "buyvipbutton";
        public static inline final COMMUNITYGOALSCORE= "communitygoalscore";
        public static inline final GAMECENTERBUTTON= "gamecenterbutton";
        public static inline final INTERNALLINKBUTTON= "internallinkbutton";

        public static function _Str_24129(k:String):IElementHandler
        {
            switch (k)
            {
                case WidgetElementHandler.CAPTION
                   | WidgetElementHandler.SUBCAPTION
                   | WidgetElementHandler.BODYTEXT:
                    return new TextElementHandler();
                case WidgetElementHandler.TITLE:
                    return new TitleElementHandler();
                case WidgetElementHandler.SPACING:
                    return new SpacingElementHandler();
                case WidgetElementHandler.CATALOGBUTTON:
                    return new CatalogButtonElementHandler();
                case WidgetElementHandler.PROMOTEDROOMBUTTON:
                    return new PromotedRoomButtonElementHandler();
                case WidgetElementHandler.LINK:
                    return new LinkElementHandler();
                case WidgetElementHandler.GOTOROOMBUTTON:
                    return new GoToRoomButtonElementHandler();
                case WidgetElementHandler.REQUESTBADGEBUTTON
                   | WidgetElementHandler.REQUESTBADGEBUTTONSECOND
                   | WidgetElementHandler.REQUESTBADGEBUTTONTHIRD
                   | WidgetElementHandler.REQUESTBADGEBUTTONFOURTH
                   | WidgetElementHandler.REQUESTBADGEBUTTONFIFTH:
                    return new RequestBadgeButtonElementHandler();
                case WidgetElementHandler.CREDITHABBLETBUTTON:
                    return new CreditHabbletButtonElementHandler();
                case WidgetElementHandler.COMMUNITYGOALTIMER:
                    return new CommunityGoalTimerElementHandler();
                case WidgetElementHandler.CUSTOMTIMER:
                    return new CustomTimerElementHandler();
                case WidgetElementHandler.GOTOHOMEROOMBUTTON:
                    return new GoToHomeRoomButtonElementHandler();
                case WidgetElementHandler.GOTOCOMPETITIONROOMBUTTON:
                    return new GoToCompetitionRoomButtonElementHandler();
                case WidgetElementHandler.REWARDBADGE:
                    return new RewardBadgeElementHandler();
                case WidgetElementHandler.IMAGE:
                    return new ImageElementHandler();
                case WidgetElementHandler.SUBMITCOMPETITIONROOM:
                    return new SubmitCompetitionRoomElementHandler();
                case WidgetElementHandler.CONCURRENTUSERSMETER:
                    return new ConcurrentUsersMeterElementHandler();
                case WidgetElementHandler.CONCURRENTUSERSINFO:
                    return new ConcurrentUsersInfoElementHandler();
                case WidgetElementHandler.DAILYQUEST:
                    return new DailyQuestElementHandler();
                case WidgetElementHandler.BUYVIPBUTTON:
                    return new BuyVipButtonElementHandler();
                case WidgetElementHandler.COMMUNITYGOALSCORE:
                    return new CommunityGoalScoreCounterElementHandler();
                case WidgetElementHandler.GAMECENTERBUTTON:
                    return new GameCenterButtonElementHandler();
                case WidgetElementHandler.INTERNALLINKBUTTON:
                    return new InternalLinkButtonElementHandler();
            }
            return null;
        }

	public function new() {}
    }

