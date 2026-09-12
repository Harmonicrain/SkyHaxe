package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.badges.BadgesEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window._enum._Str_4387;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetRoomPreviewerStuffDataEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.IStuffData;

     class UserBadgeSelectorCatalogWidget extends CatalogWidget
    {
        static inline final BADGEGRIDITEM= "badgeGridItem";

        var _itemGrid:IItemGridWindow;
        var _gridItemLayout:com.sulake.core.utils.xml.XML;
        var _catalog:HabboCatalog;
        var _selectedBadgeIndex:Int = -1;
        var _badgesUpdatedMessageListener:IMessageEvent;
        var _excludedBadges:Array<ASAny>;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
            this._excludedBadges = (cast this._catalog.getProperty("badge.display.excluded.badgeCodes").split(","));
        }

        override public function dispose()
        {
            if (this._badgesUpdatedMessageListener != null)
            {
                this._catalog.connection.removeMessageEvent(this._badgesUpdatedMessageListener);
            }
            this._catalog = null;
            this._excludedBadges = null;
            super.dispose();
        }

        override public function init():Bool
        {
            this._itemGrid = Std.downcast(_window.findChildByName("badgeGrid") , IItemGridWindow);
            var k= Std.downcast(page.viewer.catalog.assets.getAssetByName("badgeGridItem") , XmlAsset);
            this._gridItemLayout = ((k.content : com.sulake.core.utils.xml.XML) );
            this._Str_20622();
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            this._badgesUpdatedMessageListener = new BadgesEvent(this._Str_22798);
            this._catalog.connection.addMessageEvent(this._badgesUpdatedMessageListener);
            return true;
        }

        function _Str_20622()
        {
            var _local_2:String = null;
            this._itemGrid.destroyGridItems();
            var k = 0;
            final _iter_ = this._catalog.inventory.getAllMyBadgeIds(this._excludedBadges); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._itemGrid.addGridItem(this._Str_7360(_local_2, k++));
            }
        }

        function onWidgetsInitialized(k:_Str_3308)
        {
            if (page.offers.length == 0)
            {
                return;
            }
            var _local_2= page.offers[0];
            events.dispatchEvent(new _Str_3308(CatalogWidgetEvent.EXTRA_PARAM_REQUIRED_FOR_BUY));
            events.dispatchEvent(new SelectProductEvent(_local_2));
        }

        function _Str_7360(k:String, _arg_2:Int):IWindowContainer
        {
            var _local_3= Std.downcast(page.viewer.catalog.windowManager.buildFromXML(this._gridItemLayout) , IWindowContainer);
            var _local_4= cast(cast(_local_3.findChildByName("badgeWidget"), IWidgetWindow).widget, IBadgeImageWidget);
            _local_4.type = _Str_4387.NORMAL;
            _local_4.badgeId = k;
            _local_3.id = _arg_2;
            _local_3.name = BADGEGRIDITEM;
            _local_3.procedure = this._Str_24708;
            return _local_3;
        }

        function _Str_21961(k:Int, _arg_2:Bool)
        {
            var _local_3= cast(this._itemGrid.getGridItemAt(k), IWindowContainer);
            if (_local_3 != null)
            {
                cast(_local_3.findChildByName("bg"), IBorderWindow).style = (_arg_2 ? 0 : 2);
            }
        }

        function _Str_22817(k:Int):String
        {
            var _local_2= cast(this._itemGrid.getGridItemAt(k), IWindowContainer);
            var _local_3= cast(cast(_local_2.findChildByName("badgeWidget"), IWidgetWindow).widget, IBadgeImageWidget);
            return _local_3.badgeId;
        }

        function _Str_24708(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (_arg_2.name == BADGEGRIDITEM)
            {
                if (this._selectedBadgeIndex != -1)
                {
                    this._Str_21961(this._selectedBadgeIndex, false);
                }
                this._selectedBadgeIndex = _arg_2.id;
                if (this._selectedBadgeIndex < this._catalog.inventory.getAllMyBadgeIds(this._excludedBadges).length)
                {
                    this._Str_21961(this._selectedBadgeIndex, true);
                    events.dispatchEvent(new SetExtraPurchaseParameterEvent(this._Str_22817(this._selectedBadgeIndex)));
                    page.dispatchWidgetEvent(new SetRoomPreviewerStuffDataEvent(this._Str_17425()));
                }
            }
        }

        function _Str_17425():IStuffData
        {
            var k= new Array<ASAny>();
            k.push("0");
            k.push(this._catalog.inventory.getAllMyBadgeIds(this._excludedBadges)[this._selectedBadgeIndex]);
            k.push("");
            k.push("");
            var _local_2= new StringArrayStuffData();
            _local_2._Str_13438(k);
            return _local_2;
        }

        function _Str_22798(k:IMessageEvent)
        {
            this._Str_20622();
        }
    }

