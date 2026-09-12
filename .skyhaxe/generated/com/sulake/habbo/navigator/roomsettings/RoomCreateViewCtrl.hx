package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.navigator.domain.RoomLayout;
    import flash.utils.Timer;
    import com.sulake.habbo.navigator.TextFieldManager;
    import com.sulake.core.window.components.IDropMenuWindow;
    import flash.events.TimerEvent;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.events.Event;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.navigator.Util;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.CreateFlatMessageComposer;
    import com.sulake.habbo.navigator.*;

     class RoomCreateViewCtrl 
    {
        static inline final ROOM_LIMIT_HC= 75;
        static inline final ROOM_LIMIT_NON_SUBSCRIBER= 50;

        var _navigator:IHabboTransitionalNavigator;
        var _content:IWindowContainer;
        var _list:IItemListWindow;
        var _layouts:Vector<RoomLayout>;
        var _selectedLayout:RoomLayout;
        var _arrowTimer:Timer;
        var _arrowMovingDown:Bool = true;
        var _roomNameInput:TextFieldManager;
        var _roomDescInput:TextFieldManager;
        var _categoryMenu:IDropMenuWindow;
        var _maxVisitors:IDropMenuWindow;
        var _tradeSettings:IDropMenuWindow;
        var _selectableAndVisibleCategories:Array<ASAny>;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._selectableAndVisibleCategories = [];
            this._navigator = k;
            this._arrowTimer = new Timer(100);
            this._arrowTimer.addEventListener(TimerEvent.TIMER, (this._Str_19844 : ASAny));
            this._layouts = new Vector<RoomLayout>();
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 104, "a"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 94, "b"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 36, "c"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 84, "d"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 80, "e"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 80, "f"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 416, "i"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 320, "j"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 448, "k"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 352, "l"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 384, "m"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.NO_CLUB, 372, "n"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 80, "g"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 74, "h"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 416, "o"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 352, "p"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 304, "q"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 336, "r"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 748, "u"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.CLUB, 438, "v"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 540, "t"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 512, "w"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 396, "x"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 440, "y"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 456, "z"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 208, "0"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 1009, "1"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 1044, "2"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 183, "3"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 254, "4"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 1024, "5"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 801, "6"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 354, "7"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 888, "8"));
            this._layouts.push(new RoomLayout(HabboClubLevelEnum.VIP, 926, "9"));
            this._layouts.push(new RoomLayout(-1, 2500, "snowwar1"));
            this._layouts.push(new RoomLayout(-1, 2500, "snowwar2"));
        }

        static function addMouseClickListener(k:IWindow, _arg_2:ASFunction)
        {
            if (k != null)
            {
                k.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
                k.addEventListener(WindowMouseEvent.CLICK, _arg_2);
            }
        }


        public function dispose()
        {
            if (this._arrowTimer != null)
            {
                this._arrowTimer.removeEventListener(TimerEvent.TIMER, (this._Str_19844 : ASAny));
                this._arrowTimer.reset();
                this._arrowTimer = null;
            }
        }

        function _Str_19844(k:Event)
        {
            var _local_2= "select_arrow";
            var _local_3= cast(this._selectedLayout.view.findChildByName(_local_2), IBitmapWrapperWindow);
            var _local_4 = 0;
            var _local_5= 15;
            var _local_6= (((Math.abs((_local_3.y - _local_4)) < 2) || (Math.abs((_local_3.y - _local_5)) < 2)) ? 1 : 2);
            _local_3.y = (_local_3.y + (this._arrowMovingDown ? _local_6 : -_local_6));
            if (_local_3.y < _local_4)
            {
                this._arrowMovingDown = true;
                _local_3.y = (_local_4 + 1);
            }
            else
            {
                if (_local_3.y > _local_5)
                {
                    this._arrowMovingDown = false;
                    _local_3.y = (_local_5 - 1);
                }
            }
        }

        public function hide()
        {
            if (this._content != null)
            {
                this._content.visible = false;
            }
        }

        public function show()
        {
            this.prepare();
            this._content.visible = true;
            this.refresh();
            this._content.activate();
            this._arrowTimer.start();
        }

        function prepare()
        {
            if (this._content != null)
            {
                return;
            }
            this._content = cast(this._navigator.getXmlWindow("roc_create_room"), IWindowContainer);
            this._list = cast(this._content.findChildByName("layout_item_list"), IItemListWindow);
            this._Str_19409();
            var k= this.getCreateButton();
            addMouseClickListener(k, this.onCreateButtonClick);
            var _local_2= this._Str_25310();
            addMouseClickListener(_local_2, this._Str_4604);
            var _local_3= this._content.findChildByTag("close");
            addMouseClickListener(_local_3, this._Str_4604);
            this._roomNameInput = new TextFieldManager(this._navigator, cast(this._content.findChildByName("room_name_input"), ITextFieldWindow), 25, null, this._navigator.getText("navigator.createroom.roomnameinfo"));
            this._roomDescInput = new TextFieldManager(this._navigator, cast(this._content.findChildByName("room_desc_input"), ITextFieldWindow), 128, null, this._navigator.getText("navigator.createroom.roomdescinfo"));
            this.prepareCategorySelection();
            this.prepareTradeModeSelection();
            this._Str_10439(50);
            var _local_4= Util._Str_10228(this._content.desktop, this._content.width, this._content.height);
            this._content.x = Std.int(_local_4.x);
            this._content.y = Std.int(_local_4.y);
        }

        function prepareCategorySelection()
        {
            var _local_2:FlatCategory = null;
            this._categoryMenu = Std.downcast(this._content.findChildByName("categories_list") , IDropMenuWindow);
            var k= new Array<ASAny>();
            this._selectableAndVisibleCategories = [];
            final _iter_ = this._navigator.data._Str_11717; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((!_local_2.automatic) && ((!_local_2._Str_13024) || (_local_2._Str_13024 && this._navigator.sessionData.hasSecurity(SecurityLevelEnum.COMMUNITY)))))
                {
                    this._selectableAndVisibleCategories.push(_local_2);
                    k.push(_local_2._Str_14718);
                }
            }
            this._categoryMenu.populate(k);
            this._categoryMenu.selection = 0;
        }

        function prepareTradeModeSelection()
        {
            this._tradeSettings = Std.downcast(this._content.findChildByName("trade_settings_list") , IDropMenuWindow);
            var k= new Array<ASAny>();
            k.push("${navigator.roomsettings.trade_not_allowed}");
            k.push("${navigator.roomsettings.trade_not_with_Controller}");
            k.push("${navigator.roomsettings.trade_allowed}");
            this._tradeSettings.populate(k);
            this._tradeSettings.selection = 0;
        }

        public function refresh()
        {
            this._roomNameInput.goBackToInitialState();
            this._roomNameInput.input.textBackgroundColor = 0xFFFFFFFF;
            this._roomDescInput.goBackToInitialState();
            this._roomDescInput.input.textBackgroundColor = 0xFFFFFFFF;
            this._tradeSettings.selection = 0;
            this._categoryMenu.selection = 0;
            this._selectedLayout = this._layouts[0];
            this._Str_19409();
            if (this._navigator.sessionData.clubLevel >= HabboClubLevelEnum.VIP)
            {
                this._Str_10439(ROOM_LIMIT_HC);
            }
            else
            {
                this._Str_10439(ROOM_LIMIT_NON_SUBSCRIBER);
            }
            this._Str_16163();
        }

        function _Str_10439(k:Int)
        {
            this._maxVisitors = Std.downcast(this._content.findChildByName("visitors_list") , IDropMenuWindow);
            var _local_2= new Array<ASAny>();
            var _local_3= 10;
            while (_local_3 <= k)
            {
                _local_2.push(("" + Std.string(_local_3)));
                _local_3 = (_local_3 + 5);
            }
            this._maxVisitors.populate(_local_2);
            this._maxVisitors.selection = 0;
        }

        function _Str_16163()
        {
            var k:RoomLayout = null;
            var _local_2 = false;
            var _local_3:ITextWindow = null;
            final _iter_ = this._layouts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.view == null)
                {
                }
                else
                {
                    _local_2 = (k == this._selectedLayout);
                    k.view.findChildByName("bg_sel").visible = _local_2;
                    k.view.findChildByName("bg_unsel").visible = (!_local_2);
                    _local_3 = cast(k.view.findChildByName("tile_size_txt"), ITextWindow);
                    _local_3.textColor = (_local_2 ? 0xFFFFFFFF : 0xFF000000);
                    _local_3.color = (_local_2 ? 0xFF6E8184 : 0xFFCBCBCB);
                    this._navigator.refreshButton(k.view, "tile_icon_black", (!_local_2), null, 0);
                    this._navigator.refreshButton(k.view, "tile_icon_white", _local_2, null, 0);
                    this._navigator.refreshButton(k.view, "select_arrow", _local_2, null, 0);
                }
            }
        }

        function _Str_19409()
        {
            var k:RoomLayout = null;
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            var _local_4 = 0;
            var _local_6:IWindow = null;
            var _local_7:RoomLayout = null;
            var _local_8:IWindowContainer = null;
            var _local_9:IWindow = null;
            while (this._list.numListItems > 0)
            {
                _local_6 = this._list.removeListItemAt(0);
                _local_6.destroy();
            }
            final _iter_ = this._layouts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.view != null)
                {
                    k.view.destroy();
                    k.view = null;
                }
            }
            _local_2 = 0;
            _local_4 = 0;
            while (_local_4 < this._layouts.length)
            {
                _local_7 = this._layouts[_local_4];
                if (!this.isAllowed(_local_7, false))
                {
                }
                else
                {
                    if (_local_2 == 0)
                    {
                        _local_3 = this.getRow();
                        this._list.addListItem(_local_3);
                    }
                    this.addThumbnail(_local_3, this._layouts[_local_4], ((_local_2 % 2) == 0));
                    _local_2 = ((_local_2 == 0) ? 1 : 0);
                }
                _local_4++;
            }
            this._Str_16163();
            var _local_5:String = null;
            if (((this._navigator.sessionData.clubLevel < HabboClubLevelEnum.VIP) && (!this._navigator.getBoolean("habbo_club_buy_disabled"))))
            {
                _local_5 = "roc_vip_promo";
            }
            if (_local_5 != null)
            {
                _local_8 = cast(this._navigator.getXmlWindow(_local_5), IWindowContainer);
                if (_local_8 != null)
                {
                    _local_9 = _local_8.findChildByName("link");
                    addMouseClickListener(_local_9, this.onHcMoreClick);
                    this._list.addListItem(_local_8);
                }
            }
        }

        function addThumbnail(k:IWindowContainer, _arg_2:RoomLayout, _arg_3:Bool)
        {
            var _local_4= cast(this._navigator.getXmlWindow("roc_room_thumbnail"), IWindowContainer);
            _local_4.tags.push(_arg_2.name);
            if (!_arg_3)
            {
                _local_4.x = _local_4.width;
            }
            addMouseClickListener(_local_4, this._Str_22785);
            var _local_5= Std.downcast(_local_4.findChildByName("bg_pic") , IStaticBitmapWrapperWindow);
            _local_5.assetUri = (("${image.library.url}newroom/model_" + _arg_2.name) + ".png");
            k.addChild(_local_4);
            (this._navigator.sessionData.clubLevel >= HabboClubLevelEnum.VIP);
            k.width = (2 * _local_4.width);
            k.height = _local_4.height;
            _arg_2.view = _local_4;
            cast(_arg_2.view.findChildByName("tile_size_txt"), ITextWindow).text = ((Std.string(_arg_2.tileSize) + " ") + this._navigator.getText("navigator.createroom.tilesize"));
            _local_4.findChildByName("club_icon").visible = ((_arg_2.requiredClubLevel == HabboClubLevelEnum.CLUB) || (_arg_2.requiredClubLevel == HabboClubLevelEnum.VIP));
        }

        function isAllowed(k:RoomLayout, _arg_2:Bool=true):Bool
        {
            switch (k.requiredClubLevel)
            {
                case HabboClubLevelEnum.NO_CLUB:
                    return true;
                case HabboClubLevelEnum.CLUB:
                    return (!_arg_2) || (this._navigator.sessionData.clubLevel >= HabboClubLevelEnum.CLUB);
                case HabboClubLevelEnum.VIP:
                    return (!_arg_2) || (this._navigator.sessionData.clubLevel >= HabboClubLevelEnum.VIP);
                default:
                    return this._navigator.sessionData.hasSecurity(SecurityLevelEnum.EMPLOYEE);
            }
        }

        function getRow():IWindowContainer
        {
            return cast(this._navigator.windowManager.createWindow("", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, new Rectangle(0, 0, 100, 300)), IWindowContainer);
        }

        function isMandatoryFieldsFilled():Bool
        {
            var k= this._roomNameInput.checkMandatory(this._navigator.getText("navigator.createroom.nameerr"));
            return k;
        }

        function getCreateButton():IButtonWindow
        {
            return cast(this._content.findChildByName("create_button"), IButtonWindow);
        }

        function _Str_25310():IButtonWindow
        {
            return cast(this._content.findChildByName("back_button"), IButtonWindow);
        }

        function _Str_23552(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3= this.getLayout(_arg_2);
            if (this.isAllowed(_local_3, true))
            {
                this._selectedLayout = _local_3;
                this._Str_16163();
            }
            else
            {
                this._navigator.openCatalogClubPage("RoomCreateViewCtrl");
            }
        }

        function getLayout(k:IWindow):RoomLayout
        {
            var _local_2= this._Str_23514(k.tags[0]);
            return _local_2;
        }

        function _Str_23514(k:String):RoomLayout
        {
            var _local_2:RoomLayout = null;
            final _iter_ = this._layouts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.name == k)
                {
                    return _local_2;
                }
            }
            return this._layouts[0];
        }

        function _Str_22785(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , IWindowContainer);
            this._Str_23552(k, _local_2);
        }

        function _Str_4604(k:WindowEvent)
        {
            this.close();
        }

        function onHcMoreClick(k:WindowEvent)
        {
            Logger.log(["HC LINK CLICKED"]);
            this._navigator.openCatalogClubPage("RoomCreateViewCtrl");
        }

        function onCreateButtonClick(k:WindowEvent)
        {
            var _flatCategory:FlatCategory = null;
            var roomTradeSetting = 0;
            var _roomName= this._roomNameInput.getText();
            var _roomDesc= this._roomDescInput.getText();
            var _roomLayout= ("model_" + this._selectedLayout.name);
            var _maxVisitors= ASCompat.parseInt(this._maxVisitors.items()[this._maxVisitors.selection]);
            var selectedFlatCategoryNodeId = 0;
            var i = 0;
            final _iter_ = this._selectableAndVisibleCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_flatCategory  = _tmp_;
                if (this._categoryMenu.selection == i)
                {
                    selectedFlatCategoryNodeId = _flatCategory.nodeId;
                    break;
                }
                i++;
            }
            roomTradeSetting = this._tradeSettings.selection;
            if (!this.isMandatoryFieldsFilled())
            {
                return;
            }
            this._navigator.send(new CreateFlatMessageComposer(_roomName, _roomDesc, _roomLayout, selectedFlatCategoryNodeId, _maxVisitors, roomTradeSetting));
        }

        function close()
        {
            this._content.visible = false;
            this._arrowTimer.reset();
        }
    }

