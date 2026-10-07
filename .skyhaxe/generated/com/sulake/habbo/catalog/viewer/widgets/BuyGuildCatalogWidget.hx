package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildCreationInfoMessageComposer;
    import com.sulake.habbo.catalog._enum.CatalogType;

     class BuyGuildCatalogWidget extends CatalogWidget
    {
        var _button:IButtonWindow;

        public function new(k:IWindowContainer)
        {
            super(k);
            if (this._button != null)
            {
                this._button.removeEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._button = Std.downcast(window.findChildByName("start_guild_purchase") , IButtonWindow);
            this._button.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            return true;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            if (HabboTracking.getInstance() != null)
            {
                HabboTracking.getInstance().trackGoogle("groupPurchase", "catalogBuyClicked");
            }
            page.viewer.catalog.connection.send(new GetGuildCreationInfoMessageComposer());
            page.viewer.catalog.toggleCatalog(CatalogType.NORMAL);
        }
    }

