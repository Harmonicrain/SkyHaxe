package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.navigator.domain.Tabs;

     class CategoriesTabPageDecorator implements ITabPageDecorator 
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

        public function navigatorOpenedWhileInTab()
        {
            this._navigator.mainViewCtrl.startSearch(Tabs.TAB_CATEGORIES, Tabs.SEARCHTYPE_CATEGORIES);
        }

        public function refreshFooter(k:IWindowContainer)
        {
        }

        public function setSubSelection(k:Int)
        {
        }

        public var filterCategory(get,never):String;
public function  get_filterCategory():String
        {
            return null;
        }

        public function processSearchParam(k:String):String
        {
            return "";
        }
    }

