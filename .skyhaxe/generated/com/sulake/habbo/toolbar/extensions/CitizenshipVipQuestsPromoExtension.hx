package com.sulake.habbo.toolbar.extensions
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.events.IEventDispatcher;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.toolbar.IExtensionView;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.perk.CitizenshipVipOfferPromoEnabledEvent;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.communication.messages.outgoing.quest.StartCampaignMessageComposer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;

     class CitizenshipVipQuestsPromoExtension 
    {
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _events:IEventDispatcher;
        var _localization:ICoreLocalizationManager;
        var _connection:IConnection;
        var _extensionView:IExtensionView;
        var _view:IBorderWindow;
        var _disposed:Bool = false;
        var _expanded:Bool = true;
        var _originalHeight:Int = 216;
        var _vipQuestsCampaignName:String;
        var _promoEnabledListener:IMessageEvent = null;

        public function new(k:HabboToolbar, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IEventDispatcher, _arg_5:ICoreLocalizationManager, _arg_6:IConnection)
        {
            this._windowManager = _arg_2;
            this._assets = _arg_3;
            this._events = _arg_4;
            this._localization = _arg_5;
            this._connection = _arg_6;
            this._extensionView = k.extensionView;
            this._promoEnabledListener = new CitizenshipVipOfferPromoEnabledEvent(this._Str_24787);
            this._connection.addMessageEvent(this._promoEnabledListener);
            this._vipQuestsCampaignName = k.getProperty("citizenship.vip.tutorial.quest.campaign.name");
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (((this._connection != null) && (this._promoEnabledListener != null)))
            {
                this._connection.removeMessageEvent(this._promoEnabledListener);
                this._promoEnabledListener = null;
            }
            this.destroyWindow();
            this._localization = null;
            this._assets = null;
            this._events = null;
            this._windowManager = null;
            this._connection = null;
            this._extensionView = null;
            this._disposed = true;
        }

        function createWindow():IBorderWindow
        {
            var k:IBorderWindow = null;
            var _local_2= this._assets.getAssetByName("vip_quests_promo_xml");
            if (_local_2 != null)
            {
                k = Std.downcast(this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ), 1) , IBorderWindow);
                if (k != null)
                {
                    cast(k.findChildByName("quests_button"), IButtonWindow).addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                    cast(k.findChildByName("minimize_region"), IRegionWindow).addEventListener(WindowMouseEvent.CLICK, this._Str_12174);
                    cast(k.findChildByName("maximize_region"), IRegionWindow).addEventListener(WindowMouseEvent.CLICK, this._Str_12174);
                    this._originalHeight = k.height;
                }
            }
            return k;
        }

        function destroyWindow()
        {
            if (this._extensionView != null)
            {
                this._extensionView.detachExtension(ToolbarDisplayExtensionIds.VIP_QUESTS);
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            if (this._connection != null)
            {
                this._connection.send(new StartCampaignMessageComposer(this._vipQuestsCampaignName));
            }
            this.destroyWindow();
        }

        function _Str_12174(k:WindowMouseEvent)
        {
            this._expanded = (!this._expanded);
            this._Str_6881();
        }

        function _Str_6881()
        {
            cast(this._view.findChildByName("content_itemlist"), IItemListWindow).visible = this._expanded;
            cast(this._view.findChildByName("promo_img"), IStaticBitmapWrapperWindow).visible = this._expanded;
            this._view.height = (this._expanded ? this._originalHeight : 33);
        }

        function _Str_24787(k:IMessageEvent)
        {
            if (this._view == null)
            {
                this._view = this.createWindow();
            }
            this._Str_6881();
            this._extensionView.detachExtension(ToolbarDisplayExtensionIds.CLUB_PROMO);
            this._extensionView.attachExtension(ToolbarDisplayExtensionIds.VIP_QUESTS, this._view, ExtensionFixedSlotsEnum._Str_8642);
        }
    }

