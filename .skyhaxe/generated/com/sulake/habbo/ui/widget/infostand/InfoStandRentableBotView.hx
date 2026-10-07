package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotInfoUpdateEvent;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.RemoveBotFromFlatMessageComposer;

     class InfoStandRentableBotView 
    {
        static inline final _Str_5169= 162;
        static inline final _Str_8071= 16;
        static inline final _Str_4882= 5;
        static inline final _Str_3835= 4;
        static inline final _Str_5037:UInt = 0xDADADA;
        static inline final _Str_4952:UInt = 0x3A3A3A;
        static inline final _Str_19674:UInt = 2085362;
        static inline final _Str_21814:UInt = 39616;
        static inline final NAME_TEXT= "name_text";
        static inline final DESCRIPTION_TEXT= "description_text";
        static inline final HANDITEM_TEXT= "handitem_text";
        static inline final OWNER_TEXT= "owner_text";
        static inline final EXPIRE_TIME_LEFT= "expire_time_left";
        static inline final EXPIRE_TIME_INFO= "expire_time_info";
        static inline final HANDITEM_SPACER= "handitem_spacer";
        static inline final _Str_8222= 250;
        static inline final _Str_4468= 25;
        static inline final _Str_6207= 5;

        var _catalog:IHabboCatalog;
        var _habboTracking:IHabboTracking;
        var _widget:InfoStandWidget;
        var _window:IItemListWindow;
        var _border:IBorderWindow;
        var _buttonsContainer:IWindowContainer;
        var _infoElements:IItemListWindow;
        var _badgeId:String;
        var _botId:Int = 0;
        var _disposed:Bool = false;

        public function new(k:InfoStandWidget, _arg_2:String, _arg_3:IHabboCatalog)
        {
            this._widget = k;
            this._catalog = _arg_3;
            this._habboTracking = HabboTracking.getInstance();
            this.createWindow(_arg_2);
        }

        public function dispose()
        {
            this._widget = null;
            this._catalog = null;
            this._habboTracking = null;
            this._border = null;
            this._buttonsContainer = null;
            this._infoElements = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            this._disposed = true;
        }

        public var window(get,never):IItemListWindow;
public function  get_window():IItemListWindow
        {
            return this._window;
        }

        function updateWindow()
        {
            if ((((this._infoElements == null) || (this._border == null)) || (this._buttonsContainer == null)))
            {
                return;
            }
            this._buttonsContainer.width = this._buttonsContainer.width;
            this._buttonsContainer.visible = (this._buttonsContainer.width > 0);
            this._infoElements.height = Std.int(this._infoElements.scrollableRegion.height);
            this._border.height = (this._infoElements.height + 20);
            this._window.width = Std.int(Math.max(this._border.width, this._buttonsContainer.width));
            this._window.height = Std.int(this._window.scrollableRegion.height);
            if (this._border.width < this._buttonsContainer.width)
            {
                this._border.x = (this._window.width - this._border.width);
                this._buttonsContainer.x = 0;
            }
            else
            {
                this._buttonsContainer.x = (this._window.width - this._buttonsContainer.width);
                this._border.x = 0;
            }
            this._widget._Str_10301();
        }

        public function update(k:RoomWidgetRentableBotInfoUpdateEvent)
        {
            this._botId = k.id;
            this._Str_9667(NAME_TEXT, true, k.name);
            this._Str_9667(DESCRIPTION_TEXT, true, k.motto);
            if (k.ownerId > -1)
            {
                this._widget.localizations.registerParameter("infostand.text.botowner", "name", k.ownerName);
                this._Str_9667(OWNER_TEXT, true, this._widget.localizations.getLocalization("infostand.text.botowner"));
            }
            else
            {
                this._Str_9667(OWNER_TEXT, false, "");
            }
            this._Str_25241();
            this._Str_22346(k.carryItem);
            var _local_2= k.badges;
            this._Str_5605((((_local_2 != null) && (_local_2.length > 0)) ? _local_2[0] : null));
            this._Str_7907(k.figure);
            this.showButton("whisper", false);
            this.showButton("ignore", false);
            this.showButton("unignore", false);
            this.showButton("pick", ((k.ownerId > -1) && (k.amIOwner || k.amIAnyRoomController)));
            this.updateWindow();
        }

        function _Str_25241()
        {
            this._Str_9667(EXPIRE_TIME_LEFT, false, "N/A");
            this._Str_9667(EXPIRE_TIME_INFO, false, "");
        }

        public function _Str_22346(k:Int)
        {
            var _local_6:String = null;
            var _local_2= Std.downcast(this._infoElements.getListItemByName(HANDITEM_TEXT) , ITextWindow);
            var _local_3= Std.downcast(this._infoElements.getListItemByName(HANDITEM_SPACER) , IWindowContainer);
            if (((_local_2 == null) || (_local_3 == null)))
            {
                return;
            }
            if (((k > 0) && (k < 999999)))
            {
                _local_6 = this._widget.localizations.getLocalization(("handitem" + Std.string(k)), ("handitem" + Std.string(k)));
                this._widget.localizations.registerParameter("infostand.text.handitem", "item", _local_6);
            }
            _local_2.height = Std.int(_local_2.textHeight + _Str_4882);
            var _local_4= _local_2.visible;
            var _local_5= ((k > 0) && (k < 999999));
            _local_2.visible = _local_5;
            _local_3.visible = _local_5;
            if (_local_5 != _local_4)
            {
                this._infoElements.arrangeListItems();
            }
            this.updateWindow();
        }

        function _Str_12421(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:UInt):BitmapData
        {
            _arg_2 = Std.int(Math.max(_arg_2, 1));
            k = Std.int(Math.max(k, 0));
            if (k > _arg_2)
            {
                k = _arg_2;
            }
            var _local_5= (k / _arg_2);
            var _local_6= 1;
            var _local_7= new BitmapData(_Str_5169, _Str_8071, false);
            _local_7.fillRect(new Rectangle(0, 0, _local_7.width, _local_7.height), _Str_5037);
            var _local_8= new Rectangle(_local_6, _local_6, (_local_7.width - (_local_6 * 2)), (_local_7.height - (_local_6 * 2)));
            _local_7.fillRect(_local_8, _Str_4952);
            var _local_9= new Rectangle(_local_6, (_local_6 + _Str_3835), (_local_7.width - (_local_6 * 2)), ((_local_7.height - (_local_6 * 2)) - _Str_3835));
            _local_9.width = (_local_5 * _local_9.width);
            _local_7.fillRect(_local_9, _arg_3);
            var _local_10= new Rectangle(_local_6, _local_6, (_local_7.width - (_local_6 * 2)), _Str_3835);
            _local_10.width = (_local_5 * _local_10.width);
            _local_7.fillRect(_local_10, _arg_4);
            return _local_7;
        }

        function createWindow(k:String)
        {
            var _local_5:IWindow = null;
            var _local_6:IWindow = null;
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("rentable_bot_view") , XmlAsset);
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IItemListWindow);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._border = Std.downcast(this._window.getListItemByName("info_border") , IBorderWindow);
            if (this._border != null)
            {
                this._infoElements = Std.downcast(this._border.findChildByName("infostand_element_list") , IItemListWindow);
            }
            this._window.name = k;
            this._widget.mainContainer.addChild(this._window);
            var _local_3= this._border.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            this._buttonsContainer = Std.downcast(this._window.getListItemByName("button_list") , IWindowContainer);
            if (this._buttonsContainer == null)
            {
                return;
            }
            var _local_4:Array<ASAny> = [];
            this._buttonsContainer.groupChildrenWithTag("CMD_BUTTON", _local_4, -1);
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_5  = _tmp_;
                _local_5.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                if (_local_6.parent != null)
                {
                    _local_6.parent.width = _local_6.width;
                }
                _local_6.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_17596);
            }
        }

        function _Str_9667(k:String, _arg_2:Bool, _arg_3:String)
        {
            var _local_5:IWindowContainer = null;
            if (this._infoElements == null)
            {
                return;
            }
            var _local_4= Std.downcast(this._infoElements.getListItemByName(k) , ITextWindow);
            if (_local_4 == null)
            {
                _local_5 = Std.downcast(this._infoElements.getListItemByName("description_container") , IWindowContainer);
                if (_local_5 == null)
                {
                    return;
                }
                _local_4 = Std.downcast(_local_5.findChildByName(k) , ITextWindow);
                if (_local_4 == null)
                {
                    return;
                }
            }
            _local_4.text = _arg_3;
            _local_4.visible = _arg_2;
        }

        function _Str_7907(k:String)
        {
            var _local_2= Std.downcast(cast(this._border.findChildByName("avatar_image"), IWidgetWindow).widget , IAvatarImageWidget);
            _local_2.figure = k;
        }

        function _Str_5605(k:String)
        {
            var _local_2= Std.downcast(cast(this._border.findChildByName("badge"), IWidgetWindow).widget , IBadgeImageWidget);
            _local_2.badgeId = k;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            if (k.target.name == "pick")
            {
                this._widget.handler.container.connection.send(new RemoveBotFromFlatMessageComposer(this._botId));
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._widget.close();
        }

        function showButton(k:String, _arg_2:Bool)
        {
            if (this._buttonsContainer == null)
            {
                return;
            }
            var _local_3= this._buttonsContainer.getChildByName(k);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
                this._Str_18168();
            }
        }

        function _Str_17596(k:WindowEvent)
        {
            var _local_2= k.window.parent;
            if (((_local_2 != null) && (_local_2.tags.indexOf("CMD_BUTTON_REGION") > -1)))
            {
                _local_2.width = k.window.width;
            }
        }

        function _Str_18168()
        {
            var _local_5:IWindow = null;
            var k= _Str_8222;
            this._buttonsContainer.width = k;
            var _local_2:Array<ASAny> = [];
            this._buttonsContainer.groupChildrenWithTag("CMD_BUTTON_REGION", _local_2, -1);
            var _local_3= k;
            var _local_4 = 0;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_5  = _tmp_;
                if (!_local_5.visible)
                {
                }
                else
                {
                    if ((_local_3 - _local_5.width) < 0)
                    {
                        _local_3 = k;
                        _local_4 = (_local_4 + (_Str_4468 + _Str_6207));
                    }
                    _local_5.x = (_local_3 - _local_5.width);
                    _local_5.y = _local_4;
                    _local_3 = (_local_5.x - _Str_6207);
                }
            }
            this._buttonsContainer.height = (_local_4 + _Str_4468);
            this.updateWindow();
        }
    }

