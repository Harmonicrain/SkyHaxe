package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.IDropListWindow;
    import com.sulake.habbo.catalog.guilds.GuildMembershipsController;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetGuildSelectedEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_4201;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetRoomPreviewerStuffDataEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.IStuffData;

     class GuildSelectorCatalogWidget extends CatalogWidget
    {
        static inline final GUILD_SELECTOR= "guild_selector";
        static inline final GUILD_SELECTOR_WIDGET_ITEM= "guild_selector_widget_item";
        static inline final _Str_18419:UInt = 0;
        static inline final _Str_6422= 1;
        static inline final _Str_16811= 14;
        static inline final _Str_18723= 21;

        var _Str_4025:IDropListWindow;
        var _Str_5363:GuildMembershipsController;
        var _Str_14021:Array<ASAny>;
        var _Str_4978:IWindow;
        var _Str_15746:IWindow;
        var _Str_5561:Int = -1;

        public function new(k:IWindowContainer, _arg_2:GuildMembershipsController)
        {
            super(k);
            this._Str_5363 = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                events.removeEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
                page.dispatchWidgetEvent(new CatalogWidgetGuildSelectedEvent(CatalogWidgetGuildSelectedEvent._Str_15457, "", "", ""));
                if (this._Str_4025 != null)
                {
                    this._Str_4025.procedure = null;
                    this._Str_4025 = null;
                }
                this._Str_4978 = null;
                this._Str_15746 = null;
                if (this._Str_5363 != null)
                {
                    this._Str_5363.unregisterGuildSelectorWidget(this);
                    this._Str_5363 = null;
                }
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            _Str_2819(CatalogWidgetEnum.GUILD_SELECTOR);
            this._Str_4978 = window.findChildByName("guild_selector");
            this._Str_15746 = window.findChildByName("members_only");
            var k= window.findChildByName("find_groups_button");
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this._Str_22828);
            }
            this._Str_4025 = Std.downcast(_window.findChildByName(GUILD_SELECTOR) , IDropListWindow);
            if (this._Str_4025 != null)
            {
                this._Str_4025.procedure = this._Str_23967;
            }
            else
            {
                Logger.log([(("ERROR: Missing '" + GUILD_SELECTOR) + "' itemlist_dropmenu component from page layout xml")]);
            }
            this._Str_4978.visible = false;
            this._Str_15746.visible = false;
            return true;
        }

        function onWidgetsInitialized(k:_Str_3308)
        {
            this._Str_5363.registerGuildSelectorWidget(this);
            events.dispatchEvent(new _Str_3308(CatalogWidgetEvent.EXTRA_PARAM_REQUIRED_FOR_BUY));
        }

        public function populateAndSelectFavorite(k:Array<ASAny>)
        {
            var _local_7:HabboGroupEntryData = null;
            var _local_2= -1;
            this._Str_14021 = this.filterGroupMemberships(k);
            var _local_3:ASAny = (k.length > 0);
            events.dispatchEvent(new _Str_4201(CatalogWidgetEnum.PURCHASE, _local_3));
            this._Str_4978.visible = _local_3;
            this._Str_15746.visible = (!_local_3);
            var _local_4= this._Str_4025.numMenuItems;
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                this._Str_4025.removeMenuItemAt(0);
                _local_5++;
            }
            var _local_6 = 0;
            while (_local_6 < this._Str_14021.length)
            {
                _local_7 = this._Str_14021[_local_6];
                this._Str_4025.addMenuItem(this._Str_23230(_local_7));
                if (_local_7.favourite)
                {
                    _local_2 = _local_6;
                }
                _local_6++;
            }
            if (this._Str_5561 == -1)
            {
                if (_local_2 != -1)
                {
                    this._Str_4025.selection = _local_2;
                }
                else
                {
                    if (this._Str_4025.numMenuItems > 0)
                    {
                        this._Str_4025.selection = 0;
                    }
                }
            }
            else
            {
                this._Str_4025.selection = this._Str_5561;
            }
        }

        function filterGroupMemberships(k:Array<ASAny>):Array<ASAny>
        {
            return k;
        }

        public function selectFirstOffer()
        {
            if ((((page != null) && (page.offers != null)) && (page.offers.length > 0)))
            {
                page.selectOffer(cast(page.offers[0], Offer).offerId);
            }
        }

        function _Str_23967(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowEvent.WINDOW_EVENT_SELECTED:
                    this._Str_24750(this._Str_4025.selection);
                    this._Str_5561 = this._Str_4025.selection;
                    return;
            }
        }

        function _Str_24750(k:Int)
        {
            var _local_2:HabboGroupEntryData = null;
            if (k > -1)
            {
                _local_2 = this._Str_14021[k];
                this.selectGroup(_local_2);
            }
        }

        function selectGroup(k:HabboGroupEntryData)
        {
            page.dispatchWidgetEvent(new CatalogWidgetGuildSelectedEvent(k.groupId, k._Str_5845, k._Str_6659, k.badgeCode));
            page.dispatchWidgetEvent(new SetRoomPreviewerStuffDataEvent(this._Str_17425(k.groupId, k._Str_5845, k._Str_6659, k.badgeCode)));
            events.dispatchEvent(new SetExtraPurchaseParameterEvent(Std.string(k.groupId)));
        }

        function createGuildColorsBitmap(k:UInt, _arg_2:UInt):BitmapData
        {
            var _local_3= new BitmapData(_Str_18723, _Str_16811, false, _Str_18419);
            var _local_4= Std.int((_local_3.width / 2) + 1);
            var _local_5= new Rectangle();
            _local_5.left = _Str_6422;
            _local_5.top = _Str_6422;
            _local_5.right = _local_4;
            _local_5.bottom = (_local_3.height - _Str_6422);
            var _local_6= new Rectangle();
            _local_6.left = _local_4;
            _local_6.top = _Str_6422;
            _local_6.right = (_local_3.width - _Str_6422);
            _local_6.bottom = (_local_3.height - _Str_6422);
            _local_3.fillRect(_local_5, k);
            _local_3.fillRect(_local_6, _arg_2);
            return _local_3;
        }

        function _Str_23230(k:HabboGroupEntryData):IWindow
        {
            var _local_2= this.createGuildColorsBitmap(ASCompat.parseInt(k._Str_5845, 16), ASCompat.parseInt(k._Str_6659, 16));
            var _local_3= ((page.viewer.catalog.assets.getAssetByName(GUILD_SELECTOR_WIDGET_ITEM).content : com.sulake.core.utils.xml.XML) );
            var _local_4= Std.downcast(page.viewer.catalog.windowManager.buildFromXML(_local_3) , IWindowContainer);
            var _local_5= Std.downcast(_local_4.findChildByName("guild_colors") , IBitmapWrapperWindow);
            var _local_6= Std.downcast(_local_4.findChildByName("guild_name") , ILabelWindow);
            _local_5.bitmap = _local_2;
            _local_6.caption = k.groupName;
            return _local_4;
        }

        function _Str_22828(k:WindowMouseEvent)
        {
            if (((((page != null) && (page.viewer != null)) && (page.viewer.catalog != null)) && (page.viewer.catalog.navigator != null)))
            {
                page.viewer.catalog.navigator.performGuildBaseSearch();
            }
        }

        function _Str_17425(k:UInt, _arg_2:String, _arg_3:String, _arg_4:String):IStuffData
        {
            var _local_5= new Array<ASAny>();
            _local_5.push("0");
            _local_5.push(Std.string(k));
            _local_5.push(_arg_4);
            _local_5.push(_arg_2);
            _local_5.push(_arg_3);
            var _local_6= new StringArrayStuffData();
            _local_6._Str_13438(_local_5);
            return _local_6;
        }
    }

