package com.sulake.habbo.navigator.domain
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.EventsTabPageDecorator;
    import com.sulake.habbo.navigator.mainview.MainViewCtrl;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.CategoriesTabPageDecorator;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.RoomsTabPageDecorator;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.OfficialTabPageDecorator;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.MyRoomsTabPageDecorator;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.SearchTabPageDecorator;
    import com.sulake.habbo.navigator.mainview.*;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.*;

     class Tabs 
    {
        public static inline final TAB_EVENTS= 1;
        public static inline final TAB_ROOMS= 2;
        public static inline final TAB_ME= 3;
        public static inline final TAB_OFFICIAL= 4;
        public static inline final TAB_SEARCH= 5;
        public static inline final TAB_CATEGORIES= 6;
        static final TAB_NAMES:ASDictionary<ASAny,ASAny> = new ASDictionary();
        public static inline final SEARCHTYPE_POPULAR_ROOMS= 1;
        public static inline final SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE= 2;
        public static inline final SEARCHTYPE_MY_FRIENDS_ROOMS= 3;
        public static inline final SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE= 4;
        public static inline final SEARCHTYPE_MY_ROOMS= 5;
        public static inline final SEARCHTYPE_MY_FAVOURITES= 6;
        public static inline final SEARCHTYPE_MY_HISTORY= 7;
        public static inline final SEARCHTYPE_TEXT_SEARCH= 8;
        public static inline final SEARCHTYPE_TAG_SEARCH= 9;
        public static inline final SEARCHTYPE_ROOM_NAME_SEARCH= 10;
        public static inline final SEARCHTYPE_OFFICIALROOMS= 11;
        public static inline final SEARCHTYPE_LATEST_EVENTS= 12;
        public static inline final SEARCHTYPE_GROUP_NAME_SEARCH= 13;
        public static inline final SEARCHTYPE_GUILD_BASES= 14;
        public static inline final SEARCHTYPE_COMPETITION_ROOMS= 15;
        public static inline final SEARCHTYPE_ROOM_ADS= 16;
        public static inline final SEARCHTYPE_NEW_ROOM_ADS= 17;
        public static inline final SEARCHTYPE_ROOMS_WITH_RIGHTS= 18;
        public static inline final SEARCHTYPE_MY_GUILD_BASES= 19;
        public static inline final SEARCHTYPE_BY_OWNER= 20;
        public static inline final SEARCHTYPE_CATEGORIES= 21;
        public static inline final SEARCHTYPE_RECOMMENDED_ROOMS= 22;
        public static inline final SEARCHTYPE_FREQUENT_HISTORY= 23;

        var _tabs:Array<ASAny>;
        var _navigator:HabboNavigator;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
            this._tabs = new Array<ASAny>();
            this._tabs.push(new Tab(this._navigator, TAB_EVENTS, SEARCHTYPE_ROOM_ADS, new EventsTabPageDecorator(this._navigator), MainViewCtrl.SEARCHMSG_SEARCH));
            this._tabs.push(new Tab(this._navigator, TAB_CATEGORIES, SEARCHTYPE_CATEGORIES, new CategoriesTabPageDecorator(this._navigator), MainViewCtrl.SEARCHMSG_CATEGORIESWITHUSERCOUNT));
            this._tabs.push(new Tab(this._navigator, TAB_ROOMS, SEARCHTYPE_POPULAR_ROOMS, new RoomsTabPageDecorator(this._navigator), MainViewCtrl.SEARCHMSG_SEARCH));
            this._tabs.push(new Tab(this._navigator, TAB_OFFICIAL, SEARCHTYPE_OFFICIALROOMS, new OfficialTabPageDecorator(this._navigator), MainViewCtrl.SEARCHMSG_OFFICIALROOMS));
            this._tabs.push(new Tab(this._navigator, TAB_ME, SEARCHTYPE_MY_ROOMS, new MyRoomsTabPageDecorator(this._navigator), MainViewCtrl.SEARCHMSG_SEARCH));
            this._tabs.push(new Tab(this._navigator, TAB_SEARCH, SEARCHTYPE_TEXT_SEARCH, new SearchTabPageDecorator(this._navigator), MainViewCtrl.SEARCHMSG_POPTAGS));
            this.setSelectedTab(TAB_EVENTS);
        }

        public static function tabIdFromName(k:String, _arg_2:Int):Int
        {
            return ASCompat.toInt(TAB_NAMES.exists(k ) ? ASCompat.toInt(TAB_NAMES[k] ): _arg_2);
        }


        public function onFrontPage():Bool
        {
            return this.getSelected().id == TAB_OFFICIAL;
        }

        public var tabs(get,never):Array<ASAny>;
public function  get_tabs():Array<ASAny>
        {
            return this._tabs;
        }

        public function setSelectedTab(k:Int)
        {
            var _local_2= this.getTab(k);
            if (_local_2 != null)
            {
                this.clearSelected();
                _local_2.selected = true;
            }
        }

        public function getSelected():Tab
        {
            var k:Tab = null;
            final _iter_ = this._tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.selected)
                {
                    return k;
                }
            }
            return null;
        }

        function clearSelected()
        {
            var k:Tab = null;
            final _iter_ = this._tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.selected = false;
            }
        }

        public function getTab(k:Int):Tab
        {
            var _local_2:Tab = null;
            final _iter_ = this._tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

	static final ___init = {

        {
            TAB_NAMES["popular"] = TAB_ROOMS;
            TAB_NAMES["official"] = TAB_OFFICIAL;
            TAB_NAMES["me"] = TAB_ME;
            TAB_NAMES["events"] = TAB_EVENTS;
            TAB_NAMES["search"] = TAB_SEARCH;
            TAB_NAMES["categories"] = TAB_CATEGORIES;
        }

	null;
	};
    }

