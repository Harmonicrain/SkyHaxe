package com.sulake.habbo.navigator.domain
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.habbo.navigator.mainview.tabpagedecorators.ITabPageDecorator;

     class Tab 
    {
        var _navigator:HabboNavigator;
        var _id:Int = 0;
        var _defaultSearchType:Int = 0;
        var _button:ITabButtonWindow;
        var _tabPageDecorator:ITabPageDecorator;
        var _selected:Bool = false;
        var _searchMsg:Int = 0;

        public function new(k:HabboNavigator, _arg_2:Int, _arg_3:Int, _arg_4:ITabPageDecorator, _arg_5:Int=1)
        {
            this._navigator = k;
            this._id = _arg_2;
            this._defaultSearchType = _arg_3;
            this._tabPageDecorator = _arg_4;
            this._searchMsg = _arg_5;
        }

        public function sendSearchRequest()
        {
            var k= this._navigator.context.configuration.getBoolean("navigator.2014.personalized.navigator");
            if ((k && (this.id == Tabs.TAB_ROOMS)))
            {
                this._defaultSearchType = Tabs.SEARCHTYPE_RECOMMENDED_ROOMS;
            }
            this._navigator.mainViewCtrl.startSearch(this._id, this._defaultSearchType, "-1", this._searchMsg);
        }

        
        public var selected(get,set):Bool;
public function  set_selected(k:Bool):Bool        {
            return this._selected = k;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var defaultSearchType(get,never):Int;
public function  get_defaultSearchType():Int
        {
            return this._defaultSearchType;
        }
public function  get_selected():Bool
        {
            return this._selected;
        }

        public var _Str_5252(get,never):ITabPageDecorator;
public function  get__Str_5252():ITabPageDecorator
        {
            return this._tabPageDecorator;
        }

        public var searchMsg(get,never):Int;
public function  get_searchMsg():Int
        {
            return this._searchMsg;
        }

        
        public var button(get,set):ITabButtonWindow;
public function  get_button():ITabButtonWindow
        {
            return this._button;
        }
public function  set_button(k:ITabButtonWindow):ITabButtonWindow        {
            return this._button = k;
        }
    }

