package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.communication.messages.incoming.catalog.RoomAdPurchaseInfoEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.purchase.RoomAdPurchaseData;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.EventCategory;
    import com.sulake.habbo.communication.messages.incoming.users.RoomEntryData;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.session.HabboClubLevelEnum;

     class RoomAdsCatalogWidget extends CatalogWidget
    {
        var _catalog:HabboCatalog;
        var _messageListener:IMessageEvent = null;
        var _name:String;
        var _description:String;
        var _rooms:Array<ASAny>;
        var _isVip:Bool = false;
        var _categoryMenu:IDropMenuWindow;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            if (this._catalog == null)
            {
                return false;
            }
            var k= this._catalog.connection;
            if (this._messageListener == null)
            {
                this._messageListener = new RoomAdPurchaseInfoEvent(this._Str_22552);
                k.addMessageEvent(this._messageListener);
            }
            this._catalog.getRoomAdsPurchaseInfo();
            window.findChildByName("name_input_text").addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_24912);
            window.findChildByName("desc_input_text").addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_24087);
            events.addEventListener(CatalogWidgetEvent.PURCHASE, this._Str_24262);
            var _local_2= this._catalog.roomAdPurchaseData;
            var _local_3= this._catalog.getInteger("room_ad.duration.minutes", 120);
            var _local_4= this._Str_21550(_local_2, _local_3);
            this._catalog.localization.registerParameter("roomad.catalog_text", "duration", Std.string(_local_4));
            this._catalog.roomEngine.events.addEventListener(RoomEngineEvent.INITIALIZED, this.onRoomInitialized);
            this._Str_20930();
            return true;
        }

        function _Str_21550(k:RoomAdPurchaseData, _arg_2:Int):Int
        {
            var _local_3= this._catalog.getBoolean("roomad.limited_extension");
            if ((((!_local_3) || (k == null)) || (k.expirationTime == null)))
            {
                return _arg_2;
            }
            var _local_4= Date.now();
            var _local_5= _local_4.getTime();
            var _local_6= k.expirationTime.getTime();
            var _local_7= (_local_5 - _local_6);
            var _local_8= (_local_7 / (1000 * 60));
            _local_8 = (_local_8 + _arg_2);
            return Std.int(_local_8);
        }

        function _Str_20930()
        {
            var _local_2:EventCategory = null;
            if (window == null)
            {
                return;
            }
            this._categoryMenu = Std.downcast(window.findChildByName("categories_list") , IDropMenuWindow);
            var k:Array<ASAny> = [];
            final _iter_ = this._catalog.navigator._Str_8075; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push((("${navigator.searchcode.title.eventcategory__" + Std.string(_local_2.categoryId)) + "}"));
            }
            this._categoryMenu.populate(k);
            this._categoryMenu.selection = 0;
            this._categoryMenu.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this._Str_23736);
        }

        function onRoomInitialized(k:RoomEngineEvent)
        {
            if (k == null)
            {
                return;
            }
            this._Str_19526(k.roomId, false);
        }

        function _Str_19526(k:Int, _arg_2:Bool=false)
        {
            var _local_8:RoomEntryData = null;
            var _local_9:String = null;
            var _local_10:RoomAdPurchaseData = null;
            if (window == null)
            {
                return;
            }
            var _local_3= Std.downcast(window.findChildByName("room_drop_menu") , IDropMenuWindow);
            if (this._rooms == null)
            {
                if (_local_3.numMenuItems > 0)
                {
                    _local_3.selection = 0;
                }
                return;
            }
            var _local_4 = 0;
            var _local_5:Array<ASAny> = [];
            var _local_6 = 0;
            while (_local_6 < this._rooms.length)
            {
                _local_8 = ASCompat.dynamicAs(this._rooms[_local_6] , RoomEntryData);
                if (_arg_2)
                {
                    if (_local_8.roomName.length > 25)
                    {
                        _local_9 = (_local_8.roomName.substr(0, 25) + "...");
                        _local_5.push(_local_9);
                    }
                    else
                    {
                        _local_5.push(_local_8.roomName);
                    }
                }
                if (_local_8.roomId == k)
                {
                    _local_4 = _local_6;
                }
                _local_6++;
            }
            if (_arg_2)
            {
                if (_local_5.length == 0)
                {
                    _local_5.push(this._catalog.localization.getLocalization("roomad.no.available.room", "roomad.no.available.room"));
                }
                _local_3.populate(_local_5);
            }
            var _local_7= ASCompat.dynamicAs(this._rooms[_local_4] , RoomEntryData);
            if (_local_7 != null)
            {
                _local_3.selection = _local_4;
                _local_10 = this._catalog.roomAdPurchaseData;
                if (_local_10 == null)
                {
                    _local_10 = new RoomAdPurchaseData();
                    this._catalog.roomAdPurchaseData = _local_10;
                }
                _local_10.flatId = _local_7.roomId;
            }
            else
            {
                _local_3.selection = 0;
            }
        }

        function _Str_23599()
        {
            var _local_2:RoomEntryData = null;
            var k= this._catalog.roomAdPurchaseData;
            if (((!(k == null)) && k._Str_8314))
            {
                window.findChildByName("name_input_text").caption = k.name;
                window.findChildByName("desc_input_text").caption = k.description;
                _local_2 = new RoomEntryData(k.flatId, k.roomName, false);
                if (this._rooms != null)
                {
                    this._rooms.push(_local_2);
                }
                if (this._categoryMenu == null)
                {
                    this._categoryMenu = Std.downcast(window.findChildByName("categories_list") , IDropMenuWindow);
                }
                this._categoryMenu.selection = (k.categoryId - 1);
            }
        }

        public function _Str_22552(k:IMessageEvent)
        {
            var _local_7:RoomAdPurchaseData = null;
            var _local_8:IWindowContainer = null;
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomAdPurchaseInfoEvent);
            var _local_3= _local_2.getParser();
            var _local_4= Std.downcast(window.findChildByName("room_drop_menu") , IDropMenuWindow);
            this._rooms = _local_3.rooms;
            this._isVip = _local_3._Str_12313;
            var _local_5= this._catalog.roomEngine.activeRoomId;
            this._Str_23599();
            this._Str_20930();
            this._Str_19526(_local_5, true);
            var _local_6= this._Str_25100();
            if (_local_6 != null)
            {
                events.dispatchEvent(new SelectProductEvent(_local_6));
                _local_7 = this._catalog.roomAdPurchaseData;
                if (_local_7 == null)
                {
                    _local_7 = new RoomAdPurchaseData();
                    this._catalog.roomAdPurchaseData = _local_7;
                }
                _local_7.offerId = _local_6.offerId;
                this._catalog.roomAdPurchaseData = _local_7;
                _local_8 = Std.downcast(window.findChildByName("price_container") , IWindowContainer);
                this._catalog.utils._Str_6455(_local_8, _local_6);
            }
        }

        function _Str_24262(k:_Str_3308)
        {
            this._catalog.getRoomAdsPurchaseInfo();
            window.findChildByName("name_input_text").caption = "";
            window.findChildByName("desc_input_text").caption = "";
            if (this._catalog.roomAdPurchaseData != null)
            {
                this._catalog.roomAdPurchaseData.clear();
            }
        }

        function _Str_24912(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , ITextFieldWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._catalog.roomAdPurchaseData;
            if (_local_3 != null)
            {
                _local_3.name = _local_2.text;
            }
        }

        function _Str_24087(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , ITextFieldWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._catalog.roomAdPurchaseData;
            if (_local_3 != null)
            {
                _local_3.description = _local_2.text;
            }
        }

        function _Str_26020(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:RoomEntryData = null;
            var _local_5:RoomAdPurchaseData = null;
            var _local_6 = 0;
            var _local_7:IWindow = null;
            var _local_8:String = null;
            if (((k.type == WindowEvent.WINDOW_EVENT_SELECTED) && (this._rooms.length > 0)))
            {
                _local_3 = cast(_arg_2, IDropMenuWindow).selection;
                _local_4 = ASCompat.dynamicAs(this._rooms[_local_3] , RoomEntryData);
                _local_5 = this._catalog.roomAdPurchaseData;
                if (_local_5 != null)
                {
                    _local_5.flatId = _local_4.roomId;
                    _local_6 = this._catalog.getInteger("room_ad.duration.minutes", 120);
                    if (_local_4.roomId == _local_5._Str_16649)
                    {
                        _local_6 = this._Str_21550(_local_5, _local_6);
                    }
                    _local_7 = window.findChildByName("ctlg_text_1");
                    _local_7.caption = "${roomad.catalog_text}";
                    this._catalog.localization.registerParameter("roomad.catalog_text", "duration", Std.string(_local_6));
                    _local_8 = this._catalog.localization.getLocalization("roomad.catalog_text");
                    _local_7.caption = _local_8;
                }
            }
        }

        function _Str_23736(k:WindowEvent)
        {
            var _local_5:EventCategory = null;
            var _local_6:RoomAdPurchaseData = null;
            var _local_2 = 0;
            var _local_3= -1;
            var _local_4= this._categoryMenu.selection;
            final _iter_ = this._catalog.navigator._Str_8075; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (_local_5.visible)
                {
                    if (_local_4 == _local_2)
                    {
                        _local_3 = _local_5.categoryId;
                        break;
                    }
                    _local_2++;
                }
            }
            _local_6 = this._catalog.roomAdPurchaseData;
            if (_local_6 != null)
            {
                _local_6.categoryId = _local_3;
            }
        }

        function _Str_25100():IPurchasableOffer
        {
            var _local_2 = 0;
            var _local_3:Offer = null;
            var k= page.offers;
            if (((!(k == null)) && (k != null)))
            {
                if (k.length == 1)
                {
                    return k[0];
                }
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    _local_3 = Std.downcast(k[_local_2] , Offer);
                    if ((((_local_3.clubLevel == HabboClubLevelEnum.VIP) && this._isVip) || ((!(_local_3.clubLevel == HabboClubLevelEnum.VIP)) && (!this._isVip))))
                    {
                        return _local_3;
                    }
                    _local_2++;
                }
            }
            return null;
        }

        override public function dispose()
        {
            var k:IConnection = null;
            super.dispose();
            if (this._catalog != null)
            {
                k = this._catalog.connection;
                if (this._messageListener != null)
                {
                    k.removeMessageEvent(this._messageListener);
                    this._messageListener = null;
                }
                this._catalog.roomEngine.events.removeEventListener(RoomEngineEvent.INITIALIZED, this.onRoomInitialized);
                this._catalog = null;
            }
        }
    }

