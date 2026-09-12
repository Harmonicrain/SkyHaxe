package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.navigator.mainview.MainViewCtrl;

     class OfficialTabPageDecorator implements ITabPageDecorator 
    {
        var _navigator:HabboNavigator;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
        }

        public function refreshCustomContent(k:IWindowContainer)
        {
        }

        public function tabSelected()
        {
        }

        public function refreshFooter(k:IWindowContainer)
        {
            this._navigator.officialRoomEntryManager._Str_21717(k);
        }

        public function navigatorOpenedWhileInTab()
        {
            this._navigator.mainViewCtrl.startSearch(Tabs.TAB_OFFICIAL, Tabs.SEARCHTYPE_OFFICIALROOMS, "-1", MainViewCtrl.SEARCHMSG_OFFICIALROOMS);
        }

        public var filterCategory(get,never):String;
public function  get_filterCategory():String
        {
            return null;
        }

        public function setSubSelection(k:Int)
        {
        }

        public function processSearchParam(k:String):String
        {
            return k;
        }
    }

