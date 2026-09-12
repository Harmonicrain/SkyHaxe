package com.sulake.habbo.notifications.feed
;

     class FeedSettings 
    {
        public static inline final FEED_SECTION_URGENT= 0;
        public static inline final FEED_SECTION_ACTIONS= 1;
        public static inline final FEED_SECTION_PERSISTENT= 2;
        public static inline final FEED_SECTION_NOTIFICATIONS= 3;
        public static inline final FEED_CATEGORY_ME= 0;
        public static inline final FEED_CATEGORY_FRIENDS= 1;
        public static inline final FEED_CATEGORY_HOTEL= 2;

        var _feed:NotificationController;
        var _visibleFeedCategories:Vector<Int>;

        public function new(k:NotificationController)
        {
            this._visibleFeedCategories = new Vector<Int>();
            this._visibleFeedCategories.push(FeedSettings.FEED_CATEGORY_FRIENDS);
            this._visibleFeedCategories.push(FeedSettings.FEED_CATEGORY_ME);
            this._visibleFeedCategories.push(FeedSettings.FEED_CATEGORY_HOTEL);
        }

        public function dispose()
        {
            this._feed = null;
            this._visibleFeedCategories = null;
        }

        public function _Str_22647():Vector<Int>
        {
            return this._visibleFeedCategories;
        }

        public function _Str_24684(k:Int)
        {
            this._feed.updateFeedCategoryFiltering();
        }
    }

