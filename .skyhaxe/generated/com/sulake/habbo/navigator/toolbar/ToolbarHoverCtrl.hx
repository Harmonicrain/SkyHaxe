package com.sulake.habbo.navigator.toolbar
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.utils.Timer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.CanCreateRoomMessageComposer;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Point;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IBorderWindow;

     class ToolbarHoverCtrl
    {
        static inline final _Str_18494:UInt = 7433577;
        static inline final _Str_18752:UInt = 5723213;

        static inline final _Str_24574= "item_list";
        static inline final _Str_22393= "SIMPLE_ITEM";

        var _disposed:Bool = false;
        var _habboNavigator:HabboNavigator;
        var _localizationManager:IHabboLocalizationManager;
        var _window:IWindowContainer;
        var _list:IItemListWindow;
        var _Str_13051:IWindowContainer;
        var _Str_4789:Timer;
        var _Str_7476:Bool = false;

        public function new(k:HabboNavigator)
        {
            this._habboNavigator = k;
            this._localizationManager = k.localization;
            this._window = cast(this._habboNavigator.getXmlWindow("toolbar_hover"), IWindowContainer);
            this._list = cast(this._window.findChildByName(ToolbarHoverCtrl._Str_24574), IItemListWindow);
            this._Str_13051 = cast(this._list.getListItemByTag(ToolbarHoverCtrl._Str_22393), IWindowContainer);
            this._list.removeListItem(this._Str_13051);
            this._window.addEventListener(WindowMouseEvent.OVER, this._Str_19268);
            this._window.addEventListener(WindowMouseEvent.HOVERING, this._Str_19268);
            this._window.addEventListener(WindowMouseEvent.OUT, this._Str_20048);
            this._Str_9244("navigator", "${navigator.title}", this._Str_23296);
            this._Str_9244("home", "${toolbar.icon.label.exitroom.home}", this._Str_23229);
            this._Str_9244("favorites", "${navigator.navisel.myfavourites}", this._Str_26475);
            this._Str_9244("create", "${navigator.createroom.create}", this.onCreateRoomClick);
            this._Str_9244("history", "${navigator.navisel.visitedrooms}", this._Str_23602);
            this._Str_9244("frequent", "${navigator.navisel.frequentvisits}", this._Str_24692);
        }

        public function dispose()
        {
            this._disposed = true;
            if (this._Str_4789 != null)
            {
                this._Str_4789.reset();
                this._Str_4789 = null;
            }
            this._list = null;
            this._window = null;
            this._Str_13051 = null;
            this._habboNavigator = null;
            this._localizationManager = null;
        }

        function _Str_23296(k:WindowMouseEvent)
        {
            this._habboNavigator.openNavigator();
            this._habboNavigator.goToMainView();
            this._Str_8696();
        }

        function _Str_23229(k:WindowMouseEvent)
        {
            var _local_2= this._habboNavigator.data.homeRoomId;
            if (_local_2 > -1)
            {
                this._habboNavigator.goToPrivateRoom(_local_2);
                this._Str_8696();
            }
        }

        function _Str_26475(k:WindowMouseEvent)
        {
            this._habboNavigator.showFavouriteRooms();
            this._Str_8696();
        }

        function onCreateRoomClick(k:WindowMouseEvent)
        {
            this._habboNavigator.send(new CanCreateRoomMessageComposer());
            this._Str_8696();
        }

        function _Str_23602(k:WindowMouseEvent)
        {
            this._habboNavigator.showHistoryRooms();
            this._Str_8696();
        }

        function _Str_24692(k:WindowMouseEvent)
        {
            this._habboNavigator.showFrequentRooms();
            this._Str_8696();
        }

        function _Str_9244(k:String, _arg_2:String, _arg_3:ASFunction)
        {
            var _local_4= cast(this._Str_13051.clone(), IWindowContainer);
            _local_4.name = k;
            Std.downcast(_local_4.getChildByName("text") , ITextWindow).text = _arg_2;
            _local_4.addEventListener(WindowMouseEvent.CLICK, _arg_3);
            _local_4.addEventListener(WindowMouseEvent.OVER, this._Str_20179);
            _local_4.addEventListener(WindowMouseEvent.OUT, this._Str_20179);
            this._list.addListItem(_local_4);
        }

        public function show(k:Point)
        {
            this._Str_17438();
            this._window.visible = true;
            this._window.position = k;
        }

        public function _Str_14093()
        {
            if ((this._disposed || this._Str_7476))
            {
                return;
            }
            this._Str_25410();
        }

        public function _Str_8696()
        {
            if (this._disposed)
            {
                return;
            }
            this._Str_17438();
            this._Str_7476 = false;
            this._window.visible = false;
        }

        public function hide()
        {
            if ((this._disposed || this._Str_7476))
            {
                return;
            }
            this._Str_17438();
            this._Str_7476 = false;
            this._window.visible = false;
        }

        function _Str_25410()
        {
            if (this._Str_4789 == null)
            {
                this._Str_4789 = new Timer(500, 1);
                this._Str_4789.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                this._Str_4789.start();
            }
            else
            {
                this._Str_4789.reset();
                this._Str_4789.start();
            }
        }

        function _Str_17438()
        {
            if (((this._Str_4789 != null) && this._Str_4789.running))
            {
                this._Str_4789.reset();
            }
        }

        function onTimerComplete(k:Event)
        {
            this.hide();
        }

        function _Str_20179(k:WindowMouseEvent)
        {
            var _local_4 = false;
            var _local_2= cast(k.target, IRegionWindow);
            var _local_3= cast(_local_2.findChildByName("background"), IBorderWindow);
            if (_local_3 != null)
            {
                _local_4 = (k.type == WindowMouseEvent.OVER);
                _local_3.color = (_local_4 ? _Str_18494 : _Str_18752);
                this._Str_20048(k);
            }
        }

        function _Str_19268(k:WindowMouseEvent)
        {
            this._Str_7476 = true;
        }

        function _Str_20048(k:WindowMouseEvent)
        {
            if (this._window.hitTestGlobalPoint(new Point(k.stageX, k.stageY)))
            {
                this._Str_7476 = true;
                return;
            }
            this._Str_7476 = false;
            this._Str_14093();
        }
    }

