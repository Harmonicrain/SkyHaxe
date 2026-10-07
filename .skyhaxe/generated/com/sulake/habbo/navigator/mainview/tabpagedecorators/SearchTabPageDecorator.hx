package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class SearchTabPageDecorator implements ITabPageDecorator 
    {
        var _navigator:HabboNavigator;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
        }

        public function refreshCustomContent(k:IWindowContainer)
        {
            this._Str_25530(k);
        }

        public function tabSelected()
        {
        }

        public function refreshFooter(k:IWindowContainer)
        {
        }

        public function navigatorOpenedWhileInTab()
        {
            this._navigator.mainViewCtrl.open();
        }

        public var filterCategory(get,never):String;
public function  get_filterCategory():String
        {
            return null;
        }

        function _Str_25530(k:IWindowContainer)
        {
            var _local_2= Std.downcast(k.getChildByName("room_competitions_header") , IWindowContainer);
            if (((this._navigator.data == null) || (this._navigator.data._Str_4079 == null)))
            {
                _local_2.visible = false;
                return;
            }
            var _local_3= this._navigator.data._Str_4079.pageIndex;
            var _local_4= this._navigator.data._Str_4079._Str_8849;
            var _local_5= (_local_3 + 1);
            if (_local_4 < 2)
            {
                _local_2.visible = false;
                return;
            }
            _local_2.visible = true;
            this._navigator.registerParameter("navigator.roomcompetitionspager", "page", ("" + Std.string(_local_5)));
            this._navigator.registerParameter("navigator.roomcompetitionspager", "total", ("" + Std.string(_local_4)));
            var _local_6= _local_2.findChildByName("next_button");
            var _local_7= _local_2.findChildByName("prev_button");
            _local_6.visible = (_local_5 < _local_4);
            _local_7.visible = (_local_5 > 1);
            _local_6.procedure = this._Str_22311;
            _local_7.procedure = this._Str_25590;
        }

        function _Str_22311(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && (!(this._navigator.data._Str_4079 == null))))
            {
                this._navigator.performCompetitionRoomsSearch(this._navigator.data._Str_4079.goalId, (this._navigator.data._Str_4079.pageIndex + 1));
            }
        }

        function _Str_25590(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && (!(this._navigator.data._Str_4079 == null))))
            {
                this._navigator.performCompetitionRoomsSearch(this._navigator.data._Str_4079.goalId, (this._navigator.data._Str_4079.pageIndex - 1));
            }
        }

        public function setSubSelection(k:Int)
        {
        }

        public function processSearchParam(k:String):String
        {
            return k;
        }
    }

