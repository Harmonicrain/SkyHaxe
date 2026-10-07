package com.sulake.habbo.navigator.transitional
;
    import com.sulake.habbo.navigator.mainview.ITransitionalMainViewCtrl;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.navigator.TextSearchInputs;
    import flash.geom.Point;

     class FakeMainViewCtrl implements ITransitionalMainViewCtrl 
    {
        var _newNavigator:HabboNewNavigator;
        var _oldNavigator:HabboNavigator;

        public function new(k:HabboNewNavigator, _arg_2:HabboNavigator)
        {
            this._newNavigator = k;
            this._oldNavigator = _arg_2;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return (this._newNavigator == null) && (this._oldNavigator == null);
        }

        public function _Str_18392()
        {
            this._newNavigator.toggle();
        }

        public function dispose()
        {
            this._newNavigator = null;
            this._oldNavigator = null;
        }

        public function open()
        {
            this._newNavigator.open();
        }

        public function isOpen():Bool
        {
            return false;
        }

        public function close()
        {
            this._newNavigator.close();
        }

        public var mainWindow(get,never):IFrameWindow;
public function  get_mainWindow():IFrameWindow
        {
            return this._newNavigator.mainWindow;
        }

        public function refresh()
        {
            this._newNavigator.refresh();
        }

        public function reloadRoomList(k:Int):Bool
        {
            this._newNavigator.refresh();
            return true;
        }

        function _Str_22867(k:Int):String
        {
            switch (k)
            {
                case Tabs.SEARCHTYPE_POPULAR_ROOMS:
                    return "popular";
                case Tabs.SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE:
                    return "highest_score";
                case Tabs.SEARCHTYPE_MY_FRIENDS_ROOMS:
                    return "friends_rooms";
                case Tabs.SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE:
                    return "with_friends";
                case Tabs.SEARCHTYPE_MY_ROOMS:
                    return "my";
                case Tabs.SEARCHTYPE_MY_FAVOURITES:
                    return "favorites";
                case Tabs.SEARCHTYPE_MY_HISTORY:
                    return "history";
                case Tabs.SEARCHTYPE_TEXT_SEARCH:
                    return "query";
                case Tabs.SEARCHTYPE_TAG_SEARCH:
                    return "query";
                case Tabs.SEARCHTYPE_ROOM_NAME_SEARCH:
                    return "query";
                case Tabs.SEARCHTYPE_OFFICIALROOMS:
                    return "official";
                case Tabs.SEARCHTYPE_LATEST_EVENTS:
                    return "new_ads";
                case Tabs.SEARCHTYPE_GROUP_NAME_SEARCH:
                    return "groups";
                case Tabs.SEARCHTYPE_GUILD_BASES:
                    return "groups";
                case Tabs.SEARCHTYPE_COMPETITION_ROOMS:
                    return "competition";
                case Tabs.SEARCHTYPE_ROOM_ADS:
                    return "top_promotions";
                case Tabs.SEARCHTYPE_NEW_ROOM_ADS:
                    return "new_ads";
                case Tabs.SEARCHTYPE_ROOMS_WITH_RIGHTS:
                    return "with_rights";
                case Tabs.SEARCHTYPE_MY_GUILD_BASES:
                    return "my_groups";
                case Tabs.SEARCHTYPE_BY_OWNER:
                    return "query";
                case Tabs.SEARCHTYPE_CATEGORIES:
                    return "all_categories";
                case Tabs.SEARCHTYPE_RECOMMENDED_ROOMS:
                    return "recommended";
                case Tabs.SEARCHTYPE_FREQUENT_HISTORY:
                    return "history_freq";
                default:
                    return "query";
            }
        }

        public function startSearch(k:Int, _arg_2:Int, _arg_3:String="-1", _arg_4:Int=1)
        {
            this._newNavigator.performSearch(this._Str_22867(_arg_2), _arg_3);
        }

        public function update(k:UInt)
        {
        }

        public var searchInput(get,never):TextSearchInputs;
public function  get_searchInput():TextSearchInputs
        {
            return this._oldNavigator.mainViewCtrl.searchInput;
        }

        public function openAtPosition(k:Point)
        {
            return this._newNavigator.open();
        }

        public var isPhaseOneNavigator(get,never):Bool;
public function  get_isPhaseOneNavigator():Bool
        {
            return this._oldNavigator.mainViewCtrl.isPhaseOneNavigator;
        }
    }

